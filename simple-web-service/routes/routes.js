const https = require('http');

var express = require('express');
var router = express.Router();

var sleep = require('sleep');

function isJSON(str) {
  try {
      return (JSON.parse(str) && !!str);
  } catch (e) {
      return false;
  }
}

router.use(function(req, res, next) {
  console.log('Processing request');
  next();
});

router.get('/error/', function(req, res) {
  res.setHeader('Content-Type', 'application/json');
  res.status(500).json({ result: 'error', message: 'Parameter must be a number between 0 and 100' }); 
});

router.get('/error/:setting', function(req, res) {
  res.setHeader('Content-Type', 'application/json');
  if ( isNaN(req.params.setting) ) {
    res.status(500).json({ result: 'error', message: 'Parameter must be a number between 0 and 100' }); 
  }
  else if (req.params.setting > 100) {
    res.status(500).json({ result: 'error', message: 'Parameter must be a number between 0 and 100' }); 
  }
  else {
    global.errorRate = req.params.setting;
    res.status(200).json({ result: 'success', message: 'Set error rate to: ' + global.errorRate + ' percent'}); 
  }
});

router.get('/delay/', function(req, res) {
  res.setHeader('Content-Type', 'application/json');
  res.status(500).json({ result: 'error', message: 'Parameter must be a number less than 60' }); 
});

router.get('/delay/:setting', function(req, res) {
  res.setHeader('Content-Type', 'application/json');
  if ( isNaN(req.params.setting) ) {
    res.status(500).json({ result: 'error', message: 'Parameter must be a number less than 60' }); 
  }
  else if (req.params.setting > 60) {
    res.status(500).json({ result: 'error', message: 'Parameter must be less than 60' }); 
  }
  else {
    global.responseDelay = req.params.setting;
    res.status(200).json({ result: 'success', message: 'Set delay to: ' + global.responseDelay + ' seconds'}); 
  }
});

router.get('/', function(req, res) {
  res.setHeader('Content-Type', 'application/json');
  res.status(400).json({ result: 'error', message: 'Invalid route' }); 
});

router.get('/about', function(req, res) {
  res.setHeader('Content-Type', 'application/json');
  res.status(200).json({ 
    serviceName: serviceName, 
    messageurl: serviceToCall,
    errorRate: global.errorRate,
    responseDelay: global.responseDelay
  }); 
});

router.get('/url/:setting', function(req, res) {
  res.setHeader('Content-Type', 'application/json');
  if ( !req.params.setting ) {
    res.status(500).json({ result: 'error', message: 'Must pass a URL' }); 
  }
  else {
    global.serviceToCall = req.params.setting;
    res.status(200).json({ result: 'success', message: 'Set serviceToCall to: ' + global.serviceToCall}); 
  }
});

router.get('/fail', function(req, res) {
  throw new Error('Whoops I got an Exeption');
});

router.get('/message', async (req, res, next) => {
  res.setHeader('Content-Type', 'application/json');
  
  // validate required arguments
  if(!serviceToCall)
  {
    res.status(500).json({ result: 'error', message: 'Missing environment variable: SERVICE_TO_CALL_URL' });
  }

  // determine if send back a fake error
  var fakeError = false;
  if ( global.errorRate > 0 ) {
    // get random number between 1 and 100
    randomNumber = Math.ceil(Math.random() * 100);
    console.log('Determine if send a fake error. errorRate: ' + global.errorRate + ' randomNumber: ' + randomNumber);
    if ( randomNumber <= global.errorRate ) {
      console.log('Faking Error');
      fakeError = true;
    }
  }

  // do this as to avoid the ERR_HTTP_HEADERS_SENT issue
  if (fakeError) {
    res.status(500).json({ result: 'error', message: 'Faking out an error' });
  }
  else {
    var responseMessage = '{ "whoami": "I am ' + serviceName + '"';
    responseMessage += ',"call": { "url":"'+serviceToCall+'"';

    // determine if make a backend call
    if ( serviceToCall != "none" ) {
      console.log('About to call: ' + serviceToCall);
      https.get(serviceToCall, (callResp) => {
        let data = '';
      
        // A chunk of data has been recieved.
        callResp.on('data', (chunk) => {
          data += chunk;
        });

        // The whole response has been received.
        callResp.on('end', () => {

          console.log('Response: ' + JSON.stringify(data));
          console.log('statusCode: ' + callResp.statusCode.toString());
          responseMessage += ',"status":"'+callResp.statusCode.toString()+'"';
          if (callResp.statusCode == 200) {
            if ( global.responseDelay > 0) {
              console.log('Sleeping: ' + global.responseDelay);
              sleep.sleep(global.responseDelay);
            }
            responseMessage += ',"response":'+ data.toString()+'}}';
            console.log('Final responseMessage: ' + responseMessage );
            res.status(200).send(responseMessage);
          }
          else {
            responseMessage += ',"response":'+ data.toString()+'}}';
            console.log(responseMessage);
            res.status(500).send(responseMessage);
          }
        });
      }).on("error", (err) => {
        console.log("Error: " + err.message);
        responseMessage += ',"status":"500"';
        responseMessage += ',"response":"'+err.message+'"}}';
        res.status(500).send(responseMessage);
      }).on('uncaughtException', function (err) {
        console.log(err);
        responseMessage += ',"status":"500"';
        responseMessage += ',"response":"'+err.message+'"}}';
        res.status(500).send(responseMessage);
      });
    }
    else {
      console.log('Skipping call got SERVICE_TO_CALL_URL = None');
      responseMessage += '}}';
      console.log('Final responseMessage: ' + responseMessage );
      if ( global.responseDelay > 0) {
        console.log('Sleeping: ' + global.responseDelay);
        sleep.sleep(global.responseDelay);
      }
      res.status(200).send(responseMessage);
    }
  }
});  

module.exports.router = router;

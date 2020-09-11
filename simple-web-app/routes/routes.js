
var http = require('http'); // Import Node.js core module
var express = require('express');
var router = express.Router();
var os = require('os')
var fs = require('fs')

router.use(function(req, res, next) {
  console.log('Processing request');
  next();
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

function isJSON(str) {
  try {
      return (JSON.parse(str) && !!str);
  } catch (e) {
      return false;
  }
}

router.get('/about', function(req, res) {
  fs = require('fs');
  let data="";
  try {
    data = fs.readFileSync('MANIFEST', 'utf8')
    console.log(data)
  } catch (err) {
    console.error(err)
    data="MANIFEST file not found"
  }
  console.log(data);
  res.setHeader('Content-Type', 'application/json');
  res.status(200).send(data); 
});

router.get('/', function(req, res) {
  let responseMessage='';
  let showResponse='hidden';
  if ( serviceToCall != "none" ) {
      console.log('About to call: ' + serviceToCall);
      http.get(serviceToCall, (callResp) => {
        let data = '';
        // A chunk of data has been recieved.
        callResp.on('data', (chunk) => {
          data += chunk;
        });

        // The whole response has been received.
        callResp.on('end', () => {
          // if pass in any query string, then show the response
          if ( Object.keys(req.query).length != 0) {
            showResponse='';
          }
          responseMessage=data.toString();
          if (callResp.statusCode == 200) {
            if ( isJSON(responseMessage)) {
              responseMessage = JSON.stringify(JSON.parse(responseMessage),undefined,2);
            }
            console.log(responseMessage);
            res.writeHead(200, { 'Content-Type': 'text/html' });    
            res.write(buildHtml(200, responseMessage,showResponse));
            res.end();
          }
          else {
              if ( isJSON(responseMessage)) {
                responseMessage = JSON.stringify(JSON.parse(responseMessage),undefined,2);
              }
              console.log(responseMessage);
              res.writeHead(500, { 'Content-Type': 'text/html' });    
              res.write(buildHtml(500,responseMessage,showResponse));
              res.end();                
          }
        });
      }).on("error", (err) => {
        responseMessage="Error: " + err.message;
        console.log(responseMessage);
        res.writeHead(500, { 'Content-Type': 'text/html' });    
        res.write(buildHtml(500,responseMessage,showResponse));
        res.end();      
      }).on('uncaughtException', function (err) {
        responseMessage="Exception: " + err.message;
        console.log(responseMessage);
        res.writeHead(500, { 'Content-Type': 'text/html' });    
        res.write(buildHtml(500,responseMessage,showResponse));
        res.end();
      });
    }
    else {
      responseMessage='Skipping call got SERVICE_TO_CALL_URL = none';
      console.log(responseMessage);
      res.writeHead(200, { 'Content-Type': 'text/html' });    
      res.write(buildHtml(200,responseMessage,showResponse));
      res.end();
    }
});

function buildHtml(code,message,showResponse) {
  html = fs.readFileSync(__dirname + '/index.html').toString();
  html = html.replace("HOSTNAME-PLACEHOLDER", os.hostname());
  html = html.replace("DT_CUSTOM_PROP-PLACEHOLDER", dtCustomProps);
  html = html.replace(/SERVICE_TO_CALL_URL-PLACEHOLDER/g, serviceToCall);
  html = html.replace("MESSAGE-PLACEHOLDER", message);
  html = html.replace("SHOW-RESPONSE-PLACEHOLDER",showResponse);
  html = html.replace("SERVICE-NAME-PLACEHOLDER",global.serviceName);

  if (code ==200) {
    html = html.replace("IMAGE-PLACEHOLDER", "green.png");
    html = html.replace(/ERROR-BUTTON-CLASS-VALUE-PLACEHOLDER/g, "hidden");
    html = html.replace(/COLOR-CLASS-VALUE-PLACEHOLDER/g, "green");
    html = html.replace("SERVICE-MESSAGE-PLACEHOLDER", "I AM GOOD TO GO");
  }
  else {
    html = html.replace("IMAGE-PLACEHOLDER", "red.png");
    html = html.replace(/ERROR-BUTTON-CLASS-VALUE-PLACEHOLDER/g, "nothidden");
    html = html.replace(/COLOR-CLASS-VALUE-PLACEHOLDER/g, "red");
    html = html.replace("SERVICE-MESSAGE-PLACEHOLDER", "I HAVE AN ERROR");
  }
  return html
};

module.exports.router = router;

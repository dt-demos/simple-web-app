//setup
var express = require("express");
var app = express();
var bodyParser = require('body-parser');

global.responseDelay = 0;
global.errorRate = 0;

//configuration 
app.use(bodyParser.json()); // support json encoded bodies
app.use(bodyParser.urlencoded({ extended: true })); // support encoded bodies
app.set('etag', false);  // disable cache
global.dtCustomProps = process.env.DT_CUSTOM_PROP || "DT_CUSTOM_PROP Not defined"
global.serviceToCall = process.env.SERVICE_TO_CALL_URL || "SERVICE_TO_CALL_URL Not defined"
global.serviceName = process.env.SERVICE_NAME || "SERVICE_NAME Not defined"

// routes =======================================================================
var router = express.Router();
app.use('/api', require('./routes/routes').router);

router.get('/', function (req, res, next) {
  res.json({status: 'UP'});
});

// listen (start app with node server.js) 
app.listen(process.env.PORT || 8080, () => {
  console.log("Server running!");
});

module.exports = app;


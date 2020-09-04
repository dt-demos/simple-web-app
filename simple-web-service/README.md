# Overview

Microservice web service for demos

# Web Service endpoints

Each of the these endpoints starts with the `api/` prefix.

## api/message

This is the main interface that will return a concatenated string;
* Add the value return from the request to the URL set in the docker environment variable `SERVICE_TO_CALL_URL`
* if `SERVICE_TO_CALL_URL` is set to `none` then, do not append a value
* if there is an error calling `SERVICE_TO_CALL_URL`, then return a 500 error
* if `SERVICE_TO_CALL_URL` is not set, then return a 500 error

Examples:

```
# sample failure output
GET request: http://localhost:8080/api/message
{"result":"fail","message":"service-1 -> service-2 -> connect ECONNREFUSED 172.17.0.1:8380"}

# sample success output
GET request: http://localhost:8580/api/message
{ "whoami": "I am simple-web-service-5","call": { "url":"none"}}

GET request: http://localhost:8480/api/message
{ "whoami": "I am simple-web-service-4","call": { "url":"http://172.17.0.1:8580/api/message","status":"200","response":{ "whoami": "I am simple-web-service-5","call": { "url":"none"}}}}
```

## api/about

Retrieve the settings for the service.

Example:

```
http://localhost:8480/api/about
{"serviceName":"simple-web-service-4","messageurl":"http://172.17.0.1:8580/api/message","errorRate":0,"responseDelay":0}
```

## api/delay

Set the delay in seconds for requests to /api/message. Delay can be up to 60 seconds.  Set to zero to disable the delay.

Examples:

```
# set to 2 seconds
http://localhost:8080/api/delay/2
{"result":"success","message":"Set delay to: 2 seconds"}

# set delay off
http://localhost:8080/api/delay/0
{"result":"success","message":"Set delay to: 0 seconds"}

```

## api/error

Set a percentage rate to have the requests to /api/message return a 500 code.  Valid values are between 0 and 100.  Zero means no errors. 100 mean 100% errors.

Examples:

```
# set to 50%
http://localhost:8080/api/error/50
{"result":"success","message":"Set error rate to: 50 percent"}

# set to 0%
http://localhost:8080/api/error/0
{"result":"success","message":"Set error rate to: 0 percent"}
```

## api/url

Override the `SERVICE_TO_CALL_URL` value.  **MUST BE ENCODED**. Use [https://www.urlencoder.org/](https://www.urlencoder.org/) as a resource to do this.

Example request to set url to http://11.22.33.44:55:8280/api/message

```
http://localhost:8180/api/url/http%3A%2F%2F11.22.33.44%3A55%3A8280%2Fapi%2Fmessage
```

Example result:

```
{"result":"success","message":"Set serviceToCall to: http://11.22.33.44:55:8180/api/message"}
```

## api/fail

Call this endpoint create an unhandled error which will return a 500 code and stack trace.

Example request:

```
http://localhost:8080/api/fail
```
Example result:

```
Error: Whoops I got an Error
    at /usr/src/app/routes/routes.js:75:9
    at Layer.handle [as handle_request] (/usr/src/app/node_modules/express/lib/router/layer.js:95:5)
    at next (/usr/src/app/node_modules/express/lib/router/route.js:137:13)
    at Route.dispatch (/usr/src/app/node_modules/express/lib/router/route.js:112:3)
    at Layer.handle [as handle_request] (/usr/src/app/node_modules/express/lib/router/layer.js:95:5)
    at /usr/src/app/node_modules/express/lib/router/index.js:281:22
    at Function.process_params (/usr/src/app/node_modules/express/lib/router/index.js:335:12)
    at next (/usr/src/app/node_modules/express/lib/router/index.js:275:10)
    at /usr/src/app/routes/routes.js:18:3
    at Layer.handle [as handle_request] (/usr/src/app/node_modules/express/lib/router/layer.js:95:5)
```

## Invalid endpoints

Any invalid endpoint results in 400 response code.

Example:

```
http://localhost:8080/api/

400 status code
{"result":"error","message":"Invalid route"}
```





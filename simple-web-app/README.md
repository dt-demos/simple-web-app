# Overview

Microservice web application for demos

# Web App endpoints

## Home page

The home page will show whether there is an error or not.

## Home page with query string

Any query string value will the details for the result of `SERVICE_TO_CALL_URL` execution.  If `SERVICE_TO_CALL_URL` set to `none`, then just `none` will be shown.

Example:

```
http://localhost:8080/?a
```

## url

Override the `SERVICE_TO_CALL_URL` value.  **MUST BE ENCODED**. Use [https://www.urlencoder.org/](https://www.urlencoder.org/) as a resource to do this.

Example request to set url to `http://11.22.33.44:55:8180/api/message`

```
http://localhost:8080/url/http%3A%2F%2F11.22.33.44%3A55%3A8180%2Fapi%2Fmessage
```

Example result:

```
{"result":"success","message":"Set serviceToCall to: http://11.22.33.44:55:8180/api/message"}
```

## about

Retrieve the settings for the service.

Example:

```
http://localhost:8080/about
{
    "DATE" : "20200910.0844",
    "IMAGE_NAME" : "dtdemos/simple-web-app",
    "IMAGE_TAG" : "0.1.0",
    "REPO" : "https://github.com/dt-demos/simple-web-app.git",
    "BRANCH" : "master",
    "SHA" : "34806c14e248f91fc3ee5e17e1a4f0e36539c8cd",
}
```
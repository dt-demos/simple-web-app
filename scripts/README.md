# Overview

This folder contains a set of helper scripts to build, deploy and test the application.  The scripts are in BASH so you will need linux or macos. The scripts are organized into subfolder.  You should be in the subfolder when you run one of them.

# Deploy

Helper scripts can deploy the application to kubernetes or run Docker containers on a VM.  Both will start up the following:

* simple-web-app-1 - web app running on port 8080
* simple-web-app-2 - web app running on port 8090
* simple-web-service-1 - service running on port 8180
* simple-web-service-2 - service running on port 8280
* simple-web-service-3 - service running on port 8380
* simple-web-service-4 - service running on port 8480
* simple-web-service-5 - service running on port 8580

These are the helper scripts that can be run with no arguments.

* `./vm-start-app.sh` will pull the required images and start all docker containers.
* `./vm-stop-app.sh` will stop all docker containers.
* `./k8-deploy.sh` will create the namespace `demo-app-dev` and apply the YAML files in the k8/ subfolder
* `./vm-start-app.sh` will delete the namespace `demo-app-dev`

For kubernetes, these commands can be used to review status and get the URLs to the services.

```
kubectl -n demo-app-dev get pods
kubectl -n demo-app-dev get svc
```

For docker, this commands can be used to review status

```
sudo docker ps
```

# Test

This script assumes:
* you have jmeter installed 
* have configured the dynatrace scripts credentials file (see the Dynatrace section below)

The jmeter script will loop to call the home page to the simple-web-app-1 and simple-web-app-2.

So that the script jmeter has the URLs, copy the `jmeter.template` to a file called `jmeter.json` and update the values.

To run a test, call `./run-load-test.sh` and it will send a load test event to Dynatrace and run the jmeter script with the values from the `jmeter.json` file.

# Dynatrace

This folder contains a few script to send information events to Dynatrace.

Note that the services each set DT_CUSTOM_PROPS that will create meta-data in Dynatrace for that process.  These process properties are used in the AUTO TAGGING rules.  These TAGS are then reference in the tagging rule for the API call. 

This script assumes:

* you have [jq](https://stedolan.github.io/jq) installed 
* have configured the dynatrace scripts credentials file
* you have configured an AUTO TAGGING rule in Dynatrace for `stage`, `project` and `service`

To configure the Dynatrace scripts credentials file, copy the `creds.template` to a file called `creds.json` and update the values with the URL and an API token for the Dynatrace tenant monitoring the application.

To configure the AUTO TAGGING rules:

* make 3 seperate rules named `stage`, `project` and `service`.
* each rules applies to a `service`
* each rules has tag value to `{ProcessGroup:Environment:project}`, `{ProcessGroup:Environment:service}` or `{ProcessGroup:Environment:stage}`
* each rules has condition that the process properties value `project (Environment)`, `service (Environment)` or `stage (Environment)` exists.

# Build

These scripts are used to automate the build and pushing of multiple Docker images.  These helper scripts call the `build.sh` script in the simple-web-app and simple-web-service subfolders.
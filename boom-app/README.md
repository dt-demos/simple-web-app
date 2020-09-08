# Overview

Dockerized application to show Docker Crashes for demos. 

Written in Python and using the [Dynatrace Python SDK](https://github.com/dynatrace-oss/OneAgent-SDK-Python-AutoInstrumentation)  See this [blog](https://www.dynatrace.com/news/blog/end-to-end-request-monitoring-for-popular-python-frameworks-with-oneagent-sdk/) to learn about the SDK benefits.

# Build

Use the ```buildpush.sh``` script to build and push the image as `dtdemos/boom-app:0.1.0`.

# Deploy

Assuming you have Kubernetes, run these commands to start the app.

```
kubectl apply -f boom-app.yaml -n demo-app-dev
```

# Monitor

Assuming you have Kubernetes, run these commands to monitor the app.

```
kubectl -n demo-app-dev get pods -l app=boom-app -w
```

will show output of app crashing and restarting

```
NAME                        READY   STATUS             RESTARTS   AGE
boom-app-6464467678-xhnq7   1/1     Running            1          45s
boom-app-6464467678-xhnq7   0/1     Error              1          78s
boom-app-6464467678-xhnq7   0/1     CrashLoopBackOff   1          90s
boom-app-6464467678-xhnq7   1/1     Running            2          93s
boom-app-6464467678-xhnq7   0/1     Error              2          2m9s
boom-app-6464467678-xhnq7   0/1     CrashLoopBackOff   2          2m23s
boom-app-6464467678-xhnq7   1/1     Running            3          2m36s
boom-app-6464467678-xhnq7   0/1     Error              3          3m14s
boom-app-6464467678-xhnq7   0/1     CrashLoopBackOff   3          3m24s
boom-app-6464467678-xhnq7   1/1     Running            4          3m56s
boom-app-6464467678-xhnq7   0/1     Error              4          4m34s
boom-app-6464467678-xhnq7   0/1     CrashLoopBackOff   4          4m44s
boom-app-6464467678-xhnq7   1/1     Running            5          6m2s
boom-app-6464467678-xhnq7   0/1     Error              5          6m39s
boom-app-6464467678-xhnq7   0/1     CrashLoopBackOff   5          6m53s
boom-app-6464467678-xhnq7   1/1     Running            6          9m23s
boom-app-6464467678-xhnq7   0/1     Error              6          10m
```

# Clean up

To remove the pod, run this command

```
kubectl -n demo-app-dev delete deploy boom-app
```
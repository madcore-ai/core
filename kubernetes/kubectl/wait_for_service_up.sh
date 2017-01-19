#!/usr/bin/env bash

APP_NAME="$1"
SERVICE_NAME="$2"
SERVICE_NAMESPACE="$3"
# TODO@geo Maybe we can use standard kubectl to make this check?
echo "Waiting for ${APP_NAME} (may take few minutes) …"
sudo su -c "until curl -sL -w '%{http_code}' 'http://localhost:8080/api/v1/proxy/namespaces/${SERVICE_NAMESPACE}/services/${SERVICE_NAME}/' -o /dev/null | grep -m 1 '200'; do : ; done" jenkins
echo "${APP_NAME}  confirmed."

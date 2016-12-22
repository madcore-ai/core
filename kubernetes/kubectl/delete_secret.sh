#!/usr/bin/env bash

kubectl delete secret $APP_NAME-secret --namespace=$APP_NAME-plugin

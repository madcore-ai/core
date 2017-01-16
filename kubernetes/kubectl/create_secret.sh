#!/usr/bin/env bash

FROM_LITERAL=$(python -c "import sys; print ' '.join(map(lambda apps_data: '--from-literal=%s' % apps_data, sys.argv[1].split(';')))" $SECRET)
kubectl create secret generic $APP_NAME-secret $FROM_LITERAL --namespace=$APP_NAME-plugin

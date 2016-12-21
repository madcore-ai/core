#!/usr/bin/env bash

FROM_LITERAL=$(python -c "import sys; print ' '.join(map(lambda x: '--from-literal=%s' % x, sys.argv[1].split(';')))" $SECRET)
kubectl create secret generic $APP_NAME-secret $FROM_LITERAL --namespace=$APP_NAME-plugin

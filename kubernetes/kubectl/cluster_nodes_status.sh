#!/usr/bin/env bash

NODE_LABEL=$1

kubectl get nodes --selector="${NODE_LABEL}" --label-columns=[cluster]

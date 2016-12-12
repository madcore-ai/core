#!/usr/bin/env bash

echo "Delete job name: '$Name'"

JOBS_DIR="/opt/jenkins/schedules"
JOB_BASE_NAME="madcore_schedule_${Name}"

rm $JOBS_DIR/$JOB_BASE_NAME*

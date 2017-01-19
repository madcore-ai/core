from __future__ import print_function

import os
import sys

from utils import run_cmd

NAMESPACE = 'spark-cluster'
SPARK_PATH = '/opt/spark'

# TODO@geo validate this
sparks_args = sys.argv[1]
# this can be
app_file_name = sys.argv[2]
app_args = sys.argv[3]

example_subfold = None
if app_file_name.endswith('.py'):
    example_file_path = os.path.join(SPARK_PATH, 'examples/src/main/python', app_file_name)
else:
    # Load jar files with examples
    example_file_path = os.path.join(SPARK_PATH, 'lib', app_file_name)

zepplin_controller = run_cmd(
    "kubectl get pods --namespace=%s | grep zeppelin-controller | awk '{print $1}'" % (NAMESPACE,))

run_spark_job_cmd = "kubectl exec -i {pod_name} --namespace={namespace} -ti -- " \
                    "spark-submit --master=spark://spark-master:7077 {sparks_args} {spark_file} {app_args}"
run_spark_job = run_spark_job_cmd.format(pod_name=zepplin_controller, namespace=NAMESPACE, sparks_args=sparks_args,
                                         spark_file=example_file_path, app_args=app_args)

if __name__ == '__main__':
    print(run_cmd(run_spark_job))

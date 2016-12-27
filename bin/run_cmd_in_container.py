from __future__ import print_function
import sys
from utils import wait_until_pod_is_ready, get_pod, execute_cmd_on_pod

app_name = sys.argv[1]
namespace = sys.argv[2]
cmd = sys.argv[3]

wait_until_pod_is_ready(namespace)

pod_name = get_pod(app_name, namespace, wait_until_created=True)

print(execute_cmd_on_pod(pod_name, cmd, namespace))

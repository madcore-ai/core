from __future__ import print_function
import sys
import subprocess
from jinja2 import Template
import time


def str_to_bool(s):
    try:
        s = s.strip().lower()
        if s == 'true':
            return True
        elif s == 'false':
            return False
    except:
        pass

    return False


def run_cmd(cmd, debug=True):
    if debug:
        print("Running cmd: %s" % cmd)
        sys.stdout.flush()

    process = subprocess.Popen(cmd, stdout=subprocess.PIPE, shell=True)
    out, err = process.communicate()

    if err:
        print("    ERROR: ", err)
    else:
        print("    OK")

    return out.strip()


def run_cmd_no_debug(cmd):
    run_cmd(cmd, debug=False)


def j2_render(in_template_path, out_file, data):
    with open(in_template_path, 'r') as config_template:
        template = Template(config_template.read())
        config = template.render(**data)
        with open(out_file, 'w') as out_f:
            out_f.write(config)

    return config


def get_pod(pod_name, namespace='default', wait_until_created=False, sleep_time=2, max_attempts=10):
    attempts_cnt = 0
    pod = None

    while not pod and attempts_cnt < max_attempts:
        pod = run_cmd(
            "kubectl get pods --namespace=%s | grep %s | awk '{print $1}'" % (namespace, pod_name))
        if not wait_until_created:
            break
        time.sleep(sleep_time)
        attempts_cnt += 1

    return pod


def wait_until_pod_is_ready(namespace='default', sleep_time=3, max_attempts=15):
    attempts_cnt = 0
    ready_state = False

    while attempts_cnt < max_attempts:
        ready_state = str_to_bool(run_cmd(
            "kubectl get pods --namespace=%s -o jsonpath={.items[*].status.conditions[1].status}" % (namespace,)))
        print("State: ", ready_state)
        if ready_state:
            break

        time.sleep(sleep_time)
        attempts_cnt += 1

    return ready_state


def copy_file_to_pod(pod_name, local_file, pod_file, namespace='default'):
    return run_cmd("kubectl exec -i {0} --namespace={1} -- /bin/bash -c 'cat > {2}' < {3}".format(
        pod_name, namespace, pod_file, local_file))


def execute_cmd_on_pod(pod_name, cmd, namespace='default'):
    return run_cmd("kubectl exec -i {0} --namespace={1} -- {2}".format(
        pod_name, namespace, cmd))

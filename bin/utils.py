from __future__ import print_function
import sys
import subprocess
from jinja2 import Template
import time
from consts import docker_server, registry_user, registry_pass, registry_secret
import os


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


def docker_push(app_name):
    run_cmd("docker tag {0} {1}/{0}:image".format(app_name, docker_server))
    run_cmd("docker login -u{0} -p{1} {2}".format(registry_user, registry_pass, docker_server))
    run_cmd("docker push {0}/{1}:image".format(docker_server, app_name))


def docker_pull(app_name):
    run_cmd("docker pull {0}/{1}:image".format(docker_server, app_name))


def docker_build_from_repo(repo_url, app_name, repo_dest, branch_name='master', dockerfile_path=None):
    """Clone a repo, cd to specific folder if needed and build docker from there.
    Also put image into local registry
    """

    run_cmd("git clone -b {0} {1} {2}".format(branch_name, repo_url, repo_dest))
    if dockerfile_path:
        build_path = os.path.join(repo_dest, dockerfile_path)
    else:
        build_path = repo_dest

    # Crete image
    run_cmd("docker build -t {0} {1}".format(app_name, build_path))


def kubectl_create_secret_for_docker_registry():
    run_cmd("kubectl create secret docker-registry {0} --docker-server={1} --docker-username={2} --docker-password={3} "
            "--docker-email=test@test.com".format(registry_secret, docker_server, registry_user, registry_pass))


def create_secrete(secrets, app_name, namespace):
    if secrets:
        secrets = secrets.split(';')
        kub_secrets = ['--from-literal={0}'.format(i) for i in secrets]
        # create secrete for
        run_cmd("kubectl create secret generic {0}-secret {1} --namespace={2}".format(app_name, ' '.join(kub_secrets),
                                                                                      namespace))

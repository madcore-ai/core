from __future__ import print_function
import sys
from utils import docker_build_from_repo, kubectl_create_secret_for_docker_registry, run_cmd, j2_render, \
    wait_until_pod_is_ready, get_pod, \
    execute_cmd_on_pod, create_secrete
from consts import registry_secret, docker_server
import time

job_name = 'madcore.deploy.container'
repo_url = sys.argv[1]
app_name = sys.argv[2]
# list of secret data in the form
# key1=value1;key2=value2
secrets = sys.argv[3]
# command to execute on pod
cmd = sys.argv[4]

workspace = '/var/lib/jenkins/workspace/' + job_name + "/" + app_name + "/"
repo_dest = workspace + 'repo/'
kub_config_path = workspace + 'kube_config/'
app_port = 1234
namespace = 'madcore-plugins-%s' % app_name
volume_mount_path = '/opt/s3'
volume_host_path = '/opt/s3'

run_cmd("mkdir -p %s" % kub_config_path)

docker_build_from_repo(
    repo_url=repo_url,
    app_name=app_name,
    repo_dest=repo_dest,
    branch_name='master',
    repo_folder=app_name
)

kubectl_create_secret_for_docker_registry()

data_ns = {
    'namespace': namespace
}
j2_render('/opt/madcore/bin/templates/namespace.yaml', kub_config_path + 'ns.yaml', data_ns)

# create namespace before secrete
# TODO@geo use kubernetes Kind: Secretes for this
print(run_cmd("kubectl create -f %s" % kub_config_path + 'ns.yaml'))
time.sleep(5)

create_secrete(secrets, app_name, namespace)

data_rc = {
    'name': app_name,
    'image': app_name + ':image',
    'registry_secret': registry_secret,
    'docker_server': docker_server,
    'namespace': namespace,
    'volume_mount_path': volume_mount_path,
    'volume_host_path': volume_host_path
}
j2_render('/opt/madcore/bin/templates/kub_replication_controller_template_plugins.yaml',
          kub_config_path + 'rc.yaml', data_rc)

data_srv = {
    'name': app_name,
    'port': app_port,
    'rc_name': app_name,
    'namespace': namespace
}
j2_render('/opt/madcore/bin/templates/kub_service_template.yaml', kub_config_path + 'svc.yaml', data_srv)

print(run_cmd("kubectl create -f %s" % kub_config_path))

wait_until_pod_is_ready(namespace)

pod_name = get_pod(app_name, namespace, wait_until_created=True)

print(execute_cmd_on_pod(pod_name, cmd, namespace))

from __future__ import print_function
import sys
from utils import docker_build_from_repo, kubectl_create_secret, run_cmd, j2_render, wait_until_pod_is_ready, get_pod, \
    execute_cmd_on_pod
from consts import registry_secret, docker_server

job_name = 'madcore.deploy.container'
repo_url = sys.argv[1]
app_name = sys.argv[2]
# command to execute on pod
cmd = sys.argv[3]

workspace = '/var/lib/jenkins/workspace/' + job_name + "/" + app_name + "/"
repo_dest = workspace + 'repo/'
kub_config_path = workspace + 'kube_config/'
app_port = 1234
namespace = 'madcore-plugins'
volume_mount_path = '/opt/s3'
volume_host_path = '/opt/s3'

run_cmd("mkdir -p %s" % kub_config_path)

docker_build_from_repo(
    repo_url=repo_url,
    app_name=app_name,
    repo_dest=repo_dest,
    branch_name='development',
    repo_folder=app_name
)

kubectl_create_secret()

data_ns = {
    'namespace': namespace
}
j2_render('/opt/madcore/bin/templates/namespace.yaml', kub_config_path + 'ns.yaml', data_ns)


data_rc = {
    'name': app_name,
    'image': app_name + ':image',
    'registry_secret': registry_secret,
    'docker_server': docker_server,
    'namespace': namespace,
    'volume_mount_path': volume_mount_path,
    'volume_host_path': volume_host_path
}
j2_render('/opt/madcore/bin/templates/kub_replication_controller_template_with_volume.yaml',
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

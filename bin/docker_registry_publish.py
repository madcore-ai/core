import sys
from utils import docker_push, kubectl_create_secret_for_docker_registry

app_name = sys.argv[1]

if __name__ == '__main__':
    kubectl_create_secret_for_docker_registry()
    docker_push(app_name)

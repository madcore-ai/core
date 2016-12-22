import sys
from utils import docker_pull

app_name = sys.argv[1]

if __name__ == '__main__':
    docker_pull(app_name)

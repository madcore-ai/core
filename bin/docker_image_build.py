import sys
from utils import docker_build_from_repo

job_name = 'madcore.docker.image.build'
repo_url = sys.argv[1]
app_name = sys.argv[2]

workspace = '/var/lib/jenkins/workspace/' + job_name + "/" + app_name + "/"
repo_dest = workspace + 'repo/'

if __name__ == '__main__':
    docker_build_from_repo(
        repo_url=repo_url,
        app_name=app_name,
        repo_dest=repo_dest,
        branch_name='master',
        repo_folder=app_name
    )

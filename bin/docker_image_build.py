import sys
from utils import docker_build_from_repo

job_name = 'madcore.docker.image.build'
repo_url = sys.argv[1]
app_name = sys.argv[2]
dockerfile_path = sys.argv[3]
if(len(sys.argv)==5):
    repo_branch = sys.argv[4]
else:
    repo_branch = 'master'

workspace = '/var/lib/jenkins/workspace/' + job_name + "/" + app_name + "/"
repo_dest = workspace + 'repo/'

if __name__ == '__main__':
    docker_build_from_repo(
        repo_url=repo_url,
        app_name=app_name,
        repo_dest=repo_dest,
        branch_name=repo_branch,
        dockerfile_path=dockerfile_path
    )

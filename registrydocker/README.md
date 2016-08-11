Steps for Docker Registry Start .
1.First chanage directory to /opt/controlbox/registrydocker
2.Run sudo bash setup.sh  (this will start docker registry )
3.check Docker registry is running or not  using docker ps 

Steps for Tag, Push and Pull Images from Docker Registry
1.First check Docker Images using docker images
2.login in docker using > docker login localhost:5000/   or run this 
Enter user 
Enter Password
Login Succeeded
4.Tag image that you want to push using below command
docker tag Image_ID  localhost:5000/REPOSITORY_NAME
5.For push use below command 
docker push localhost:5000/v2:TAG_NAME   > this will save image in /opt/dockerstorage
6.For pull Image use.
docker pull localhost:5000/v2:TAG_NAME

7. To check images in registry use below command with user name and password
curl -X GET https://admin:redhat007@localhost.com:5000/v2/_catalog


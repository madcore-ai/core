#!/bin/bash
echo "IMAGE_NAME: '$IMAGE_NAME'"
docker login -uroot -pmadcore localhost:5000/
docker tag $(docker images | grep $IMAGE_NAME | awk '{print $3}') localhost:5000/$IMAGE_NAME:image
docker push localhost:5000/$IMAGE_NAME:image

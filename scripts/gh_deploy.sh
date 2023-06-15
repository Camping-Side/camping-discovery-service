#!/bin/bash

DEPLOY_LOG_PATH="/home/ubuntu/github_action/discovery/deploy.log"
SERVICE_NAME="camping-discovery-service"
IMAGE_VERSION="1.0.0"
DOCKER_IMAGE="ghcr.io/camping-side/$SERVICE_NAME"
PROFILE="dev"

echo "===== $SERVICE_NAME 배포 시작 : $(date +%c) =====" >> $DEPLOY_LOG_PATH

EXIST_BLUE=$(docker ps -f "name=$SERVICE_NAME-blue" | grep Up)

# Blue 기동 중인지 체크( -z : 길이 0인지 )
# docker run -d -p 9888:9888 -e "spring.profiles.active=dev" --name camping-config-service-blue ghcr.io/camping-side/camping-config-service:latest
if [ -z "$EXIST_BLUE" ]; then
  echo "===== Blue Run Start =====" >> $DEPLOY_LOG_PATH
#  docker-compose -p $SERVICE_NAME-blue -f docker-compose.blue.yml up -d
  docker run -d -p 9761:9761 -e "spring.profiles.active=$PROFILE" --name $SERVICE_NAME-blue $DOCKER_IMAGE:$IMAGE_VERSION
  STOP_TARGET_COLOR="green"
  START_TARGET_COLOR="blue"
else
  echo "===== Green Run Start =====" >> $DEPLOY_LOG_PATH
#  docker-compose -p $SERVICE_NAME-green -f docker-compose.green.yml up -d
  docker run -d -p 9761:9761 -e "spring.profiles.active=$PROFILE" --name $SERVICE_NAME-green $DOCKER_IMAGE:$IMAGE_VERSION
  STOP_TARGET_COLOR="blue"
  START_TARGET_COLOR="green"
fi

# 넉넉하게 30초 대기
sleep 30


# 신규버전 컨테이너 기동 확인
START_SUCCESS=$(docker ps -f "name=$SERVICE_NAME-$START_TARGET_COLOR" | grep Up)
# -n : 길이가 0이 아닌경우
if [ -n "$START_SUCCESS" ]; then
#  docker-compose -p $SERVICE_NAME-$STOP_TARGET_COLOR -f docker-compose.$STOP_TARGET_COLOR.yml down
  docker stop $SERVICE_NAME-$STOP_TARGET_COLOR
  sleep 3
  docker rm $SERVICE_NAME-$STOP_TARGET_COLOR
  echo "===== 이전 컨테이너 종료 ====="  >> $DEPLOY_LOG_PATH
fi

# 신규 도커 이미지 삭제(다음 이미지 새로고침 위해)
sleep 3
docker -l debug system prune -af
# none 이미지 삭제
#docker rmi $(docker images -f "dangling=true" -q)
echo "===== 이미지 삭제 ====="  >> $DEPLOY_LOG_PATH

echo "===== $SERVICE_NAME 배포 종료 : $(date +%c) =====" >> $DEPLOY_LOG_PATH


# camping-discovery-serivce

---

### Infra Structure
![DiscoveryServer_배포](https://github.com/Camping-Side/camping-config-service/assets/56568571/9daef418-1983-46d2-982e-3d7d8b1fbb57)

### 로컬 도커 실행
* 도커 로그인
```shell
docker login ghcr.io -u <계정명>
# + 비밀번호 입력
```

* 도커 이미지 가져와서 실행
```shell
# 맨 뒤에 버전은 master 브런치 maven version으로 싱크를 맞춰준다. 
# 혹시나 로컬 rabbitmq를 사용하고 싶다면 profiles를 local로 세팅해주면 된다.
docker run -d -p 9761:9761 -e "spring.profiles.active=dev" --name camping-discovery-service ghcr.io/camping-side/camping-discovery-service:1.0.0
```

---

### 실서버에서 배포전략
1. Dockerfile, pom.xml, gh_deploy.sh에서 version up
2. master branch push
3. 필요하다면 shell 접속하여 아래 명령어로 확인
```shell
docker ps -a
docker images

```

---

### encrypt key
1. 원하는 key값을 local에 encrypt.key 세팅
2. 서버 구동 후 키값을 파라미터로 encrypt api 호출
3. 결과값으로 camping-profile에 '{cipher}결과값' 세팅

---


### Setting Documentation
> [RabbitMQ](./setting-doc/rabbitmq){:target="_blank"} <br>
> [Github Action](./.github/workflows/deploy.yaml) <br>
> [appspec.yml](./scripts/appspec.yml) / [공식문서](https://docs.aws.amazon.com/ko_kr/codedeploy/latest/userguide/reference-appspec-file.html)<br>
> [Nginx](./setting-doc/nginx/real)<br>
> 

---

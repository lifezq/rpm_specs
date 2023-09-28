#!/bin/bash
## rocket mq
docker run --name mqnamesrv -p 9876:9876 -it apache/rocketmq ./mqnamesrv
docker run --name mqbroker -p 10911:10911 -it apache/rocketmq ./mqbroker -n 192.168.0.103:9876
docker run -d --name rocketmq-dashboard -e "JAVA_OPTS=-Drocketmq.namesrv.addr=192.168.0.103:9876" -p 8080:8080 -t apacherocketmq/rocketmq-dashboard:latest

## redis
docker run -itd --name redis -p 6379:6379 redis:5.0.14-alpine --requirepass 123456

## mariadb
docker run -itd --name mariadb -p 3306:3306 mariadb:latest

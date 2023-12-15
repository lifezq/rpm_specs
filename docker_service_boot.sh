#!/bin/bash
## rocket mq
docker run --name mqnamesrv -p 9876:9876 -it apache/rocketmq ./mqnamesrv
## 生成broker.conf
cat >>broker.conf <<EOF
brokerClusterName = DefaultCluster
brokerName = broker-a
brokerId = 0
deleteWhen = 04
fileReservedTime = 48
brokerRole = ASYNC_MASTER
flushDiskType = ASYNC_FLUSH
brokerIP1 = 192.168.0.252
EOF
docker run --name mqbroker -e "JAVA_OPT_EXT=-Xmx128m -Xms128m" -p 10911:10911 -p 10909:10909 -v .\broker.conf:/opt/broker.conf -it apache/rocketmq ./mqbroker -n 192.168.0.252:9876 -c /opt/broker.conf
docker run -d --name rocketmq-dashboard -e "JAVA_OPTS=-Drocketmq.namesrv.addr=192.168.0.252:9876" -p 8080:8080 -t apacherocketmq/rocketmq-dashboard:latest

## redis
docker run -itd --name redis -p 6379:6379 redis:5.0.14-alpine --requirepass 123456

## mariadb
docker run -itd --name mariadb -p 3306:3306 mariadb:latest

## mysql
docker run -p 3306:3306 --name mysql --restart=always --privileged=true -v /d/ProgramData/mysql/log:/var/log/mysql -v /d/ProgramData/mysql/data:/var/lib/mysql -v /d/ProgramData/mysql/conf:/etc/mysql -e MYSQL_ROOT_PASSWORD=123456 -d mysql:5.7.43

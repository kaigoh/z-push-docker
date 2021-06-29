# docker-z-push

```shell
docker run -d \
        -p 80:80 \
        -e MAILSERVER_TIMEZONE=Asia/Tokyo \
        -e SERVER_ADDRESS=push.example.com \
        -e MAILSERVER_ADDRESS=mx.example.com  \
        -e MAILSERVER_PORT=993 \
        -e MAILSERVER_PORT_SMTP_SERVER=mx.example.com \
        -e MAILSERVER_PORT_SMTP_PORT=587 \
    dylanwzy/z-push-docker
```

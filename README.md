# docker-z-push

```shell
docker run -d \
        -p 80:80 \
        -e MAILSERVER_TIMEZONE=Europe/London \
        -e MAILSERVER_FOLDER_PREFIX= \
        -e SERVER_ADDRESS=push.example.com \
        -e MAILSERVER_ADDRESS=mx.example.com  \
        -e MAILSERVER_PORT=993 \
        -e SMTPSERVER_ADDRESS=mx.example.com \
        -e SMTPSERVER_PORT=587 \
    docker-registry.gohegan.uk/zpushdocker
```

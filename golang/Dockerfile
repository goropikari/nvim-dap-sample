FROM golang:1.22-bookworm
ENV SERVER_PORT=8080 \
    DELVE_PORT=8081 \
    DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get upgrade -y
RUN go install github.com/go-delve/delve/cmd/dlv@latest

WORKDIR /app/hoge
COPY main.go .
RUN go build -o server -gcflags=all='-N -l' main.go

EXPOSE $SERVER_PORT $DELVE_PORT
CMD dlv exec ./server --headless --continue --accept-multiclient --listen :$DELVE_PORT

FROM golang:1.23-alpine

ENV APP_HOME=/go/src/bird

RUN mkdir -p "$APP_HOME"

WORKDIR "$APP_HOME"

COPY go.mod ./

COPY *.go ./

RUN go build -o getBird

EXPOSE 4201

CMD [ "./getBird" ]
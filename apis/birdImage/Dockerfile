FROM golang:1.23-alpine

ENV APP_HOME=/go/src/birdImage

RUN mkdir -p "$APP_HOME"

WORKDIR "$APP_HOME"

COPY go.mod ./

COPY *.go ./

RUN go build -o getBirdImage

EXPOSE 4200

CMD [ "./getBirdImage" ]
FROM golang:alpine as builder
RUN apk update && apk add git
COPY . $GOPATH/src/app/
WORKDIR $GOPATH/src/app/
RUN go get -d -v
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -a -installsuffix cgo -ldflags="-w -s" -o /go/bin/app
FROM scratch
COPY --from=builder /go/bin/app /go/bin/app
ENTRYPOINT ["/go/bin/app"]
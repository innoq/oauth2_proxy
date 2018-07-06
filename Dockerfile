FROM golang:1.10.3 as builder

WORKDIR /go/src/github.com/bitly/oauth2_proxy
COPY . .
RUN make dep
RUN make build


FROM alpine:3.7

COPY --from=builder /go/src/github.com/bitly/oauth2_proxy/build/oauth2_proxy /oauth2_proxy
RUN apk add --no-cache --virtual=build-dependencies ca-certificates

EXPOSE 8080 4180
ENTRYPOINT [ "/oauth2_proxy" ]
CMD [ "--upstream=http://0.0.0.0:8080/", "--http-address=0.0.0.0:4180" ]
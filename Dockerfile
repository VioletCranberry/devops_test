FROM golang:1.12-alpine AS build-env

ENV CGO_ENABLED=0 \
    SRC_DIR=/build
RUN apk update && apk add git

WORKDIR $SRC_DIR
COPY app/ .
RUN go mod download
RUN go build -o app .

FROM scratch AS production

COPY --from=build-env /build/index.html .
COPY --from=build-env /build/assets .
COPY --from=build-env /build/app .

ENTRYPOINT ["./app"]

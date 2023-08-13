##
## Build
##
FROM golang:1.16-buster AS build

WORKDIR /app

COPY go.mod ./
RUN go mod download

COPY . ./

RUN CGO_ENABLED=0 go build -o /metr ./cmd/server/main.go

##
## Deploy
##
FROM scratch

WORKDIR /

COPY --from=build /metr /metr
COPY --from=build /app/config/gometr.conf.yaml /config/gometr.conf.yaml

EXPOSE 8000

ENTRYPOINT ["/metr"]
# Build stage
FROM golang:alpine AS builder
WORKDIR /app
COPY . .
RUN go build -o listmonk ./cmd

# Final image
FROM alpine:latest
WORKDIR /listmonk
RUN apk --no-cache add ca-certificates tzdata shadow su-exec
COPY --from=builder /app/listmonk .
COPY config.toml.sample config.toml
COPY static/config.toml.sample ./static/config.toml.sample
COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh
EXPOSE 9000
ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["./listmonk"]

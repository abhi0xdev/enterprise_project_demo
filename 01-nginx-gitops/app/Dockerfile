# ---- Stage 1: build ----
FROM alpine:3.20 AS builder
ARG APP_VERSION=dev
ARG GIT_SHA=local
WORKDIR /build
COPY site/ ./
RUN sed -i "s/__APP_VERSION__/${APP_VERSION}/g; s/__GIT_SHA__/${GIT_SHA}/g" index.html

# ---- Stage 2: runtime ----
FROM nginxinc/nginx-unprivileged:1.31-alpine AS runtime
LABEL org.opencontainers.image.source="https://github.com/abhi0xdev/enterprise_project_demo"
COPY --chown=101:101 nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=builder --chown=101:101 /build/ /usr/share/nginx/html/
USER 101
EXPOSE 8080
HEALTHCHECK --interval=30s --timeout=3s --retries=3 \
  CMD wget -qO- http://127.0.0.1:8080/healthz || exit 1
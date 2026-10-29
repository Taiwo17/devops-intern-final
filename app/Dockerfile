FROM nginx:1.27-alpine-slim

ARG BUILD_SHA=local

# Install the custom page and NGINX configuration
COPY app/index.html /usr/share/nginx/html/index.html
COPY app/nginx.conf  /etc/nginx/nginx.conf

# Inject the image build identifier into the html   
RUN sed -i "s/BUILD_SHA_PLACEHOLDER/${BUILD_SHA}/g" \
    /usr/share/nginx/html/index.html

# Run the web server as unpriviledge users
USER 101:101

EXPOSE 8080

HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD wget -q -O /dev/null http://127.0.0.1:8080/healthz || exit 1

ENTRYPOINT [ "nginx" ]
CMD [ "-g", "daemon off;" ]

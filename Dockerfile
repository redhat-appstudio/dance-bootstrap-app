FROM registry.access.redhat.com/ubi9/nodejs-22:latest as builder

COPY \
    app.js \
    package.json \
    package-lock.json \
    start.sh \
    /opt/app-root/src/

# If we combine this with the command above, the contents of the
# directory are copied instead of the full directory.
COPY html /opt/app-root/src/html

# Required for the `chmod` and the `npm install` command.
USER root

RUN chmod 777 html && npm install --only=production

FROM registry.access.redhat.com/ubi9/nodejs-22-minimal:latest

COPY --from=builder /opt/app-root/src /opt/app-root/src

# Configure and document the service HTTP port.
ENV PORT 8080
EXPOSE $PORT

ENV GIT_REPO=unknown
ENV DEBUG=express:*

# Run the web service on container startup.
CMD [ "/bin/sh", "/opt/app-root/src/start.sh" ]

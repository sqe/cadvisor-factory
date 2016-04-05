# Simulate Travis build environment
FROM quay.io/aptible/ubuntu:12.04

RUN apt-install git build-essential curl

ENV BUILD_USER build
ENV BUILD_HOME "/home/${BUILD_USER}"
ENV DEPLOY_TO "/home/${BUILD_USER}/out"

RUN useradd "$BUILD_USER"

RUN mkdir "$BUILD_HOME"
RUN chown -R "$BUILD_USER" "$BUILD_HOME"

USER "$BUILD_USER"
WORKDIR "$BUILD_HOME"

ADD helper.inc "$BUILD_HOME"
ADD install.sh "$BUILD_HOME"

RUN "${BUILD_HOME}/install.sh"
ADD . "$BUILD_HOME"

CMD "${BUILD_HOME}/build.sh"

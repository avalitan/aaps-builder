FROM alvrme/alpine-android-base:jdk21
LABEL maintainer="Avalitan <avalitan.docker.aaps@avalitan.com>"

ENV TARGET_SDK=35
ENV BUILD_TOOLS=35.0.0

ENV KEYSTORE_FILE=keystore
ENV KEYSTORE_PASSWORD=AndroidAPS
ENV KEYSTORE_ALIAS=key0
ENV VERSION=master

VOLUME [ "/aaps" ]
WORKDIR /aaps
COPY build-aaps /usr/bin
RUN chmod +x /usr/bin/build-aaps && mkdir /patches && mkdir /tmp/patches
COPY patches /tmp/patches/
COPY nginx.conf /tmp

# Install a local webserver and link to the APK output
# folder so users can navigate and install APKs directly
# from their phones after the build process is finished.
RUN apk add --no-cache nginx libqrencode libqrencode-tools && rm -rf /var/www/localhost/htdocs && ln -s -f /aaps/ /var/www/localhost/htdocs #&& sed -i 's/Listen 80/Listen 8080/g' /etc/apache2/httpd.conf

ENV PATH=$PATH:${ANDROID_SDK_ROOT}/build-tools/${BUILD_TOOLS}

# Install SDK Packages
RUN sdkmanager --sdk_root="${ANDROID_SDK_ROOT}" --install "build-tools;${BUILD_TOOLS}" "platforms;android-${TARGET_SDK}" && \
    sdkmanager --sdk_root="${ANDROID_SDK_ROOT}" --uninstall emulator || true

EXPOSE 8080/tcp
ENTRYPOINT ["/usr/bin/build-aaps"]
CMD ["app"]

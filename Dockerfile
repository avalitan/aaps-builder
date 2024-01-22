FROM alvrme/alpine-android-base:jdk17
LABEL maintainer="Avalitan <avalitan.docker.aaps@avalitan.com>"

ENV KEYSTORE_FILE=keystore
ENV KEYSTORE_PASSWORD=AndroidAPS
ENV KEYSTORE_ALIAS=key0
ENV VERSION=master

ENV BUILD_VERSION="33.0.0"
ENV BUILD_TOOLS="r33"

VOLUME [ "/aaps" ]
WORKDIR /aaps
RUN wget -q https://dl.google.com/android/repository/build-tools_${BUILD_TOOLS}-linux.zip -O /tmp/tools.zip && \
	mkdir -p ${ANDROID_HOME}/build-tools && \
	unzip -qq /tmp/tools.zip -d ${ANDROID_HOME}/build-tools && \
	mv ${ANDROID_HOME}/build-tools/* ${ANDROID_HOME}/build-tools/${BUILD_VERSION} && \
	rm -v /tmp/tools.zip
COPY build-aaps /usr/bin
RUN chmod +x /usr/bin/build-aaps && mkdir /patches && mkdir /tmp/patches
COPY patches /tmp/patches/
COPY nginx.conf /tmp


# Install a local webserver and link to the APK output
# folder so users can navigate and install APKs directly
# from their phones after the build process is finished.
RUN apk add --no-cache nginx libqrencode && rm -rf /var/www/localhost/htdocs && ln -s -f /aaps/ /var/www/localhost/htdocs #&& sed -i 's/Listen 80/Listen 8080/g' /etc/apache2/httpd.conf

EXPOSE 8080/tcp
ENTRYPOINT ["/usr/bin/build-aaps"]
CMD ["app"]

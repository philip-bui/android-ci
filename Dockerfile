FROM openjdk:14-jdk-slim
LABEL maintainer="philip.bui.developer@gmail.com"

RUN apt-get update -q && \
	apt-get install -q -y \
	curl \
	libpulse0 \
	libglu1-mesa 

ARG SDK_VERSION=sdk-tools-linux-3859397.zip
ENV ANDROID_HOME=/opt/android/sdk

RUN mkdir -p ${ANDROID_HOME} && \
	curl --silent --show-error --location --fail --retry 3 --output /tmp/${SDK_VERSION} https://dl.google.com/android/repository/${SDK_VERSION} && \
	unzip -q /tmp/${SDK_VERSION} -d ${ANDROID_HOME} && \
	rm /tmp/${SDK_VERSION}

ENV PATH=${PATH}:${ANDROID_HOME}/emulator:${ANDROID_HOME}/tools:${ANDROID_HOME}/tools/bin:${ANDROID_HOME}/platform-tools

RUN mkdir ~/.android && echo '### User Sources for Android SDK Manager' > ~/.android/repositories.cfg

RUN touch /var/log/licenses.log && \
	yes | sdkmanager --licenses > /var/log/licenses.log && sdkmanager --update
RUN sdkmanager --list|grep tools
RUN sdkmanager \
	"tools" \
	"platform-tools" \
	"emulator" \
	"extras;android;m2repository" \
	"extras;google;m2repository" \
	"extras;google;google_play_services"

RUN sdkmanager "system-images;android-25;google_apis;arm64-v8a" "build-tools;25.0.3" "platforms;android-25" 
 
RUN echo no|avdmanager -s create avd -n test -f -k "system-images;android-25;google_apis;arm64-v8a"


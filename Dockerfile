FROM ubuntu:latest as ubuntu

RUN apt update --yes && apt install curl unzip --yes

COPY --from=gradle:6.5-jdk8 /opt/java/ /opt/java/

# ARG ndk_tool_version=21.0.6113669
ARG built_tools=28.0.3
ARG platform_version=28

ENV ANDROID_SDK_ROOT=/opt/android-sdk \
    ANDROID_HOME=/opt/android-sdk \
    DEBIAN_FRONTEND=noninteractive \
    JAVA_HOME=/opt/java/openjdk

# install android sdk
RUN mkdir -p ${ANDROID_SDK_ROOT}/cmdline-tools \
    && curl -o commandlinetools-linux-6609375_latest.zip https://dl.google.com/android/repository/commandlinetools-linux-6609375_latest.zip \
    && unzip commandlinetools-linux-6609375_latest.zip -d ${ANDROID_SDK_ROOT}/cmdline-tools \
    && rm -rf commandlinetools-linux-6609375_latest.zip

RUN echo yes | ${ANDROID_SDK_ROOT}/cmdline-tools/tools/bin/sdkmanager "build-tools;${built_tools}" \
    && echo yes | ${ANDROID_SDK_ROOT}/cmdline-tools/tools/bin/sdkmanager "platforms;android-${platform_version}" \
    && echo yes | ${ANDROID_SDK_ROOT}/cmdline-tools/tools/bin/sdkmanager "platform-tools"
    # && echo yes | ${ANDROID_SDK_ROOT}/cmdline-tools/tools/bin/sdkmanager "ndk;${ndk_tool_version}"

FROM node:lts

USER root

WORKDIR /tmp

COPY --from=ubuntu /opt/android-sdk /opt/android-sdk
COPY --from=gradle:6.5-jdk8 /opt/gradle /opt/gradle
COPY --from=gradle:6.5-jdk8 /opt/java/ /opt/java/

# path env
ENV ANDROID_SDK_ROOT=/opt/android-sdk \
    ANDROID_HOME=/opt/android-sdk \
    JAVA_HOME=/opt/java/openjdk \
    GRADLE_HOME=/opt/gradle

ENV PATH=${PATH}:${JAVA_HOME}/bin:${GRADLE_HOME}/bin:${ANDROID_HOME}/bin:${ANDROID_HOME}/platform-tools:${ANDROID_HOME}/tools/bin:${ANDROID_HOME}/built_tools/${built_tools}

COPY ./npm.env.sh ./npm.env.sh
RUN chmod +x ./npm.env.sh && ./npm.env.sh

RUN npm -g i --unsafe-perm @quasar/cli cordova pngquant-bin node-sass

CMD [ "bash" ]

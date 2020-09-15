FROM ubuntu:latest

WORKDIR /tmp

RUN apt update --yes && apt install curl unzip --yes && apt autoremove && apt-get autoclean

COPY --from=gradle:6.5-jdk8 /opt/gradle /opt/gradle
COPY --from=gradle:6.5-jdk8 /opt/java/ /opt/java/

# ARG ndk_tool_version=21.0.6113669
ARG build_tools=28.0.3
ARG platform_version=28

ENV ANDROID_SDK_ROOT=/opt/android-sdk \
    ANDROID_HOME=/opt/android-sdk \
    DEBIAN_FRONTEND=noninteractive \
    JAVA_HOME=/opt/java/openjdk \
    GRADLE_HOME=/opt/gradle

# install android sdk
RUN mkdir -p ${ANDROID_SDK_ROOT}/cmdline-tools \
    && curl -o commandlinetools-linux-6609375_latest.zip https://dl.google.com/android/repository/commandlinetools-linux-6609375_latest.zip \
    && unzip commandlinetools-linux-6609375_latest.zip -d ${ANDROID_SDK_ROOT}/cmdline-tools \
    && rm -rf commandlinetools-linux-6609375_latest.zip

RUN echo yes | ${ANDROID_SDK_ROOT}/cmdline-tools/tools/bin/sdkmanager "build-tools;${build_tools}" > /dev/null \
    && echo yes | ${ANDROID_SDK_ROOT}/cmdline-tools/tools/bin/sdkmanager "platforms;android-${platform_version}" \
    && echo yes | ${ANDROID_SDK_ROOT}/cmdline-tools/tools/bin/sdkmanager "platform-tools"
    # && echo yes | ${ANDROID_SDK_ROOT}/cmdline-tools/tools/bin/sdkmanager "ndk;${ndk_tool_version}"

COPY --from=node:lts /usr /usr
COPY --from=node:lts /opt/yarn-v1.22.4 /opt/yarn-v1.22.4
COPY ./npm.env.sh ./npm.env.sh

ENV PATH=${PATH}:${JAVA_HOME}/bin:${GRADLE_HOME}/bin:${ANDROID_HOME}/bin:${ANDROID_HOME}/platform-tools:${ANDROID_HOME}/tools/bin:${ANDROID_HOME}/build-tools/${build_tools}

RUN chmod +x ./npm.env.sh && ./npm.env.sh && rm -rf /tmp/* \
    && npm -g i --unsafe-perm @quasar/cli cordova pngquant-bin node-sass

CMD [ "bash" ]

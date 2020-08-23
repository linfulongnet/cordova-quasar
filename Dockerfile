FROM gradle:6.5-jdk8

USER root

# ARG ndk_tool_version=21.0.6113669
ARG built_tools=28.0.3
ARG platform_version=28

ENV ANDROID_SDK_ROOT=/opt/android-sdk \
    ANDROID_HOME=/opt/android-sdk \
    DEBIAN_FRONTEND=noninteractive

# install android sdk
RUN mkdir -p ${ANDROID_SDK_ROOT}/cmdline-tools \
    && curl -o commandlinetools-linux-6609375_latest.zip https://dl.google.com/android/repository/commandlinetools-linux-6609375_latest.zip \
    && unzip commandlinetools-linux-6609375_latest.zip -d ${ANDROID_SDK_ROOT}/cmdline-tools \
    && rm -rf commandlinetools-linux-6609375_latest.zip

RUN echo yes | ${ANDROID_SDK_ROOT}/cmdline-tools/tools/bin/sdkmanager "build-tools;${built_tools}" > /dev/null \
    && echo yes | ${ANDROID_SDK_ROOT}/cmdline-tools/tools/bin/sdkmanager "platforms;android-${platform_version}" \
    && echo yes | ${ANDROID_SDK_ROOT}/cmdline-tools/tools/bin/sdkmanager "platform-tools"
    # && echo yes | ${ANDROID_SDK_ROOT}/cmdline-tools/tools/bin/sdkmanager "ndk;${ndk_tool_version}"

# copy node npm yarn
COPY --from=node:lts-alpine / /

# path env
ENV PATH=${PATH}:${JAVA_HOME}/bin:${GRADLE_HOME}/bin:${ANDROID_HOME}/bin:${ANDROID_HOME}/platform-tools:${ANDROID_HOME}/tools/bin:${ANDROID_HOME}/built_tools/${built_tools}

RUN npm -g i @quasar/cli cordova

WORKDIR /tmp

CMD [ "bash" ]


FROM ubuntu:14.04

# Development user
RUN echo "%sudo ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers \
    && useradd -u 1000 -G sudo -d /home/developer --shell /bin/bash -m developer \
    && echo "secret\nsecret" | passwd developer

# Basic packages and Java 8
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
                      android-tools-adb \
                      android-tools-adbd \
                      blackbox \
                      build-essential \
                      curl \
                      bison \
                      git \
                      gperf \
                      lib32gcc1 \
                      lib32bz2-1.0 \
                      lib32ncurses5 \
                      lib32stdc++6 \
                      lib32z1 \
                      libc6-i386 \
                      libhardware2 \
                      libxml2-utils \
                      make \
                      software-properties-common \
                      unzip \
                      wget \
    && add-apt-repository ppa:openjdk-r/ppa \
    && apt-get update \
    && apt-get install -y \
                      openjdk-8-jdk \
                      ca-certificates-java \
    && apt-get clean \
    && apt-get autoremove \
    && rm -rf /var/lib/apt/lists/*

# Set things up using the dev user and reduce the need for `chown`s
USER developer

# Android SDK
ENV SDK_SHA1 725bb360f0f7d04eaccff5a2d57abdd49061326d
ENV SDK_VERSION 24.4.1
RUN wget -q http://dl.google.com/android/android-sdk_r${SDK_VERSION}-linux.tgz -O /tmp/android-sdk.tar.gz \
    && echo "$SDK_SHA1 /tmp/android-sdk.tar.gz" | sha1sum -c - \
    && echo "installing SDK v $SDK_VERSION" \
    && tar -xzf /tmp/android-sdk.tar.gz -C /home/developer/ \
    && rm /tmp/android-sdk.tar.gz

# Configure the SDK
# TODO: Move this up so that it is cached between android-studio releases
ENV ANDROID_HOME="/home/developer/android-sdk-linux" \
    PATH="${PATH}:/home/developer/android-sdk-linux/tools:/home/developer/android-sdk-linux/platform-tools" \
    JAVA_HOME="/usr/lib/jvm/java-8-openjdk-amd64"

# Android Studio
ENV STUDIO_URL https://dl.google.com/dl/android/studio/ide-zips/1.5.1.0/android-studio-ide-141.2456560-linux.zip
ENV STUDIO_SHA1 b8460a2197abe26979d88e3b01b3c8bfd80a37db
RUN cd /opt \
    && sudo mkdir android-studio \
    && sudo chown developer:developer android-studio \
    && wget -q ${STUDIO_URL} -O /tmp/android-studio.zip \
    && echo "$STUDIO_SHA1 /tmp/android-studio.zip" | sha1sum -c - \
    && unzip /tmp/android-studio.zip \
    && rm /tmp/android-studio.zip


# TODO: what else do we need for sdk stuff to work?
RUN echo y | android update sdk --all --no-ui --force --filter platform-tools
RUN echo y | android update sdk --all --no-ui --force --filter extra-android-m2repository
RUN echo y | android update sdk --all --no-ui --force --filter extra-google-m2repository

RUN echo y | android update sdk --all --no-ui --force --filter android-16
RUN echo y | android update sdk --all --no-ui --force --filter source-16
RUN echo y | android update sdk --all --no-ui --force --filter build-tools-16.0.0

RUN echo y | android update sdk --all --no-ui --force --filter android-17
RUN echo y | android update sdk --all --no-ui --force --filter source-17
RUN echo y | android update sdk --all --no-ui --force --filter build-tools-17.0.4

RUN echo y | android update sdk --all --no-ui --force --filter android-19
RUN echo y | android update sdk --all --no-ui --force --filter source-19
RUN echo y | android update sdk --all --no-ui --force --filter build-tools-19.0.3

RUN echo y | android update sdk --all --no-ui --force --filter android-23
RUN echo y | android update sdk --all --no-ui --force --filter source-23
RUN echo y | android update sdk --all --no-ui --force --filter build-tools-23.0.3

# http://stackoverflow.com/questions/32090832/android-studio-cant-start-after-installation
RUN echo "disable.android.first.run=true" > /opt/android-studio/bin/idea.properties

# setup connection to real hardware device
USER root
ADD 51-android.rules /etc/udev/rules.d/51-android.rules
RUN chmod a+r /etc/udev/rules.d/51-android.rules
USER developer

# TODO: Merge this into the studio installation step
RUN sudo ln -s /opt/android-studio/bin/studio.sh /bin/studio

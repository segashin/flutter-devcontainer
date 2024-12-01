FROM ubuntu:24.04

# Prerequisites
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    rm /etc/apt/apt.conf.d/docker-clean \
    && apt update \
    && apt install -y \
    curl \
    git \
    unzip \
    xz-utils \
    zip \
    libglu1-mesa \
    libpulse0 \
    openjdk-17-jdk \
    wget \
    && rm -rf /var/lib/apt/lists/*

ENV USERNAME=ubuntu
ENV HOME=/home/$USERNAME

# # Set up a new user
# RUN useradd -ms /bin/bash $USERNAME

USER $USERNAME
WORKDIR $HOME

# Prepare Android directories and system variables
ENV ANDROID_SDK_ROOT=$HOME/android/sdk
RUN mkdir -p $ANDROID_SDK_ROOT
RUN mkdir -p .android && touch .android/repositories.cfg
 
# Install Flutter SDK
ENV DEVELOPMENT_DIR=$HOME/development
RUN mkdir -p $DEVELOPMENT_DIR
RUN wget -O flutter.zip https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.24.5-stable.tar.xz
RUN tar -xf flutter.zip -C $DEVELOPMENT_DIR && rm flutter.zip
ENV ANDROID_PLATFORM_VERSION=
ENV PATH=$PATH:$DEVELOPMENT_DIR/flutter/bin

# Install Android SDK and tools
# - Android SDK Platform, API 35.0.1
# - Android SDK Command-line Tools
# - Android SDK Build-Tools
# - Android SDK Platform-Tools
# - (optional) Android Emulator

# SDK Command-line Tools
ENV COMMANDLINE_TOOLS_VERSION=11076708_latest
ENV ANDROID_PLATFORM_VERSION=33
ENV ANDROID_BUILD_TOOLS_VERSION=34.0.0
RUN wget -O sdk-tools.zip https://dl.google.com/android/repository/commandlinetools-linux-$COMMANDLINE_TOOLS_VERSION.zip
RUN unzip sdk-tools.zip -d $ANDROID_SDK_ROOT/tmp && rm sdk-tools.zip
RUN mkdir -p $ANDROID_SDK_ROOT/cmdline-tools/latest && mv $ANDROID_SDK_ROOT/tmp/cmdline-tools/* $ANDROID_SDK_ROOT/cmdline-tools/latest
ENV PATH=$PATH:$ANDROID_SDK_ROOT/cmdline-tools/latest/bin
ENV PATH=$PATH:$ANDROID_SDK_ROOT/platform-tools
ENV PATH=$PATH:$ANDROID_SDK_ROOT/emulator

RUN yes | sdkmanager --licenses
RUN sdkmanager \
        "build-tools;$ANDROID_BUILD_TOOLS_VERSION" \
        "platform-tools" \
        "platforms;android-$ANDROID_PLATFORM_VERSION" \
        "sources;android-$ANDROID_PLATFORM_VERSION" \
        "emulator"
#         "system-images;android-$ANDROID_PLATFORM_VERSION;google_apis;x86_64"

# RUN echo yes | avdmanager create avd --force -n Android${ANDROID_PLATFORM_VERSION} \
#     -k "system-images;android-${ANDROID_PLATFORM_VERSION};google_apis;x86_64" \
#     --device "pixel"

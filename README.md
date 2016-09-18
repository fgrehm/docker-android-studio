# docker-android-studio

Android Studio in a Docker container.
This image comes with API Levels `16, 17, 19, 23` installed, because that's what me and my partners currently use for university.

## Getting Started

### Starting the container

You don't want to remove the container between uses, because many things installed via the _Android Studio GUI_ are only stored in the container.


```bash
    docker run -it  \
           --net=host \
           --name android-studio \
           --privileged \
           -e DISPLAY \
           -e SHELL=/bin/bash \
           -e GRADLE_USER_HOME='/workspace/.docker-dev/.gradle/home' \
           -v /tmp/.X11-unix:/tmp/.X11-unix \
           -v /dev/bus/usb:/dev/bus/usb \
           -v $ANDROID_DIR/projects:/home/developer/AndroidStudioProjects \
           -v $ANDROID_DIR:/workspace \
           -v $ANDROID_DIR/.docker-dev/.studio-home:/home/developer/.AndroidStudio1.2 \
           -v $ANDROID_DIR/.docker-dev/.android/avd:/home/developer/.android/avd \
           fschl/android-studio:latest \
           /bin/studio
```

### Enable Developer Options On Real Hardware Device

http://developer.android.com/tools/device.html#setting-up

### Connect Real Device to your Android-Studio Container

- this image comes with `android-tools-adb` installed
- VendorId of your device has to be added to `./51-android.rules` to be able to detect/connect to device
- USB device needs to be mounted into the container `-v /dev/bus/usb/:/dev/bus/usb`

_This feels quite scary but was the easiest thing I came up with, so far._

#### check if device is detected inside container

1. open a bash in your container
```bash
docker run -it -u root <id/name of your android-studio container> bash
```

2. ```adb devices```

## Personal Notes

- Using LG Phone with Android `4.4.2` installed
- [USB Vendor IDs](http://developer.android.com/tools/device.html#VendorIds)
  - LG: 1004
-

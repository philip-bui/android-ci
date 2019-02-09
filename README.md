# Android CI

[![Docker Pulls](https://img.shields.io/docker/pulls/philipbui/android-ci.svg)](https://hub.docker.com/r/philipbui/android-ci)
[![Docker Build Status](https://img.shields.io/docker/build/philipbui/android-ci.svg)](https://hub.docker.com/r/philipbui/android-ci/builds)
[![Docker Automated build](https://img.shields.io/docker/automated/philipbui/android-ci.svg)](https://hub.docker.com/r/philipbui/android-ci/~/dockerfile)

## Setup

Use `philipbui/android-ci` as your Docker image.

### Build

```yaml
script:
  - ./gradlew clean assembleRelease

artifacts:
  - app/build/outputs
```

### Unit Tests

```yaml
script:
  - ./gradlew test
  
artifacts:
  - app/build/reports/tests
```

### Instrumentation Tests

```yaml
script:
  - echo no|avdmanager -s create avd -n test -f -k "system-images;android-25;google_apis;arm64-v8a"
  - emulator -avd test -no-audio -no-window & source <(curl -sSL https://raw.githubusercontent.com/philip-bui/android-ci/master/wait-for-emulator.sh)
  - adb shell settings put global window_animation_scale 0 &
  - adb shell settings put global transition_animation_scale 0 &
  - adb shell settings put global animator_duration_scale 0
  - adb shell input keyevent 82
  - ./gradlew cAT
  - source <(curl -sSL https://raw.githubusercontent.com/philip-bui/android-ci/master/stop-emulators.sh)

artifacts:
  - app/build/reports/androidTest/connected/
```

# flutter-docker-devcontainer
VS Code devcontainer for Flutter, especially Android, development. Runs on any device that has docker and adb(android debug bridge).


## Available features
### Supported Platforms
You can develop apps for following platforms
- Android - supported
    - Android emulator is not supported
- iOS - not supported yet
- Web - not supported yet

## Requirements
Your machine should be able to run the following tools
- VS Code
- Docker
    - Docker can be installed on your host machine. On Windows, docker can be installed on either Windows or WSL2.
- Android Debug Bridge(adb)
    - ADB must be installed on your host machine to detect physical Android devices.
    

## How to start developing
### Install Prerequisite Tools
1. ADB
    - Install Android SDK Platform Tools which includes ADB
        - https://developer.android.com/tools/releases/platform-tools
    - You should be able to use `adb` command before proceeding to the next step.
        - Make sure your PATH is configured.
        - Try `adb --version` to check adb installation.
2. Docker
    - Install Docker
        - You should be able to use `docker` command without `sudo` before proceeding to the next step.
        - On Windows, docker can be installed on either Windows or WSL2.

### Steps
1. Launch ADB on your host machine
    - On your Android device, enable Developer Developer Mode and turn on USB debugging.
    - Connect the Android deivce to your computer.
    - Execute `adb devices`. You should see your Android device listed.
        - Execute `adb tcpip 5555`
            - 5555 is the port on which ADB will run. Choose a different port if it's occupied by something else.
        - The list might indicate your device is unauthorized
        - On your Android device, you will be asked to allow USB debugging.
        - Execute `adb devices` again to check your device status.
2. VS Code setup
    - Clone this repository and open the root of this repository on VS Code.
    - Click the `><` bottom in the bottom left corner and select `Reopen in container`
        - Wait for a while until container starts running
    - `Ctr + Shift + P` and `Flutter: New Project`. Follow the prompt to create a new project.
    - Check the IP address of your Android device.
        - `Settings` → `About phone` → `Status` → `IP address`
        - It will probably be something like `192.168.0.2`.
    - Open terminal on VS Code and run `adb connect ANDROID_IP:ADB_PORT`
        - Replace the `ANDROID_IP` and `ADB_PORT` with proper values.
        - The command will look something like `adb connect 192.168.0.2:5555`
3. Run Flutter app on Android Device
    - `Ctr + Shift + P` and `Flutter: Select Device`. You should see your Android device listed. Select it.
    - On your VS Code terminal, run `flutter run`
        - If build succeeds, your app will run on your Android device.

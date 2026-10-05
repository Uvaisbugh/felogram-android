# Android baseline build on Windows

This guide builds the upstream-derived debug baseline. It does not establish a
rebranded or release-ready Felogram APK. Do not install the upstream-identity APK
over another Telegram installation or sign into it for Felogram verification.

## 1. Source and long paths

Use a short checkout path. This source contains long media test filenames.
Configure Git per repository rather than changing global/system settings:

```powershell
git config core.longpaths true
git -c core.longpaths=true submodule update --init --recursive --depth 1
```

If a submodule checkout reports a long-filename error, set `core.longpaths true`
inside that submodule and retry its checkout. Preserve any personal edits first.
Record `git rev-parse HEAD` and `git submodule status --recursive` for evidence.

## 2. Toolchain

The current source specifies Gradle 8.13, Android Gradle Plugin 8.13.2, SDK/build
tools 36, NDK 27.2.12479018 and CMake 3.22.1. This host uses JDK 17. Java source
compatibility is configured separately by upstream and is not the Gradle JVM.
Install missing components through Android Studio's SDK Manager, selecting
**Show Package Details** for the exact NDK version. Keep existing versions.

This upstream tree includes the wrapper JAR and Unix launcher, but no Windows
launcher. Our PowerShell helper invokes that same wrapper directly with Java.
It does not substitute a system Gradle installation or rewrite build files.

```powershell
$env:JAVA_HOME = 'C:\path\to\jdk-17'
$env:ANDROID_HOME = 'C:\path\to\Android\Sdk'
./scripts/build-android.ps1 -PreflightOnly
./scripts/build-android.ps1
```

The helper bounds workers and JVM memory. Dependency/native builds still require
substantial time, memory and disk. If SDK licenses are already accepted, the
explicit `-AllowSdkDownload` switch permits Gradle's normal SDK auto-installation.
It does not automatically accept licenses or bypass missing source dependencies.
The helper's Gradle cache is ignored; set GRADLE_USER_HOME to reuse another cache.

## 3. Credentials and output

Upstream contains documented dummy API/push/signing configuration for its build.
Use it only for baseline compilation. Felogram distribution requires independent
identity, own API/push configuration and private signing setup. Never commit real
credentials, keystores, SDK paths or session data.

The default task is `:TMessagesProj_App:assembleAfatDebug` (upstream's multi-ABI
debug flavor). APK output is under `TMessagesProj_App/build/outputs/apk` if it
succeeds. A Gradle launcher success or configuration success is not an APK build.
Record task exit status, APK SHA-256, tool versions and runtime evidence separately.

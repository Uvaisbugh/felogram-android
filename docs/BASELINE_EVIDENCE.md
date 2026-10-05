# Android baseline evidence

Recorded on 2026-10-05. This is an upstream-derived debug foundation, not a
Felogram release or a completed account/messaging verification.

- Upstream source: `f2908b14133bbffbf7ab04f641ecb5bfaf533242` (12.10.6).
- All 15 direct submodules initialized at upstream-pinned revisions.
- Windows host: JDK 17.0.20.1, Gradle 8.13, AGP 8.13.2, SDK/build tools 36,
  NDK 27.2.12479018, CMake 3.22.1.
- Task: `:TMessagesProj_App:assembleAfatDebug` with injected ARM64 selection.
- Result: Gradle exit 0, 301 tasks, 36m 58s for the final packaging attempt.
- APK: `TMessagesProj_App/build/intermediates/apk/afat/debug/app.apk`.
- Preserved artifact: 63,947,343 bytes; SHA-256
  `B14EB07113D1289A39E741048944CBCA91A7DD8FBEFCC64EE34C43ADAE130107`.
- Identity: `org.telegram.messenger.beta`, version code 71129, Telegram Beta.
- `apksigner verify --verbose`: verified, v1 and v2 signatures present.

## Offline runtime check

A new workspace-only emulator profile booted API 37.2 with 16 KB pages and ARM64
translation on x86_64. Airplane mode was enabled before installation. The APK
installed using `adb install -t --abi arm64-v8a`, and LaunchActivity returned
`Status: ok`. The welcome screen rendered and the process remained running.
No fatal AndroidRuntime exception was logged during this check. The profile was
closed after testing; existing user emulator profiles were not modified.

This does not verify authentication, network behavior, messaging, notifications,
physical ARM64 devices, performance or accessibility. Dummy upstream API/push
and signing configuration is retained for this offline compilation baseline.

## Verified packaging correction

The injected ABI property restricts native compilation but did not remove
other-ABI MLKit libraries from the APK. Those ABI folders lack the matching
Telegram native library, so this artifact must not be described as a complete
multi-ABI build. `scripts/single-abi.gradle` additionally restricts default/flavor
ABI filters to the selected ABI. The corrected build succeeded in 1m 22s (301 tasks; 297 up-to-date). ZIP inspection confirmed only ARM64 libraries: Telegram and MLKit. Signature verification passed again. `-Abi all` preserves upstream configuration.

Corrected artifact: 62,343,517 bytes, SHA-256
`3EC0DC57D221595CCBF2F33431DC22347A5802AD52A3E9BBB12EDA11FC18425E`.
`aapt2 dump badging` reports only `arm64-v8a`, minimum SDK 21, target SDK 36.
The recursive [submodule manifest](baseline-submodules.txt) records the revisions.
The corrected APK was installed over the owned baseline test package in the same isolated offline emulator. LaunchActivity again returned Status ok; the process remained running and the welcome screen rendered. No fatal AndroidRuntime exception was recorded. The emulator was closed after the check.

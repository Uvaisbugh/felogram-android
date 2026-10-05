# Felogram development identity evidence

Recorded on 2026-10-05, from baseline source/helper snapshot
`bd4c81eb380a20cb9fc1a7649f83adf5d0e67cbb` plus the independent-identity patch.

- First branded build passed; visual inspection caught an unregistered
  localization string. Registering the new strings in upstream's `strings.xml`
  pipeline fixed the welcome text and setup dialog.
- Corrected build: Gradle exit 0, 4m02s, 299 tasks (281 up-to-date).
- APK: 64,736,059 bytes, SHA-256
  `610772663F0F968A5C5C6E249751FC09E3956058967237CC756446D0EE7F8B46`.
- Package `io.github.uvaisbugh.felogram.beta`; launcher label Felogram Dev.
- Minimum SDK 21, target SDK 36, ARM64-only native libraries.
- APK signature verification passed (v1/v2). The signer is still the documented
  upstream dummy development keystore; private production signing remains open.
- Installed beside `org.telegram.messenger.beta` in the isolated offline AVD.
  Both packages remained installed. LaunchActivity returned Status ok, the
  Felogram mark/name/text rendered, and no fatal AndroidRuntime exception appeared.
- Tapping Start Messaging with default unconfigured API settings showed the
  explanatory Offline developer build dialog and did not open sign-in.
- A distribution-task dry run failed during configuration with the intended
  missing-maintainer-API error, before any release task could execute.

The AVD was closed after testing. No existing user emulator profile or Telegram
session was modified. This verifies package separation and initial UI behavior,
not account-storage isolation under sign-in or physical-device operation.

The Settings About/source row compiled but still needs signed-in UI verification.
Push, other store variants, private signing, account tests, notifications,
accessibility and developer workflows remain open. No production APK is released.

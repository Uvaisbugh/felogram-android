# Felogram Android

Independent Android Telegram client for developers and power users.
**Status: upstream-derived debug APK builds and opens offline in an isolated emulator. No rebranded Felogram APK has been released.** Upstream features are not yet verified
as Felogram features. The existing Windows Python prototype is a separate project.

## Foundation

Forked from [official Android source](https://github.com/DrKLO/Telegram).
Preserve upstream history, copyright, license and dependency notices.
Do not describe this code as MIT. The upstream README below remains the build
reference; its official branding describes upstream, not affiliation of Felogram.

Research reference: `f2908b14133bbffbf7ab04f641ecb5bfaf533242`.
Pin a tested release baseline and record recursive submodule versions before
distribution. Own API identity, package name, icon, storage, signing and any
push-service configuration are required for an independent release.

## Proposed first differentiators

- Account-scoped local project workspaces and discussion bookmarks.
- Fast return to saved searches and linked messages.
- Exact code copy, readable wrapping and safe text/log file workflows.
- Discoverable notification/focus settings with normal Telegram read behavior.

No forced Python runtime or shared desktop UI. Keep feature changes localized;
maintain a patch inventory and rehearse upstream merges.
No added analytics by default. Translation/external processing is deferred until
provider, data disclosure and Telegram terms are assessed.

## To-do and release gates

- [x] Create public repository separately from Windows prototype.
- [x] Preserve official source provenance and GPL license.
- [x] Build upstream-derived ARM64 debug APK; record source/toolchain and offline startup evidence.
- [x] Verify corrected ARM64-only packaging, signature and offline emulator startup.
- [ ] Verify startup on a physical ARM64 device.
- [x] Add a Windows build helper and prerequisite checks; Gradle wrapper and
  exact SDK/NDK/CMake setup verified. See [baseline evidence](docs/BASELINE_EVIDENCE.md).
- [ ] Add Felogram package/icon/name and About/source links; install beside upstream.
- [ ] Configure own API/push identities outside source; keep signing secrets private.
- [ ] Verify login, reopen/logout and multi-account isolation with test accounts.
- [ ] Verify text/media/file/voice, edits, reactions, topics and reconnect.
- [ ] Verify notifications screen-off and under background restrictions on two vendors.
- [ ] Implement/test workspaces, bookmarks, code copy and saved search incrementally.
- [ ] Verify TalkBack, 200% font scaling, share intents and process recreation.
- [ ] Compare startup/memory/battery against identical upstream baseline.
- [ ] Define Play/FOSS build differences and dependency/network inventory.
- [ ] Complete license/source, signing, install/upgrade and update gates before APK release.

Full [product specification](https://github.com/Uvaisbugh/felogram/blob/main/docs/PRODUCT_PLAN.md)
and [comparison research](https://github.com/Uvaisbugh/felogram/blob/main/docs/CLIENT_RESEARCH.md)
live in the project planning repository. Do not use upstream release links as
Felogram download links.

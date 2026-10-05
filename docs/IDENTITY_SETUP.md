# Felogram Android development identity

This stage targets the primary `TMessagesProj_App` ARM64 debug build. Other
store flavors and push integrations remain separate verification work.

## Private maintainer configuration

Copy `.felogram.properties.example` to `.felogram.properties` in the checkout.
The latter file is ignored by Git. Add the app maintainer's Telegram `api_id`
as `api.id` and `api_hash` as `api.hash`. Do not paste them into chat or commit
the completed file. Every end user should not need to register a developer app.

An unconfigured checkout builds an offline debug app with sign-in disabled and
an explanatory setup dialog. A partial/invalid pair fails configuration, and
release/standalone tasks require a complete pair. API credentials in a shipped
client are compiled into its binary; this local-file rule prevents accidental
source publication, not extraction by an APK recipient.

## Identity and service boundaries

The application ID is `io.github.uvaisbugh.felogram`; debug adds `.beta`. Android
isolates its private data by that ID. Native Java namespaces remain upstream
names to keep the patch small. Manifest authorities use application ID placeholders.
Install beside the verified upstream baseline to check package/storage separation.

Launcher and welcome screen use Felogram's F/chat mark and app name. Settings
has an About Felogram row with a source link and license attribution. The
upstream optional icon variants still exist and need a later branding pass.

The primary debug build does not generate upstream Firebase service identity.
Own push configuration and background-notification verification are unresolved;
Google/Firebase libraries are still dependencies. Official-app-only passkeys,
Google authentication, billing and upstream automatic-update checks are disabled.
This is not a FOSS flavor or a completed notification implementation.

## Acceptance gates

- Build and inspect package, label, signature and source/API configuration.
- Install beside the upstream baseline in the isolated emulator.
- Verify the welcome screen and missing-configuration dialog offline.
- Verify own API configuration, account login, session reopening and logout.
- Test notifications and account isolation on physical devices.
- Define push, signing, store/FOSS and update policies before distribution.

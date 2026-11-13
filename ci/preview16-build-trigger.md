# COUI Preview 16 build trigger

This file records the signed Preview 16 CI build attempt after the R5 `darkenTheme` ThemeExtension type fix. The build source is `release/coui-secure-preview-1`; the signing key is supplied separately as an ephemeral encrypted envelope.

## R6 test fixture follow-up

The COUI setting separator assertion now targets the `material_ui` widget, and standalone CDN/account tests initialize isolated Hive settings boxes before accessing preferences.

## R7 account fixture follow-up

Initialize isolated `localCache` Hive storage for account tests, which use `Pref.buvid` during serialization.

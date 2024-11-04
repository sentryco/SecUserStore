[![Tests](https://github.com/sentryco/SecUserStore/actions/workflows/Tests.yml/badge.svg)](https://github.com/sentryco/SecUserStore/actions/workflows/Tests.yml)
[![codebeat badge](https://codebeat.co/badges/2aee5e88-5ffe-41d9-848b-983182003de4)](https://codebeat.co/projects/github-com-sentryco-secuserstore-main)

# SecUserStore

> Secure user store

## Description

Utilizes keychain to securely store sensitive user data. 

## Problem

Regular UserDefault are not secure by default. It's possible to extract them with third party software. 

## Solution

This library works like userdefault, with its easy to use interface but under the hood stores the user data in keychain.
 
## Examples

Minimal implementation for setting up a secure user default. 

```swift
struct PrefsStore: SecUserStoreKind { 
   var useBioAuth: Bool
   var usePassword: Bool
   static var key: String { "secure-prefs-store" }
   static var defaultModel: PrefsStore {
      .init(useBioAuth: false, useBioAuth: false)
   }
}
```

## Todo
- Add more description
- Clean up comments
- Add info regarding limitations with some variable. Bools etc. 
- Add dependency declaration in the readme
- Consider adding the simpler keychain kit from telemetry etc

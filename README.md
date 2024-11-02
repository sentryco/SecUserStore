# SecUserStore

> Secure user default

## Description

Secure Storage. Utilizes keychain to securely store sensitive data such as passwords and pin codes. Regular UserDefault are not secure by default. It's possible to extract them with third party software. This library encrypts the data stored in userdefault and stores the key used to encrypt the data in keychain.
 
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

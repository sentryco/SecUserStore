import Foundation
import Key
import LocalAuthentication

extension KeyQuery {
   /**
    * KeyQuery (Key query creator)
    * - Description: Creates a key query for accessing keychain items securely.
    * - Remark: By not using `BioAuth` here, we can access keychain outside apples timelock, access to the app is still only granted with BioAuth, later we might need to lock the app after non-use etc, but open for sync etc, in the future we could cache the sync, and apply it after the fact
    * - Remark: We need `accessGroup` to make it work with `AutoFill` extension etc
    * - Remark: When you set share keychain group in xcode target, accessGroup can sometimes prepend `$(AppIdentifierPrefix)` in .entitlements, remove that part and things work
    * - Remark: items are saved with the `kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly` We cannot use more strict flags because the app must often work in the background, even when the device is locked. also prevents an attacker from retrieving data via a logical extraction from a rebooted device or restoring a stolen backup on another device.
    * - Fixme: ⚠️️ We could pass the `BioAuth` context, or else we might get prompted for auth more often etc?
    * - Fixme: ⚠️️ We could remove the `BioAuth` stuff to make the code simpler?
    * - Fixme: ⚠️️ Make this throw etc?
    * - Fixme: ⚠️️ We might need to use: kSecAttrAccessibleWhenUnlocked for case is nil or not nil, related to restoration mode?
    * - Parameter key: Key of keychain item
    * - Returns: Private key identifier for keychain (used by `SecDB` and `AutoSync`)
    */
   internal static func getKeyQuery(key: String) -> KeyQuery {
      //      Logger.info("\(Trace.trace()) - key: \(key)", tag: .security) // Logs a security-related message with the key using the info log level.
      let context: LAContext? = nil
      let accessControl: SecAccessControl? = { // This is vital to get keychain sharing working without having to write the password at first time use etc
         if context != nil { // If context is not nil, use bio-access
            return SecAccessControlCreateWithFlags(
               nil, // The allocator to use for creating the access control object
               kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly, // The accessibility attribute for the access control object
               .userPresence, // The flags for the access control object
               nil // The error pointer for returning errors
            )
         } else { // Else use default access ⚠️️ The bellow was recently changed
            /*was using kSecAttrAccessibleWhenUnlocked*/ /*was using .userPresence*/
            return SecAccessControlCreateWithFlags(
               nil, // The allocator to use for creating the access control object
               kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly, // The accessibility attribute for the access control object
               [], // The flags for the access control object
               nil // The error pointer for returning errors
            )
         }
      }() // Swift.print("key: \(key) service: \(service) accessGroup: \(accessGroup) appIdentifierPrefix: \(appIdentifierPrefix) appGroup:  \(appGroup) accessControl:  \(String(describing: accessControl))")
      return .init(
         key: key, // The key to use for the authentication object
         service: SysUtil.service, // The service to use for the authentication object
         accessGroup: SysUtil.accessGroup, // The access group to use for the authentication object
         accessControl: accessControl, // The access control to use for the authentication object
         context: context // The context to use for the authentication object
      ) // construct query
   }
}

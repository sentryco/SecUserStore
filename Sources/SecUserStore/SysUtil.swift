import Foundation
import CryptoKit
import LocalAuthentication
/**
 * System util - Consistent way to access app info
 */
final internal class SysUtil {
   /**
    * Returns a string representing the app identifier prefix needed to make the `access-group` for keychain.
    * - Description: Retrieves the app identifier prefix from the app's `info.plist` file, which is necessary for configuring the keychain access group for sharing data securely between the app and its extensions.
    * - Returns: A string representing the app identifier prefix. I.E: "TW37UKNDCG". etc (read more about this in Readme.md)
    * - Remark: This is needed to make the `access-group` for keychain.
    * - Remark: You also have to add this to `info.plist` in both the app and the extension key: `AppIdentifierPrefix` value: `$(AppIdentifierPrefix)`.
    * - Note: More about this here: https://stackoverflow.com/a/28714850/5389500 and here is another approach using keychain meta data: https://bencoding.com/2016/12/31/simplifying-using-keychain-access-groups/.
    * - Note: If the app `AutoFill` extension doesn't work with this approach at some point, LockWise has some clever tricks: https://github.com/mozilla-lockwise/lockwise-ios/blob/master/Shared/Common/Helpers/AppInfo.swift.
    */
   internal static let appIdentifierPrefix: String? = {
      Bundle.main.infoDictionary?["AppIdentifierPrefix"] as? String
   }()
   /**
    * Returns the service identifier needed to access the keychain.
    * - Description: This property retrieves the service identifier from the app's `info.plist` file, which is used to uniquely identify the keychain service across the app and its extensions.
    * - Returns: A string representing the service identifier.
    * - Remark: We have to use a hard-coded service identifier, because we need to use the same service provider in the autofill extension.
    * - Remark: The `Bundle.main.bundleIdentifier` will return the organization name and app name registered when the app project was set up.
    * - Note: The service identifier is used to access the keychain.
    */
   internal static let service: String? = {
      Bundle.main.infoDictionary?["BundleService"] as? String
   }()
   /**
    * Returns the access group identifier needed to share data between the app and its extensions using the keychain.
    * - Description: This property provides the identifier used to create an access group for the keychain, allowing shared access between the app and its extensions.
    * - Returns: A string representing the access group identifier.
    * - Remark: This access group variable is automatically added to entitlements when you create a shared keychain in `target` -> `signing` -> `+` -> add `keychain group`.
    * - Remark: The access group is constructed by concatenating the app identifier prefix and the service identifier.
    * - Note: The access group identifier is used to share data between the app and its extensions using the keychain.
    */
   internal static let accessGroup: String? = {
      guard let appIdentifierPrefix: String = appIdentifierPrefix,
            let service: String = service else { return nil }
      return "\(appIdentifierPrefix + service)" // This is the default Apple-provided native naming convention.
   }()
}

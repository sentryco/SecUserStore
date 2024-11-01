import Foundation
//import Logger
import Key
import JSONSugar
/**
 * Protocol for a secure user store.
 * - Abstract: We use this so that master-psw can't be toggled off via third party apps etc
 * - Description: Defines a protocol for securely storing user preferences and settings. Implementations of this protocol should ensure that sensitive information is protected and only accessible within the app's secure context.
 * - Remark: If the app is sandboxed the preferences are located in `~/Library/Containers/[bundle-identifier]/Data/Library/Preferences`
 * - Remark: If it's not sandboxed the preferences are at the usual location `~/Library/Preferences`
 * - Remark: Regarding persistent data even after app re-install etc: UserDefault values are removed, but keychain data is preserved
 * - Note: https://github.com/matthiasplappert/Secure-NSUserDefaults
 * - Note: https://github.com/vpeschenkov/SecureDefaults (Maybe refactor this with cryptokit etc)
 * - Note: Since user default is accibile and editable: https://reverseengineering.stackexchange.com/questions/15816/changing-nsuserdefaults-of-a-mac-or-ios-binary-executable
 * - Note: Ref https://developer.apple.com/library/archive/documentation/MacOSX/Conceptual/BPRuntimeConfig/Articles/UserPreferences.html
 * - Note: Ref https://stackoverflow.com/a/44825560/5389500
 * - Note: Sandboxed apps might have uneditable user defaults: https://developer.apple.com/documentation/foundation/userdefaults
 * - Note: Alternative name: `SecPrefsStore`, `SecStore`
 * - Fixme: ⚠️️ Maybe use generics. here is an example where generics is used with userdefaults to store different prefs settings: https://www.kodeco.com/books/expert-swift/v1.0/chapters/4-generics (use 12feetladder if the website has a paywall etc)
 * - Fixme: ⚠️️ We could make this it's own repo. Even OSS. Name it SecUserStore?
 * - Fixme: ⚠️️ Make a DummyStore and add to example etc called it PrefsStore maybe?
 */
public protocol SecUserStoreKind: Codable {
   /**
    * The key used to store the model in the keychain
    * - Abstract: This is the unique key that ensures that no other part of the app overwrites this (key, value) pair in the keychain
    * - Description: This is the unique identifier used to store and retrieve the model from the keychain. It ensures that the stored data is not overwritten by any other part of the application.
    * - Note: alt name: modelKeyName
    */
   static var key: String { get }
   /**
    * The default model for the first run.
    * - Description: Provides the default instance of the model to be used when the application is run for the first time or when no existing data is found in the keychain. This ensures that the application has a consistent initial state.
    */
   static var defaultModel: Self { get }
   /**
    * The current model.
    * - Description: Represents the current instance of the model that is stored in the keychain. This model can be retrieved and updated as needed, providing a secure way to manage user preferences and settings.
    */
   static var model: Self { get }
}
/**
 * Extension for `SecUserStoreKind` protocol.
 */
extension SecUserStoreKind {
   /**
    * Returns the model for the specified key.
    * - Description: This property provides access to the current model stored in the keychain. It retrieves the model when accessed and updates the model when a new value is set.
    * - Remark: Serializes and deserializes the model using JSON.
    * - Remark: To access individual values, you can use `model.dict?["someKey"] as? SomeValue`.
    * - Remark: Consider using ordered JSON if available in newer OS.
    * - Returns: The model for the specified key.
    */
   public static var model: Self {
      get {
         getData(key: Self.key) // Returns the model for the specified key.
      } set {
         setData(key: Self.key, data: newValue) // Sets the new model for the specified key.
      }
   }
}
/**
 * Private helpers
 */
extension SecUserStoreKind {
   /**
    * Gets data for the specified key.
    * - Description: This method retrieves the data associated with the specified key from the keychain. If the data is not found, it returns the default model.
    * - Remark: If the data is not found, the default model is used instead.
    * - Parameter key: The key in the user-defined dictionary.
    * - Returns: The data for the specified key.
    */
   fileprivate static func getData(key: String) -> Self {
      // Get the key query for the specified key
      let keyQuery: KeyQuery = .getKeyQuery(key: key)
      guard let data = try? Key.read(keyQuery) as? Data, // Get data from KeyChain
            let model: Self = try? data.decode() else { // Decode the data to model
          // If data is not found, set the default model and return it
         return setData(key: key, data: Self.defaultModel)
      }
      return model // Return the retrieved data
   }
   /**
    * Sets data for the specified key.
    * - Description: This method stores the provided data model associated with the specified key into the keychain. It ensures that the user preferences and settings are securely saved and can be retrieved later using the same key.
    * - Parameters:
    *   - key: The key in the user-defined dictionary.
    *   - data: The data to be stored.
    * - Returns: The data that was stored for convenience.
    */
   @discardableResult fileprivate static func setData(key: String, data: Self) -> Self {
      do {
         let query: KeyQuery = .getKeyQuery(key: key) // Get the key query for the specified key
         try Key.insert(data: try data.encode(), query: query) // Encode the data and insert it into the keychain
      } catch {
         Swift.print("Error setting data for key: \(key), error: \(error)")
//         Logger.warn("Error setting data for key: \(key), error: \(error)", tag: .security) // Log a warning if there was an error setting the data
      }
      return data // Return the data that was stored for convenience
   }
}
/**
 * Service
 * - Fixme: ⚠️️ Add later? or do we use Bundle service in the keyquery etc, so this isnt used etc?
 */
// static var service: String { get }

import Security
import Foundation

struct KeychainManager {

    static func save(key: String, data: Data) -> OSStatus {
        let query = [
            kSecClass as String       : kSecClassGenericPassword as String,
            kSecAttrAccount as String : key,
            kSecValueData as String   : data
        ] as [String : Any]

        SecItemDelete(query as CFDictionary) 

        return SecItemAdd(query as CFDictionary, nil)
    }

    static func load(key: String) -> Data? {
        let query = [
            kSecClass as String       : kSecClassGenericPassword as String,
            kSecAttrAccount as String : key,
            kSecReturnData as String  : kCFBooleanTrue!,
            kSecMatchLimit as String  : kSecMatchLimitOne
        ] as [String : Any]

        var result: AnyObject?

        let status = SecItemCopyMatching(query as CFDictionary, &result)

        if status == errSecSuccess {
            return result as? Data
        } else {
            return nil
        }
    }

    static func delete(key: String) -> OSStatus {
        let query = [
            kSecClass as String       : kSecClassGenericPassword as String,
            kSecAttrAccount as String : key
        ] as [String : Any]

        return SecItemDelete(query as CFDictionary)
    }
    
    static func saveToken(token: String, key: String) {
            if let tokenData = token.data(using: .utf8) {
                let status = save(key: key, data: tokenData)
                if status != errSecSuccess {
                    print("Error saving token to keychain: \(status)")
                } else {
                    print("Token saved successfully.")
                }
            }
        }

        static func loadToken(key: String) -> String? {
            if let tokenData = load(key: key) {
                return String(data: tokenData, encoding: .utf8)
            }
            return nil
        }

        static func deleteToken(key: String) {
            let status = delete(key: key)
            if status != errSecSuccess {
                print("Error deleting token from keychain: \(status)")
            } else {
                print("Token deleted successfully.")
            }
        }
}

import Foundation

public extension UserDefaults {
    
    /// Checks whether or not an object exists for given key.
    /// - Parameter key: The key to search for.
    func objectExists(forKey key: String) -> Bool {
        self.object(forKey: key) != nil
    }
    
}

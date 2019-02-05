//
//  Data+Ext.swift
//
//  Created by Craz1k0ek on 05/02/2019.
//

import Foundation

extension Data {
    
    /// Hexadecimal encoding options.
    struct HexadecimalEncodingOptions: OptionSet {
        let rawValue: Int
        /// Encode with capital characters.
        static let upperCase        = HexadecimalEncodingOptions(rawValue: 1)
        /// Encode with a separator.
        static let separateBlocks   = HexadecimalEncodingOptions(rawValue: 2)
    }
    
    /// Initialize a `Data` object from a hexadecimal `String`.
    ///
    /// - Note: The initializer will fail when invalid hexadecimal data is provided. The initializer will automatically pad the input with a leading `0` when required.
    /// - Parameter hexString: The hexadecimal string.
    init?(hexString: String) {
        if !hexString.isHexString { return nil }
        let paddedHexString = hexString.count % 2 == 0 ? hexString : "0\(hexString)"
        let length          = paddedHexString.count / 2
        var data            = Data(capacity: length)
        
        for i in 0 ..< length {
            let firstIndex  = paddedHexString.index(hexString.startIndex, offsetBy: i * 2)
            let secondIndex = paddedHexString.index(firstIndex, offsetBy: 2)
            let bytes       = paddedHexString[firstIndex ..< secondIndex]
            
            if var num = UInt8(bytes, radix: 16) {
                data.append(&num, count: 1)
            } else {
                return nil
            }
        }
        self = data
    }
    
    /// Transform the `Data` to a hexadecimal `String`.
    ///
    /// - Parameter encodingOptions: Encoding options to use.
    /// - Returns: The hexadecimal string.
    func hexEncodedString(encodingOptions: HexadecimalEncodingOptions = []) -> String {
        let format              = encodingOptions.contains(.upperCase) ? "%02hhX" : "%02hhx"
        var hexadecimalString   = map { String(format: format, $0) }.joined()
        if encodingOptions.contains(.separateBlocks) { hexadecimalString = hexadecimalString.insert(separator: " ", every: 8) }
        return hexadecimalString
    }
    
}

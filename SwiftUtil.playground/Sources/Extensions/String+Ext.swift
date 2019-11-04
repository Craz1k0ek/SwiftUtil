//
//  String+Ext.swift
//
//  Created by Craz1k0ek on 05/02/2019.
//

import Foundation

public extension String {
    
    /// Indication if a `String` contains only hexadecimal characters.
    var isHexString: Bool {
        let hexCharacterSet = CharacterSet(charactersIn: "0123456789abcdefABCDEF")
        return self.rangeOfCharacter(from: hexCharacterSet.inverted) == nil
    }
    
}

public extension StringProtocol where Self: RangeReplaceableCollection {
    private mutating func inserting(separator: String, every n: Int) {
        indices.reversed().forEach {
            if $0 != startIndex {
                if distance(from: startIndex, to: $0) % n == 0 {
                    insert(contentsOf: separator, at: $0)
                }
            }
        }
    }
    
    /// Insert a specific `String` after every `n` characters.
    ///
    /// - Parameters:
    ///   - separator: The string to insert.
    ///   - n: The amount of characters to place the separator after.
    /// - Returns: The `String` separated every nth character by the given separator.
    func insert(separator: String, every n: Int) -> Self {
        var string = self
        string.inserting(separator: separator, every: n)
        return string
    }
}

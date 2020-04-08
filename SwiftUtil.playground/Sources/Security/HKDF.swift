//
// HKDF.swift
//
// Created by Craz1k0ek on 07/04/2020.
//

import Foundation
import CryptoKit

public enum HKDFError: LocalizedError {
    case expandFailed(Int)
    
    public var errorDescription: String? {
        switch self {
        case .expandFailed(let size): return "Cannot expand to more than \(size) bytes using the specified hash function."
        }
    }
    
}

public struct HKDF<H> where H: HashFunction {
    
    /// The extracted pseudorandom key.
    private let prk: Data
    
    public init(key: Data, salt: Data) {
        prk = HKDF.extract(key: key, salt: salt)
    }
    
    /// Extract a pseudorandom key using HMAC with the
    /// provided hash, salt and key material, suitable
    /// for use with the `expand` function.
    ///
    /// The salt should be random. If the salt is not
    /// provided, an all-zeros salt with the same size
    /// of the hash's block size will be used instead
    /// per the RFC.
    ///
    /// - Parameters:
    ///   - salt: The random generated salt.
    ///   - input: The original key.
    /// - Returns: The extracted pseudorandom key.
    static private func extract(key: Data, salt: Data = Data(repeating: 0, count: H.Digest.byteCount)) -> Data {
        HMAC<H>.authenticationCode(for: key, using: SymmetricKey(data: salt)).withUnsafeBytes({ Data($0) })
    }
    
    /// Expand the pseudorandom key and info into
    /// a key of the given length using HKDF's
    /// expand function based on HMAC.
    ///
    /// The desired length cannot be greater than
    /// `255 * hash.digest.size / 8`.
    ///
    /// - Parameters:
    ///   - info: Application specific context information.
    ///   - length: The desired length of the derived key in bytes.
    /// - Returns: The derived key.
    public func expand(info: Data = Data(), length: Int = 32) throws -> Data {
        if length > 255 * (H.Digest.byteCount / 8) {
            throw HKDFError.expandFailed(255 * (H.Digest.byteCount / 8))
        }
        let blocksNeeded = length / H.Digest.byteCount + (length % H.Digest.byteCount == 0 ? 0 : 1)
        
        var okm = Data()
        var outputBlock = Data()
        
        for counter in 0 ..< blocksNeeded {
            outputBlock = HMAC<H>.authenticationCode(for: outputBlock + info + Data([UInt8(counter + 1)]), using: SymmetricKey(data: prk)).withUnsafeBytes({ Data($0) })
            okm += outputBlock
        }
        return okm[0 ..< length]
    }
    
}

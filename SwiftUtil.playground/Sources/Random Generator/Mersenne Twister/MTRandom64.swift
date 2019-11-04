import Foundation

/// The word size in number of bits.
fileprivate let w: UInt64 = 64
/// The degree of recurrence.
fileprivate let n: UInt64 = 312
/// The middle word, an offset used in the recurrence relation defining the series `x, 1 ≤ m < n`.
fileprivate let m: UInt64 = 156
/// Separation point of one word, or the number of bits of the lower bitmask, `0 ≤ r ≤ w -1`.
fileprivate let r: UInt64 = 31

/// Coefficients of the rational normal twist matrix.
fileprivate let a: UInt64 = 0xB5026F5AA96619E9

/// Additional Mersenne Twister tempering bit shifts/masks.
fileprivate let u: UInt64 = 11
/// Additional Mersenne Twister tempering bit shifts/masks.
fileprivate let d: UInt64 = 0x5555555555555555

/// A `TGFSR(R)` tempering bit shift.
fileprivate let s: UInt64 = 17
/// A `TGFSR(R)` tempering bit mask.
fileprivate let b: UInt64 = 0x71D67FFFEDA60000

/// A `TGFSR(R)` tempering bit shift.
fileprivate let t: UInt64 = 37
/// A `TGFSR(R)` tempering bit mask.
fileprivate let c: UInt64 = 0xFFF7EEE000000000

/// Additional Mersenne Twister tempering bit shifts/masks.
fileprivate let l: UInt64 = 43

/// Another generator parameter, though not part of the algorithm.
fileprivate let f: UInt64 = 0x5851F42D4C957F2D

/// Additional Mersenne Twister masks.
fileprivate let lowerMask: UInt64 = (1 << r) - 1
fileprivate let upperMask: UInt64 = ~lowerMask

public struct MTRandom64: MTRandom {
    
    fileprivate var mt: [UInt64]
    fileprivate var index: UInt64
    
    public init() {
        var randomSeed: UInt64 = 0
        arc4random_buf(&randomSeed, MemoryLayout.size(ofValue: randomSeed))
        
        var trueSeed: UInt64 = UInt64(Date().timeIntervalSinceReferenceDate)
        trueSeed += randomSeed
        trueSeed += 1
        
        self.init(withSeed: trueSeed)
    }
    
    public init(withSeed seed: UInt64) {
        self.mt = [UInt64](repeating: 0, count: Int(n))
        self.index = n
        mt[0] = seed
        
        for i in 1 ..< n {
            let createdValue = (f &* (mt[Int(i - 1)] ^ (mt[Int(i - 1)] >> (w - 2))) + i)
            mt[Int(i)] = createdValue
        }
    }
    
    private mutating func twist() {
        for i in 0 ..< n {
            let x: UInt64 = (mt[Int(i)] & upperMask) + (mt[Int((i + 1) % n)] & lowerMask);
            var xA: UInt64 = x >> 1;
            if x & UInt64(0x01) != 0 {
                xA ^= a;
            }
            mt[Int(i)] = mt[Int((i + m) % n)] ^ xA;
        }
        index = 0;
    }
    
    public mutating func next() -> UInt {
        var i = index
        if index >= n {
            twist()
            i = index
        }
        
        var y = mt[Int(i)]
        index = i + 1
        
        y ^= (y >> u) & d;
        y ^= (y << s) & b;
        y ^= (y << t) & c;
        y ^= (y >> l);
        
        return UInt(y)
    }
    
    
    
}

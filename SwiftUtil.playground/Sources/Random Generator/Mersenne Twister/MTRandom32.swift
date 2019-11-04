import Foundation

/// The word size in number of bits.
fileprivate let w: UInt32 = 32
/// The degree of recurrence.
fileprivate let n: UInt32 = 624
/// The middle word, an offset used in the recurrence relation defining the series `x, 1 ≤ m < n`.
fileprivate let m: UInt32 = 397
/// Separation point of one word, or the number of bits of the lower bitmask, `0 ≤ r ≤ w -1`.
fileprivate let r: UInt32 = 31

/// Coefficients of the rational normal twist matrix.
fileprivate let a: UInt32 = 0x9908B0DF

/// Additional Mersenne Twister tempering bit shifts/masks.
fileprivate let u: UInt32 = 11
/// Additional Mersenne Twister tempering bit shifts/masks.
fileprivate let d: UInt32 = 0xFFFFFFFF

/// A `TGFSR(R)` tempering bit shift.
fileprivate let s: UInt32 = 7
/// A `TGFSR(R)` tempering bit mask.
fileprivate let b: UInt32 = 0x9D2C5680

/// A `TGFSR(R)` tempering bit shift.
fileprivate let t: UInt32 = 15
/// A `TGFSR(R)` tempering bit mask.
fileprivate let c: UInt32 = 0xEFC60000

/// Additional Mersenne Twister tempering bit shifts/masks.
fileprivate let l: UInt32 = 18

/// Another generator parameter, though not part of the algorithm.
fileprivate let f: UInt32 = 0x6C078965

/// Additional Mersenne Twister masks.
fileprivate let lowerMask: UInt32 = (1 << r) - 1
fileprivate let upperMask: UInt32 = ~lowerMask

public struct MTRandom32: MTRandom {
    
    fileprivate var mt: [UInt32]
    fileprivate var index: UInt32
    
    public init() {
        var randomSeed: UInt32 = 0
        arc4random_buf(&randomSeed, MemoryLayout.size(ofValue: randomSeed))
        
        var trueSeed: UInt32 = UInt32(Date().timeIntervalSinceReferenceDate)
        trueSeed += randomSeed
        trueSeed += 1
        
        self.init(withSeed: trueSeed)
    }
    
    public init(withSeed seed: UInt32) {
        self.mt = [UInt32](repeating: 0, count: Int(n))
        self.index = n
        mt[0] = seed
        
        for i in 1 ..< n {
            let createdValue = (f &* (mt[Int(i - 1)] ^ (mt[Int(i - 1)] >> (w - 2))) + i)
            mt[Int(i)] = createdValue
        }
    }
    
    private mutating func twist() {
        for i in 0 ..< n {
            let x: UInt32 = (mt[Int(i)] & upperMask) + (mt[Int((i + 1) % n)] & lowerMask);
            var xA: UInt32 = x >> 1;
            if x & UInt32(0x01) != 0 {
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

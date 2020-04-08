# Security 

In this folder you will find security implementations that might be useful.

### HKDF

HKDF is a HMAC based expand-and-extract key derivation function.
You can use it to derive keys of a fixed size used for other cryptographic operations.

#### _Example 1_
In this example, a key is derived from a salt and a shared secret.
There is no extra information added when expanding the key.

```swift
// The shared key between the two parties.
let sharedKey   = Data("deadbeefdeadbeefdeadbeefdeadbeef".utf8)
// The randomly generated salt.
let salt        = Data("12345678876543211234567887654321".utf8)

// Create the HKDF object using the key and the salt.
let hkdf = HKDF<SHA256>(key: sharedKey, salt: salt)
// Expand
do {
    let derived = try hkdf.expand()
} catch {
    print(error.localizedDescription)
}
```

#### _Example 2_
In this example, a key is derived from a salt and a shared secret.
There is some extra information added when expanding the key.
We also specify that we want 64 bytes of output key material.
__Note:__ The maximum length of the derived key is `255 * Hash.Digest.Size / 8`.

```swift
// The shared key between the two parties.
let sharedKey   = Data("deadbeefdeadbeefdeadbeefdeadbeef".utf8)
// The randomly generated salt.
let salt        = Data("12345678876543211234567887654321".utf8)
// The application specific info.
let info        = Data("https://www.example.com/".utf8)

// Create the HKDF object using the key and the salt.
let hkdf = HKDF<SHA256>(key: sharedKey, salt: salt)
// Expand
do {
    let derived = try hkdf.expand(info: info, length: 64)
} catch {
    print(error.localizedDescription)
}
```

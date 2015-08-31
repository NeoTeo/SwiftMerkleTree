//
//  main.swift
//  Merkle
//
//  Created by Teo on 28/08/15.
//  Copyright © 2015 Teo Sartori. All rights reserved.
//

import Foundation
/** To get CommonCrypto to be found ensure there's a CommonCrypto directory in the
project root and that it contains a module.map file with the contents:

module CommonCrypto [system] {
header "/Applications/Xcode-beta.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.11.sdk/usr/include/CommonCrypto/CommonCrypto.h"
export *
}

Finally ensure that CommonCrypto is in the project's import paths.
*/
import CommonCrypto



extension String {
    func SHAString() -> String {
        if let data = dataUsingEncoding(NSUTF8StringEncoding) {
            let result = NSMutableData(length: Int(CC_SHA1_DIGEST_LENGTH))!
            
            let resultBytes = UnsafeMutablePointer<CUnsignedChar>(result.mutableBytes)
            CC_SHA1(data.bytes, CC_LONG(data.length), resultBytes)
            let resultEnumerator = UnsafeBufferPointer<CUnsignedChar>(start: resultBytes, count: result.length)
            let SHA1 = NSMutableString()
            for c in resultEnumerator {
                SHA1.appendFormat("%02x", c)
            }
            return SHA1 as String
        }
        return ""
    }
}


let myString = "Hej Linda."
print("the SHA1 cryptographic hash digest of",myString," is",myString.SHAString())
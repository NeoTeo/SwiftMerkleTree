//
//  String+Crypto.swift
//  Merkle
//
//  Created by Teo on 04/09/15.
//  Copyright © 2015 Teo Sartori. All rights reserved.
//

import Foundation
/**     To ensure CommonCrypto can be found:

1) Make a CommonCrypto directory in the project root.
2) In the CommonCrypto directory create a module.map file with the contents:

module CommonCrypto [system] {
header "/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.11.sdk/usr/include/CommonCrypto/CommonCrypto.h"
export *
}

3) Finally ensure that CommonCrypto is in the project's import paths by setting:
Project->Build Settings->Swift Compiler - Search Paths->Import Paths to CommonCrypto
*/

import CommonCrypto


extension String {
    
    func SHAString() -> String {
        if let data = dataUsingEncoding(NSUTF8StringEncoding) {
            
            let result      = NSMutableData(length: Int(CC_SHA256_DIGEST_LENGTH))!
            let resultBytes = UnsafeMutablePointer<CUnsignedChar>(result.mutableBytes)
            
            CC_SHA256(data.bytes, CC_LONG(data.length), resultBytes)
            
            let resultEnumerator    = UnsafeBufferPointer<CUnsignedChar>(start: resultBytes, count: result.length)
            let SHA256                = NSMutableString()
            
            for c in resultEnumerator {
                SHA256.appendFormat("%02x", c)
            }
            
            return SHA256 as String
        }
        return ""
    }
}
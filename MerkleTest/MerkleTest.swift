//
//  MerkleTest.swift
//  MerkleTest
//
//  Created by Teo on 02/09/15.
//  Copyright © 2015 Teo Sartori. All rights reserved.
//

import XCTest
@testable import Merkle
//@testable import String


class MerkleTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testSha() {
        XCTAssert( "Hej Linda.".SHAString() == "aa63c65cd0be277db8fada3913e96f6fa17e74d43d2199e5ef6e848281e0f181")
        //SHA1 would be "c89dc32c274a20fc1c0e0c490ab7df969af53546"
    }
    
    func testBuildTree() {
        let blobStrings = ["Teo","Linda","Karin"]
        var blobs = [NSData]()
        
        for blobString in blobStrings {
            blobs.append(blobString.dataUsingEncoding(NSUTF8StringEncoding)!)
        }
        // SHA256 of 
        // Teo is 576579bbf67a863d01dada39c1714170993e564ce0f303b545afbd737256394f
        // Linda is 1bda9e5035725cc6c86d3e4207ae33d8d0509b922bbc44ba163540c455c6d2a8
        // Karin is 006952514fe555f137977959868b97fd530ec3a825015e54da95675ac040ca17
        
        // Of the concatenated hashes of Teo and Linda is e1f396ef4c0d93f21bdeb04aca3b1613371763cb2c94651fa431a88e346152ba
        // Of the Karin's hash is 0c4140e594c067e72b2e597575501feb7a6393ad738041256c24f24662eb9c50
        // Of the concatenated hashes of (Teo and Linda) and (Karin's hash) is ca8a2321da39aed84ed5192f43d1bc312768cb05a7745b4bb3d3d50b9293dc56
        let tree = MerkleTree.buildTree(fromBlobs: blobs)
        switch tree {
        case let .Node(root_hash,_,_,_):
            XCTAssert(root_hash == "ca8a2321da39aed84ed5192f43d1bc312768cb05a7745b4bb3d3d50b9293dc56")
        case .Empty:
            XCTFail()
            break
        }
        
        MerkleTree.printTree(tree)
    }
        
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
}

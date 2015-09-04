//
//  MerkleTree.swift
//  Merkle
//
//  Created by Teo on 31/08/15.
//  Copyright © 2015 Teo Sartori. All rights reserved.
//

import Foundation

/**     A Merkle/Binary Hash Tree node.

        The Merkle tree can either be of type .Empty or be of type .Node.
        A .Node will hold some data of type NSData and optionally have
        some children which are also of type MerkleTree.
*/
indirect enum MerkleTree {
    
    case Empty
    case Node(hash: String, data: NSData?, left: MerkleTree, right: MerkleTree)
    
    init() { self = .Empty }


    init(hash: String) {
        self = MerkleTree.Node(hash: hash, data: nil, left: .Empty, right: .Empty)
    }
    
    init(blob: NSData) {
        
        /// make a string from the data and make a hash from it.
        let hash = String(data: blob, encoding: NSUTF8StringEncoding)?.SHAString()
        
        self = MerkleTree.Node(hash: hash!, data: blob, left: .Empty, right: .Empty)
    }

}

extension MerkleTree {
    
    static func createParentNode(leftChild: MerkleTree, rightChild: MerkleTree) -> MerkleTree {
        
        /// get the hashes
        var leftHash  = ""
        var rightHash = ""
        
        switch leftChild {
        case let .Node(hash, _, _, _):
            leftHash = hash
        case .Empty:
            break
        }
        
        switch rightChild {
        case let .Node(hash, _, _, _):
            rightHash = hash
        case .Empty:
            break
        }
        
        /// Calculate the new node's hash which is the hash of the concatenation 
        /// of the two children's hashes.
        let newHash = (leftHash + rightHash).SHAString()
        return MerkleTree.Node(hash: newHash, data: nil, left: leftChild, right: rightChild)
    }
    
    
    static func buildTree(fromBlobs blobs: [NSData]) -> MerkleTree {
        
        /// Calculate the depth of the tree.
        //        let treeDepth = ceil(log2(Double(blobs.count)))
        
        /// Create the node array we will turn into the tree.
        var nodeArray = [MerkleTree]()
        
        /// Start the array off with leaf nodes.
        for blob in blobs {
            nodeArray.append(MerkleTree(blob: blob))
        }
        
        /// Instead of doing this recursively, which would run out of stack for very large trees,
        /// We do this iteratively using a temporary array.
        while nodeArray.count != 1 {
            var tmpArray = [MerkleTree]()
            while nodeArray.count > 0 {
                
                let leftNode  = nodeArray.removeFirst()
                let rightNode = nodeArray.count > 0 ? nodeArray.removeFirst() : .Empty
                
                tmpArray.append(createParentNode(leftNode, rightChild: rightNode))
            }
            
            nodeArray = tmpArray
        }
        
        return nodeArray.first!
    }
}

/// Debug stuff
extension MerkleTree {
    
    static func printTree(theTree: MerkleTree, depth: Int = 0) {
        
        var indent: String = ""
        for _ in 0..<depth {
            indent.appendContentsOf("    ")
        }
        
        switch theTree {
        case let .Node(hash,_,leftChild,rightChild):
            print(indent,"The node has a hash of",hash)
            
            print(indent,hash,"'s left child is:")
            MerkleTree.printTree(leftChild, depth: depth+1)
            print(indent,hash,"'s right child is:")
            MerkleTree.printTree(rightChild, depth: depth+1)
            
        case .Empty:
            print(indent,".Empty")
            break
        }
    }

}

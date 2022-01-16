//
//  Realm+.swift
//  MomCare
//
//  Created by Nam Ngây on 04/07/2021.
//

import UIKit
import RealmSwift

extension Realm {
    public func safeWrite(_ block: (() throws -> Void)) throws {
        if isInWriteTransaction {
            try block()
        } else {
            try write(block)
        }
    }
}

extension Results {
    func toArray() -> [Element] {
      return compactMap {
        $0
      }
    }
 }

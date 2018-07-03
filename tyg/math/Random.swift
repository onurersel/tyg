//
//  Random.swift
//  tyg
//
//  Created by Onur Ersel on 2018-07-03.
//  Copyright © 2018 Onur Ersel. All rights reserved.
//

import Foundation

extension Tyg {
    public struct Random {
        public static var between0And1: Double {
            return Double(arc4random_uniform(UInt32.max-1)) / Double(UInt32.max)
        }

        public static func between<T: Any>(_ element: T, _ rest: T...) -> T {
            if rest.count == 0 {
                return element
            }

            let count = rest.count + 1
            let randomIndex = Int(floor(Double(count) * between0And1))
            var nrest = rest
            nrest.insert(element, at: 0)
            return nrest[randomIndex]
        }
    }
}

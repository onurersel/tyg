//
//  RandomTests.swift
//  tygTests
//
//  Created by Onur Ersel on 2018-07-03.
//  Copyright © 2018 Onur Ersel. All rights reserved.
//

import XCTest
@testable import tyg

class RandomTests: XCTestCase {

    func testRandomBetween0And1() {
        var dict: [String: Int] = [:]
        let totalCount: Int = 1000000

        // creating random numbers to check if their distribution is even
        for _ in 0..<totalCount {

            let value = Tyg.Random.between0And1
            if value == 1.0 {
                XCTFail("Random.between0And1 should not return 1.0")
                return
            }

            let floored = floor(value * 10)
            let key = String(describing: Int(floored))
            if dict[key] == nil {
                dict[key] = 1
            } else {
                dict[key] = dict[key]! + 1
            }
        }

        // checking if all ten integers have balanced values
        let marginOfError = Int(floor(Double(totalCount/1000)))
        let targetNumber = Int(floor(Double(totalCount/10)))
        for i in 0..<10 {
            let key = String(describing: i)
            if dict[key] == nil {
                XCTFail("There's no value between \(i) and \(i+1) generated by Random.between0And1")
                return
            }

            let value = dict[key]!
            if value > targetNumber + marginOfError || value < targetNumber - marginOfError {
                XCTFail("Random.between0And1 generated inbalancely distributed numbers between \(i) and \(i+1). It should be \(targetNumber) with \(marginOfError) margin of error. It is \(value) with \(Int(abs(value - targetNumber))) margin.")
            }
        }
    }

    func testRandom_withSingleElement() {
        let expectedValue = 1987
        let value = Tyg.Random.between(expectedValue)
        XCTAssertEqual(value, expectedValue)
    }

    func testRandomBetween() {
        var dict: [String: Int] = [:]
        let totalCount: Int = 1000000

        let references: [NSObject] = [
            NSObject(),
            NSObject(),
            NSObject(),
            NSObject(),
            NSObject(),
            ]

        for _ in 0..<totalCount {

            let value = Tyg.Random.between(references[0], references[1], references[2], references[3], references[4])

            guard let index = references.index(of: value) else {
                XCTFail()
                return
            }

            let key = String(describing: index)
            if dict[key] == nil {
                dict[key] = 1
            } else {
                dict[key] = dict[key]! + 1
            }
        }

        let marginOfError = Int(floor(Double(totalCount/1000)))
        let targetNumber = Int(floor(Double(totalCount/references.count)))
        for i in 0..<references.count {
            let key = String(describing: i)
            if dict[key] == nil {
                XCTFail("There's no value between \(i) and \(i+1) generated by Random.between0And1")
                return
            }

            let value = dict[key]!
            if value > targetNumber + marginOfError || value < targetNumber - marginOfError {
                XCTFail("between returned inbalancely distributed elements at index \(i). It should be \(targetNumber) with \(marginOfError) margin of error. It is \(value) with \(Int(abs(value - targetNumber))) margin.")
            }
        }
    }

}

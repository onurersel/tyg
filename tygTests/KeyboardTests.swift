//
//  KeyboardTests.swift
//  tygTests
//
//  Created by Onur Ersel on 2018-07-03.
//  Copyright © 2018 Onur Ersel. All rights reserved.
//

import XCTest
import Bond
@testable import tyg

extension Tyg.BondKeyboardInfo: Equatable {
    public static func == (lhs: Tyg.BondKeyboardInfo, rhs: Tyg.BondKeyboardInfo) -> Bool {
        return lhs.isShown == rhs.isShown && lhs.height == rhs.height && lhs.animationDuration == rhs.animationDuration
    }
}

class KeyboardTests: XCTestCase {

    // Taken from iPhone SE portrait mode
    private func mockKeyboardShow() {
        let userInfo: [AnyHashable: Any] = [
            "UIKeyboardCenterBeginUserInfoKey": CGPoint(x: 160, y:694.5),
            "UIKeyboardIsLocalUserInfoKey": 1,
            "UIKeyboardCenterEndUserInfoKey": CGPoint(x: 160, y: 441.5),
            "UIKeyboardBoundsUserInfoKey": CGRect(x:0, y:0, width:320, height:253),
            "UIKeyboardFrameEndUserInfoKey": CGRect(x:0, y:315, width:320, height:253),
            "UIKeyboardAnimationCurveUserInfoKey": 7,
            "UIKeyboardFrameBeginUserInfoKey": CGRect(x:0, y:568, width:320, height:253),
            "UIKeyboardAnimationDurationUserInfoKey": 0.25
        ]
        NotificationCenter.default.post(name: Notification.Name.UIKeyboardWillShow, object: nil, userInfo: userInfo)
    }

    private func mockKeyboardHide() {
        let userInfo: [AnyHashable: Any] = [
            "UIKeyboardCenterBeginUserInfoKey": CGPoint(x: 160, y:441.5),
            "UIKeyboardIsLocalUserInfoKey": 1,
            "UIKeyboardCenterEndUserInfoKey": CGPoint(x: 160, y: 694.5),
            "UIKeyboardBoundsUserInfoKey": CGRect(x:0, y:0, width:320, height:253),
            "UIKeyboardFrameEndUserInfoKey": CGRect(x:0, y:568, width:320, height:253),
            "UIKeyboardAnimationCurveUserInfoKey": 7,
            "UIKeyboardFrameBeginUserInfoKey": CGRect(x:0, y:315, width:320, height:253),
            "UIKeyboardAnimationDurationUserInfoKey": 0.25
        ]
        NotificationCenter.default.post(name: Notification.Name.UIKeyboardWillHide, object: nil, userInfo: userInfo)
    }

    private func mockKeyboardMalfunctionedNotification() {
        let userInfo: [AnyHashable: Any] = [:]
        NotificationCenter.default.post(name: Notification.Name.UIKeyboardWillHide, object: nil, userInfo: userInfo)
    }

    func testKeyboardNotifications() {

        let keyboardShowPromise = expectation(description: "keyboard show")
        let keyboardHidePromise = expectation(description: "keyboard hide")

        var didExpanded = false
        Tyg.Keyboard.changeState().observeNext { (info) in
            if didExpanded == false {
                didExpanded = true
                XCTAssertEqual(info, Tyg.BondKeyboardInfo(isShown: true, height: 253, animationDuration: 0.25))
                keyboardShowPromise.fulfill()
            } else {
                XCTAssertEqual(info, Tyg.BondKeyboardInfo(isShown: false, height: 253, animationDuration: 0.25))
                keyboardHidePromise.fulfill()
            }
        }.dispose(in: bag)

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(1)) {
            // show keyboard
            self.mockKeyboardShow()
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(1), execute: {
                // hide keyboard
                self.mockKeyboardHide()
            })
        }

        waitForExpectations(timeout: 5, handler: nil)
    }

    func testKeyboardNotifications_malfunctionedNotification() {
        let promise = expectation(description: "malfunctioned keyboard event")

        Tyg.Keyboard.changeState().observeNext { (info) in
            // fails if it captures malfunctioned notification
            XCTFail()
        }.dispose(in: bag)

        // try to show keyboard with malfunctioned userInfo
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(1)) {
            self.mockKeyboardMalfunctionedNotification()
        }

        // success
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(2)) {
            promise.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)
    }

    func testKeyboardNotifications_dispose() {
        let disposable = Tyg.Keyboard.changeState().observeNext { (_) in }
        disposable.dispose()
        XCTAssertTrue(disposable.isDisposed)
    }
}


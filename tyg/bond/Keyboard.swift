//
//  Keyboard.swift
//  tyg
//
//  Created by Onur Ersel on 2018-07-03.
//  Copyright © 2018 Onur Ersel. All rights reserved.
//

import UIKit
import Bond
import ReactiveKit

extension Tyg {
    public struct BondKeyboardInfo {
        public let isShown: Bool
        public let height: CGFloat
        public let animationDuration: TimeInterval
    }
}

extension Tyg {
    public class Keyboard: NSObject {

        public static func changeState() -> Signal<BondKeyboardInfo, NoError> {
            return Signal { observer in
                let disposeBag = DisposeBag()

                NotificationCenter.default.reactive.notification(name: Notification.Name.UIKeyboardWillShow).observeNext { (notification) in
                    signalObserverWhenStateChanges(observer: observer, notification: notification, isShown: true)
                    }.dispose(in: disposeBag)

                NotificationCenter.default.reactive.notification(name: Notification.Name.UIKeyboardWillHide).observeNext { (notification) in
                    signalObserverWhenStateChanges(observer: observer, notification: notification, isShown: false)
                    }.dispose(in: disposeBag)

                return BlockDisposable {
                    disposeBag.dispose()
                }
            }
        }

        private static func signalObserverWhenStateChanges(observer: AtomicObserver<BondKeyboardInfo, NoError>, notification: Notification, isShown: Bool) {
            guard let userInfo = notification.userInfo,
                let keyboardFrame = userInfo[UIKeyboardFrameEndUserInfoKey] as? CGRect,
                let animationDuration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? TimeInterval else {
                    return
            }

            observer.next(
                BondKeyboardInfo(isShown: isShown, height: keyboardFrame.size.height, animationDuration: animationDuration)
            )
        }

    }
}

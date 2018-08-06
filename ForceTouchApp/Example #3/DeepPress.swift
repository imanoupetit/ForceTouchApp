//
//  DeepPress.swift
//  ForceTouchApp
//
//  Created by Imanou on 03/08/2018.
//  Copyright © 2018 Imanou Petit. All rights reserved.
//

// Source: https://github.com/FlexMonkey/DeepPressGestureRecognizer

import UIKit.UIGestureRecognizerSubclass

class DeepPressGestureRecognizer: UIGestureRecognizer {

    var vibrateOnDeepPress = true
    let threshold: CGFloat

    private let pulse = PulseLayer()
    private var deepPressed: Bool = false

    required init(target: AnyObject?, action: Selector, threshold: CGFloat) {
        self.threshold = threshold

        super.init(target: target, action: action)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        if let touch = touches.first {
            handleTouch(touch)
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
        if let touch = touches.first {
            handleTouch(touch)
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesEnded(touches, with: event)

        state = deepPressed ? UIGestureRecognizerState.ended : UIGestureRecognizerState.failed

        deepPressed = false
    }

    private func handleTouch(_ touch: UITouch) {
        guard let view = view, touch.force != 0 && touch.maximumPossibleForce != 0 else {
            return
        }

        if !deepPressed && (touch.force / touch.maximumPossibleForce) >= threshold {
            view.layer.addSublayer(pulse)
            pulse.pulse(frame: CGRect(origin: .zero, size: view.frame.size))

            state = UIGestureRecognizerState.began

            if vibrateOnDeepPress {
                UINotificationFeedbackGenerator().notificationOccurred(.error)
            }

            deepPressed = true
        } else if deepPressed && (touch.force / touch.maximumPossibleForce) < threshold {
            state = UIGestureRecognizerState.ended
            deepPressed = false
        }
    }

}

// MARK: - DeepPressable protocol extension

protocol DeepPressable {

    var gestureRecognizers: [UIGestureRecognizer]? {get set}

    func addGestureRecognizer(_ gestureRecognizer: UIGestureRecognizer)
    func removeGestureRecognizer(_ gestureRecognizer: UIGestureRecognizer)
    func setDeepPressAction(target: AnyObject, action: Selector)
    func removeDeepPressAction()

}

extension DeepPressable {

    func setDeepPressAction(target: AnyObject, action: Selector) {
        let deepPressGestureRecognizer = DeepPressGestureRecognizer(target: target, action: action, threshold: 0.75)
        self.addGestureRecognizer(deepPressGestureRecognizer)
    }

    func removeDeepPressAction() {
        guard let gestureRecognizers = gestureRecognizers else {
            return
        }

        for recogniser in gestureRecognizers where recogniser is DeepPressGestureRecognizer {
            removeGestureRecognizer(recogniser)
        }
    }

}

class PulseLayer: CAShapeLayer {

    var pulseColor = UIColor.red.cgColor

    func pulse(frame: CGRect) {
        strokeColor = pulseColor
        fillColor = nil

        let startPath = UIBezierPath(roundedRect: frame, cornerRadius: 5).cgPath
        let endPath = UIBezierPath(roundedRect: frame.insetBy(dx: -50, dy: -50), cornerRadius: 5).cgPath

        path = startPath
        lineWidth = 1

        let pathAnimation = CABasicAnimation(keyPath: "path")
        pathAnimation.toValue = endPath

        let opacityAnimation = CABasicAnimation(keyPath: "opacity")
        opacityAnimation.toValue = 0

        let lineWidthAnimation = CABasicAnimation(keyPath: "lineWidth")
        lineWidthAnimation.toValue = 10

        CATransaction.begin()

        CATransaction.setCompletionBlock {
            self.removeFromSuperlayer()
        }

        for animation in [pathAnimation, opacityAnimation, lineWidthAnimation] {
            animation.duration = 0.25
            animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
            animation.isRemovedOnCompletion = false
            animation.fillMode = kCAFillModeForwards

            add(animation, forKey: animation.keyPath)
        }

        CATransaction.commit()
    }

}

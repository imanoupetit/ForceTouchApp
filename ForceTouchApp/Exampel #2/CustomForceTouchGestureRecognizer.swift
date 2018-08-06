//
//  PressViewController.swift
//  ForceTouchApp
//
//  Created by Imanou on 03/08/2018.
//  Copyright © 2018 Imanou Petit. All rights reserved.
//

/*
 Sources:
 - https://github.com/FlexMonkey/DeepPressGestureRecognizer
 - https://developer.apple.com/documentation/uikit/touches_presses_and_gestures/implementing_a_custom_gesture_recognizer/implementing_a_discrete_gesture_recognizer
 */

import UIKit

class CustomForceTouchViewController: UIViewController {

    let button = UIButton(type: .system)
    let stepper = UIStepper()

    override func viewDidLoad() {
        super.viewDidLoad()

        button.setTitle("Button", for: .normal)
        let forceTouchGestureRecognizer = CustomForceTouchGestureRecognizer(target: self, action: #selector(deepPressHandler))
        button.addGestureRecognizer(forceTouchGestureRecognizer)

        let deepPressGestureRecognizer2 = CustomForceTouchGestureRecognizer(target: self, action: #selector(deepPressHandler))
        stepper.addGestureRecognizer(deepPressGestureRecognizer2)
        stepper.addTarget(self, action: #selector(stepperChange), for: UIControlEvents.valueChanged)

        let stackView = UIStackView()
        stackView.addArrangedSubview(button)
        stackView.addArrangedSubview(stepper)
        view.addSubview(stackView)

        stackView.axis = UILayoutConstraintAxis.vertical
        stackView.spacing = 20
        stackView.alignment = UIStackViewAlignment.center

        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }

    @objc func deepPressHandler(_ sender: CustomForceTouchGestureRecognizer) {
        print("force touch triggered: \(sender.state == .recognized)")
        if sender.state == .recognized {
            UINotificationFeedbackGenerator().notificationOccurred(.success)
        }
    }

    @objc func stepperChange() {
        print("stepper change", stepper.value)
    }

}

import UIKit.UIGestureRecognizerSubclass

final class CustomForceTouchGestureRecognizer: UIGestureRecognizer {

    private let threshold: CGFloat = 0.75

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
        state = UIGestureRecognizerState.failed
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesCancelled(touches, with: event)
        state = UIGestureRecognizerState.failed
    }

    private func handleTouch(_ touch: UITouch) {
        guard touch.force != 0 && touch.maximumPossibleForce != 0 else { return }

        if touch.force / touch.maximumPossibleForce >= threshold {
            state = UIGestureRecognizerState.recognized
        }
    }

}

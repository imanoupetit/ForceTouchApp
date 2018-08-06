//
//  PressViewController.swift
//  ForceTouchApp
//
//  Created by Imanou on 03/08/2018.
//  Copyright © 2018 Imanou Petit. All rights reserved.
//

import UIKit

class PressViewController: UIViewController {

    let stackView = UIStackView()
    let button = UIButton(type: UIButtonType.system)
    let deepPressableButton = DeepPressableButton(type: UIButtonType.system)
    let slider = DeepPressableSlider()
    let stepper = UIStepper()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(stackView)

        button.setTitle("Button with Gesture Recognizer", for: UIControlState.normal)

        stackView.addArrangedSubview(button)

        let deepPressGestureRecognizer = DeepPressGestureRecognizer(target: self, action: #selector(deepPressHandler), threshold: 0.75)
        button.addGestureRecognizer(deepPressGestureRecognizer)

        deepPressableButton.setTitle("DeepPressableButton", for: UIControlState.normal)
        stackView.addArrangedSubview(deepPressableButton)

        deepPressableButton.setDeepPressAction(target: self, action: #selector(deepPressHandler))
        stackView.addArrangedSubview(button)

        slider.setDeepPressAction(target: self, action: #selector(deepPressHandler))
        slider.addTarget(self, action: #selector(sliderChange), for: UIControlEvents.valueChanged)
        stackView.addArrangedSubview(slider)

        let deepPressGestureRecognizer_2 = DeepPressGestureRecognizer(target: self, action: #selector(deepPressHandler), threshold: 0.75)

        stepper.addGestureRecognizer(deepPressGestureRecognizer_2)
        stepper.addTarget(self, action: #selector(stepperChange), for: UIControlEvents.valueChanged)
        stackView.addArrangedSubview(stepper)
    }

    @objc func deepPressHandler(value: DeepPressGestureRecognizer) {
        if value.state == UIGestureRecognizerState.began {
            print("deep press begin: ", String(describing: value.view?.description))
        } else if value.state == UIGestureRecognizerState.ended {
            print("deep press ends.")
        }
    }

    @objc func stepperChange() {
        print("stepper change", stepper.value)
    }

    @objc func sliderChange() {
        print("slider change", slider.value)
    }

    override func viewDidLayoutSubviews() {
        stackView.axis = UILayoutConstraintAxis.vertical
        stackView.distribution = UIStackViewDistribution.equalSpacing
        stackView.alignment = UIStackViewAlignment.center
        stackView.frame = CGRect(x: 0, y: view.safeAreaInsets.top, width: view.frame.width, height: view.frame.height - view.safeAreaInsets.top).insetBy(dx: 50, dy: 100)
    }

}

class DeepPressableButton: UIButton, DeepPressable {

}

class DeepPressableSlider: UISlider, DeepPressable {

    override var intrinsicContentSize: CGSize {
        return CGSize(width: 200, height: super.intrinsicContentSize.height)
    }

}

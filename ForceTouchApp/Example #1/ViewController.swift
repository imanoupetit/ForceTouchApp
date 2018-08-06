//
//  ViewController.swift
//  ForceTouchApp
//
//  Created by Imanou on 03/08/2018.
//  Copyright © 2018 Imanou Petit. All rights reserved.
//

// Source: https://www.techotopia.com/index.php/An_iOS_9_3D_Touch_Force_Handling_Tutorial

import UIKit

class ForceTouchView: UIView {

    var size: CGFloat = 0

    override func draw(_ rect: CGRect) {
        let viewWidth = bounds.width
        let viewHeight = bounds.height

        let context = UIGraphicsGetCurrentContext()
        let rectangle = CGRect(x: 0, y: viewHeight - size, width: viewWidth, height: size)
        context?.addRect(rectangle)
        context?.setFillColor(UIColor.red.cgColor)
        context?.fill(rectangle)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        handleTouch(touches)
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        handleTouch(touches)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        size = 0
        self.setNeedsDisplay()
    }

    func handleTouch(_ touches: Set<UITouch>) {
        let touch = touches.first

        if traitCollection.forceTouchCapability == .available {
            //size = touch!.force * 100
            size = touch!.force / touch!.maximumPossibleForce * bounds.height
            print("force:", touch!.force)
        } else {
            // fallback
        }
        self.setNeedsDisplay()
    }

}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let forceTouchView = ForceTouchView()
        forceTouchView.backgroundColor = .green

        view.addSubview(forceTouchView)
        forceTouchView.translatesAutoresizingMaskIntoConstraints = false
        forceTouchView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        forceTouchView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        forceTouchView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        forceTouchView.heightAnchor.constraint(equalToConstant: 100).isActive = true
    }

}

//
//  ViewController.swift
//  ClothPressureExample
//
//  Created by Roland Leth on 05.01.2017.
//  Copyright © 2017 Roland Leth. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIGestureRecognizerDelegate {
	
	private lazy var distance: CGFloat = self.view.frame.width * 0.25
	
	
	// MARK: - View life

	override func viewDidLoad() {
		super.viewDidLoad()
		
		view.backgroundColor = .black
		
		(0..<Int(view.frame.width / 15)).forEach { x in
			(0..<Int(view.frame.height / 15)).forEach { y in
				let v = UIView()
				v.frame = CGRect(
					x: 6 + x * 15, y: 8 + y * 15,
					width: 4, height: 4
				)
				v.backgroundColor = .white
				v.layer.cornerRadius = v.frame.width * 0.5
				view.addSubview(v)
			}
		}
	}
	
	
	// MARK: - Gestures
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		guard let point = touches.first?.location(in: view) else { return }
		UIView.animate(withDuration: 0.1) {
			self.handleTouch(at: point)
		}
	}
	
	override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
		guard let point = touches.first?.location(in: view) else { return }
		handleTouch(at: point)
	}
	
	override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
		UIView.animate(withDuration: 0.1) {
			self.view.subviews.forEach(self.reset)
		}
	}
	
	
	// MARK: - Subview handling
	
	private func reset(view: UIView) {
		view.transform = CGAffineTransform.identity
		view.alpha = 1
	}
	
	private func handleTouch(at touch: CGPoint) {
		let adjacentViews = view.subviews.filter {
			self.distance(from: $0.frame.origin, to: touch) <= distance
		}
		
		view.subviews.forEach(reset)
		adjacentViews.forEach {
			let delta = self.distance(from: $0.frame.origin, to: touch) / distance
			
			$0.alpha = delta / 0.8
			$0.transform = CGAffineTransform.identity.scaledBy(x: delta, y: delta)
		}
	}
	
	
	// MARK: - Helpers
	
	private func distance(from p1: CGPoint, to p2: CGPoint) -> CGFloat {
		let xDiff = p1.x - p2.x
		let yDiff = p1.y - p2.y
		return sqrt(pow(xDiff, 2) + pow(yDiff, 2))
	}
	
}


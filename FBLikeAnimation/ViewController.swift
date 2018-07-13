//
//  ViewController.swift
//  FBLikeAnimation
//
//  Created by Israel Mayor on 12/07/2018.
//  Copyright © 2018 Israel Mayor. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

	let bgImage: UIImageView = {
		let imageView = UIImageView(image: #imageLiteral(resourceName: "fb_core_data_bg"))
		return imageView
	}()
	
	let iconsContainerView: UIView = {
		let containerView = UIView()
		containerView.backgroundColor = .white
		
		let iconHeight:CGFloat = 38
		let padding:CGFloat = 6
		
		let images = [#imageLiteral(resourceName: "blue_like"), #imageLiteral(resourceName: "red_heart"), #imageLiteral(resourceName: "cry_laugh"), #imageLiteral(resourceName: "surprised"), #imageLiteral(resourceName: "cry"), #imageLiteral(resourceName: "angry")]
		
		let arrangedSubViews = images.map({ (image) -> UIView in
			let imageView = UIImageView(image: image)
			imageView.layer.cornerRadius = iconHeight / 2
			imageView.isUserInteractionEnabled = true
			return imageView
		})
		
		let stackView =  UIStackView(arrangedSubviews: arrangedSubViews)
		stackView.distribution = .fillEqually
		stackView.spacing = padding
		stackView.isLayoutMarginsRelativeArrangement = true
		stackView.layoutMargins = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)

		let iconNum = CGFloat(arrangedSubViews.count)
		let width = iconNum * iconHeight + (iconNum + 1) * padding
		
		containerView.frame = CGRect(x: 0, y: 0, width: width, height: iconHeight + (2 * padding))
		containerView.layer.cornerRadius = containerView.frame.height / 2
		stackView.frame = containerView.frame
		containerView.addSubview(stackView)
		
		containerView.layer.shadowColor = UIColor(white: 0.4, alpha: 0.4).cgColor
		containerView.layer.shadowRadius = 8
		containerView.layer.shadowOffset = CGSize(width: 0, height: 4)
		containerView.layer.shadowOpacity = 0.5
		
		return containerView
	}()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		bgImage.frame = view.frame
		view.addSubview(bgImage)
		setupLongPressed()
	}
	
	fileprivate func setupLongPressed() {
		view.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(handleTapGesture)))
	}
	
	@objc func handleTapGesture(gesture: UILongPressGestureRecognizer) {
		if gesture.state == .began {
			handleBeganGesture(gesture: gesture)
		} else if gesture.state == .ended {
			handleEndedGesture(gesture: gesture)
		} else if gesture.state == .changed {
			handleChangedGesture(gesture: gesture)
		}
	}
	
	fileprivate func handleEndedGesture(gesture: UILongPressGestureRecognizer) {
		UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
			let stackView = self.iconsContainerView.subviews.first
			stackView?.subviews.forEach({ (imageView) in
				imageView.transform = .identity
			})
			self.iconsContainerView.transform = self.iconsContainerView.transform.translatedBy(x: 0, y: 50)
			self.iconsContainerView.alpha = 0
		}, completion: { (_) in
			self.iconsContainerView.removeFromSuperview()
		})
	}
	
	fileprivate func handleBeganGesture(gesture: UILongPressGestureRecognizer) {
		view.addSubview(iconsContainerView)
		let pressedLocation = gesture.location(in: view)
		let centeredX = (view.frame.width - iconsContainerView.frame.width) / 2
		iconsContainerView.transform = CGAffineTransform(translationX: centeredX, y: pressedLocation.y)
		iconsContainerView.alpha = 0
		
		UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
			self.iconsContainerView.alpha = 1
			self.iconsContainerView.transform = CGAffineTransform(translationX: centeredX, y: pressedLocation.y - self.iconsContainerView.frame.height)
		})
	}
	
	fileprivate func handleChangedGesture(gesture: UILongPressGestureRecognizer) {
		let pressedLocation = gesture.location(in: iconsContainerView)
		let fixedYLocation = CGPoint(x: pressedLocation.x, y: iconsContainerView.frame.height / 2)
		let hitTest = iconsContainerView.hitTest(fixedYLocation, with: nil)
		
		if hitTest is UIImageView {
			UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
				let stackView = self.iconsContainerView.subviews.first
				stackView?.subviews.forEach({ (imageView) in
					imageView.transform = .identity
				})
				hitTest?.transform = CGAffineTransform(translationX: 0, y: -50)
			})
		}
	}
	
	override var prefersStatusBarHidden: Bool {
		return true
	}
}


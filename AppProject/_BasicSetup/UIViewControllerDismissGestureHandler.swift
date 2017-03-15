//
//  UIViewControllerGestureDismissHandler.swift
//  AppProject
//
//  Created by Chamira Fernando on 15/03/2017.
//  Copyright © 2017 Making Waves. All rights reserved.
//


import UIKit

//MARK: - Gesture directions
enum UIViewControllerDismissGestureDirection {
	case topToBottom, leftToRight, bottomToTop, rightToLeft
}

//MARK: - Gesture Handler class
///
///
///	Allow UIViewControllers to dismiss with pan gesture.
///
///
/// Dismissing an UIViewController with pan gesture creates so much boilerplate code in UIViewController class. Thus, this handler (wrapper) class
/// does all the dirty work to dismiss with pan gesture.
///
/// Example:
/// ```
///	class ViewController : UIViewController {
///
///		var dragDownHandler:UIViewControllerDismissGestureHandler!
///
///		override func viewDidLoad() {
///			super.viewDidLoad()
///			dragDownHandler = UIViewControllerDismissGestureHandler(for: self, direction:.topToBottom)
///			self.view.backgroundColor = UIColor.red
///		}
///
///	}
/// ```
///
class UIViewControllerDismissGestureHandler : NSObject, UIViewControllerTransitioningDelegate {
	
	static let kDefaultAnimationDuration = 0.6
	weak fileprivate(set) var viewController:UIViewController!
	fileprivate(set) var direction:UIViewControllerDismissGestureDirection = .topToBottom
	fileprivate(set) var animationDuration:TimeInterval = UIViewControllerDismissGestureHandler.kDefaultAnimationDuration
	
	let interactor:UIViewControllerGestureDismissInteractor = UIViewControllerGestureDismissInteractor()
	
	
	/// init handler for UIViewController
	///
	/// - Parameters:
	///   - viewController: UIViewController to add pan gesture,
	///   - direction: direction default value is UIViewControllerDismissGestureDirection.topToBottom
	///   - animationDuration: animation duration default value is UIViewControllerDismissGestureHandler.kDefaultAnimationDuration = 0.6
	
	init(for viewController:UIViewController, direction:UIViewControllerDismissGestureDirection = .topToBottom, animationDuration:TimeInterval = UIViewControllerDismissGestureHandler.kDefaultAnimationDuration) {
		super.init()
		self.viewController = viewController
		self.direction = direction
		self.animationDuration = animationDuration
		self.addDragDownGesture()
	}
	
	
	private func addDragDownGesture() {
		
		guard let vc = viewController else {
			return
		}
		
		let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handleGesture(sender:)))
		panGesture.cancelsTouchesInView = true
		panGesture.delaysTouchesEnded = true
		panGesture.minimumNumberOfTouches = 1
		vc.transitioningDelegate = self
		vc.view.addGestureRecognizer(panGesture)
	}
	
	@objc private func handleGesture(sender: UIPanGestureRecognizer) {
		
		guard let vc = viewController else {
			return
		}
		
		let view = vc.view!
		
		let progress = self.progress(sender, view)
		handler(sender, progress)
		
	}
	
	
	private func progress(_ sender:UIPanGestureRecognizer, _ view:UIView) -> CGFloat {
		
		switch direction {
		case .leftToRight:
			return leftToRightProgress(sender, view)
		case .bottomToTop:
			return bottomToTopProgress(sender, view)
		case .rightToLeft:
			return rightToLeftProgress(sender, view)
		default:
			return topToBottomProgress(sender, view)
		}
		
	}
	
	private func progressMovement(movement:CGFloat) -> CGFloat {
		let maxMovement = fmaxf(Float(movement), 0.0)
		let maxMovementPercent = fminf(maxMovement, 1.0)
		let progress = CGFloat(maxMovementPercent)
		return progress
	}
	
	private func topToBottomProgress(_ sender:UIPanGestureRecognizer, _ view:UIView) -> CGFloat {
		
		let translation = sender.translation(in: view)
		let verticalMovement = translation.y / view.bounds.height
		return progressMovement(movement: verticalMovement)
		
	}
	
	private func bottomToTopProgress(_ sender:UIPanGestureRecognizer, _ view:UIView) -> CGFloat {
		
		let translation = sender.translation(in: view)
		let movement = translation.y / view.bounds.height
		if movement >= 0.0 {
			return 0.0
		}
		
		let verticalMovement = abs(movement)
		return progressMovement(movement: verticalMovement)
		
	}
	
	private func leftToRightProgress(_ sender:UIPanGestureRecognizer, _ view:UIView) -> CGFloat {
		
		let translation = sender.translation(in: view)
		let horizontalMovement = translation.x / view.bounds.width
		return progressMovement(movement: horizontalMovement)
		
	}
	
	private func rightToLeftProgress(_ sender:UIPanGestureRecognizer, _ view:UIView) -> CGFloat {
		
		let translation = sender.translation(in: view)
		
		let movement = translation.x / view.bounds.width
		if movement >= 0.0 {
			return 0.0
		}
		
		let horizontalMovement = abs(movement)
		return progressMovement(movement: horizontalMovement)
		
	}
	
	private func handler(_ sender:UIPanGestureRecognizer, _ progress:CGFloat) {
		
		guard let vc = viewController else {
			return
		}
		
		let percentThreshold:CGFloat = 0.3
		switch sender.state {
		case .began:
			interactor.hasStarted = true
			vc.dismiss(animated: true, completion: nil)
		case .changed:
			interactor.shouldFinish = progress > percentThreshold
			interactor.update(progress)
		case .cancelled:
			interactor.hasStarted = false
			interactor.cancel()
		case .ended:
			interactor.hasStarted = false
			interactor.shouldFinish ? interactor.finish() : interactor.cancel()
		default:
			break
		}
		
	}
	
	func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
		return UIViewControllerDismissAnimator(for: self.direction, animationDuration: self.animationDuration)
	}
	
	func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
		return interactor.hasStarted ? interactor : nil
	}
	
}

//MARK: - Dismiss Interactor class
public class UIViewControllerGestureDismissInteractor: UIPercentDrivenInteractiveTransition {
	var hasStarted = false
	var shouldFinish = false
}

//MARK: - Dismiss animator class
class UIViewControllerDismissAnimator : NSObject, UIViewControllerAnimatedTransitioning {
	
	var animationDuration:TimeInterval = 0.6
	fileprivate(set) var direction:UIViewControllerDismissGestureDirection = .topToBottom
	
	init(for direction:UIViewControllerDismissGestureDirection, animationDuration:TimeInterval =  UIViewControllerDismissGestureHandler.kDefaultAnimationDuration) {
		super.init()
		self.direction = direction
		self.animationDuration = animationDuration
	}
	
	private func finalFrame()-> CGRect {
		
		let screenBounds = UIScreen.main.bounds
		var hiddingCorner = CGPoint(x: 0, y: screenBounds.height)
		
		switch direction {
			
		case .bottomToTop:
			hiddingCorner = CGPoint(x: 0, y: -screenBounds.height)
		case .leftToRight:
			hiddingCorner = CGPoint(x: screenBounds.width, y: 0)
		case .rightToLeft:
			hiddingCorner = CGPoint(x: -screenBounds.width, y: 0)
		default:
			hiddingCorner = CGPoint(x: 0, y: screenBounds.height)
			
		}
		
		let finalFrame = CGRect(origin: hiddingCorner, size: screenBounds.size)
		return finalFrame
	}
	
	func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
		return animationDuration
	}
	
	func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
		guard
			let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from),
			let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
			else {
				return
		}
		
		let containerView = transitionContext.containerView
		containerView.insertSubview(toVC.view, belowSubview: fromVC.view)
		
		let finalFrame = self.finalFrame()
		
		UIView.animate(
			withDuration: transitionDuration(using: transitionContext),
			animations: {
				fromVC.view.frame = finalFrame
		},
			completion: { _ in
				transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
		}
		)
	}
}

//
//  UIViewControllerGestureDismissHandler.swift
//  AppProject
//
//  Created by Chamira Fernando on 15/03/2017.
//  Copyright © 2017 Chamira Fernando. All rights reserved.
//


import UIKit

//MARK: - Gesture directions
enum UIViewControllerDismissGestureDirection {
	case topToBottom, leftToRight, bottomToTop, rightToLeft
	
	var presentingDirection:UIViewControllerPresentingDirection {
		
		switch self {
		case .topToBottom:
			return .bottomToTop
		case .leftToRight:
			return .rightToLeft
		case .rightToLeft:
			return .leftToRight
		default:
			return .topToBottom
		}
	}
	
}

enum UIViewControllerPresentingDirection {
	case bottomToTop, leftToRight, topToBottom , rightToLeft
	
	var dismissingDirection:UIViewControllerDismissGestureDirection {
		
		switch self {
		case .topToBottom:
			return .bottomToTop
		case .leftToRight:
			return .rightToLeft
		case .rightToLeft:
			return .leftToRight
		default:
			return .topToBottom
		}
	}
	
}

//MARK: - UIViewController Basic TransitioningHandler class
///
/// Idea of this wrapper/handler class is to get rid of all the boilerplate code that has be impletemented to get basic custom transition work. (Left To Right and Top To Bottom kind)
///
///	Let you to present view controllers from bottomToTop, topToBottom, leftToRight and rightToLeft with animation. Also allows you to enabled pan gesture to dismiss with gesture
///
/// Dismissing an UIViewController with pan gesture creates so much boilerplate code in UIViewController class. Thus, this handler (wrapper) class
/// does all the dirty work to dismiss with pan gesture.
///
/// Dismiss opposite direction of presented direction
///
/// Example:
/// ```
///
/// class ViewController : UIViewController {
///
///	var transitionHandler:UIViewControllerBasicTransitioningHandler!
///
///	override func viewDidAppear(_ animated: Bool) {
///		super.viewDidAppear(animated)
///	}
///
///	override func viewDidLoad() {
///		super.viewDidLoad()
///		transitionHandler = UIViewControllerBasicTransitioningHandler(for: self, direction:.leftToRight)
///		transitionHandler.allowDismissWithGesture = true
///		self.view.backgroundColor = UIColor.red
///	}
///
///}
/// ```
///

class UIViewControllerBasicTransitioningHandler : NSObject, UIViewControllerTransitioningDelegate {
	
	static let kDefaultAnimationDuration = 0.6
	weak fileprivate(set) var viewController:UIViewController!
	fileprivate(set) var direction:UIViewControllerPresentingDirection = .bottomToTop
	fileprivate(set) var animationDuration:TimeInterval = UIViewControllerBasicTransitioningHandler.kDefaultAnimationDuration
	
	lazy fileprivate(set) var interactor:UIViewControllerGestureDismissInteractor = UIViewControllerGestureDismissInteractor()
	lazy fileprivate(set) var panGesture = UIPanGestureRecognizer()
	
	var allowDismissWithGesture:Bool = false {
		didSet {
			if allowDismissWithGesture {
				addDismissGesture()
			} else {
				removeDismissGesture()
			}
		}
	}
	
	init(for viewController:UIViewController, direction:UIViewControllerPresentingDirection = .bottomToTop, animationDuration:TimeInterval = UIViewControllerBasicTransitioningHandler.kDefaultAnimationDuration) {
		super.init()
		self.viewController = viewController
		self.direction = direction
		self.animationDuration = animationDuration
		self.viewController.transitioningDelegate = self
	}
	
	//MARK: - Transition Delegate Handler
	func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
		return UIViewControllerPresentingAnimator(for: self.direction, animationDuration: self.animationDuration)
	}
	
	func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
		if !allowDismissWithGesture {
			return nil
		}
		
		return UIViewControllerDismissAnimator(for: self.direction.dismissingDirection, animationDuration: self.animationDuration)
	}
	
	func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
		if !allowDismissWithGesture {
			return nil
		}
		return interactor.hasStarted ? interactor : nil
	}
	
	
	//MARK: - Private Methods (Helpers)
	private func addDismissGesture() {
		
		guard let vc = viewController else {
			return
		}
		
		panGesture.addTarget(self, action: #selector(handleGesture(sender:)))
		panGesture.cancelsTouchesInView = true
		panGesture.delaysTouchesEnded = true
		panGesture.minimumNumberOfTouches = 1
		
		vc.view.addGestureRecognizer(panGesture)
		
	}
	
	private func removeDismissGesture() {
		
		guard let vc = viewController else {
			return
		}
	
		vc.view.removeGestureRecognizer(panGesture)
		
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
		
		switch direction.dismissingDirection {
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

	
}


//MARK: - Dismiss animator class
final class UIViewControllerPresentingAnimator : NSObject, UIViewControllerAnimatedTransitioning {
	
	fileprivate(set) var animationDuration:TimeInterval = 0.6
	fileprivate(set) var direction:UIViewControllerPresentingDirection = .bottomToTop
	
	init(for direction:UIViewControllerPresentingDirection, animationDuration:TimeInterval =  UIViewControllerBasicTransitioningHandler.kDefaultAnimationDuration) {
		super.init()
		self.direction = direction
		self.animationDuration = animationDuration
	}
	
	private func initialFrame()-> CGRect {
		
		let screenBounds = UIScreen.main.bounds
		var hiddingCorner = CGPoint(x: 0, y: screenBounds.height)
		
		switch direction {
			
		case .topToBottom:
			hiddingCorner = CGPoint(x: 0, y: -screenBounds.height)
		case .leftToRight:
			hiddingCorner = CGPoint(x: -screenBounds.width, y: 0)
		case .rightToLeft:
			hiddingCorner = CGPoint(x: screenBounds.width, y: 0)
		default:
			hiddingCorner = CGPoint(x: 0, y:screenBounds.height)
			
		}
		
		let finalFrame = CGRect(origin: hiddingCorner, size: screenBounds.size)
		return finalFrame
	}
	
	func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
		return animationDuration
	}
	
	func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
		guard let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) else {
			return
		}
		
		let containerView = transitionContext.containerView
		
		
		toVC.view.frame = initialFrame()
		
		containerView.addSubview(toVC.view)
		
		let screenBounds = UIScreen.main.bounds
		
		UIView.animate(
			withDuration: transitionDuration(using: transitionContext),
			animations: {
				toVC.view.frame = CGRect(origin: CGPoint(x:0,y:0), size: screenBounds.size)
		},
			completion: { _ in
				transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
		}
		)
	}
}

//MARK: - Dismiss Interactor class
final public class UIViewControllerGestureDismissInteractor: UIPercentDrivenInteractiveTransition {
	var hasStarted = false
	var shouldFinish = false
}


//MARK: - Dismiss animator class
final class UIViewControllerDismissAnimator : NSObject, UIViewControllerAnimatedTransitioning {
	
	fileprivate(set) var animationDuration:TimeInterval = UIViewControllerBasicTransitioningHandler.kDefaultAnimationDuration
	fileprivate(set) var direction:UIViewControllerDismissGestureDirection = .topToBottom
	
	init(for direction:UIViewControllerDismissGestureDirection, animationDuration:TimeInterval =  UIViewControllerBasicTransitioningHandler.kDefaultAnimationDuration) {
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

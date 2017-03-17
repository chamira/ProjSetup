//
//  UI3DTouchPreviewableWrapper.swift
//
//  Created by Chamira Fernando on 16/03/2017.
//  Copyright © 2017 Chamira Fernando. All rights reserved.
//

import UIKit

/// Make UIView 3DTouch friendly
///
/// Example
///```
///		//Register for 3D touch
/// 	lazy var threeDTouchHandler:UIView3DTouchHandler = {
///			return UIView3DTouchHandler(holdingViewController: self)
///		}()

///		if self.traitCollection.forceTouchCapability == .available {
///			self.registerForPreviewing(with: self.threeDTouchHandler, sourceView: tableView)
///		}
///
///		//Implementing UITableViewCell3DTouchPreviewable Protocol
///		extension PersonImageView : UIView3DTouchPreviewable {
///			var previewableViewController: UIViewController {
///				let preViewController:PersonViewController = PersonViewController(nibName: "PersonViewController", bundle: nil)
///				preViewController.person = self.person!
///				preViewController.preferredContentSize = CGSize(width: 0.0, height: 300)
///				return preViewController
///			}
///		}
///
///```
///
///

final class UIView3DTouchHandler : NSObject, UIViewControllerPreviewingDelegate {
	
	weak fileprivate(set) var viewController:UIViewController!
	
	init(sender viewController:UIViewController) {
		super.init()
		self.viewController = viewController
	}
	
	func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
		
		let view = previewingContext.sourceView
		
		guard let previewableView = view as? UIView3DTouchPreviewable else {
			print("Make sure cell cell.conforms(to: UIView3DTouchPreviewable) protocol")
			return nil
		}
		
		previewingContext.sourceRect = view.frame
		return previewableView.previewableViewController
	}
	
	
	func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
		if (viewControllerToCommit.isBeingPresented){
			return
		}
		
		if viewControllerToCommit.modalPresentationStyle == UIModalPresentationStyle.fullScreen {
			self.viewController.present(viewControllerToCommit, animated: false, completion: nil)
		} else {
			self.viewController.show(viewControllerToCommit, sender: self)
		}
	}
	
}

/// Make UITableViewCell 3DTouch friendly
/// 
/// Example
///```
///		//Register for 3D touch
/// 	lazy var threeDTouchHandler:UITableViewCell3DTouchHandler = {
///			return UITableViewCell3DTouchHandler(holdingViewController: self)
///		}()

///		if self.traitCollection.forceTouchCapability == .available {
///			self.registerForPreviewing(with: self.threeDTouchHandler, sourceView: tableView)
///		}
///
///		//Implementing UITableViewCell3DTouchPreviewable Protocol
///		extension PersonTableViewCell : UIView3DTouchPreviewable {
///			var previewableViewController: UIViewController {
///				let preViewController:PersonViewController = PersonViewController(nibName: "PersonViewController", bundle: nil)
///				preViewController.person = self.person!
///				preViewController.preferredContentSize = CGSize(width: 0.0, height: 300)
///				return preViewController
///			}
///		}
///
///```
///
///
final class UITableViewCell3DTouchHandler : NSObject, UIViewControllerPreviewingDelegate { 
	
	weak fileprivate(set) var viewController:UIViewController!
	
	init(sender viewController:UIViewController) {
		super.init()
		self.viewController = viewController
	}
	
	func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
		
		guard let tableView = previewingContext.sourceView as? UITableView else {
			print("Source view is not type of UITableView", type(of:previewingContext.sourceView))
			return nil
		}
		
		guard let indexPath = tableView.indexPathForRow(at: location) else {
			return nil
		}
		
		guard let cell = tableView.cellForRow(at: indexPath) else {
			return nil
		}
		
		guard let previewableCell = cell as? UIView3DTouchPreviewable else {
			print("Make sure cell cell.conforms(to: UIView3DTouchPreviewable) protocol")
			return nil
		}
		
		previewingContext.sourceRect = cell.frame
		return previewableCell.previewableViewController
	}
	
	
	func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
		if (viewControllerToCommit.isBeingPresented){
			return
		}
		self.viewController.show(viewControllerToCommit, sender: self)
	}
	
}

/// Make UICollectionViewCell 3DTouch friendly
///
/// Example
///```
///		//Register for 3D touch
/// 	lazy var threeDTouchHandler:UICollectionViewCell3DTouchHandler = {
///			return UICollectionViewCell3DTouchHandler(holdingViewController: self)
///		}()

///		if self.traitCollection.forceTouchCapability == .available {
///			self.registerForPreviewing(with: self.threeDTouchHandler, sourceCollectionView: collectionView)
///		}
///
///		//Implementing UITableViewCell3DTouchPreviewable Protocol
///		extension PersonCollectionViewCell : UIView3DTouchPreviewable {
///			var previewableViewController: UIViewController {
///				let preViewController:PersonViewController = PersonViewController(nibName: "PersonViewController", bundle: nil)
///				preViewController.person = self.person!
///				preViewController.preferredContentSize = CGSize(width: 0.0, height: 300)
///				return preViewController
///			}
///		}
///
///```
///
///

final class UICollectionViewCell3DTouchHandler : NSObject, UIViewControllerPreviewingDelegate {
	
	weak fileprivate(set) var viewController:UIViewController!
	
	init(sender viewController:UIViewController) {
		super.init()
		self.viewController = viewController
	}
	
	func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
		
		guard let collectionView = previewingContext.sourceView as? UICollectionView else {
			print("Source view is not type of UICollectionView", type(of:previewingContext.sourceView))
			return nil
		}
		
		guard let indexPath = collectionView.indexPathForItem(at: location) else {
			return nil
		}
		
		guard let cell = collectionView.cellForItem(at: indexPath) else {
			return nil
		}
		
		guard let previewableCell = cell as? UIView3DTouchPreviewable else {
			print("Make sure cell cell.conforms(to: UIView3DTouchPreviewable) protocol")
			return nil
		}
		
		previewingContext.sourceRect = cell.frame
		return previewableCell.previewableViewController
	}
	
	
	func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
		if (viewControllerToCommit.isBeingPresented){
			return
		}
		self.viewController.show(viewControllerToCommit, sender: self)
	}
	
}


/// Every UITableViewCell must conform to UITableViewCell3DTouchPreviewable protocol to be able to make 3D touch previewable
protocol UIView3DTouchPreviewable : class {
	var previewableViewController:UIViewController { get }
}

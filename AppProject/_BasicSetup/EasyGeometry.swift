//
//  EasyGeometry.swift
//  AppProject
//
//  Created by Chamira Fernando on 14/03/2017.
//  Copyright © 2017 Making Waves. All rights reserved.
//

import UIKit

func Rect(_ x:Int = 0, _ y:Int = 0, _ width:Int, _ height:Int) -> CGRect {
	return CGRect(x: x, y: y, width: width, height: height)
}

func Rect(_ x:CGFloat = 0.0, _ y:CGFloat = 0.0, _ width:CGFloat, _ height:CGFloat) -> CGRect {
	return CGRect(x: x, y: y, width: width, height: height)
}

func Rect(_ x:Double = 0.0, _ y:Double = 0.0, _ width:Double, _ height:Double) -> CGRect {
	return CGRect(x: x, y: y, width: width, height: height)
}

func Size(_ width:Int, _ height:Int) -> CGSize {
	return CGSize(width: width, height: height)
}

func Size(_ width:CGFloat, _ height:CGFloat) -> CGSize {
	return CGSize(width: width, height: height)
}

func Size(_ width:Double, _ height:Double) -> CGSize {
	return CGSize(width: width, height: height)
}

func Point(_ x:Int = 0, _ y:Int = 0) -> CGPoint {
	return CGPoint(x: x, y: y)
}

func Point(_ x:CGFloat = 0, _ y:CGFloat = 0) -> CGPoint {
	return CGPoint(x: x, y: y)
}

func Point(_ x:Double = 0, _ y:Double = 0) -> CGPoint {
	return CGPoint(x: x, y: y)
}

func EdgeInsets (_ top:CGFloat, _ left:CGFloat, _ bottom: CGFloat, right:CGFloat) -> UIEdgeInsets {
	return UIEdgeInsets(top: top, left: left, bottom: bottom, right: right)
}

extension UIView {
	
	var minX:CGFloat {
		return self.frame.minX
	}

	var minY:CGFloat {
		return self.frame.minY
	}
	
	var midX:CGFloat {
		return self.frame.midX
	}
	
	var midY:CGFloat {
		return self.frame.midY
	}
	
	var maxX:CGFloat {
		return self.frame.maxX
	}
	
	var maxY:CGFloat {
		return self.frame.maxY
	}
	
}

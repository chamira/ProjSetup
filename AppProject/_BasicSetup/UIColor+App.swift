//
//  UIColor+App.swift
//  AppProject
//
//  Created by Chamira Fernando on 14/03/2017.
//  Copyright © 2017 Making Waves. All rights reserved.
//

import UIKit

//HEX extension
extension UIColor {
	convenience init(red: Int, green: Int, blue: Int) {
		self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
	}
	
	convenience init(hex:Int) {
		self.init(red:(hex >> 16) & 0xff, green:(hex >> 8) & 0xff, blue:hex & 0xff)
	}
	
}

extension UIColor {
	static var theme: UIColor {
		return UIColor(hex: 0x005BAA)
	}
	
	static var random:UIColor {
		
		let base:UInt32 = 255
		let fBase:Float = Float(base)
		
		let r = Float(arc4random_uniform(base) + 0) / fBase
		let g = Float(arc4random_uniform(base) + 0) / fBase
		let b = Float(arc4random_uniform(base) + 0) / fBase
		
		return UIColor(colorLiteralRed: r, green: g, blue: b, alpha: 1)
	}
}

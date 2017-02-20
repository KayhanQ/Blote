//
//  FontHelper.swift
//  Blote
//
//  Created by Mac on 2017-02-20.
//  Copyright © 2017 Paddy Crab Games. All rights reserved.
//

import Foundation
import UIKit

class FontHelper {
  static func printAllFonts() {
    for family: String in UIFont.familyNames {
      print("\(family)")
      for names: String in UIFont.fontNames(forFamilyName: family) {
        print("== \(names)")
      }
    }
  }
  
  static func latoMedium(_ size: CGFloat = 16.0) ->  UIFont {
    return UIFont(name: LatoFontNames.latoMedium.rawValue, size: size)!
  }
  
  static func latoLight(_ size: CGFloat = 16.0) ->  UIFont {
    return UIFont(name: LatoFontNames.latoLight.rawValue, size: size)!
  }
}

enum LatoFontNames: String {
  case latoMedium = "Lato-Medium"
  case latoBold = "Lato-Bold"
  case latoRegular = "Lato-Regular"
  case latoHairline = "Lato-Hairline"
  case latoLight = "Lato-Light"
}

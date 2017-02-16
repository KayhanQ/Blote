//
//  UIViewControllerExtensions.swift
//  Blote
//
//  Created by Mac on 2017-02-16.
//  Copyright © 2017 Paddy Crab Games. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
  func dismissKeyboard() {
    view.endEditing(true)
  }
}

//
//  Note.swift
//  Blote
//
//  Created by Mac on 2017-02-14.
//  Copyright © 2017 Paddy Crab Games. All rights reserved.
//

import UIKit

class Note {
  var uid: String!
  var title: String = ""
  var body: String = ""
  
  var hasUserEnteredTitle: Bool {
    return !title.isEmpty
  }
  
  var hasUserEnteredBody: Bool {
    return !body.isEmpty
  }
  
  func getDisplayableTitle() -> String {
    if !hasUserEnteredTitle {
      return "New Note"
    } else {
      return title
    }
  }
  
  init() {
    let now = Date()
    uid = String(now.timeIntervalSince1970)
  }
}


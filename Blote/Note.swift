//
//  Note.swift
//  Blote
//
//  Created by Mac on 2017-02-14.
//  Copyright © 2017 Paddy Crab Games. All rights reserved.
//

import UIKit

class Note {
  var uid: String {
    return String(dateCreated)
  }
  
  var title: String = ""
  var body: String = ""
  var isInFirstSession: Bool = false
  
  var dateCreated: TimeInterval!
  var dateLastEdited: TimeInterval!

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
    dateCreated = now.timeIntervalSince1970
    dateLastEdited = dateCreated
  }
}


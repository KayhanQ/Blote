//
//  PersistentDataStore.swift
//  Blote
//
//  Created by Mac on 2017-02-16.
//  Copyright © 2017 Paddy Crab Games. All rights reserved.
//

import Foundation

class PersistentDataStore {
  var notes: [Note] = []
  
  func isNoteNewNote(_ note: Note) -> Bool {
    if noteWithUID(note.uid) == nil {
      return true
    }
    return false
  }
  
  func deleteNote(_ note: Note) {
    for (i, n) in notes.enumerated() {
      if n.uid == note.uid {
        notes.remove(at: i)
      }
    }
  }
  
  func noteWithUID(_ uid: String) -> Note? {
    for n in notes {
      if n.uid == uid {
        return n
      }
    }
    return nil
  }
}

//
//  Note.swift
//  Blote
//
//  Created by Mac on 2017-02-14.
//  Copyright © 2017 Paddy Crab Games. All rights reserved.
//

import UIKit

class NoteViewController: UIViewController {
  
  @IBOutlet weak var titleView: UITextView!
  @IBOutlet weak var bodyView: UITextView!

  weak var mainViewDelegate: MainViewDelegate?
  
  var note: Note!
  var shouldBeDeleted: Bool = false
  var isViewDisappearing: Bool = false
  
  enum Focus {
    case none
    case title
    case body
  }
  
  var previousFocus: Focus = .none
  var currentFocus: Focus {
    if titleView.isFirstResponder {
      return .title
    } else if bodyView.isFirstResponder {
      return .body
    }
    return .none
  }
  
  static func instantiate() -> NoteViewController {
    return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NoteViewController") as! NoteViewController
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()

    titleView.delegate = self
    titleView.text = note.getDisplayableTitle()

    bodyView.delegate = self
    bodyView.text = note.body

    let backButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
    navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
    
    if !note.hasUserEnteredTitle && !note.hasUserEnteredBody {
      titleView.becomeFirstResponder()
      changeRightNavItemToDone()
    } else {
      changeRightNavItemToTrash()
    }
  }
  
  func changeRightNavItemToDone(_ animated: Bool = false) {
    let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(self.doneTapped(_:)))
    navigationItem.setRightBarButton(doneButton, animated: animated)
  }
  
  func changeRightNavItemToTrash(_ animated: Bool = false) {
    let trashButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.trash, target: self, action: #selector(self.trashTapped(_:)))
    navigationItem.setRightBarButton(trashButton, animated: animated)
  }
  
  func doneTapped(_ onboardingItem: UINavigationItem) {
    changeRightNavItemToTrash(true)
    resignFirstResponder()
    dismissKeyboard()
  }
  
  func trashTapped(_ onboardingItem: UINavigationItem) {
    shouldBeDeleted = true
    _ = navigationController?.popViewController(animated: true)
  }
  
  override func viewWillDisappear(_ animated : Bool) {
    isViewDisappearing = true
    super.viewWillDisappear(animated)
    if (self.isMovingFromParentViewController) {
      if shouldBeDeleted {
        mainViewDelegate?.delteNote(note)
      } else if !note.hasUserEnteredTitle && !note.hasUserEnteredBody {
        mainViewDelegate?.delteNote(note)
      }
    }
  }
}

extension NoteViewController: UITextViewDelegate {
  func textViewDidBeginEditing(_ textView: UITextView) {
    changeRightNavItemToDone()
    if currentFocus == .title {
      if !note.hasUserEnteredTitle {
        titleView.text = ""
      }
    }
  }
  
  func textViewDidChange(_ textView: UITextView) {
    note.title = titleView.text
    note.body = bodyView.text
  }
  
  func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
    if currentFocus == .title {
      if text == "\n" {
        bodyView.becomeFirstResponder()
        return false
      } else {
        return true
      }
    } else if currentFocus == .body {

    }
    return true
  }
  
  func textViewDidEndEditing(_ textView: UITextView) {
    if !note.hasUserEnteredTitle && !isViewDisappearing {
      titleView.text = note.getDisplayableTitle()
    }
  }
}

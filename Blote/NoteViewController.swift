//
//  Note.swift
//  Blote
//
//  Created by Mac on 2017-02-14.
//  Copyright © 2017 Paddy Crab Games. All rights reserved.
//

import UIKit
import SafariServices

class NoteViewController: UIViewController {
  
  @IBOutlet weak var titleView: UITextView!
  @IBOutlet weak var bodyView: UITextView!
  @IBOutlet weak var scrollView: UIScrollView!

  weak var mainViewDelegate: MainViewDelegate?
  
  var note: Note!
  var shouldBeDeleted: Bool = false
  var isViewDisappearing: Bool = false
  var keyboardHeight: CGFloat = 0
  var keyboardFrame: CGRect = CGRect.zero
  
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
    bodyView.linkTextAttributes = [//NSForegroundColorAttributeName: UIColor.orange,
                                   NSUnderlineStyleAttributeName: NSUnderlineStyle.styleSingle.rawValue | NSUnderlineStyle.patternSolid.rawValue]
    
    
    if !note.hasUserEnteredTitle && !note.hasUserEnteredBody {
      titleView.becomeFirstResponder()
      changeRightNavItemToDone()
    } else {
      changeRightNavItemToTrash()
    }
    
    NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    
    let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.viewTapped(_:)))
    view.addGestureRecognizer(tap)
    
    scrollView.delegate = self
  }
  
  func bodyTextViewTapped(_ sender: UITapGestureRecognizer) {
    
  }
  
  func makeNavigationBar() {
    let backButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
    navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
  }
  
  func viewTapped(_ sender: UITapGestureRecognizer) {
    let tapPoint = sender.location(in: self.view)
    
    if tapPoint.y >= bodyView.frame.origin.y {
      if currentFocus == .title {
        titleView.resignFirstResponder()
        return
      }
      
      bodyView.isEditable = true
      
      let layoutManager = bodyView.layoutManager
      var location: CGPoint = sender.location(in: bodyView)
      location.x -= bodyView.textContainerInset.left
      location.y -= bodyView.textContainerInset.top
      let charIndex = layoutManager.characterIndex(for: location, in: bodyView.textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
      
      bodyView.becomeFirstResponder()
      bodyView.selectedRange = NSRange.init(location: charIndex, length: 0)
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
      } else if note.isInFirstSession {
        mainViewDelegate?.noteWasJustCreated(note)
      }
    }
  }
  
  func keyboardWillShow(_ notification:NSNotification) {
    let userInfo:NSDictionary = notification.userInfo! as NSDictionary
    let keyboardFrame:NSValue = userInfo.value(forKey: UIKeyboardFrameEndUserInfoKey) as! NSValue
    let keyboardRectangle = keyboardFrame.cgRectValue
    keyboardHeight = keyboardRectangle.height
    self.keyboardFrame = keyboardRectangle
    
    let contentInsets = UIEdgeInsetsMake(0, 0, keyboardHeight + 20, 0)
    scrollView.contentInset = contentInsets
    scrollView.scrollIndicatorInsets = contentInsets
  }
  
  func keyboardWillHide(_ notification:NSNotification) {
    let contentInsets = UIEdgeInsets.zero
    scrollView.contentInset = contentInsets
    scrollView.scrollIndicatorInsets = contentInsets
  }
  
  deinit {
    NotificationCenter.default.removeObserver(self)
  }
}

extension NoteViewController: UITextViewDelegate {
  func textViewDidBeginEditing(_ textView: UITextView) {
    changeRightNavItemToDone()
    if currentFocus == .title {
      if !note.hasUserEnteredTitle {
        titleView.text = ""
      }
    } else if currentFocus == .body {

    }
  }
  
  func textViewDidChange(_ textView: UITextView) {
    note.title = titleView.text
    note.body = bodyView.text
  }
  
  func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
    if currentFocus == .title {
      if text == "\n" {
        titleView.resignFirstResponder()
        bodyView.isEditable = true
        bodyView.becomeFirstResponder()
        return false
      } else {
        return true
      }
    } else if currentFocus == .body {
//      if range.location > 0 {
//        let characters = textView.text.characters
//        let index = characters.index(characters.startIndex, offsetBy: range.location - 1)
//        let characterAtIndex = characters[index]
//        if characterAtIndex == "#" {
//          textView.text.remove(at: index)
//          textView.typingAttributes[NSFontAttributeName] = FontHelper.latoMedium()
//          textView.selectedRange = NSRange.init(location: range.location - 1, length: range.length)
//        }
//      }
    }
    return true
  }

  func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
    let webView = SFSafariViewController(url: URL)
    navigationController?.present(webView, animated: true, completion: nil)
    return false
  }
  
  func textViewDidEndEditing(_ textView: UITextView) {
    if !note.hasUserEnteredTitle && !isViewDisappearing {
      titleView.text = note.getDisplayableTitle()
    }
    bodyView.isEditable = false
  }
}

extension NoteViewController: UIScrollViewDelegate {
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    
  }
}

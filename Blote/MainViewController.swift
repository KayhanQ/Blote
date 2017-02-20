//
//  MainViewController.swift
//  Blote
//
//  Created by Mac on 2017-02-14.
//  Copyright © 2017 Paddy Crab Games. All rights reserved.
//

import UIKit

protocol MainViewDelegate: class {
  func delteNote(_ note: Note)
}

class MainViewController: UIViewController {
  
  @IBOutlet weak var tableView: UITableView!
  
  var persistentDataStore: PersistentDataStore = PersistentDataStore()
  
  override func viewDidLoad() {
    super.viewDidLoad()

    tableView.delegate = self
    tableView.dataSource = self
    //tableView.contentInset = UIEdgeInsetsMake(0, 20, 0, 0)
    
    tableView.allowsSelectionDuringEditing = false
    tableView.allowsMultipleSelectionDuringEditing = true

    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = 80
    tableView.tableFooterView = UIView(frame: .zero)

    createData()
    createNavBar()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    tableView.reloadData()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func createData() {
    for i in 0..<100 {
      let note1 = Note()
      note1.title = "Note " + String(i)
      note1.body = "If the above-mentioned international glyphs were not enough, we can also see a set of accents meant to combine with other characters to create diacritics. Those include dialytika tonos, itself a combination of dialytika and tonos, indicating that a (Greek) vowel should both pronounced separately (dialytika) and stressed (tonos). Most of the accents beautiful names — circumflex, diaeresis, macron, breve — but my favourite one is ogonek, literally Polish for little tail, used in this language’s ą and ę."
      persistentDataStore.notes.append(note1)
    }
  }
  
  func createNavBar() {
    navigationController?.navigationBar.isTranslucent = false
    navigationController?.navigationBar.backgroundColor = UIColor.white
    navigationController?.navigationBar.tintColor = UIColor.orange
    
    let editButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.edit, target: self, action: #selector(self.editTapped(_:)))
    editButton.title = "Select"
    navigationItem.leftBarButtonItem = editButton
    
    let newNote = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.compose, target: self, action: #selector(self.newNoteTapped(_:)))
    navigationItem.rightBarButtonItem = newNote
    
  }
  
  func editTapped(_ onboardingItem: UINavigationItem) {
    if tableView.isEditing {
      onboardingItem.title = "Select"
      tableView.setEditing(false, animated: true)
    } else {
      onboardingItem.title = "Done"
      tableView.setEditing(true, animated: true)
    }
  }
  
  func newNoteTapped(_ onboardingItem: UINavigationItem) {
    let note = Note()
    persistentDataStore.notes.append(note)
    pushNoteVCWithNote(note)
    
//    let onboardingVC = OnboardingViewController.instantiate()
//    let backButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
//    navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
//    navigationController?.pushViewController(onboardingVC, animated: true)
  }
  
  func pushNoteVCWithNote(_ note: Note) {
    let noteViewController = NoteViewController.instantiate()
    noteViewController.note = note
    noteViewController.mainViewDelegate = self
    navigationController?.pushViewController(noteViewController, animated: true)
  }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    print(persistentDataStore.notes.count)
    return persistentDataStore.notes.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let note = persistentDataStore.notes[indexPath.row]
    let cell = tableView.dequeueReusableCell(withIdentifier: "NoteCell", for: indexPath) as! NoteTableViewCell
    cell.title.attributedText = NSAttributedString(string: note.getDisplayableTitle())
    cell.body.attributedText = NSAttributedString(string: note.body)
    
    let backgroundView = UIView()
    backgroundView.backgroundColor = UIColor.clear
    cell.selectedBackgroundView = backgroundView
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if !tableView.isEditing {
      pushNoteVCWithNote(persistentDataStore.notes[indexPath.row])
    }
  }
  
  func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
    return true
  }
  
  func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
    var itemToMove = persistentDataStore.notes[sourceIndexPath.row]
    persistentDataStore.notes.remove(at: sourceIndexPath.row)
    persistentDataStore.notes.insert(itemToMove, at: destinationIndexPath.row)
  }
  
  
}

extension MainViewController: MainViewDelegate {
  func delteNote(_ note: Note) {
    persistentDataStore.deleteNote(note)
    tableView.reloadData()
  }
}

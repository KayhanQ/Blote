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
    let note1 = Note()
    persistentDataStore.notes.append(note1)
  }
  
  func createNavBar() {
    navigationController?.navigationBar.isTranslucent = false
    navigationController?.navigationBar.backgroundColor = UIColor.white
    navigationController?.navigationBar.tintColor = UIColor.orange
    
    let newNote = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.compose, target: self, action: #selector(self.newNoteTapped(_:)))
    navigationItem.rightBarButtonItem = newNote
    
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
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    pushNoteVCWithNote(persistentDataStore.notes[indexPath.row])
  }
}

extension MainViewController: MainViewDelegate {
  func delteNote(_ note: Note) {
    persistentDataStore.deleteNote(note)
    tableView.reloadData()
  }
}

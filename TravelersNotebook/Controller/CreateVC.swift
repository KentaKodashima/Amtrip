//
//  CreateVC.swift
//  TravelersNotebook
//
//  Created by Kenta Kodashima on 2018-03-28.
//  Copyright © 2018 Kenta Kodashima. All rights reserved.
//

import UIKit

class CreateVC: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate, UITextViewDelegate {
  
  @IBOutlet weak var albumTitle: UITextField!
  @IBOutlet weak var pageTitle: UITextField!
  @IBOutlet weak var date: UITextField!
  @IBOutlet weak var location: UITextField!
  @IBOutlet weak var bodyText: UITextView!
  @IBOutlet weak var imageCollection: UICollectionView!
  @IBOutlet weak var scrollView: UIScrollView!
  @IBOutlet weak var frameStack: UIStackView!
  
  var imageStore: ImageStore!
  var images = NSMutableArray()
  var selectedImage: UIImage?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // UITextView
    self.bodyText.delegate = self
    
    // UITextFields
    self.albumTitle.delegate = self
    self.pageTitle.delegate = self
    self.date.delegate = self
    self.location.delegate = self
    
    // Create close button above the textView keyboard
    // Tool bar
    let closeBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 40))
    closeBar.barStyle = UIBarStyle.default  // Style
    closeBar.sizeToFit()  // Size change depends on screen size
    // Spacer
    let spacer = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil)
    // Close Botton
    let closeButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(CreateVC.closeButtonTapped))
    
    closeBar.items = [spacer, closeButton]
    bodyText.inputAccessoryView = closeBar
    imageCollection.isHidden = true
    
    // Make a little space at top and bottom of the UIScrollView
    let edgeInsets = UIEdgeInsets(top: 30, left: 0, bottom: 30, right: 0)
    scrollView.contentInset = edgeInsets
  }
  
  override func viewDidLayoutSubviews() {
    scrollView.flashScrollIndicators()
  }
  
  // Enable textView to close
  @objc func closeButtonTapped() {
    self.view.endEditing(true)
  }
  
  // Enable return key of UITextFields
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    albumTitle.resignFirstResponder()
    pageTitle.resignFirstResponder()
    date.resignFirstResponder()
    location.resignFirstResponder()
    return true
  }
  
  // Open up device's camera
  @IBAction func takePicture(_ sender: UIButton) {
    let imagePicker = UIImagePickerController()
    if UIImagePickerController.isSourceTypeAvailable(.camera) {
      imagePicker.sourceType = .camera
    } else {
      imagePicker.sourceType = .photoLibrary
    }
    imagePicker.delegate = self
    
    // Place image picker on the screen
    present(imagePicker, animated: true, completion: nil)
  }
  
  // Open up device's camera
  @IBAction func pickPicture(_ sender: UIButton) {
    let imagePicker = UIImagePickerController()
    imagePicker.sourceType = .photoLibrary
    imagePicker.delegate = self
    // Place image picker on the screen
    present(imagePicker, animated: true, completion: nil)
  }
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
    // Get picked image from info directory
    let image = info[UIImagePickerControllerOriginalImage] as! UIImage
    
    // Put that image on the screen in the image view
    selectedImage = image
    images.add(selectedImage!)
    
    imageCollection.reloadData()
    
    // Take image picker off the screen
    dismiss(animated: true, completion: nil)
  }
  
}

extension CreateVC: UICollectionViewDelegate, UICollectionViewDataSource {
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    
    return images.count
  }
  
  // Assign cells contents
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ImageCell
    
    cell.cellImage.isHidden = true
    if let image = cell.cellImage.image {
      imageCollection.isHidden = false
      cell.cellImage.isHidden = false
      cell.cellImage.image = images[indexPath.row] as? UIImage
    }
    // Modifying Cell's width and height
    cell.layoutIfNeeded()
    scrollView.layoutIfNeeded()
    
    return cell
  }
  
}

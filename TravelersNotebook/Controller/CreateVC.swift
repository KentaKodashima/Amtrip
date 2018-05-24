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
  @IBOutlet weak var dateField: UITextField!
  @IBOutlet weak var locationField: UITextField!
  @IBOutlet weak var bodyText: UITextView!
  @IBOutlet weak var imageCollection: UICollectionView!
  @IBOutlet weak var scrollView: UIScrollView!
  @IBOutlet weak var frameStack: UIStackView!
  
  var imageStore: ImageStore!
  var images = [UIImage]()
  var selectedImage: UIImage?
  var textFromLocationVC: String?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // UITextView
    self.bodyText.delegate = self
    
    // UITextFields
    self.albumTitle.delegate = self
    self.pageTitle.delegate = self
    self.dateField.delegate = self
    self.locationField.delegate = self
    
    // Create close button above the textView keyboard
    // Tool bar
    let closeBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 40))
    closeBar.barStyle = UIBarStyle.default  // Style
    closeBar.sizeToFit()  // Size change depends on screen size
    // Spacer
    let spacer = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil)
    // Close Botton
    let closeButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(closeButtonTapped))
    closeBar.items = [spacer, closeButton]
    bodyText.inputAccessoryView = closeBar
    dateField.inputAccessoryView = closeBar
    
    // Hide the collectionview at first
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
    locationField.resignFirstResponder()
    return true
  }
  
  // Segue to LocationVC
  @IBAction func showLocationVC(_ sender: UITextField) {
    self.performSegue(withIdentifier: "toLocationVC", sender: self)
  }
  
//  func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
//    performSegue(withIdentifier: "toLocationVC", sender: self)
//    return false
//  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "toLocationVC" {
      let locationVC = segue.destination as? LocationVC
      //l.note = noteTextField.text
    }
  }
  
  // Show UIDatePicker when the dateField is tapped
  @IBAction func showDatePicker(_ sender: UITextField) {
    let datePicker = UIDatePicker()
    datePicker.datePickerMode = .date
    datePicker.addTarget(self, action: #selector(datePickerInput(_:)), for: UIControlEvents.valueChanged)
    sender.inputView = datePicker
  }
  
  // Show date in String on the dateField
  @objc func datePickerInput(_ sender: UIDatePicker) {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy/MM/dd"
    dateField.text = dateFormatter.string(from: sender.date)
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
    //images = [UIImage]()
    selectedImage = image
    images.append(selectedImage!)
    
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
    // Modify Cell's width and height
    cell.layoutIfNeeded()
    scrollView.layoutIfNeeded()
    
    return cell
  }
  
  @IBAction func deleteCell(_ sender: UIButton) {
    var cell = sender.superview?.superview as! UICollectionViewCell
    var imageCell = cell as! ImageCell
    var index = imageCollection?.indexPath(for: imageCell)
    images.remove(at: (index?.item)!)
    imageCollection.deleteItems(at: [index!])
    
    imageCollection.reloadData()
  }
  
}

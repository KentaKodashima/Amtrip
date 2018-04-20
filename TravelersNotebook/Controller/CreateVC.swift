//
//  CreateVC.swift
//  TravelersNotebook
//
//  Created by Kenta Kodashima on 2018-03-28.
//  Copyright © 2018 Kenta Kodashima. All rights reserved.
//

import UIKit

class CreateVC: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate,UITextFieldDelegate, UITextViewDelegate {
  
  @IBOutlet weak var albumTitle: UITextField!
  @IBOutlet weak var pageTitle: UITextField!
  @IBOutlet weak var date: UITextField!
  @IBOutlet weak var location: UITextField!
  @IBOutlet weak var bodyText: UITextView!
  @IBOutlet weak var imageCollection: UICollectionView!
  
  var imageStore: ImageStore!
  var images: [UIImage]?
  var selectedImage: UIImage?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    bodyText.delegate = self
    
    // Enable return key of UITextFields
    self.albumTitle.delegate = self
    self.pageTitle.delegate = self
    self.date.delegate = self
    self.location.delegate = self
    
  }
  
  func textViewDidChange(_ textView: UITextView) {
    // Method 1
    let maxHeight = 1000.0
//    if (textView.frame.size.height.native < maxHeight) {
//      let size:CGSize = textView.sizeThatFits(textView.frame.size)
//      textView.frame.size.height = size.height
//    }
  }
  
  /*
   Enable return key of UITextFields
   */
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
    images?.append(selectedImage!)
    
    imageCollection.reloadData()
    
    // Take image picker off the screen
    dismiss(animated: true, completion: nil)
  }
  
}

extension CreateVC: UICollectionViewDelegate, UICollectionViewDataSource {
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    
    if let image = images {
      return image.count
    } else {
      return 0
    }
    
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! ImageCell
    
    cell.cellImage.isHidden = true
    if let image = cell.cellImage {
      cell.cellImage.isHidden = false
      cell.cellImage.image = selectedImage
    }
    //cell.cellImage.image = selectedImage
    
    return cell
  }
  
}

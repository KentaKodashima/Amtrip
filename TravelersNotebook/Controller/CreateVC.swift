//
//  CreateVC.swift
//  TravelersNotebook
//
//  Created by Kenta Kodashima on 2018-03-28.
//  Copyright © 2018 Kenta Kodashima. All rights reserved.
//

import UIKit
import GooglePlaces
import RealmSwift

class CreateVC: UIViewController, UITextFieldDelegate, UITextViewDelegate {
  
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
  
  var imageData: Data?
  var imagesData = [Data]()
  var imagesPath = List<String>()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Set delegates
    self.imageCollection.delegate = self
    self.bodyText.delegate = self
    self.albumTitle.delegate = self
    self.pageTitle.delegate = self
    self.dateField.delegate = self
    self.locationField.delegate = self
    
    // Create Toolbar with 'Close' button above the system keyboard
    createToolbarForKeyboard()
    
    // Hide the collectionview at first
    imageCollection.isHidden = true
    
    // Make a little space at top and bottom of the UIScrollView
    let edgeInsets = UIEdgeInsets(top: 30, left: 0, bottom: 30, right: 0)
    scrollView.contentInset = edgeInsets
  }
  
  override func viewDidLayoutSubviews() {
    scrollView.flashScrollIndicators()
    
    let layout = UICollectionViewFlowLayout()
    layout.itemSize = CGSize(width: 120, height: 120)
    layout.minimumInteritemSpacing = 0
    layout.minimumLineSpacing = 10
    layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    layout.scrollDirection = .horizontal
    imageCollection.collectionViewLayout = layout
  }
  
  private func createToolbarForKeyboard() {
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
  
  // Segue to AlbumCreateVC
  @IBAction func albumTitleFieldTapped(_ sender: UITextField) {
    albumTitle.resignFirstResponder()
    
    self.performSegue(withIdentifier: "toAlbumCreateVC", sender: sender)
  }
  
  // Unwind segue from AlbumCreateVC to CreateVC
  // Passing albumTitle from AlbumCreateVC
  @IBAction func returnHere(segue: UIStoryboardSegue) {
    let sourceVC = segue.source as? AlbumCreateVC
    if let albumFieldText = sourceVC?.albumTitleField.text {
      albumTitle.text = albumFieldText
    }
    if let albumTitleSelected = sourceVC?.tempString {
      albumTitle.text = albumTitleSelected
    }
  }
  
  // Present the Autocomplete view controller when the button is pressed.
  @IBAction func locationFieldTapped(_ sender: Any) {
    locationField.resignFirstResponder()
    let acController = GMSAutocompleteViewController()
    acController.delegate = self
    
    //let darkBrown: UIColor = #colorLiteral(red: 0.6784313725, green: 0.4235294118, blue: 0.2078431373, alpha: 1)
    let lightBrown: UIColor = #colorLiteral(red: 0.9450980392, green: 0.8549019608, blue: 0.7215686275, alpha: 1)
    acController.tableCellBackgroundColor = lightBrown
    
    present(acController, animated: true, completion: nil)
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
  
  @IBAction func saveButtonTapped(_ sender: UIButton) {

    if isPropertyEmpty() {
      let page = Page(
        albumTitle: self.albumTitle.text!,
        pageTitle: self.pageTitle.text!,
        date: self.dateField.text!,
        location: self.locationField.text!,
        bodyText: self.bodyText.text!,
        images: self.imagesPath
      )
      
      let realm = try! Realm()
      
      // Check to see if there is an Album which has the same name
      let existingAlbum = realm.objects(Album.self).filter("albumTitle == '\(page.albumTitle)'")
      
      if existingAlbum.count == 0 {
        let album = Album(albumTitle: page.albumTitle)
        album.pages.append(page)
        try! realm.write {
          realm.add(page)
          realm.add(album)
        }
      } else {
        try! realm.write {
         existingAlbum.first?.pages.append(page)
        }
      }
      
      resetFields()
      
    } else {
      
      let alert = UIAlertController(title: "There is an empty field", message: "Please try to fill out all the fields", preferredStyle: .alert)
      
      let defaultAction = UIAlertAction(
        title: "OK", style: UIAlertActionStyle.default, handler:{
          (action: UIAlertAction!) -> Void in
          print("OK")
      })
      
      alert.addAction(defaultAction)
      
      present(alert, animated: true, completion: nil)
    }
  }
  // Check all required fields are filled up
  private func isPropertyEmpty() -> Bool {
    var isEmpty = false
    switch isEmpty {
    case self.albumTitle.text?.isEmpty:
      isEmpty = true
    case self.pageTitle.text?.isEmpty:
      isEmpty = true
    case self.dateField.text?.isEmpty:
      isEmpty = true
    case self.locationField.text?.isEmpty:
      isEmpty = true
    case self.bodyText.text?.isEmpty:
      isEmpty = true
    default:
      isEmpty = false
    }
    return isEmpty
  }
  // Reset everything
  private func resetFields() {
    albumTitle.text = ""
    pageTitle.text = ""
    dateField.text = ""
    locationField.text = ""
    bodyText.text = ""
    images = [UIImage]()
  }
  
}

extension CreateVC: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
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
  
  @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
    
    // Get picked image from info directory
    let image = info[UIImagePickerControllerOriginalImage] as! UIImage
    
    // Put that image on the screen in the image view
    selectedImage = image
    
    images.append(selectedImage!)
    saveImageData(selectedImage!)
    
    imageCollection.reloadData()
    
    // Take image picker off the screen
    dismiss(animated: true, completion: nil)
  }
  
  // Save image data
  func saveImageData(_ image: UIImage) {
    let filemanager = FileManager.default
    let documentsURL = filemanager.urls(for: .documentDirectory, in: .userDomainMask).first!
    let documentPath = documentsURL.path
    let filePath = documentsURL.appendingPathComponent(".png")
    
    do {
      imageData = UIImagePNGRepresentation(image)
      try imageData?.write(to: filePath, options: .atomic)
      imagesPath.append(filePath.absoluteString)
    } catch {
      
      let alert = UIAlertController(title: "Something went wrong", message: "Couldn't write image", preferredStyle: .alert)
      
      let defaultAction = UIAlertAction(
        title: "OK", style: UIAlertActionStyle.default, handler:{
          (action: UIAlertAction!) -> Void in
          print("OK")
      })
      
      alert.addAction(defaultAction)
      
      present(alert, animated: true, completion: nil)
    }
  }
}

extension CreateVC: UICollectionViewDelegate, UICollectionViewDataSource {
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return images.count
  }
  
  // Assign cells contents
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ImageCell
  
    cell.cellImage.image = images[indexPath.row]
    imageCollection.isHidden = false

    return cell
  }
  
  @IBAction func deleteCell(_ sender: UIButton) {
    let cell = sender.superview?.superview as! UICollectionViewCell
    let imageCell = cell as! ImageCell
    var index = imageCollection?.indexPath(for: imageCell)
    images.remove(at: (index?.item)!)
    imageCollection.deleteItems(at: [index!])
    
    guard images.count > 0 else {
      imageCollection.isHidden = true
      return
    }
  }
}

// Set up google places API
extension CreateVC: GMSAutocompleteViewControllerDelegate {
  // Handle the user's selection.
  func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
    
    locationField.text = place.name
    dismiss(animated: true, completion: nil)
  }
  
  func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
    // TODO: handle the error.
    print("Error: ", error.localizedDescription)
  }
  
  // User canceled the operation.
  func wasCancelled(_ viewController: GMSAutocompleteViewController) {
    dismiss(animated: true, completion: nil)
  }
  
}

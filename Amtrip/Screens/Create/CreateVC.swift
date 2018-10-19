//
//  CreateVC.swift
//  Amtrip
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
  @IBOutlet weak var saveButton: UIButton!
  
  public var isSegueFromPageDetailVC = false
  public var receivedPage: Page?
  public var receivedAlbum: Album?
  
  private var doneButton = UIBarButtonItem()
  
  private var images = [UIImage]()
  private var selectedImage: UIImage?
  private var imageData: Data?
  private var imagesData = [Data]()
  private var imageNames = [String]()
  private var selectedDate = Date()
  
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
    pageTitle.createToolbarForKeyboard()
    dateField.createToolbarForKeyboard()
    bodyText.createToolbarForKeyboard()
    
    imageCollection.isHidden = true
    navigationItem.hidesBackButton = true
    
    // Default texts for UITextView
    bodyText.text = NSLocalizedString("Enter your text here.", comment: "")
    bodyText.alpha = 0.5
    
    // Make a little space at top and bottom of the UIScrollView
    let edgeInsets = UIEdgeInsets(top: 30, left: 0, bottom: 30, right: 0)
    scrollView.contentInset = edgeInsets
    
    if isSegueFromPageDetailVC == true {
      saveButton.isHidden = true
      
      doneButton = UIBarButtonItem(
        barButtonSystemItem: .done,
        target: self,
        action: #selector(doneButtonTapped(_:))
      )
      self.navigationItem.setRightBarButton(doneButton, animated: true)
      
      albumTitle.text = receivedPage?.albumTitle
      pageTitle.text = receivedPage?.pageTitle
      dateField.text = receivedPage?.date.dateToString()
      locationField.text = receivedPage?.location
      bodyText.text = receivedPage?.bodyText
      saveButton.setTitle("Save this change", for: .normal)
      
      fetchImage()
    }
  }
  
  override func viewDidLayoutSubviews() {
    scrollView.flashScrollIndicators()
    
    setCollectionViewFlowLayout()
  }
  
  fileprivate func setCollectionViewFlowLayout() {
    let layout = UICollectionViewFlowLayout()
    layout.itemSize = CGSize(width: 120, height: 120)
    layout.minimumInteritemSpacing = 0
    layout.minimumLineSpacing = 10
    layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    layout.scrollDirection = .horizontal
    imageCollection.collectionViewLayout = layout
  }
  
  // Enable return key of UITextFields
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    albumTitle.resignFirstResponder()
    pageTitle.resignFirstResponder()
    locationField.resignFirstResponder()
    return true
  }
  
  // Placeholder for UITextView
  func textViewDidBeginEditing(_ textView: UITextView) {
    if bodyText.alpha == 0.5 {
      bodyText.text = nil
      bodyText.alpha = 1
    }
  }
  func textViewDidEndEditing(_ textView: UITextView) {
    if bodyText.text.isEmpty {
      bodyText.text = "Enter your text here."
      bodyText.alpha = 0.5
    }
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
    
    acController.tableCellBackgroundColor = AppColors.backgroundBrown.value
    acController.primaryTextColor = AppColors.textBrown.value
    acController.secondaryTextColor = AppColors.textBrown.value
    acController.primaryTextHighlightColor = AppColors.barBrown.value
    
    present(acController, animated: true, completion: nil)
  }
  
  // Show UIDatePicker when the dateField is tapped
  private let dateFormatter = DateFormatter()
  @IBAction func showDatePicker(_ sender: UITextField) {
    let datePicker = UIDatePicker()
    let defaultDate = Date()
    dateFormatter.dateFormat = "yyyy/MM/dd"
    dateField.text = dateFormatter.string(from: defaultDate)
    datePicker.datePickerMode = .date
    datePicker.addTarget(self, action: #selector(datePickerInput(_:)), for: UIControlEvents.valueChanged)
    sender.inputView = datePicker
  }
  
  // Get data from UIDatePicker
  @objc func datePickerInput(_ sender: UIDatePicker) {
    dateFormatter.dateFormat = "yyyy/MM/dd"
    selectedDate = sender.date
    dateField.text = dateFormatter.string(from: sender.date)
  }
  
  @objc func doneButtonTapped(_ sender: UIBarButtonItem) {
    if isPropertyEmpty() {
      let realm = try! Realm()
      let page = realm.object(ofType: Page.self, forPrimaryKey: receivedPage?.key)
      let receivedAlbum = realm.object(ofType: Album.self, forPrimaryKey: receivedPage?.whatAlbumToBelong)
      let receivedAlbumImages = receivedAlbum?.images
      
      try! realm.write {
        guard let newPage = page else { return }
        print(imageNames)
        newPage.albumTitle = albumTitle.text!
        newPage.pageTitle = pageTitle.text!
        newPage.date = selectedDate
        newPage.location = locationField.text!
        newPage.bodyText = bodyText.text
        newPage.images.removeAll()
        newPage.images.append(objectsIn: self.imageNames)
        
        guard let oldAlbum = receivedAlbum else { return }
        guard let oldAlbumImages = receivedAlbumImages else { return }
        
        if receivedAlbum?.albumTitle != newPage.albumTitle {
          let existingAlbum = realm.objects(Album.self).filter("albumTitle == '\(newPage.albumTitle)'")
          
          if existingAlbum.count == 0 {
            let album = Album(albumTitle: newPage.albumTitle, creationDate: newPage.date)
            album.pages.append(newPage)
            album.images.append(objectsIn: newPage.images)
            realm.add(newPage)
            realm.add(album)
            newPage.whatAlbumToBelong = album.key
          } else {
            existingAlbum.first?.pages.append(newPage)
            existingAlbum.first?.images.append(objectsIn: newPage.images)
            newPage.whatAlbumToBelong = existingAlbum.first!.key
          }
          
          let index = receivedAlbum?.pages.index(of: page!)
          receivedAlbum?.pages.remove(at: index!)
          
          for image in oldAlbumImages {
            for imageName in imageNames {
              if image == imageName {
                if let index = oldAlbumImages.index(of: image) {
                  oldAlbumImages.remove(at: index)
                }
              }
            }
          }
          imageNames.removeAll()
          if oldAlbum.pages.count == 0 {
            realm.delete(oldAlbum)
          }
        } else {
          // If there are any images which have the same name as imageName, remove the image from the Album images
          for image in oldAlbumImages {
            for imageName in imageNames {
              if image == imageName {
                if let index = oldAlbumImages.index(of: image) {
                  oldAlbumImages.remove(at: index)
                }
              }
            }
          }
          receivedAlbum?.images.append(objectsIn: self.imageNames)
        }
      }
      dismiss(animated: true, completion: nil)
    } else {
      displayEmptyFieldAlert()
    }
  }
  
  private func fetchImage() {
    let documentsURL = FileManager.documentDirectory
    
    for imagePath in (receivedPage?.images)! {
      imageNames.append(imagePath)
      let filePath = documentsURL.appendingPathComponent(imagePath).path
      self.selectedImage = UIImage(contentsOfFile: filePath)
      images.append(self.selectedImage!)
    }
  }
  
  @IBAction func saveButtonTapped(_ sender: UIButton) {
    if isPropertyEmpty() {
      let page = Page(
        albumTitle: self.albumTitle.text!,
        pageTitle: self.pageTitle.text!,
        date: self.selectedDate,
        location: self.locationField.text!,
        bodyText: self.bodyText.text!
      )
      page.images.append(objectsIn: imageNames)
      
      // Check to see if there is an Album which has the same name
      let realm = try! Realm()
      let existingAlbum = realm.objects(Album.self).filter("albumTitle == '\(page.albumTitle)'")
      
      if existingAlbum.count == 0 {
        let album = Album(albumTitle: page.albumTitle, creationDate: page.date)
        album.pages.append(page)
        album.images.append(objectsIn: page.images)
        try! realm.write {
          realm.add(page)
          realm.add(album)
          page.whatAlbumToBelong = album.key
        }
      } else {
        try! realm.write {
          existingAlbum.first?.pages.append(page)
          existingAlbum.first?.images.append(objectsIn: page.images)
          page.whatAlbumToBelong = existingAlbum.first!.key
        }
      }
      
      // Reset data
      resetFields()
      
      self.tabBarController?.selectedIndex = 0
    } else {
      displayEmptyFieldAlert()
    }
  }
  
  fileprivate func displayEmptyFieldAlert() {
    let alert = UIAlertController(
      title: NSLocalizedString("Required field is empty.", comment: ""),
      message: NSLocalizedString("Please fill out all the fields except for Location.", comment: ""),
      preferredStyle: .alert
    )
    let defaultAction = UIAlertAction(
      title: "OK",
      style: UIAlertActionStyle.default,
      handler: nil
    )
    alert.addAction(defaultAction)
    
    present(alert, animated: true, completion: nil)
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
    images.removeAll()
    selectedImage = nil
    selectedDate = Date()
    imageCollection.isHidden = true
    imageCollection.reloadData()
    let realm = try! Realm()
    try! realm.write {
      imageNames.removeAll()
    }
  }
}

extension CreateVC: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
  // Open up device's camera
  @IBAction func takePicture(_ sender: UIButton) {
    let imagePicker = UIImagePickerController()
    
    setImagePicker(imagePicker: imagePicker)
    if UIImagePickerController.isSourceTypeAvailable(.camera) {
      imagePicker.sourceType = .camera
    } else {
      imagePicker.sourceType = .photoLibrary
    }
    
    // Place image picker on the screen
    present(imagePicker, animated: true, completion: nil)
  }
  
  // Open up device's camera
  @IBAction func pickPicture(_ sender: UIButton) {
    let imagePicker = UIImagePickerController()
    
    setImagePicker(imagePicker: imagePicker)
    imagePicker.sourceType = .photoLibrary
    
    // Place image picker on the screen
    present(imagePicker, animated: true, completion: nil)
  }
  
  private func setImagePicker(imagePicker: UIImagePickerController) {
    imagePicker.delegate = self
    imagePicker.navigationBar.isTranslucent = false
    imagePicker.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white, NSAttributedStringKey.font: UIFont(name: "Futura-Medium", size: 22)]
    imagePicker.allowsEditing = true
  }
  
  @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
    
    // Get picked image from info directory
    let image = info[UIImagePickerControllerEditedImage] as! UIImage
    
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
    
    // Random file name for the image
    let fileName = UUID().uuidString + ".png"
    
    // Open FileManager
    let filemanager = FileManager.default
    let documentsURL = filemanager.urls(for: .documentDirectory, in: .userDomainMask).first!
    let documentPath = documentsURL.path
    let filePath = documentsURL.appendingPathComponent(fileName)
    
    do {
      imageData = UIImagePNGRepresentation(image)
      try imageData?.write(to: filePath, options: .atomic)
      try! imageNames.append(fileName)
    } catch {
      let alert = UIAlertController(
        title: NSLocalizedString("Something went wrong", comment: ""),
        message: NSLocalizedString("Couldn't write image", comment: ""),
        preferredStyle: .alert
      )
      
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
    
    // Delete file from the document directory
    let filemanager = FileManager.default
    let documentsURL = filemanager.urls(for: .documentDirectory, in: .userDomainMask).first!
    let documentPath = documentsURL.path
    let filePath = documentPath + "/" + imageNames[(index?.item)!]
    
    if filemanager.fileExists(atPath: filePath) {
      try! filemanager.removeItem(atPath: filePath)
    }
    
    images.remove(at: (index?.item)!)
    imageNames.remove(at: (index?.item)!)
    imageCollection.deleteItems(at: [index!])
    
    // if segue from PageDeatilVC, delete the picture from the Album
    if isSegueFromPageDetailVC == true {
      let realm = try! Realm()
      try! realm.write {
        receivedAlbum?.images.remove(at: (index?.item)!)
      }
    }
    
    // Hide collectionview when the cell count is 0
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
    // Handle the error.
    let alert = UIAlertController(
      title: NSLocalizedString("Something went wrong.", comment: ""),
      message: NSLocalizedString("Please make sure the internet connection.", comment: ""),
      preferredStyle: .alert
    )
    let defaultAction = UIAlertAction(
      title: "OK",
      style: UIAlertActionStyle.default,
      handler: nil
    )
    alert.addAction(defaultAction)
    present(alert, animated: true, completion: nil)
  }
  
  // User canceled the operation.
  func wasCancelled(_ viewController: GMSAutocompleteViewController) {
    dismiss(animated: true, completion: nil)
  }
  
}

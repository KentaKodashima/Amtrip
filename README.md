#  Amtrip
![iphonex_mockup](https://user-images.githubusercontent.com/18434054/45405276-105f8a80-b617-11e8-81b3-b1c8fe0be820.png)

## Overview
Amtrip is a simple traveler's journal app. 
Using this app, users can easily make records of their trips. 
This app is available on the [App Store](https://itunes.apple.com/ca/app/amtrip/id1416443046?mt=8).

## Architecture

![architecture](https://user-images.githubusercontent.com/18434054/45408602-b3b59d00-b621-11e8-8cf9-b7758a115226.png)

This app adopts the simple MVC design pattern. 

### Model
Provides data which is necessary to create UI. It also keeps traking of changes in data.

### View
Creates UI and sends user actions to ViewController.

### ViewControler
Processes data changes based on the user actions. Then receives the updated data from Model data and sends it back to View.

### Common
Extends built-in classes and provides helper functions to ViewControllers such as createToolbarForKeyboard(), setSearchBar(), dateToString() etc.

## Database
### Realm
I adopted Realm as the database becasue I felt more confortable when I handle database. There are two RealmObjects, Page and Album. Each object holds necessary properties to consist each page and album. Album object has the property called 'pages' to hold Page objects which belongs to the Album.

![class_map](https://user-images.githubusercontent.com/18434054/45408588-a1d3fa00-b621-11e8-80f2-0d48e88f2072.png)

Realm has a data limit of 16MB. Therefore these RealmObjects in my app holds just image data as a path in the form of String. When user uploads images, the images are copied to its file directory using FileManager. In order to re-create the images, ViewController converts image String paths into URL path, and then call the copied images in the file directory. 

## Library
- Realm
- Google Places Autocomplete API

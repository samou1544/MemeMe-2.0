//
//  ViewController.swift
//  MemeMe
//
//  Created by Asma  on 1/2/21.
//

import UIKit

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //MARK: IBOutlets

    @IBOutlet weak var topBar: UIToolbar!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var bottomBar: UIToolbar!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var albumButton: UIBarButtonItem!
        
    //defining text attributes for top and bottom textfields
    let memeTextAttributes: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.strokeColor: UIColor.black,
        NSAttributedString.Key.foregroundColor: UIColor.white,
        NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSAttributedString.Key.strokeWidth:  -5.0
    ]
    
    //delegate object for textFields
    let textDelegate=textFieldDelegate()
    
    //generated MemedImage
    var memedImage:UIImage!
    
    //sourceType for camera and album button as ENUM
    enum sourceType: Int {
        case camera = 0, album
    }
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //defining flexible space to adjust display of bar buttons in both top and bottom toolbars
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        topBar.setItems([shareButton,flexibleSpace, cancelButton], animated: false)
        bottomBar.setItems([flexibleSpace,cameraButton,flexibleSpace, albumButton,flexibleSpace], animated: false)
        
        //Preparing top and bottom textFields
        prepareTextFields(textFiled:topTextField,defaultText:"TOP")
        prepareTextFields(textFiled:bottomTextField,defaultText:"BOTTOM")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        //disabling camera button if no camera available on device
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        
        //disabling share button
        shareButton.isEnabled=false
        
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
        
    }
    
    //preparing the textFields
    func prepareTextFields(textFiled:UITextField, defaultText:String){
        textFiled.text=defaultText
        textFiled.defaultTextAttributes=memeTextAttributes
        textFiled.textAlignment  = .center
        textFiled.delegate=textDelegate
    }
    
    //MARK: Keyboard notification
    
    func subscribeToKeyboardNotifications() {
        //subscription to Keyboard will show event
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        //subscription to keyboard will hide event
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardDidHideNotification, object: nil)
    }

    func unsubscribeFromKeyboardNotifications() {

        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    //MARK: KeyBoard functions
    
    @objc func keyboardWillShow(_ notification:Notification) {
        //moving view up if bottomTextField is editing, no need to move it when topTextField is editing
        if bottomTextField.isEditing{
                self.view.window?.frame.origin.y = -1 * getKeyboardHeight(notification)
            }
        
    }

    @objc func keyboardWillHide(_ notification:Notification) {
        //move view back to its original place
        if self.view.window?.frame.origin.y != 0 {
                self.view.window?.frame.origin.y += getKeyboardHeight(notification)
            }
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {

        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }

    
    //MARK: IBActions
    
    //Selecting image from album or camera
    @IBAction func selectImage(_ sender: UIBarButtonItem) {
        
        let pickerController = UIImagePickerController()
        pickerController.delegate=self
        switch(sourceType(rawValue: sender.tag)!) {
            case .camera:
                pickerController.sourceType = .camera
            case .album:
                pickerController.sourceType = .photoLibrary
            }
        
        present(pickerController, animated: true, completion: nil)

    }
    
    //sharing created meme
    @IBAction func shareMeme(_ sender: Any) {
        //generating memedImage and storing it in memedImage variable
        memedImage=generateMemedImage()
        //creating activityViewController to share the memedImage
        let shareMemeController=UIActivityViewController(activityItems: [memedImage!], applicationActivities:nil)
        present(shareMemeController, animated: true, completion: nil)
        shareMemeController.completionWithItemsHandler={activity, success, items, error in
            if(success){
                self.save()
            }
    }
    }
    
    //MARK: Cancelling
    @IBAction func cancelMeme(_ sender: Any) {
        //resetting textFileds to default values
        topTextField.text="TOP"
        bottomTextField.text="BOTTOM"
        //removing image from imageView
        imageView.image=nil
        //disabling share button
        shareButton.isEnabled=false
        
        //dismissing
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: Delegate for imagePickerController
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        //user cancelled imagePicker
        dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                    imageView.image = image
            shareButton.isEnabled=true
                }
        dismiss(animated: true, completion: nil)
    }
    
    
    //MARK: Generating Memed Image
    func generateMemedImage() -> UIImage {
        //hiding top and bottom bar so they don't show in the generated meme Image
        topBar.isHidden=true
        bottomBar.isHidden=true
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        //show top and bottom bar after done rendering the view
        topBar.isHidden=false
        bottomBar.isHidden=false

        return memedImage
    }
    
    //MARK: Saving Meme
    func save() {
        // Create the meme object
        let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: imageView.image!, memedImage: memedImage!)
        // Add it to the memes array in the Application Delegate
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.memes.append(meme)
        dismiss(animated: true, completion: nil)
    }
    
    
    
}


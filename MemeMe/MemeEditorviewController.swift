//
//  ViewController.swift
//  MemeMe
//
//  Created by Pablo Arguimbau on 06/04/2021.
//

import UIKit

class MemeEditorviewController: UIViewController , UIImagePickerControllerDelegate,
                                UINavigationControllerDelegate, UITextFieldDelegate{
    
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    let TOP_TEXT = "TOP"
    let BOTTOM_TEXT = "BOTTOM"
    var meme : Meme!
    var memedImage:UIImage!
    let memeDelegateTop  = TopMemeTextFieldDelegate()
    let memeDelegateBottom  = BottomMemeTextFieldDelegate()
    let memeTextAttributes: [NSAttributedString.Key: Any] = [
        .strokeColor: UIColor.black,
        .foregroundColor: UIColor.white ,
        .font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        .strokeWidth: -3 ,
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTextField(topTextField,text: TOP_TEXT,delegate: memeDelegateTop)
        setupTextField(bottomTextField,text: BOTTOM_TEXT,delegate: memeDelegateBottom)
        setDefaultValues()
    }
    
    func setupTextField(_ textField: UITextField, text: String, delegate: UITextFieldDelegate ) {
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = .center
        textField.delegate = delegate
        textField.autocorrectionType = .no
        textField.text = text
    }
    
    func setDefaultValues () {
        memedImage = nil
        imagePickerView.image = nil
        meme = nil
        shareButton.isEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    @IBAction func cancel(_ sender: Any) {
        setDefaultValues()
    }
    
    func presentPickerViewController (source : UIImagePickerController.SourceType) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = source
        present(pickerController, animated: true, completion: nil)
        
    }
    
    @IBAction func pickAnImage(_ sender: UIBarButtonItem) {
        presentPickerViewController(source: .photoLibrary)
    }
    
    @IBAction func pickAnImageFromCamera(_ sender: Any) {
        presentPickerViewController(source: .camera)
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            shareButton.isEnabled = true
            imagePickerView.image = image
            imagePickerView.contentMode = .scaleAspectFit
        }
        dismiss(animated: false, completion: nil)
    }
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification:Notification) {
        if bottomTextField.isEditing {
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    @objc func keyboardWillHide(_ notification:Notification) {
        if bottomTextField.isEditing {
            view.frame.origin.y += getKeyboardHeight(notification)
        }
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    func save() {
        // Create the meme
        meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: imagePickerView.image!, memedImage: memedImage)
    }
    
    @IBAction func share(_ sender: UIBarButtonItem) {
        let memeImage = generateMemedImage()
        let items = [memeImage]
        let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
        ac.completionWithItemsHandler = {
            (activity, completed, items, error) in
            if completed {
                self.save()
            }
        }
        present(ac, animated: true)
        
    }
    
    func hideBars() {
        navBar.isHidden = true
        toolBar.isHidden = true
        
    }
    func showBars() {
        navBar.isHidden = false
        toolBar.isHidden = false
    }
    
    func generateMemedImage() -> UIImage {
        // Hide toolbar and navbar
        hideBars()
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        memedImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        //Show toolbar and navbar
        showBars()
        return memedImage
    }
    
}


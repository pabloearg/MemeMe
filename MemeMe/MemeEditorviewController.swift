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
    
    let TOP_TEXT = "TOP"
    let BOTTOM_TEXT = "BOTTOM"
    var meme : Meme!
    var memedImage:UIImage!
    let memeDelegateTop  = TopMemeTextFieldDelegate()
    let memeDelegateBottom  = BottomMemeTextFieldDelegate()
    let memeTextAttributes: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.strokeColor: UIColor.black /* TODO: fill in appropriate UIColor */,
        NSAttributedString.Key.foregroundColor: UIColor.white /* TODO: fill in appropriate UIColor */,
        NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSAttributedString.Key.strokeWidth: -1 /* TODO: fill in appropriate Float */,
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        topTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.textAlignment = .center
        topTextField.textAlignment = .center
        topTextField.delegate = memeDelegateTop
        bottomTextField.delegate = memeDelegateBottom
        bottomTextField.autocorrectionType = .no
        topTextField.autocorrectionType = .no
        setDefaultValues()
    }
    
    func setDefaultValues () {
        topTextField.text = TOP_TEXT
        bottomTextField.text = BOTTOM_TEXT
        memedImage = nil
        imagePickerView.image = nil
        meme = nil
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
    
    @IBAction func pickAnImage(_ sender: UIBarButtonItem) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .photoLibrary
        present(pickerController, animated: true, completion: nil)
    }
    
    @IBAction func pickAnImageFromCamera(_ sender: Any) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .camera
        present(pickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[.originalImage] as? UIImage {
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
        present(ac, animated: true)
        
    }
    func generateMemedImage() -> UIImage {
        save()
        // Hide toolbar and navbar
        navBar.isHidden = true
        toolBar.isHidden = true
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        memedImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        //Show toolbar and navbar
        navBar.isHidden = false
        toolBar.isHidden = false
        return memedImage
    }
    
}


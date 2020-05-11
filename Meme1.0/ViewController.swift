//
//  ViewController.swift
//  Meme1.0
//
//  Created by Emad Albarnawi on 10/05/2020.
//  Copyright © 2020 Emad Albarnawi. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: Outlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var actionBarButton: UIBarButtonItem!
    @IBOutlet weak var cancelBarButton: UIBarButtonItem!
    @IBOutlet weak var topToolBar: UIToolbar!
    @IBOutlet weak var bottomToolBar: UIToolbar!
    
    // MARK: Text field deleget
    let textFieldDeleget = TextFieldDeleget();
    
    // Variable to set the attributes of the topTextField and bottomTextField outlets
    let memeTextAttributes: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.strokeColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1),
        NSAttributedString.Key.foregroundColor: UIColor.white,
        NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSAttributedString.Key.strokeWidth:  -4.0
    ];
    
    // MARK: View did load
    override func viewDidLoad() {
        
    }
    // MARK: View will appear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        topTextField.defaultTextAttributes = memeTextAttributes;
        topTextField.textAlignment = .center;
        bottomTextField.defaultTextAttributes = memeTextAttributes;
        bottomTextField.textAlignment = .center;
        
        // Subscribing to get keyboard notifications
        subscribeToKeyboardNotifications();
        
        // Making bar buttons disabled.
        
        toggleAny(actionBarButton ?? "");
        toggleAny(cancelBarButton ?? "");
        
    }
    // MARK: View will disappear
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated);
        
        // Unsubscribe from receiving keyboard notifications
        unsubscribeFromKeyboardNotifications()
    }
    
    // MARK: Album button
    @IBAction func albumButtonClicked(_ sender: Any) {
        setDeleget(withSourceType: .photoLibrary);
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        dismiss(animated: true, completion: nil);
        print("After dismiss");
        guard (info[.originalImage] as? UIImage) != nil else {
            print("No image found")
            return
        }
        imageView.image = (info[.originalImage] as! UIImage);
        toggleAny(actionBarButton ?? "");
        toggleAny(cancelBarButton ?? "");
    }
    // MARK: Camera button
    @IBAction func cameraButtonClicked(_ sender: Any) {
        setDeleget(withSourceType: .camera);
    }
    // Refactor: common functionality between album and camera buttons
    func setDeleget(withSourceType type: UIImagePickerController.SourceType) {
        
        // MARK: Image picker controller
        let imagePicker = UIImagePickerController();
        
        imagePicker.delegate = self;
        imagePicker.sourceType = type;
        imagePicker.allowsEditing = true;
        present(imagePicker, animated: true, completion: nil);
    }
    //    MARK: Setting up the deleget for the text fields
    @IBAction func textFieldClicked(_ sender: Any) {
        topTextField.delegate = textFieldDeleget;
        bottomTextField.delegate = textFieldDeleget;
    }
    // MARK: Action button
    @IBAction func ActionBarButtonClicked(_ sender: Any) {
        let activityController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil);
        activityController.completionWithItemsHandler = { (type,completed,items,error) in
            self.save();
        }
        present(activityController, animated: true, completion: nil);
        
    }
    // MARK: Cancel button
    @IBAction func CancelBarButtonClicked(_ sender: Any) {
        resetView();
    }
}

// MARK: Keyboard management
extension ViewController {
    
    func subscribeToKeyboardNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil);
    }
    
    func unsubscribeFromKeyboardNotifications() {
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil);
    }
    
    @objc func keyboardWillHide(_ notification: Notification){
        if bottomTextField.isEditing {
            view.frame.origin.y = 0
        }
    }
    
    @objc func keyboardWillShow(_ notification:Notification) {
        
        if bottomTextField.isEditing {
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
        
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
}

// MARK: Image management and savings
extension ViewController {
    
    struct Meme {
        var topText: String;
        var bottomText: String;
        var originalImage: UIImage;
        var memedImage: UIImage;
        
    }
    
    var memedImage: UIImage {
        
        // TODO: Hide toolbar and navbar
        toggleAny(topToolBar ?? "");
        toggleAny(bottomToolBar ?? "");
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        // TODO: Show toolbar and navbar
        toggleAny(topToolBar ?? "");
        toggleAny(bottomToolBar ?? "");
        
        return memedImage
    }
    
    func save() {
        // Create the meme
        let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: imageView.image!, memedImage: memedImage);
    }
    
    func resetView(){
        imageView.image = nil;
        topTextField.text = "Top";
        bottomTextField.text = "BOTTOM";
        
        toggleAny(actionBarButton ?? "");
        toggleAny(cancelBarButton ?? "");
        
    }
    func toggleAny(_ sender: Any){
        if let button = sender as? UIBarButtonItem {
            button.isEnabled  = !button.isEnabled;
        } else if let toolBar = sender as? UIToolbar {
            toolBar.isHidden = !toolBar.isHidden;
        }
        
    }
}


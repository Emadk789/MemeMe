//
//  ViewController.swift
//  Meme1.0
//
//  Created by Emad Albarnawi on 10/05/2020.
//  Copyright © 2020 Emad Albarnawi. All rights reserved.
//

import UIKit

class MemeMeController: UIViewController {
    
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
        .strokeColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1),
        .foregroundColor: UIColor.white,
        .font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        .strokeWidth:  -4.0
    ];
    
    // MARK: View did load
    override func viewDidLoad() {
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera);
        
        configureMemeTextField(topTextField);
        configureMemeTextField(bottomTextField);
        
        // Making bar buttons disabled.
        enableToolbarButtons(false);
        
    }
    // MARK: View will appear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);

        // Subscribing to get keyboard notifications
        subscribeToKeyboardNotifications();
        
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
    
    // MARK: Camera button
    @IBAction func cameraButtonClicked(_ sender: Any) {
        setDeleget(withSourceType: .camera);
    }
    
    // MARK: Action button
    @IBAction func actionBarButtonClicked(_ sender: Any) {
        let activityController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil);
        activityController.completionWithItemsHandler = { (type,completed,items,error) in
            if(completed){
                self.save();
            }
        }
        present(activityController, animated: true, completion: nil);
        
    }
    // MARK: Cancel button
    @IBAction func cancelBarButtonClicked(_ sender: Any) {
        resetView();
    }
}
    // MARK: MemeMeController: UIImagePickerControllerDelegate, UINavigationControllerDelegate
extension MemeMeController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // Refactor: common functionality between album and camera buttons
    func setDeleget(withSourceType type: UIImagePickerController.SourceType) {
        
        // MARK: Image picker controller
        let imagePicker = UIImagePickerController();
        
        imagePicker.delegate = self;
        imagePicker.sourceType = type;
        imagePicker.allowsEditing = true;
        present(imagePicker, animated: true, completion: nil);
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        dismiss(animated: true, completion: nil);
        print("After dismiss");
        guard (info[.originalImage] as? UIImage) != nil else {
            print("No image found")
            return
        }
        imageView.image = (info[.originalImage] as! UIImage);
        enableToolbarButtons(true);
    }
    
}
// MARK: Keyboard management
extension MemeMeController {
    
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
extension MemeMeController {
    
    var memedImage: UIImage {
        
        // TODO: Hide toolbar and navbar
        hideToolbars(true);
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        // TODO: Show toolbar and navbar
        hideToolbars(false);
        
        return memedImage
    }
    
    func save() {
        // Create the memes
        let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: imageView.image!, memedImage: memedImage);
    }
    
    func resetView(){
        imageView.image = nil;
        topTextField.text = "Top";
        bottomTextField.text = "BOTTOM";
        
        enableToolbarButtons(false)
        
    }
    func hideToolbars(_ hide: Bool) {
        topToolBar.isHidden = hide;
        bottomToolBar.isHidden = hide;
    }
    func enableToolbarButtons(_ enable: Bool) {
        actionBarButton.isEnabled = enable;
        cancelBarButton.isEnabled = enable;
    }
}


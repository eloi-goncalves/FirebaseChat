//
//  Login.swift
//  Chat
//
//  Created by Eloi Andre Goncalves on 13/03/17.
//  Copyright © 2017 Eloi Andre Goncalves. All rights reserved.
//

import UIKit
import Firebase

class Login: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate,UITextFieldDelegate {
    
    var messagesController : MessagesController?

    var heightInputsAnchor : NSLayoutConstraint?
    var heightNameInputTextAnchor : NSLayoutConstraint?
    var heightPasswordTextAnchor: NSLayoutConstraint?
    var heightEmailTextAnchor: NSLayoutConstraint?
    
    let inputsContainer : UIView = {
        let view  = UIView()
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 5
        return view
    }()
    
    let loginRegisterButton : UIButton = {
        let button =  UIButton(type: .system)
        button.backgroundColor = UIColor(r: 80, g: 101, b: 161)
        button.setTitle("Register", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.masksToBounds = false
        button.layer.cornerRadius = 5
        
        button.addTarget(self, action: #selector(handleLoginOrRegister), for: UIControlEvents.allEvents)
        return button
    }()
    
    let textFieldName : UITextField = {
        let name = UITextField()
        name.placeholder = "Name"
        name.translatesAutoresizingMaskIntoConstraints = false
        name.autocorrectionType = UITextAutocorrectionType.no
        name.borderStyle = .none
        name.autocapitalizationType = UITextAutocapitalizationType.none
        name.layer.backgroundColor = UIColor.white.cgColor
        name.layer.masksToBounds = false
        name.layer.shadowColor = UIColor(r: 220, g: 220, b: 220).cgColor
        name.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        name.layer.shadowOpacity = 1.0
        name.layer.shadowRadius = 0.0
        
        name.keyboardType = UIKeyboardType.alphabet
        name.returnKeyType = UIReturnKeyType.continue
        
        return name
    }()
    
    let textFieldEmailAddress : UITextField = {
        let email = UITextField()
        email.placeholder = "Email Address"
        email.autocorrectionType = UITextAutocorrectionType.no
        email.translatesAutoresizingMaskIntoConstraints = false
        email.autocapitalizationType = UITextAutocapitalizationType.none
        
        
        email.borderStyle = .none
        email.layer.backgroundColor = UIColor.white.cgColor
        email.layer.masksToBounds = false
        email.layer.shadowColor = UIColor(r: 220, g: 220, b: 220).cgColor
        email.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        email.layer.shadowOpacity = 1.0
        email.layer.shadowRadius = 0.0
        
        email.keyboardType = UIKeyboardType.emailAddress
        email.returnKeyType = UIReturnKeyType.continue
        
        return email
    }()
    
    let textFieldPassword : UITextField = {
        let password = UITextField()
        password.placeholder = "Password"
        password.isSecureTextEntry = true
        password.translatesAutoresizingMaskIntoConstraints = false
        password.borderStyle = .none
        password.layer.backgroundColor = UIColor.white.cgColor
        password.layer.masksToBounds = false
        password.layer.shadowColor = UIColor(r: 220, g: 220, b: 220).cgColor
        password.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        password.layer.shadowOpacity = 1.0
        password.layer.shadowRadius = 0.0
        
        password.returnKeyType = UIReturnKeyType.continue
        
        return password
    }()
    
    let loginRegisterSeguement : UISegmentedControl = {
         let sc  = UISegmentedControl(items: ["Login", "Register"])
        sc.tintColor = UIColor.white
        sc.selectedSegmentIndex = 1
        sc.translatesAutoresizingMaskIntoConstraints  = false
        sc.addTarget(self, action: #selector(handleLoginRegisterSegmentControl), for: UIControlEvents.valueChanged)
        return sc
    }()
    
    let photoLogin : UIImageView = {
        
        let photo = UIImageView(image: UIImage(named: "photo"))
        photo.sizeToFit()
        photo.translatesAutoresizingMaskIntoConstraints = false

        return photo
    }()

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if  textFieldName == textField {
            textFieldName.resignFirstResponder()
            textFieldEmailAddress.becomeFirstResponder()
        } else if textFieldEmailAddress == textField {
            textFieldEmailAddress.resignFirstResponder()
            textFieldPassword.becomeFirstResponder()
        } else if textFieldPassword == textField {
            textFieldPassword.resignFirstResponder()
        }
        
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor(r: 61, g: 91, b: 151)
        setupInputsView()
        setupLoginRegisterButton()
        setupLoginRegisterSegment()
        setupPhotoLogin()
        
        textFieldName.delegate = self
        textFieldPassword.delegate = self
        textFieldEmailAddress.delegate = self
      
    }
    
    func handleSelectUserPhoto(){
        
        let picker = UIImagePickerController()
        picker.sourceType  = .photoLibrary
        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        picker.modalPresentationStyle = .popover
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
        
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var selectedImage : UIImage!
        
        if let editedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            selectedImage = editedImage
        } else {
            let originalImage = info[UIImagePickerControllerOriginalImage] as! UIImage
            selectedImage = originalImage
        }
        
        if let chooseImage = selectedImage {
            photoLogin.image = chooseImage
        }

        photoLogin.contentMode = .scaleToFill
        dismiss(animated: true, completion: nil)
        
    }
    
    func handleLoginRegisterSegmentControl(){
        let title = loginRegisterSeguement.titleForSegment(at: loginRegisterSeguement.selectedSegmentIndex)
        
        loginRegisterButton.setTitle(title, for: UIControlState.normal)
        
        //Change height of loginContainer
        
        heightInputsAnchor?.constant = loginRegisterSeguement.selectedSegmentIndex == 0 ? 100 : 150
        
        //Change height of TextFieldName
        heightNameInputTextAnchor?.isActive = false
        heightNameInputTextAnchor =  textFieldName.heightAnchor.constraint(equalTo: inputsContainer.heightAnchor, multiplier: loginRegisterSeguement.selectedSegmentIndex == 0 ? 0 : 1/3)
        heightNameInputTextAnchor?.isActive = true
        
        //Change height of TextFieldPassword
        heightPasswordTextAnchor?.isActive = false
        heightPasswordTextAnchor =  textFieldPassword.heightAnchor.constraint(equalTo: inputsContainer.heightAnchor, multiplier: loginRegisterSeguement.selectedSegmentIndex == 0 ? 1/2 : 1/3)
        heightPasswordTextAnchor?.isActive = true
        
        //Change height of TextFieldEmail
        heightEmailTextAnchor?.isActive = false
        heightEmailTextAnchor =  textFieldEmailAddress.heightAnchor.constraint(equalTo: inputsContainer.heightAnchor, multiplier: loginRegisterSeguement.selectedSegmentIndex == 0 ? 1/2 : 1/3)
        heightEmailTextAnchor?.isActive = true
    }
    
    func handleLoginOrRegister(){
        if loginRegisterSeguement.selectedSegmentIndex == 0 {
            handleLogin()
        } else {
            handleRegister()
        }
    }
    
    func handleLogin(){
        
        guard let email = textFieldEmailAddress.text, let password = textFieldPassword.text else{
                return
        }
        
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
            if  error != nil {
                
                let alert = UIAlertController(title: "Alert", message: error?.localizedDescription as! String?, preferredStyle: UIAlertControllerStyle.alert)
                
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler:nil))
                 
                self.present(alert, animated: true, completion: nil)
                
            } else {
                
                self.messagesController?.fetchUserAndSetNavBarTitle()
                
                self.dismiss(animated: true, completion: nil)
            }
        })
    
    }
    
    func handleRegister(){
        
        guard let email = textFieldEmailAddress.text, let password = textFieldPassword.text,
        let name = textFieldName.text else{
            return
        }
        
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user: FIRUser?, error : Error?) in
            
            if error != nil {
                print(error)
                return
            }
            
            guard let uid = user?.uid else {
                return
            }
            
            //storage Reference to insert image
            
            let imageUserName = NSUUID().uuidString
            
            let storageRef = FIRStorage.storage().reference().child("\(imageUserName).png")

            //Compressed image in order to fast upload and download images.
            
            if let profileImage = self.photoLogin.image, let uploadData = UIImageJPEGRepresentation(profileImage, 0.1){
            //if let uploadData = UIImageJPEGRepresentation(self.photoLogin.image!, 0.1){
                
           //if let uploadData =  UIImagePNGRepresentation(self.photoLogin.image!) {
                storageRef.put(uploadData, metadata: nil, completion: { (metadata, error) in
            
                if error != nil {
                        print(error)
                        return
                }
                    if  let userPhoto = metadata?.downloadURL()?.absoluteString {
                        
                        let values = ["name": name, "email": email, "photo": userPhoto]
                        
                        self.registerUserIntoDataBaseWithUid(uid: uid, values: values as [String : AnyObject])
                    }
                })
            }
            

        })
    }
    
    private func registerUserIntoDataBaseWithUid(uid : String, values : [String:AnyObject]){
    
        //successfully authentication
        let dataBaseRef = FIRDatabase.database().reference(fromURL: "https://loginchatfirebase-62af3.firebaseio.com/")
        
        let userReference  = dataBaseRef.child("users").child(uid)

        userReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
            if  err != nil {
                print(err)
                return
            }
            
            self.messagesController?.fetchUserAndSetNavBarTitle()
            
            print("Saved user successfuly into  Firebase")
            self.dismiss(animated: true, completion: nil)
        })
        
    }
    
    
    func setupInputsView(){
        self.view.addSubview(inputsContainer)
        inputsContainer.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        inputsContainer.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        inputsContainer.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -24).isActive = true
        heightInputsAnchor  = inputsContainer.heightAnchor.constraint(equalToConstant: 150)
        
        heightInputsAnchor?.isActive = true
        
        
        //Insert textFieldName 
        
        inputsContainer.addSubview(textFieldName)
        
        textFieldName.leftAnchor.constraint(equalTo: inputsContainer.leftAnchor, constant: 12).isActive = true
        textFieldName.topAnchor.constraint(equalTo: inputsContainer.topAnchor, constant: 0).isActive = true
        textFieldName.widthAnchor.constraint(equalTo: inputsContainer.widthAnchor, constant : -24).isActive = true
        
         heightNameInputTextAnchor =  textFieldName.heightAnchor.constraint(equalTo: inputsContainer.heightAnchor, multiplier: 1/3)
            
         heightNameInputTextAnchor?.isActive = true
        
        //Insert Email Address
        inputsContainer.addSubview(textFieldEmailAddress)
        
        textFieldEmailAddress.leftAnchor.constraint(equalTo: textFieldName.leftAnchor).isActive = true
        textFieldEmailAddress.topAnchor.constraint(equalTo: textFieldName.bottomAnchor, constant : 1).isActive = true
        textFieldEmailAddress.widthAnchor.constraint(equalTo: textFieldName.widthAnchor).isActive = true
        
        heightEmailTextAnchor = textFieldEmailAddress.heightAnchor.constraint(equalTo: textFieldName.heightAnchor)
            
        heightEmailTextAnchor?.isActive = true
        
        //Insert Password
        inputsContainer.addSubview(textFieldPassword)
        
        textFieldPassword.leftAnchor.constraint(equalTo: textFieldName.leftAnchor).isActive = true
        textFieldPassword.topAnchor.constraint(equalTo: textFieldEmailAddress.bottomAnchor, constant : 1).isActive = true
        textFieldPassword.widthAnchor.constraint(equalTo: textFieldName.widthAnchor).isActive = true
        
        heightPasswordTextAnchor = textFieldPassword.heightAnchor.constraint(equalTo: textFieldName.heightAnchor)
            
        heightPasswordTextAnchor?.isActive = true
        
        
    }
    
    func setupLoginRegisterButton() {
        self.view.addSubview(loginRegisterButton)
        loginRegisterButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        loginRegisterButton.topAnchor.constraint(equalTo: inputsContainer.bottomAnchor, constant: 12).isActive = true
        loginRegisterButton.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -24).isActive = true
        loginRegisterButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        
    }
    
    func setupLoginRegisterSegment() {
        self.view.addSubview(loginRegisterSeguement)
        
        loginRegisterSeguement.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        loginRegisterSeguement.bottomAnchor.constraint(equalTo: inputsContainer.topAnchor, constant: -12).isActive = true
        
        loginRegisterSeguement.widthAnchor.constraint(equalTo: inputsContainer.widthAnchor).isActive = true
        loginRegisterSeguement.heightAnchor.constraint(equalToConstant: 30).isActive = true
    
    }
    
    func setupPhotoLogin(){
        self.view.addSubview(photoLogin)
        photoLogin.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        photoLogin.bottomAnchor.constraint(lessThanOrEqualTo: loginRegisterSeguement.topAnchor, constant: -12).isActive = true
        photoLogin.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 60).isActive = true
        photoLogin.widthAnchor.constraint(equalTo: loginRegisterSeguement.widthAnchor, multiplier: 0.4).isActive = true
        

        
        photoLogin.layer.masksToBounds = true
        photoLogin.layer.cornerRadius = 5
        photoLogin.layer.borderColor = UIColor.white.cgColor
        photoLogin.layer.borderWidth = 1

        
        photoLogin.isUserInteractionEnabled = true
        photoLogin.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectUserPhoto)))
        
    }



}

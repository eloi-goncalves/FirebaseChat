//
//  ViewController.swift
//  Chat
//
//  Created by Eloi Andre Goncalves on 13/03/17.
//  Copyright © 2017 Eloi Andre Goncalves. All rights reserved.
//

import UIKit
import Firebase

class MessagesController: UITableViewController{

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(self.handleLogout))
        
        let imageButton = UIImage(named: "ic_border_color")
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: imageButton , style: .plain, target: self, action: #selector(handleNewMessage))
    
        checkIfUserIsLogged()
    }
    
    func handleNewMessage(){
        let newMessageController = NewMessages()
        
        let navMessageController = UINavigationController(rootViewController: newMessageController)
        present(navMessageController, animated: true, completion: nil)
    }
    
    
    func checkIfUserIsLogged(){
        if FIRAuth.auth()?.currentUser?.uid == nil {
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
        } else {
         fetchUserAndSetNavBarTitle()
        }
    }
    
    func fetchUserAndSetNavBarTitle(){
     
        guard let uid = FIRAuth.auth()?.currentUser?.uid else {
            //for some reason uid is null
            return
        }
        
        DispatchQueue.main.async {
            
        FIRDatabase.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
                
                if let dic = snapshot.value as? [String:AnyObject] {
                    
                    let user = Users(parameters: dic)
                    
                    self.setupNavBarWithUser(user: user)
                    
                }
                
            }, withCancel: nil)
        }
        
    }
    
    func setupNavBarWithUser(user: Users) {
        let titleView = UIView(frame: CGRect(x: 0, y: 0, width: 150, height: 40))
//        titleView.backgroundColor = UIColor.red
        
        //Third View (Container View to work with constraints em center of navBar
        
        let containerView = UIView()
        titleView.addSubview(containerView)
        
        let userPhotoLogin : UIImageView = {
            let  imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
            
            imageView.layer.masksToBounds = true
            imageView.layer.cornerRadius = 20
            return imageView
        }()
        
        let nameUser : UILabel = {
            let label = UILabel(frame: CGRect(x: 40, y: 0, width: 120, height: 30))
            return label
        }()
        
        
        if let userImage = user.photo {
            userPhotoLogin.loadImageUsingCacheWithUrlString(urlString: userImage)
            containerView.addSubview(userPhotoLogin)
            
            userPhotoLogin.translatesAutoresizingMaskIntoConstraints = false
            userPhotoLogin.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
            userPhotoLogin.widthAnchor.constraint(equalToConstant: 40).isActive = true
            userPhotoLogin.heightAnchor.constraint(equalToConstant: 40).isActive = true
            userPhotoLogin.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        
        }
        
        if let name = user.name {
            nameUser.text  = name
            nameUser.font = UIFont.systemFont(ofSize: 14, weight: UIFontWeightMedium)
            containerView.addSubview(nameUser)
            nameUser.translatesAutoresizingMaskIntoConstraints = false
            nameUser.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
            nameUser.leftAnchor.constraint(equalTo: userPhotoLogin.rightAnchor, constant: 8).isActive = true
            nameUser.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        }
        
        self.navigationItem.titleView =  titleView
        
        
        //Centering the container view into titleView
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.centerXAnchor.constraint(equalTo: titleView.centerXAnchor).isActive = true
        containerView.centerYAnchor.constraint(equalTo: titleView.centerYAnchor).isActive = true
    }
    
    func handleLogout(){
        
        do {
            try FIRAuth.auth()?.signOut()
        } catch  let logoutError{
                print(logoutError)
        }
        
        let loginController = Login()
        
        loginController.messagesController = self
        present(loginController, animated: true, completion: nil)
    }

    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
        
    }
    
}

extension UIColor {

    convenience init(r : CGFloat, g : CGFloat, b : CGFloat){
        self.init(red : r/255, green : g/255,  blue: b/255 , alpha: 1)
    }
}


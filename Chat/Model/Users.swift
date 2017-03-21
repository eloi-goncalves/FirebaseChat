//
//  Users.swift
//  Chat
//
//  Created by Eloi Andre Goncalves on 16/03/17.
//  Copyright © 2017 Eloi Andre Goncalves. All rights reserved.
//

import UIKit

class Users: NSObject {
    
    var email : String!
    var name : String!
    var photo : String!
    
    init(parameters : [String:AnyObject]) {
        super.init()
        
        self.setValuesForKeys(parameters)
    }
    
    init(name : String, email : String){
        self.name = name
        self.email = email
    }

}

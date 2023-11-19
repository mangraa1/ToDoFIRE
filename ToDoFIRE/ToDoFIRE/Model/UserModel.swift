//
//  UserModel.swift
//  ToDoFIRE
//
//  Created by mac on 19.11.2023.
//

import Foundation
import Firebase


struct UserModel {
    let uid: String
    let email: String

    
    init(user: User) {
        self.uid = user.uid
        self.email = user.email!
    }
}

//
//  DataModel.swift
//  SQLite3
//
//  Created by Davin Henrik on 10/31/21.
//

import UIKit

class ClientData {
    var username : String = ""
    var age : Int = 0
    var id : Int = 0
    
    init (id: Int, username: String, age: Int){
        self.id = id
        self.username = username
        self.age = age
    }
}


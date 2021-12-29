//
//  Model.swift
//  Rasha-D
//
//  Created by rasha  on 16/05/1443 AH.
//

import Foundation
struct Item {
    var description : String?
    var city : String?
    var title : String?
    var imageUrl : String?
    var date : String?
    var username : String?
    var userID : String?
    var timestamp : TimeInterval?
}

struct Message {
    var sender : String?
    var reciever : String?
    var message : String?
    var date : String?
    var timestamp : TimeInterval?
    var time : String?
}

struct ChatUser {
    var name : String?
    var id : String?
}

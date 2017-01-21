//
//  Event.swift
//  gitap
//
//  Created by Koichi Sato on 1/21/17.
//  Copyright © 2017 Koichi Sato. All rights reserved.
//

import Foundation

class Event: NSObject, ResultProtocol {
    var id: String?
    var type: String?
    var isPublic: Bool?
//    var payload: Payload?
    var repo: Repo?
    var actor: User?
//    var org: Organization?
    var created_at: Date?
    required init?(json: [String: Any]) {
        self.id = json["id"] as? String
        self.type = json["type"] as? String
        self.isPublic = json["public"] as? Bool
//        self.payload = json["payload"] as? Payload
        if let dataDictionary = json["repo"] as? [String: Any] {
            self.repo = Repo(json: dataDictionary)
        }
        if let dataDictionary = json["actor"] as? [String: Any] {
            self.actor = User(json: dataDictionary)
        }
//        self.org = json["org"] as? Organization
        
        let dateFormatter = Utils.dateFormatter()
        if let dateString = json["created_at"] as? String {
            self.created_at = dateFormatter.date(from: dateString)
        }
    
    }
}

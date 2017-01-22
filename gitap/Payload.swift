//
//  Payload.swift
//  gitap
//
//  Created by Koichi Sato on 1/22/17.
//  Copyright © 2017 Koichi Sato. All rights reserved.
//

import Foundation
class Payload: NSObject, ResultProtocol {
    var action: String?
    var issue: Issue?
    var changes: Dictionary<String, Any>?
    var changesTitleFrom: String?
    var changesBodyFrom: String?
    var assignee: User?
    //    var label: Label?
    
    required init?(json: [String: Any]) {
        self.action = json["action"] as? String
        if let dataDictionary = json["issue"] as? [String: Any] {
            self.issue = Issue(json: dataDictionary)
        }
        self.changes = json["changes"] as? Dictionary
        self.changesTitleFrom = json["changes[title][from]"] as? String
        self.changesBodyFrom = json["changes[body][from]"] as? String
        if let dataDictionary = json["assignee"] as? [String: Any] {
            self.assignee = User(json: dataDictionary)
        }
//        self.label = Label(json: dataDictionary)
    }
}


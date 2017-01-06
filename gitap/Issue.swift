//
//  Issue.swift
//  gitap
//
//  Created by Koichi Sato on 1/4/17.
//  Copyright © 2017 Koichi Sato. All rights reserved.
//

import Foundation
/*
[
    {
        "id": 1,
        "url": "https://api.github.com/repos/octocat/Hello-World/issues/1347",
        "repository_url": "https://api.github.com/repos/octocat/Hello-World",
        "labels_url": "https://api.github.com/repos/octocat/Hello-World/issues/1347/labels{/name}",
        "comments_url": "https://api.github.com/repos/octocat/Hello-World/issues/1347/comments",
        "events_url": "https://api.github.com/repos/octocat/Hello-World/issues/1347/events",
        "html_url": "https://github.com/octocat/Hello-World/issues/1347",
        "number": 1347,
        "state": "open",
        "title": "Found a bug",
        "body": "I'm having a problem with this.",
        "user": {
            ...
        },
        "labels": [
        {
        ....
        }
        ],
        "assignee": {
        ...
        },
        "milestone": {
        ...
        },
        "locked": false,
        "comments": 0,
        "pull_request": {
            "url": "https://api.github.com/repos/octocat/Hello-World/pulls/1347",
            "html_url": "https://github.com/octocat/Hello-World/pull/1347",
            "diff_url": "https://github.com/octocat/Hello-World/pull/1347.diff",
            "patch_url": "https://github.com/octocat/Hello-World/pull/1347.patch"
        },
        "closed_at": null,
        "created_at": "2011-04-22T13:33:48Z",
        "updated_at": "2011-04-22T13:33:48Z"
    }
]
*/

class Issue: NSObject {
    var id: String?
    var url: String?
    var repository_url: String?
    var labels_url: String?
    var comments_url: String?
    var events_url: String?
    var html_url: String?
    var number: String?
    var state: String?
    var title: String?
    var body: String?
//    var user: User?
//    var labels: [Label]?
//    var assignee: [User]?
//    var milestone: Milestone?
    var locked: Bool?
    var comments: String?
//    var pull_request: PullRequest?
    var closed_at:  Date?
    var created_at: Date?
    var updated_at: Date?
    
    required init?(json: [String: Any]) {
        self.body           = json["body"] as? String
        self.id             = json["id"] as? String
        self.url            = json["url"] as? String
        
        self.repository_url = json["repository_url"] as? String
        self.labels_url     = json["labels_url"] as? String
        self.comments_url   = json["comments_url"] as? String
        self.events_url     = json["events_url"] as? String
        self.html_url       = json["html_url"] as? String
        self.number         = json["number"] as? String
        self.state          = json["state"] as? String
        self.title          = json["title"] as? String
        self.body           = json["body"] as? String
        self.locked         = json["locked"] as? Bool
        self.comments       = json["comments"] as? String
        
        // Dates
        let dateFormatter = Utils.dateFormatter()
        if let dateString = json["created_at"] as? String {
            self.created_at = dateFormatter.date(from: dateString)
        }
        if let dateString = json["updated_at"] as? String {
            self.updated_at = dateFormatter.date(from: dateString)
        }
        if let dateString = json["closed_at"] as? String{
            self.closed_at = dateFormatter.date(from: dateString)
        }
    }
}


class Gist: NSObject, NSCoding {
    var id: String?
    var gistDescription: String?
    var ownerLogin: String?
    var ownerAvatarURL: String?
    var url: String?
    var files:[File]?
    var createdAt:Date?
    var updatedAt:Date?
    
    static let sharedDateFormatter = dateFormatter()
    
    class func dateFormatter() -> DateFormatter {
        let aDateFormatter = DateFormatter()
        aDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        aDateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        aDateFormatter.locale = Locale(identifier: "en_US_POSIX")
        return aDateFormatter
    }
    
    required override init() {
    }
    
    required init?(json: [String: Any]) {
        guard let gistDescription = json["description"] as? String,
            let idValue = json["id"] as? String,
            let url = json["url"] as? String else {
                return nil
        }
        
        self.gistDescription = gistDescription
        self.id = idValue
        self.url = url
        
        if let ownerJson = json["owner"] as? [String: Any] {
            self.ownerLogin = ownerJson["login"] as? String
            self.ownerAvatarURL = ownerJson["avatar_url"] as? String
        }
        
        // files
        self.files = [File]()
        if let filesJSON = json["files"] as? [String: [String: Any]] {
            for (_, fileJSON) in filesJSON {
                if let newFile = File(json: fileJSON) {
                    self.files?.append(newFile)
                }
            }
        }
        
        // Dates
        let dateFormatter = Gist.dateFormatter()
        if let dateString = json["created_at"] as? String {
            self.createdAt = dateFormatter.date(from: dateString)
        }
        if let dateString = json["updated_at"] as? String {
            self.updatedAt = dateFormatter.date(from: dateString)
        }
    }
    
    // MARK: NSCoding
    @objc func encode(with aCoder: NSCoder) {
        aCoder.encode(self.id, forKey: "id")
        aCoder.encode(self.gistDescription, forKey: "gistDescription")
        aCoder.encode(self.ownerLogin, forKey: "ownerLogin")
        aCoder.encode(self.ownerAvatarURL, forKey: "ownerAvatarURL")
        aCoder.encode(self.url, forKey: "url")
        aCoder.encode(self.createdAt, forKey: "createdAt")
        aCoder.encode(self.updatedAt, forKey: "updatedAt")
        if let files = self.files {
            aCoder.encode(files, forKey: "files")
        }
    }
    
    @objc required convenience init?(coder aDecoder: NSCoder) {
        self.init()
        self.id = aDecoder.decodeObject(forKey: "id") as? String
        self.gistDescription = aDecoder.decodeObject(forKey: "gistDescription") as? String
        self.ownerLogin = aDecoder.decodeObject(forKey: "ownerLogin") as? String
        self.ownerAvatarURL = aDecoder.decodeObject(forKey: "ownerAvatarURL") as? String
        self.createdAt = aDecoder.decodeObject(forKey: "createdAt") as? Date
        self.updatedAt = aDecoder.decodeObject(forKey: "updatedAt") as? Date
        if let files = aDecoder.decodeObject(forKey: "files") as? [File] {
            self.files = files
        }
    }
}

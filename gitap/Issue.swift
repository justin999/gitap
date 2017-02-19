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

struct Issue: ResultProtocol {
    var id: String
    var url: String
    var repository_url: String
    var labels_url: String?
    var comments_url: String?
    var events_url: String?
    var html_url: String?
    var number: String?
    var state: String
    var title: String
    var body: String?
    var user: User?
//    var labels: [Label]?
    var assignee: [User]?
//    var milestone: Milestone?
    var locked: Bool?
    var comments: String?
//    var pull_request: PullRequest?
    var closed_at:  Date?
    var created_at: Date
    var updated_at: Date?
    
    init?(json: [String: Any]) {
        let dateFormatter = Utils.dateFormatter()
        
        guard let id = json["id"] as? String,
            let url = json["url"] as? String,
            let repository_url = json["repository_url"] as? String,
            let state = json["state"] as? String,
            let title = json["title"] as? String,
            let created_at_string = json["created_at"] as? String,
            let created_at = dateFormatter.date(from: created_at_string)
//            let user = json[""] as? Dictionary<String, Any>
        else {
            return nil
        }
        self.id             = id
        self.url            = url
        self.body           = json["body"] as? String
        self.repository_url = repository_url
        self.state          = state
        self.title          = title
        
        self.labels_url     = json["labels_url"] as? String
        self.comments_url   = json["comments_url"] as? String
        self.events_url     = json["events_url"] as? String
        self.html_url       = json["html_url"] as? String
        self.number         = json["number"] as? String
        
        self.body           = json["body"] as? String
        self.locked         = json["locked"] as? Bool
        self.comments       = json["comments"] as? String
        
        // Dates
        self.created_at     = created_at
        if let dateString = json["updated_at"] as? String {
            self.updated_at = dateFormatter.date(from: dateString)
        }
        if let dateString = json["closed_at"] as? String{
            self.closed_at = dateFormatter.date(from: dateString)
        }
    }
}

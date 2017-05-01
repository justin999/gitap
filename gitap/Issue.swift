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

struct Issue: JSONDecodable {
    var id: String
    var url: String
    var title: String
    var body: String?
    var user: User
    var created_at: Date?
    var updated_at: Date?
    
    init(json: Any) throws {
        guard let dictionary = json as? [String: Any] else {
            throw JSONDecodeError.invalidFormat(json: json)
        }
        
        guard let userObject = dictionary["user"] else {
            throw JSONDecodeError.missingValue(key: "user", actualValue: dictionary["user"])
        }
        
        let dateFormatter = Utils.dateFormatter()
        
        do {
            self.id = try Utils.getValue(from: dictionary, with: "id")
            self.url = try Utils.getValue(from: dictionary, with: "url")
            self.title = try Utils.getValue(from: dictionary, with: "title")
            self.body = dictionary["body"] as? String
            self.user = try User(json: userObject)
            // TODO:ここのcreated at とupdated_atをどうするかは要検討
//            self.created_at = dateFormatter.date(from: dictionary["created_at"] as? String)
            
        } catch {
            throw error
        }
    }
}

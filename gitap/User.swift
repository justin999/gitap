//
//  User.swift
//  gitap
//
//  Created by Koichi Sato on 1/5/17.
//  Copyright © 2017 Koichi Sato. All rights reserved.
//

import Foundation
/*
"user": {
    "login": "octocat",
    "id": 1,
    "avatar_url": "https://github.com/images/error/octocat_happy.gif",
    "gravatar_id": "",
    "url": "https://api.github.com/users/octocat",
    "html_url": "https://github.com/octocat",
    "followers_url": "https://api.github.com/users/octocat/followers",
    "following_url": "https://api.github.com/users/octocat/following{/other_user}",
    "gists_url": "https://api.github.com/users/octocat/gists{/gist_id}",
    "starred_url": "https://api.github.com/users/octocat/starred{/owner}{/repo}",
    "subscriptions_url": "https://api.github.com/users/octocat/subscriptions",
    "organizations_url": "https://api.github.com/users/octocat/orgs",
    "repos_url": "https://api.github.com/users/octocat/repos",
    "events_url": "https://api.github.com/users/octocat/events{/privacy}",
    "received_events_url": "https://api.github.com/users/octocat/received_events",
    "type": "User",
    "site_admin": false
},
*/

class User: NSObject {
    var login: String?
    var githubId: String?
    var avatar_url: String?
    var gravatar_id: String?
    var url: String?
    var html_url: String?
    var type: String?
    var site_admin: Bool?
    
    init?(json: [String: Any]) {
        self.login = json["login"] as? String
        self.githubId = json["id"] as? String
        self.avatar_url = json["avatar_url"] as? String
        self.gravatar_id = json["gravatar_id"] as? String
        self.url = json["url"] as? String
        self.html_url = json["html_url"] as? String
        self.type = json["type"] as? String
        self.site_admin = json["site_admin"] as? Bool
    }
}

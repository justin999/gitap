//
//  Repo.swift
//  gitap
//
//  Created by Koichi Sato on 1/6/17.
//  Copyright © 2017 Koichi Sato. All rights reserved.
//

import Foundation

/*
 [
 {
 "id": 1296269,
 "owner": {
    ...
 },
 "name": "Hello-World",
 "full_name": "octocat/Hello-World",
 "description": "This your first repo!",
 "private": false,
 "fork": true,
 "url": "https://api.github.com/repos/octocat/Hello-World",
 "html_url": "https://github.com/octocat/Hello-World",
 "archive_url": "http://api.github.com/repos/octocat/Hello-World/{archive_format}{/ref}",
 "assignees_url": "http://api.github.com/repos/octocat/Hello-World/assignees{/user}",
 "blobs_url": "http://api.github.com/repos/octocat/Hello-World/git/blobs{/sha}",
 "branches_url": "http://api.github.com/repos/octocat/Hello-World/branches{/branch}",
 "clone_url": "https://github.com/octocat/Hello-World.git",
 "collaborators_url": "http://api.github.com/repos/octocat/Hello-World/collaborators{/collaborator}",
 "comments_url": "http://api.github.com/repos/octocat/Hello-World/comments{/number}",
 "commits_url": "http://api.github.com/repos/octocat/Hello-World/commits{/sha}",
 "compare_url": "http://api.github.com/repos/octocat/Hello-World/compare/{base}...{head}",
 "contents_url": "http://api.github.com/repos/octocat/Hello-World/contents/{+path}",
 "contributors_url": "http://api.github.com/repos/octocat/Hello-World/contributors",
 "deployments_url": "http://api.github.com/repos/octocat/Hello-World/deployments",
 "downloads_url": "http://api.github.com/repos/octocat/Hello-World/downloads",
 "events_url": "http://api.github.com/repos/octocat/Hello-World/events",
 "forks_url": "http://api.github.com/repos/octocat/Hello-World/forks",
 "git_commits_url": "http://api.github.com/repos/octocat/Hello-World/git/commits{/sha}",
 "git_refs_url": "http://api.github.com/repos/octocat/Hello-World/git/refs{/sha}",
 "git_tags_url": "http://api.github.com/repos/octocat/Hello-World/git/tags{/sha}",
 "git_url": "git:github.com/octocat/Hello-World.git",
 "hooks_url": "http://api.github.com/repos/octocat/Hello-World/hooks",
 "issue_comment_url": "http://api.github.com/repos/octocat/Hello-World/issues/comments{/number}",
 "issue_events_url": "http://api.github.com/repos/octocat/Hello-World/issues/events{/number}",
 "issues_url": "http://api.github.com/repos/octocat/Hello-World/issues{/number}",
 "keys_url": "http://api.github.com/repos/octocat/Hello-World/keys{/key_id}",
 "labels_url": "http://api.github.com/repos/octocat/Hello-World/labels{/name}",
 "languages_url": "http://api.github.com/repos/octocat/Hello-World/languages",
 "merges_url": "http://api.github.com/repos/octocat/Hello-World/merges",
 "milestones_url": "http://api.github.com/repos/octocat/Hello-World/milestones{/number}",
 "mirror_url": "git:git.example.com/octocat/Hello-World",
 "notifications_url": "http://api.github.com/repos/octocat/Hello-World/notifications{?since, all, participating}",
 "pulls_url": "http://api.github.com/repos/octocat/Hello-World/pulls{/number}",
 "releases_url": "http://api.github.com/repos/octocat/Hello-World/releases{/id}",
 "ssh_url": "git@github.com:octocat/Hello-World.git",
 "stargazers_url": "http://api.github.com/repos/octocat/Hello-World/stargazers",
 "statuses_url": "http://api.github.com/repos/octocat/Hello-World/statuses/{sha}",
 "subscribers_url": "http://api.github.com/repos/octocat/Hello-World/subscribers",
 "subscription_url": "http://api.github.com/repos/octocat/Hello-World/subscription",
 "svn_url": "https://svn.github.com/octocat/Hello-World",
 "tags_url": "http://api.github.com/repos/octocat/Hello-World/tags",
 "teams_url": "http://api.github.com/repos/octocat/Hello-World/teams",
 "trees_url": "http://api.github.com/repos/octocat/Hello-World/git/trees{/sha}",
 "homepage": "https://github.com",
 "language": null,
 "forks_count": 9,
 "stargazers_count": 80,
 "watchers_count": 80,
 "size": 108,
 "default_branch": "master",
 "open_issues_count": 0,
 "has_issues": true,
 "has_wiki": true,
 "has_pages": false,
 "has_downloads": true,
 "pushed_at": "2011-01-26T19:06:43Z",
 "created_at": "2011-01-26T19:01:12Z",
 "updated_at": "2011-01-26T19:14:43Z",
 "permissions": {
 "admin": false,
 "push": false,
 "pull": true
 }
 }
 ]
*/

struct Repo: ResultProtocol {
    var name: String
    var owner: User
    var full_name: String
    var repoDescription: String?
    var isPrivate: Bool?
    var isFork: Bool?
    var language: String?
    var forks_count: Int?
    var stargazers_count: Int?
    var watchers_count: Int?
    var size: String?
    var default_branch: String?
    var open_issues_count: Int?
    var has_issues: Bool?
    var has_wiki: Bool?
    var has_pages: Bool?
    var has_downloads: Bool?
    var pushed_at: Date?
    var created_at: Date?
    var updated_at: Date?
    var permissions: [Permission]?
    
    init?(json: [String: Any]) {
        guard let name = json["name"] as? String,
            let full_name = json["full_name"] as? String,
            let ownerDictionary = json["owner"] as? [String: Any],
            let owner = User(json: ownerDictionary)
        else {
            return nil
        }
        self.name = name
        self.full_name = full_name
        self.owner = owner
        self.repoDescription = json["description"] as? String
        self.isPrivate = json["private"] as? Bool
        self.isFork = json["fork"] as? Bool
        self.language = json["language"] as? String
        self.forks_count = json["forks_count"] as? Int
        self.stargazers_count = json["stargazers_count"] as? Int
        self.watchers_count = json["watchers_count"] as? Int
        self.size = json["size"] as? String
        self.default_branch = json["default_branch"] as? String
        self.open_issues_count = json["open_issues_count"] as? Int
        self.has_issues = json["has_issues"] as? Bool
        self.has_wiki = json["has_wiki"] as? Bool
        self.has_pages = json["has_pages"] as? Bool
        self.has_downloads = json["has_downloads"] as? Bool
        self.permissions = json["permissions"] as? [Permission]
        
        // Dates
        let dateFormatter = Utils.dateFormatter()
        if let dateString = json["pushed_at"] as? String {
            self.pushed_at = dateFormatter.date(from: dateString)
        }
        if let dateString = json["created_at"] as? String{
            self.created_at = dateFormatter.date(from: dateString)
        }
        if let dateString = json["updated_at"] as? String {
            self.updated_at = dateFormatter.date(from: dateString)
        }
    }
}


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

struct Repo: JSONDecodable {
    let id: Int
    let name: String
    let full_name: String
    let owner: User
    let isPrivate: Bool
    let description: String?
    let url: URL
    
    init(json: Any) throws {
        guard let dictionary = json as? [String : Any] else {
            throw JSONDecodeError.invalidFormat(json: json)
        }
        
        guard let ownerObject = dictionary["owner"] else {
            throw JSONDecodeError.missingValue(key: "owner", actualValue: dictionary["owner"])
        }
        
        do {
            self.id = try Utils.getValue(from: dictionary, with: "id")
            self.name = try Utils.getValue(from: dictionary, with: "name")
            self.full_name = try Utils.getValue(from: dictionary, with: "full_name")
            self.owner = try User(json: ownerObject)
            self.isPrivate = try Utils.getValue(from: dictionary, with: "private")
            self.description = dictionary["description"] as? String
            let urlString: String = try Utils.getValue(from: dictionary, with: "html_url")
            guard let url = URL(string: urlString) else {
                throw ObjectError.initializationError(object: urlString)
            }
            self.url = url
        } catch {
            throw error
        }
    }
}


//
//  ShareViewController.swift
//  GitapShareExtension
//
//  Created by Koichi Sato on 2017/09/28.
//  Copyright © 2017 Koichi Sato. All rights reserved.
//

import UIKit
import Social
import Photos
import NetworkFramework
import Locksmith

class ShareViewController: SLComposeServiceViewController, ReposSelectionTableViewControllerDelegate {
    
    var privateRepoNames = [String]()
    var publicRepoNames  = [String]()
    var fullRepoName: String?
    var githubAPIToken: String?
    let repoItem:SLComposeSheetConfigurationItem = SLComposeSheetConfigurationItem()
    let userDefaults = UserDefaults(suiteName: "group.justin999.gitap")
    
    override func presentationAnimationDidFinish() {
        guard let authToken = userDefaults?.value(forKey: "githubAuthToken") as? String else {
            self.showAlert(message: "open Gitap app and authorize your GitHub Account first.", completionHandler: nil)
            return
        }
        self.githubAPIToken = authToken
        
        guard let privateRepos = userDefaults?.value(forKey: "privateRepoNames") as? [String],
            let publicRepos = userDefaults?.value(forKey: "publicRepoNames") as? [String] else {
                self.showAlert(message: "open Gitap app and authorize your GitHub Account first.", completionHandler: nil)
                return
        }
        self.privateRepoNames = privateRepos
        self.publicRepoNames  = publicRepos
        
    }

    override func isContentValid() -> Bool {
        guard let title = self.textView.text else {
            return false
        }
        
        if !(title.characters.count > 0) {
            return false
        }
        
        return true
    }

    override func didSelectPost() {
        guard let repoName = self.fullRepoName else {
            showAlert(message: "Select the repoName", completionHandler: (nil))
            return
        }
        
        // NOTE: title is validated in isContentValid()
        guard let title = self.textView.text else { return }
        
        if let extensionContext = self.extensionContext,
            let item = extensionContext.inputItems.first as? NSExtensionItem,
            let attachment = item.attachments?.first as? NSItemProvider {

            attachment.loadDataRepresentation(forTypeIdentifier: "public.image", completionHandler: { (imageData, error) in
                if let error = error {
                    self.showAlert(message: self.makeErrorMessage(message: "Failed to fetch an image. Retry later.", error: error), completionHandler: nil)
                    return
                }

                if let data = imageData {
                    ImgurManager.shared.uploadImage(image: data) { [weak self] (uploadedData, error) in
                        guard let weakSelf = self else { return }
                        if let error = error {
                            weakSelf.showAlert(message: weakSelf.makeErrorMessage(message: "Failed to upload an image. Retry later.", error: error) , completionHandler: nil)
                            return
                        }

                        if let uploadedData = uploadedData {
                            let bodyText = "![imgur image upload at \(uploadedData.datetime)](\(uploadedData.url))\n"
                            if let params = self?.getParams(title: title, body: bodyText) {
                                self?.createIssue(repoFullName: repoName, params:params)
                            }
                        }
                    }
                    print("data fetched: \(data)")
                } else {
                    self.showAlert(message: "some thing went wrong1", completionHandler: nil)
                }
            })
        } else {
            self.showAlert(message: "some thing went wrong2", completionHandler: nil)
        }


    }

    override func configurationItems() -> [Any]! {
        return [getRepoItem()]
    }
    
    // MARK: - Private
    
    private func getRepoItem() -> SLComposeSheetConfigurationItem {
        self.repoItem.title = "Repository"
        self.repoItem.value = self.fullRepoName ?? "not set"
        self.repoItem.tapHandler = { () in
            self.segueToRepos()
        }
        return self.repoItem
    }
    
    private func updateRepoItem() {
        
    }
    
    private func segueToRepos() {
        let reposViewController = ReposSelectionTableViewController()
        reposViewController.delegate = self
        reposViewController.privateReposNames = self.privateRepoNames
        reposViewController.publicRepoNames   = self.publicRepoNames
        self.pushConfigurationViewController(reposViewController)
    }
    
    private func createIssue(repoFullName: String, params: [String: Any?]) {
        let path = "/repos/\(repoFullName)/issues"
        let session: URLSession = {
            // ref. # Performing Uploads and Downloads
            // https://developer.apple.com/library/content/documentation/General/Conceptual/ExtensibilityPG/ExtensionScenarios.html#//apple_ref/doc/uid/TP40014214-CH21-SW1
            let configuration = URLSessionConfiguration.background(withIdentifier: "com.justin999.gitap.shareExtension.background")
            let session = URLSession(configuration: configuration)
            return session
        }()
        
        let baseURL: URL = URL(string: "https://api.github.com")!
        
        let url = baseURL.appendingPathComponent(path)
        let jsonData: Data? = try? JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody   = jsonData
        
        // get api token
        if let token = self.githubAPIToken {
            request.setValue("token \(token)", forHTTPHeaderField: "Authorization")
        } else {
            self.showAlert(message: "Failed to find you GitHub account. Go back to Gitap App and authenticate your GitHub account.", completionHandler: nil)
            return
        }
        
        let task = session.dataTask(with: request) { data, response, error in
            switch (data, response, error) {
            case (_, _, let error?):
                self.showAlert(message: self.makeErrorMessage(message: "Failed to Connect to Internet.", error: error), completionHandler: nil)
                return
            case (let data?, let response?, _):
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    if case (200..<300)? = (response as? HTTPURLResponse)?.statusCode {
                        print(json)
                    } else {
                        self.showAlert(message: "Failed to Creat an Issue.", completionHandler: nil)
                        return
                    }
                } catch {
                    self.showAlert(message: self.makeErrorMessage(message: "Failed to Create an issue.", error: error), completionHandler: nil)
                    return
                }
            default:
                break
            }
        }
        task.resume()
    }
    
    private func getParams(title: String, body: String) -> [String: Any?] {
        
        let params: [String: Any?] = [
            "title": title,
            "body": body,
        ]
        
        return params
    }
    
    private func showAlert(message: String, completionHandler: (() -> Void)?) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (action: UIAlertAction!) -> () in
            if let handler = completionHandler { handler() }
            self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
        }))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    private func makeErrorMessage(message: String, error: Error?) -> String {
        if let error = error {
            return "\(message): \(error.localizedDescription)"
        } else {
            return message
        }
    }
    
    // MARK: - ReposSelectionTableViewControllerDelegate
    func repoSelection(_ tableView: UITableView, didTapped indexPath: IndexPath, repoName: String) {
        self.fullRepoName = repoName
        self.repoItem.value = repoName
    }

}

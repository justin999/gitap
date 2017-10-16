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

class ShareViewController: SLComposeServiceViewController,
                            ReposSelectionTableViewControllerDelegate,
                            ImgurManagerDelegate,
                            URLSessionDelegate,
                            URLSessionTaskDelegate,
                            URLSessionDataDelegate {
    
    var issueTitle: String?
    var privateRepoNames = [String]()
    var publicRepoNames  = [String]()
    var fullRepoName: String?
    var githubAPIToken: String?
    var imgurAPIClientID: String?
    let repoItem:SLComposeSheetConfigurationItem = SLComposeSheetConfigurationItem()
    let userDefaults = UserDefaults(suiteName: "group.justin999.gitap")
    
    override func presentationAnimationDidFinish() {
        guard let authToken = userDefaults?.value(forKey: "githubAuthToken") as? String else {
            self.showAlert(message: "open Gitap app and authorize your GitHub Account first.", completionHandler: nil)
            return
        }
        self.githubAPIToken = authToken
        
        guard let imgurClientId = userDefaults?.value(forKey: "imgurAPIClientId") as? String else {
            self.showAlert(message: "Failed to Connect to Imgur. Open Gitap app first.", completionHandler: nil)
            return
        }
        self.imgurAPIClientID = imgurClientId
        
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
        guard let _ = self.fullRepoName else {
            showAlert(message: "Select the repoName", completionHandler: (nil))
            return
        }
        
        // NOTE: title is validated in isContentValid()
        guard let title = self.textView.text else { return }
        self.issueTitle = title
        
        if let extensionContext = self.extensionContext,
            let item = extensionContext.inputItems.first as? NSExtensionItem,
            let attachment = item.attachments?.first as? NSItemProvider {

            attachment.loadDataRepresentation(forTypeIdentifier: "public.image", completionHandler: { (imageData, error) in
                if let error = error {
                    self.showAlert(message: self.makeErrorMessage(message: "Failed to fetch an image. Retry later.", error: error), completionHandler: nil)
                    return
                }

                if let data = imageData {
                    ImgurManager.shared.delegate = self
                    ImgurManager.shared.clientID = self.imgurAPIClientID! // shouldn't be nil as it validated in presentationAnimationDidFinish.
                    ImgurManager.shared.uploadImage(image: data)
                    // NOTE: lator task is processed in ImgurManagerDelegate methods
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
            // NOTE: Should use background?
            // let configuration = URLSessionConfiguration.background(withIdentifier: "com.justin999.gitap.shareExtension.background")
            // configuration.sharedContainerIdentifier = "com.justin999.gitap.shareExtension.container"
            let configuration = URLSessionConfiguration.default
            let session = URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
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
            self.showAlert(message: "Failed to find your GitHub account. Go back to Gitap App and authenticate your GitHub account.", completionHandler: nil)
            return
        }
        
        let task = session.dataTask(with: request)
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
    
    // MARK: - ImgurManagerDelegate
    func imgur(imgur: ImgurManager, didSuceededToUploadWith data: [String : Any?]) {
        print("imgur succeeded")
        print("data: \(data)")
        if let datetime = data["datetime"] as? Int,
            let url = data["url"] as? String,
            let title = self.issueTitle {
            let bodyText = "![imgur image upload at \(datetime)](\(url))\n"
            let params = self.getParams(title: title, body: bodyText)
            if let repoName = self.fullRepoName {
                self.createIssue(repoFullName: repoName, params:params)
            }
        } else {
            self.showAlert(message: "data format is illegal", completionHandler: nil)
        }
    }
    
    func imgur(imgur: ImgurManager, didFailedToUploadWith error: Error?) {
        print("imgur failed")
        if let error = error {
            self.showAlert(message: self.makeErrorMessage(message: "Failed to upload an image. Retry later.", error: error) , completionHandler: nil)
        }
    }
    
    // MARK: - URLSessionDelegate
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        self.showAlert(message: self.makeErrorMessage(message: "Failed to Connect to Internet.", error: error), completionHandler: nil)
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Swift.Void) {
        print("data received : \(response)")
        if case (200..<300)? = (response as? HTTPURLResponse)?.statusCode {
            self.showAlert(message: "Succeed to make issue.", completionHandler: nil)
        } else {
            self.showAlert(message: "Failed to Creat an Issue.", completionHandler: nil)
            return
        }
    }
    
}

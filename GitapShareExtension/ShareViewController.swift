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
    let repoItem:SLComposeSheetConfigurationItem = SLComposeSheetConfigurationItem()
    let userDefaults = UserDefaults(suiteName: "group.justin999.gitap")
    
    override func presentationAnimationDidFinish() {
        guard let privateRepos = userDefaults?.value(forKey: "privateRepoNames") as? [String],
            let publicRepos = userDefaults?.value(forKey: "publicRepoNames") as? [String] else {
                let alert = UIAlertController(title: "No Repos found", message: "open Gitap app and authorize your GitHub Account.", preferredStyle: .alert)
                alert.present(self, animated: true, completion: {
                    self.dismiss(animated: true, completion: nil)
                })
                return
        }
        self.privateRepoNames = privateRepos
        self.publicRepoNames  = publicRepos
        
    }

    override func isContentValid() -> Bool {
        // Do validation of contentText and/or NSExtensionContext attachments here
        return true
    }

    override func didSelectPost() {
        // This is called after the user selects Post. Do the upload of contentText and/or NSExtensionContext attachments.

        // Inform the host that we're done, so it un-blocks its UI. Note: Alternatively you could call super's -didSelectPost, which will similarly complete the extension context.

        if let extensionContext = self.extensionContext,
            let item = extensionContext.inputItems.first as? NSExtensionItem,
            let attachment = item.attachments?.first as? NSItemProvider {
            print("sharing image: \(item)")
            
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
                            let text = "![imgur image upload at \(uploadedData.datetime)](\(uploadedData.url))\n"
                            // making issue
                        }
                    }
                    print("data fetched: \(data)")
                }
            })
        }



        self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
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
    
    private func createIssue(repoFullName: String) {
        let path = "/repos/\(repoFullName)/issues"
        let session: URLSession = {
            let configuration = URLSessionConfiguration.default
            let session = URLSession(configuration: configuration)
            return session
        }()
        
        let baseURL: URL = URL(string: "https://api.github.com")!
        
        let url = baseURL.appendingPathComponent(path)
        let params = [String: String]() // implement later
        let jsonData: Data? = try? JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody   = jsonData
        
        // get api token
        if let token = userDefaults?.value(forKey: "githubAuthToken") as? String {
            request.setValue("token \(token)", forHTTPHeaderField: "Authorization")
        } else {
            self.showAlert(message: "Failed to find you GitHub account. Go back to Gitap App and authenticate your GitHub account.", completionHandler: nil)
            return
        }
        
        let task = session.dataTask(with: request) { (data, response, error) in
            switch (data, response, error) {
            case (_, _, let error?):
                self.showAlert(message: "Failed to Connect to Internet.", completionHandler: nil)
                return
            case (let data?, let response?, _):
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                if case (200..<300)? = (response as? HTTPURLResponse)?.statusCode {
                    print(json)
                } else {
                    // TODO: show error
                }
            default:
                break
            }
        }
        
        
    }
    
    private func showAlert(message: String, completionHandler: (() -> Void)?) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        alert.present(self, animated: true) {
            if let handler = completionHandler { handler() }
        }
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

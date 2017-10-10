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

class ShareViewController: SLComposeServiceViewController, ReposSelectionTableViewControllerDelegate {
    
    var privateRepoNames = [String]()
    var publicRepoNames  = [String]()
    var fullRepoName: String?
    let repoItem:SLComposeSheetConfigurationItem = SLComposeSheetConfigurationItem()
    
    override func presentationAnimationDidFinish() {
        let userDefaults = UserDefaults(suiteName: "group.justin999.gitap")
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
                    ImgurManager.shared.uploadImage(image: data) { (uploadedData, error) in
                        if let error = error {
                            self.showAlert(message: makeErrorMessage(message: "Failed to upload an image. Retry later.", error: error!) , completionHandler: nil)
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
        self.contentText
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

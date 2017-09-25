//
//  CreateItemViewController.swift
//  gitap
//
//  Created by Koichi Sato on 12/26/16.
//  Copyright © 2016 Koichi Sato. All rights reserved.
//
//  https://developer.github.com/v3/issues/#create-an-issue
//  aws s3: https://github.com/aws/aws-sdk-ios
//  sample: https://github.com/awslabs/aws-sdk-ios-samples/tree/master/S3TransferManager-Sample/Swift/

import UIKit
import AVFoundation
import Photos

class CreateIssuesViewController: MasterViewController, PhotoGridViewControllerDelegate {
    
    // 参考: http://dev.classmethod.jp/smartphone/ios-10-avfoundation-takephoto/
    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var repoButton: UIButton!
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var bodyTextView: PlaceHolderTextView!
    
    var accessoryView: UIToolbar?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
    }
    
    // MARK: - private 
    private func configureView() {
        bodyTextView.layer.borderColor = UIColor.placeHolderGrayColor().cgColor
        bodyTextView.layer.borderWidth = 1.0
        bodyTextView.layer.cornerRadius = 4.0
        bodyTextView.placeHolder = "issue body"
        bodyTextView.placeHolderColor = UIColor.placeHolderGrayColor()
        
        configureAccessoryView()
        
        if let repo = stateController?.selectedRepo {
            repoButton.setTitle(repo.full_name, for: .normal)
        }
    }
    
    private func configureAccessoryView() {
        accessoryView = UIToolbar()
        accessoryView?.sizeToFit()
        let imageButton = UIBarButtonItem(title: "image", style: .plain, target: self, action: #selector(imageButtonTapped))
        let linkButton = UIBarButtonItem(title: "link", style: .plain, target: self, action: #selector(linkButtonTapped))
        let taskButton = UIBarButtonItem(title: "task", style: .plain, target: self, action: #selector(taskButtonTapped))
        let headerButton = UIBarButtonItem(title: "header", style: .plain, target: self, action: #selector(headerButtonTapped))
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        accessoryView?.setItems([imageButton, spacer, linkButton, spacer, taskButton, spacer, headerButton], animated: true)
        
        bodyTextView.inputAccessoryView = accessoryView
    }
    
    private func uploadLastImage() {
        guard let lastImage = PhotoManager.shared.allPhotos.lastObject else {
            stateController?.presentAlert(title: "No Photo", message: "No photo in your library, or you need to re-allow using photo in privacy section of the Setting app.", style: .alert, actions: [UIAlertAction.okAlert()], completion: nil)
            return
        }
        
        self .uploadImage(image: lastImage)
    }
    
    private func uploadImage(image: PHAsset) {
        stateController?.getUploadImageData(image: image, options: nil) { [weak self] (data, error) in
            if let error = error, let weakSelf = self {
                Utils.showErrorAlert(error: error, in: weakSelf, message: error.localizedDescription) { () in
                    return
                }
            }
            
            if let data = data , let weakSelf = self, let originalRange = weakSelf.bodyTextView.selectedTextRange {
                let originalStart = originalRange.start
                let uploadingText = "uploading image…"
                weakSelf.insert("uploading image…")
                guard let uploadingTextEnd = weakSelf.bodyTextView.position(from: originalStart, offset: uploadingText.characters.count), let uploadingRange = weakSelf.bodyTextView.textRange(from: originalStart, to: uploadingTextEnd) else {
                    // NOTE: it shouldn't come here
                    Utils.presentAlert(inViewController: weakSelf, title: "", message: "Please select where to upload image", style: .alert, actions: nil, completion: nil)
                    return
                }
                
                ImgurManager.shared.uploadImage(image: data) { (data, error) in
                    if let error = error {
                        Utils.showErrorAlert(error: error, in: weakSelf, message: error.localizedDescription, afterAction: { () -> Void in
                            weakSelf.bodyTextView.replace(uploadingRange, withText: "")
                            return } )
                    }
                    
                    if let data = data {
                        weakSelf.bodyTextView.replace(uploadingRange, withText: "")
                        let text = "\n<img src=\"\(data.url)\" width=300>\n"
                        weakSelf.insert(text)
                    }
                }
            }
        }
    }
    
    func generateActionSheet() -> UIAlertController {
        let imageAlert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let lastPhotoAction = UIAlertAction(title: "Use Last Photo Taken", style: .default) { action in
            print("Use Last Photo Taken")
            self.uploadLastImage()
        }
        let libraryAction = UIAlertAction(title: "Choose From Library", style: .default) { [unowned self] (action) in
            print("Choose From Library")
            let destination = PhotoGridViewController()
            destination.fetchResult = PhotoManager.shared.allPhotos
            destination.photoGridViewControllerDelegate = self
            let navigationController = UINavigationController(rootViewController: destination)
            self.stateController?.present(destinationNav: navigationController, inViewController: self)
        }
        imageAlert.addAction(lastPhotoAction)
        imageAlert.addAction(libraryAction)
        
        return imageAlert
    }
    
    @objc private func imageButtonTapped() {
        self.present(generateActionSheet(), animated: true, completion: nil)
    }
    @objc private func linkButtonTapped() {
        let linkText = "[]()"
        insert(linkText)
    }
    @objc private func taskButtonTapped() {
        let taskText = "- [ ] "
        insert(taskText)
    }
    @objc private func headerButtonTapped() {
        let headerText = "### "
        insert(headerText)
    }
    
    func insert(_ text: String) {
        if let range = bodyTextView.selectedTextRange {
            if range.start == range.end {
                bodyTextView.replace(range, withText: text)
            }
        }
    }
    
    
    
    // MARK: - Actions
    @IBAction func dismissView(_ sender: Any) {
        self.dismiss(animated: true) {
            print("view is dismissed")
        }
    }

    @IBAction func createButtonTapped(_ sender: Any) {
        if titleTextField.text?.characters.count == 0 {
            Utils.presentAlert(inViewController: self, title: "", message: "Set the issue title.", style: .alert, actions: [UIAlertAction.okAlert()], completion: nil)
            return
        }
        
        guard let stateController = stateController else {
            Utils.presentAlert(inViewController: self, title: "", message: "Something went wrong. Please relaunch the app.", style: .alert, actions: [UIAlertAction.okAlert()], completion: nil)
            return
        }
        
        if let repo = stateController.selectedRepo {
            let title = titleTextField.text
            let owner = repo.owner.loginName
            let repoName = repo.name
            if title?.characters.count == 0 {
                Utils.presentAlert(inViewController: self, title: "", message: "title can't be blank", style: .alert, actions: [UIAlertAction.okAlert()], completion: nil)
                return
            }
            
            let body = bodyTextView.text
            
            let params: [String: Any?] = [
                "title": title,
                "body": body,
                "owner": owner,
                "repo": repoName
            ]
            
            stateController.createIssue(params: params) { (result) in
                switch result {
                case let .success(issue):
                    let dismissAction = UIAlertAction(title: "OK", style: .default) { (alert) in
                        self.dismiss(animated: true, completion: nil) }
                    Utils.presentAlert(inViewController: self, title: "issue created", message: "title: \(issue.title)", style: .alert, actions: [dismissAction], completion: nil)
                case let .failure(error):
                    print("error: \(error)")
                    Utils.presentAlert(inViewController: self, title: "", message: "Something went wrong. The issue was not created.", style: .alert, actions: [UIAlertAction.okAlert()], completion: nil)
                }
                
            }
            
        } else {
            stateController.presentAlert(title: "", message: "レポジトリが選択されていません。", style: .alert, actions: [UIAlertAction.okAlert()], completion: nil)
        }
        
    }
    
    // MARK: - IBActions
    @IBAction func repoButtonTapped(_ sender: Any) {
        print("repoButtonTapped")
        if let stateController = stateController {
            let destination = ReposSelectionViewController(nibName: String(describing: ReposSelectionViewController.self), bundle: nil)
            stateController.present(destination: destination, inViewController: self)
        } else {
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            Utils.presentAlert(inViewController: self, title: "エラー", message: "レポジトリがありません", style: UIAlertControllerStyle.alert, actions: [okAction], completion: nil)
        }
    }
    
    // MARK: - PhotoGridViewControllerDelegate
    func photoGridViewControllerDismissed(_ gridViewController: PhotoGridViewController, didDismissed imageIndexPath: IndexPath) {
        print("\(#file): \(#function): delegate method called")
    }
}

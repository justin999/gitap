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

class CreateIssuesViewController: MasterViewController {
    
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
        let quoteButton = UIBarButtonItem(title: "quote", style: .plain, target: self, action: #selector(quoteButtonTapped))
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        accessoryView?.setItems([imageButton, spacer, linkButton, spacer, taskButton, spacer, quoteButton], animated: true)
        
        bodyTextView.inputAccessoryView = accessoryView
    }
    
    private func uploadImage() {
        if let image = PhotoManager.shared.allPhotos.firstObject {
            // how to convert phasset to nsdata?
            // ref. https://github.com/steve228uk/ImgurKit
            PHImageManager.default().requestImageData(for: image, options: nil) { (imageData, dataUTI, orientation, info) in
                print("imageData: \(imageData)")
                
            }
        }
        
        
        
    }
    
    func generateActionSheet() -> UIAlertController {
        let imageAlert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
//        let takePhotoAction = UIAlertAction(title: "Take Photo", style: .default) { action in
//            print("Take Photo")
//        }
        let lastPhotoAction = UIAlertAction(title: "Use Last Photo Taken", style: .default) { action in
            print("Use Last Photo Taken")
            self.uploadImage()
        }
        let libraryAction = UIAlertAction(title: "Choose From Library", style: .default) { [unowned self] (action) in
            print("Choose From Library")
            let destination = PhotoSectionsViewController()
            let navigationController = UINavigationController(rootViewController: destination)
            self.stateController?.present(destinationNav: navigationController, inViewController: self)
        }
//        imageAlert.addAction(takePhotoAction)
        imageAlert.addAction(lastPhotoAction)
        imageAlert.addAction(libraryAction)
        
        return imageAlert
    }
    
    @objc private func imageButtonTapped() {
        self.present(generateActionSheet(), animated: true, completion: nil)

    }
    @objc private func linkButtonTapped() {
    }
    @objc private func taskButtonTapped() {
    }
    @objc private func quoteButtonTapped() {
    }
    
    
    
    // MARK: - Actions
    @IBAction func dismissView(_ sender: Any) {
        print("sender: \(sender)")
        self.dismiss(animated: true) {
            print("view is dismissed")
        }
    }

    @IBAction func createButtonTapped(_ sender: Any) {
        print("done button tapped")
        if titleTextField.text?.characters.count == 0 {
            Utils.presentAlert(inViewController: self, title: "", message: "Set the issue title.", style: .alert, actions: [UIAlertAction.okAlert()], completion: nil)
            return
        }
        
        if let repo = stateController?.selectedRepo,
            let owner = repo.owner?.loginName ,
            let repoName = repo.name {
            let title = titleTextField.text
            if title?.characters.count == 0 {
                Utils.presentAlert(inViewController: self, title: "", message: "title can't be blank", style: .alert, actions: [UIAlertAction.okAlert()], completion: nil)
                return
            }
            // TODO: validate title
            let body = bodyTextView.text
            
            let params = [
                "title": title,
                "body": body,
                "owner": owner,
                "repo": repoName
            ]
            stateController?.createIssue(params: params, completionHandler: nil)
        } else {
            stateController?.presentAlert(title: "", message: "レポジトリが選択されていません。", style: .alert, actions: [UIAlertAction.okAlert()], completion: nil)
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
}

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

class CreateIssuesViewController: MasterViewController {
    
    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var repoButton: UIButton!
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var bodyTextView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {   
    }
    
    // MARK: - private 
    func configureView() {
        bodyTextView.layer.borderColor = UIColor.placeHolderGrayColor().cgColor
        bodyTextView.layer.borderWidth = 1.0
        bodyTextView.layer.cornerRadius = 4.0
        bodyTextView.textColor = UIColor.placeHolderGrayColor()
        
        if let repo = stateController?.selectedRepo {
            repoButton.setTitle(repo.full_name, for: .normal)
        }
    }
    
    @IBAction func dismissView(_ sender: Any) {
        print("sender: \(sender)")
        self.dismiss(animated: true) {
            print("view is dismissed")
        }
    }

    @IBAction func createButtonTapped(_ sender: Any) {
        print("done button tapped")
        if let repo = stateController?.selectedRepo,
            let owner = repo.owner?.loginName ,
            let repoName = repo.name {
            let title = titleTextField.text
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

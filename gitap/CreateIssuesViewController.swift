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
//    var stateController: StateController?
    
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
        bodyTextView.layer.borderColor = UIColor.black.cgColor
        bodyTextView.layer.borderWidth = 1.0
        bodyTextView.layer.cornerRadius = 4.0
    }
    
    @IBAction func dismissView(_ sender: Any) {
        print("sender: \(sender)")
        self.dismiss(animated: true) {
            print("view is dismissed")
        }
    }

    @IBAction func createButtonTapped(_ sender: Any) {
        print("done button tapped")
        let params = ["title": "てすとだyo",
                      "body": "test no body dayo",
                      "owner": "justin999",
                      "repo": "bonita"
                      ]
        stateController?.createIssue(params: params, completionHandler: nil)
        
    }
    
    // MARK: - IBActions
    @IBAction func repoButtonTapped(_ sender: Any) {
        print("repoButtonTapped")
        if let stateController = stateController {
            let destination = ReposSelectionViewController(nibName: String(describing: ReposSelectionViewController.self), bundle: nil)
            destination.stateController = stateController
            stateController.present(destination: destination, inViewController: self)
        } else {
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            Utils.presentAlert(inViewController: self, title: "エラー", message: "レポジトリがありません", style: UIAlertControllerStyle.alert, actions: [okAction], completion: nil)
        }
    }
}

//
//  CreateItemViewController.swift
//  gitap
//
//  Created by Koichi Sato on 12/26/16.
//  Copyright © 2016 Koichi Sato. All rights reserved.
//

import UIKit

class CreateIssuesViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        let label = UILabel(frame: CGRect(x: 10, y: 100, width: self.view.bounds.width, height: 50))
        label.text = "クリエイト　クリエイト"
        self.view.addSubview(label)
//        self.tableView.backgroundColor = UIColor.orange
        self.view.backgroundColor = UIColor.white
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func dismissView(_ sender: Any) {
        print("sender: \(sender)")
        self.dismiss(animated: true) {
            print("view is dismissed")
        }
    }

    @IBAction func doneButtonTapped(_ sender: Any) {
        print("done button tapped")
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

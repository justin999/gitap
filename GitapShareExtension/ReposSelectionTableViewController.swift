//
//  ReposSelectionTableViewController.swift
//  GitapShareExtension
//
//  Created by Koichi Sato on 2017/10/08.
//  Copyright © 2017 Koichi Sato. All rights reserved.
//

import UIKit

protocol ReposSelectionTableViewControllerDelegate {
    func repoSelection(_ tableView: UITableView, didTapped indexPath: IndexPath, repoName: String)
}

class ReposSelectionTableViewController: UITableViewController {
    
    var privateReposNames = [String]()
    var publicRepoNames = [String]()
    var delegate: ReposSelectionTableViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return self.publicRepoNames.count
        case 1:
            return self.privateReposNames.count
        default:
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        var text: String
        switch indexPath.section {
        case 0:
            text = self.publicRepoNames[indexPath.row]
        case 1:
            text = self.privateReposNames[indexPath.row]
        default:
            text = ""
        }
        cell.textLabel?.text = text
        return cell
    }

    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Public"
        case 1:
            return "Private"
        default:
            return ""
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let repoName: String = tableView.cellForRow(at: indexPath)?.textLabel?.text ?? ""
        delegate?.repoSelection(tableView, didTapped: indexPath, repoName: repoName)
        self.navigationController?.popViewController(animated: true)
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

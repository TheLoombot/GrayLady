//
//  HomeTVC.swift
//  Gray Lady
//
//  Created by David on 1/6/17.
//  Copyright © 2017 QTScoder. All rights reserved.
//

import UIKit
import Contentful

class HomeTVC: UITableViewController, UICollectionViewDelegateFlowLayout {

     var arrayData = [Entry]()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        demodata()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    func demodata() {
        ManageContentful.sharedInstance.getEntryTypeBriefing { (arr) in
            if let arr = arr {
                self.arrayData = arr
                dispatch_async(dispatch_get_main_queue(),{
                    self.tableView.reloadData()
                })
            }
        }
    }

    // MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayData.count
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 44
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell.init(style: .Subtitle, reuseIdentifier: "Cell")
        let entry = arrayData[indexPath.row]

        cell.textLabel?.text = ManageContentful.sharedInstance.getTitleAndAuthor(entry).title
        cell.textLabel?.font = UIFont(name: "Hoefler Text", size: 15)
        cell.detailTextLabel?.text = ManageContentful.sharedInstance.getTitleAndAuthor(entry).author
        cell.detailTextLabel?.font = UIFont(name: "Hoefler Text", size: 10)
        cell.selectionStyle = .None
        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let detail = DetailPieceVC(entry: arrayData[indexPath.row])
        navigationController?.pushViewController(detail, animated: true)
        
    }


}

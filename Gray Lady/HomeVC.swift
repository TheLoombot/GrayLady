//
//  HomeVC.swift
//  Gray Lady
//
//  Created by David on 1/6/17.
//  Copyright © 2017 QTScoder. All rights reserved.
//

import UIKit
import Contentful

class HomeVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tbView: UITableView!
    var arrayData = [Entry]()


    override func viewDidLoad() {
        super.viewDidLoad()
        setNavi()
        tbView.tableFooterView = UIView()
        demodata()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func setNavi() {
        navigationItem.title = "HomeVC"
    }

    func demodata() {
        let client = Client(spaceIdentifier: Constrant.keyContentful.space, accessToken: Constrant.keyContentful.token)
        client.fetchEntries([Constrant.keyAPI.content_type : "briefing"]) { (resulft) in
            switch resulft {

            case let .Success(entry):
                self.arrayData.removeAll()
                for item in entry.items {
                    self.arrayData.append(item)
                }
                dispatch_async(dispatch_get_main_queue(),{
                    self.tbView.reloadData()
                })
            case .Error(_):
                print("Error!")
            }
        }
    }


    // MARK: - tableView

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayData.count
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 44
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell.init(style: .Subtitle, reuseIdentifier: "Cell")
        let entry = arrayData[indexPath.row]

        cell.textLabel?.text = entry.fields["briefingTitle"] as? String
        cell.textLabel?.font = UIFont(name: "Hoefler Text", size: 15)
        cell.detailTextLabel?.text = entry.fields["briefingAuthor"] as? String
        cell.detailTextLabel?.font = UIFont(name: "Hoefler Text", size: 10)
        cell.selectionStyle = .None
        return cell
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let detail = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("DetailBriefingVC") as! DetailBriefingVC
        detail.entry = arrayData[indexPath.row]
        navigationController?.pushViewController(detail, animated: true)

    }
    
    
    
    
    
}

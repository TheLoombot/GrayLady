//
//  HomeTVC.swift
//  Gray Lady
//
//  Created by David on 1/6/17.
//  Copyright © 2017 QTScoder. All rights reserved.
//

import UIKit
import Contentful

private let cellID = "HomeCellID"

class HomeTVC: UITableViewController {

    var arrayData = [Entry]()
    var isFirstLoad = true

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.register(HomeCell.self, forCellReuseIdentifier: cellID)
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        let refeshController = UIRefreshControl()
        refeshController.setText(isFirstload: true)
        refeshController.addTarget(self, action: #selector(hanleRefresh), for: .valueChanged)
        self.refreshControl = refeshController
        refeshController.beginRefreshing()
        hanleRefresh()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func hanleRefresh(){
        refreshControl?.setText(isFirstload: isFirstLoad)

        ManageContentful.sharedInstance.getEntryTypeBriefing { (arr) in
            if let arr = arr {
                self.arrayData = arr
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    OperationQueue.current?.addOperation({
                        self.refreshControl?.endRefreshing()
                        self.refreshControl?.setTextRefreshing(isFirstload: self.isFirstLoad)
                        self.isFirstLoad = false
                    })


                }

            }else {
                print("error")
                OperationQueue.current?.addOperation({
                    self.refreshControl?.endRefreshing()
                    self.refreshControl?.setText(isFirstload: self.isFirstLoad)
                    self.isFirstLoad = false
                })

            }
        }

    }

    func demodata() {

    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return arrayData.count
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let widthScreen = UIScreen.main.bounds.width
        let entry = arrayData[indexPath.row]
        let info = ManageContentful.sharedInstance.getTitleAndAuthor(entry)
        let dataPiece = entry.fields["piece"] as! [Any]
        let pieceFirst = dataPiece[0] as! Entry
        let author = "by " + info.author
        let infoPieceFirst = ManageContentful.sharedInstance.getInfoPiece_fromBriefing(pieceFirst)
        let heightImage = infoPieceFirst.infoImg.aspectImg() * UIScreen.main.bounds.width
        let hegithTitle = info.title.heightWithConstrainedWidth(width: widthScreen - 20, font: UIFont().fontApp(16))
        let heightAuthor = author.heightWithConstrainedWidth(width: widthScreen - 20, font: UIFont().fontApp(9))
        return heightImage + hegithTitle + heightAuthor + 10 + 5 + 5 + 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = HomeCell.init(style: .default, reuseIdentifier: cellID)
        let entry = arrayData[indexPath.row]
        cell.configcell(entry: entry)
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detail = DetailPieceVC(entry: arrayData[indexPath.row])
        navigationController?.pushViewController(detail, animated: true)        
    }
    
}

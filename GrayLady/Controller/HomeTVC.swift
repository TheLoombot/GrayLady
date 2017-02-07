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
private let cellLoadingId = "LoadingCell"

class HomeTVC: UITableViewController {

    var arrayData = [Entry]()
    var isFirstLoad = true
    var isloading = true
    var currentPage = 0
    var lastLoadCount = 0



    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.register(HomeCell.self, forCellReuseIdentifier: cellID)
        tableView.register(LoadMoreCell.self, forCellReuseIdentifier: cellLoadingId)
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

    // MARK: - LoadData

    func hanleRefresh(){
        refreshControl?.setText(isFirstload: isFirstLoad)
        isloading = true
        currentPage = 0
        lastLoadCount = 0
        ManageContentful.sharedInstance.getEntryBriefingPage(page: 0) { (arr) in
            self.isloading = false
            self.isFirstLoad = false
            if let arr = arr {
                self.arrayData = arr
                self.lastLoadCount = arr.count
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    OperationQueue.current?.addOperation({
                        self.refreshControl?.endRefreshing()
                    })
                }

            }else {
                self.lastLoadCount = -1
                self.refreshPaginationCell()
                OperationQueue.current?.addOperation({
                    self.refreshControl?.endRefreshing()
                })
            }
        }
    }

    func loadMoreData(page: Int) {
        isloading = true
        ManageContentful().getEntryBriefingPage(page: page) { (arr) in
            self.isloading = false

            if let arr = arr {
                self.lastLoadCount = arr.count
                self.arrayData += arr
                self.currentPage = page

                DispatchQueue.main.async {
                    self.tableView.reloadData()

                }

            }else {
                self.lastLoadCount = -1
                self.refreshPaginationCell()

            }


        }
    }


    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if shouldShowPaginationCell() {
            return arrayData.count + 1
        }

        return arrayData.count
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        if shouldShowPaginationCell() && indexPath == indexPathForPaginationCell() {
            return 44
        }
        let widthScreen = UIScreen.main.bounds.width
        let entry = arrayData[indexPath.row]
        let info = ManageContentful.sharedInstance.getTitleAndAuthor(entry)
        let dataPiece = entry.fields["piece"] as! [Any]
        let pieceFirst = dataPiece[0] as! Entry
        let author = "by " + info.author
        let infoPieceFirst = ManageContentful.sharedInstance.getInfoPiece_fromBriefing(pieceFirst)
        let heightImage = infoPieceFirst.infoImg.aspectImg() * widthScreen
        let hegithTitle = info.title.heightWithConstrainedWidth(width: widthScreen - 20, font: UIFont().fontApp(16))
        let heightAuthor = author.heightWithConstrainedWidth(width: widthScreen - 20, font: UIFont().fontApp(9))
        return heightImage + hegithTitle + heightAuthor + 10 + 5 + 5 + 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if shouldShowPaginationCell() && indexPath == indexPathForPaginationCell() {
             let loadmorecell = LoadMoreCell.init(style: .default, reuseIdentifier: cellLoadingId)
            return loadmorecell
        }
        let cell = HomeCell.init(style: .default, reuseIdentifier: cellID)
        let entry = arrayData[indexPath.row]
        cell.configcell(entry: entry)
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if shouldShowPaginationCell() && indexPath == indexPathForPaginationCell() {
            return
        }
        let detail = DetailPieceVC(entry: arrayData[indexPath.row])
        navigationController?.pushViewController(detail, animated: true)
    }

    //MARK: - load next page

    func refreshPaginationCell() {
        if shouldShowPaginationCell() {
            tableView.reloadRows(at: [indexPathForPaginationCell()], with: .automatic)
        }

    }

    func indexPathForPaginationCell() -> IndexPath {
        return IndexPath.init(row: arrayData.count, section: 0)
    }

    func shouldShowPaginationCell() -> Bool {
        return ( arrayData.count != 0 && (lastLoadCount == -1 || lastLoadCount >= ManageContentful.sharedInstance.ITEM))
    }

    // MARK: - ScrllViewDelegate

    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (scrollView.contentSize.height - scrollView.contentOffset.y ) < scrollView.bounds.size.height {
            if isloading == false  && lastLoadCount >= ManageContentful.sharedInstance.ITEM {
                loadMoreData(page: currentPage + 1)
                
            }
        }
    }
    
    
}

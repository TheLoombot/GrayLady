//
//  HomeTVC.swift
//  Gray Lady
//
//  Created by David on 1/6/17.
//  Copyright © 2017 QTScoder. All rights reserved.
//
import UIKit
import Contentful
import UserNotifications
import UserNotificationsUI

private let cellID = "HomeCellID"
private let cellLoadingId = "LoadingCell"

class HomeTVC: UITableViewController, UNUserNotificationCenterDelegate {

    var arrayData = [Entry]()
    var isFirstLoad = true
    var isloading = true
    var currentPage = 0
    var lastLoadCount = 0
    var indexphat: IndexPath?

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
        hanleRefresh()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    // MARK: - LoadData
    func hanleRefresh(){
        refreshControl?.beginRefreshing()
        refreshControl?.setText(isFirstload: isFirstLoad)
        isloading = true
        currentPage = 0
        lastLoadCount = 0
        ManageContentful.sharedInstance.getEntryBriefingPage(0) {[unowned self] (arr) in
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
//                self.showContentNotification()
               

            }else {
                self.lastLoadCount = -1
                self.refreshPaginationCell()
                OperationQueue.current?.addOperation({
                    self.refreshControl?.endRefreshing()
                })
            }
        }
    }

    func loadMoreDataAtPage(_ page: Int) {
        isloading = true
        ManageContentful().getEntryBriefingPage(page) {[unowned self]  (arr) in
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
                loadMoreDataAtPage(currentPage + 1)

            }
        }
    }
    // MARK: - Notificaiton

    func showContentNotification() {

        let content = NotificationContent(title: Constrant.appName, subTitle: "Sub title here", body: "and this is the body")
        if arrayData.count > 0 {
                       let entry: Entry = arrayData[0]
            let dataPiece = entry.fields["piece"] as! [Any]
            let pieceFirst = dataPiece[0] as! Entry
            let infoPieceFirst = ManageContentful.sharedInstance.getInfoPiece_fromBriefing(pieceFirst)
            guard  let imageData = NSData(contentsOf: URL(string: infoPieceFirst.infoImg.url)!) else { return }
            let fileManager = FileManager.default
            let tmpSubFolderName = ProcessInfo.processInfo.globallyUniqueString
            let tmpSubFolderURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(tmpSubFolderName, isDirectory: true)

            do {
                try fileManager.createDirectory(at: tmpSubFolderURL, withIntermediateDirectories: true, attributes: nil)
                let fileURL = tmpSubFolderURL.appendingPathComponent("image.jpg")
                try imageData.write(to: fileURL, options: [])
                let imageAttachment = try UNNotificationAttachment.init(identifier: Constrant.identifier.request, url: fileURL, options: [:])
                content.attachments.append(imageAttachment)

            } catch let error {
                print("error \(error)")
            }
        }
         let request = UNNotificationRequest(identifier: Constrant.identifier.request, content: content, trigger: nil)

        UNUserNotificationCenter.current().add(request) { error in
            UNUserNotificationCenter.current().delegate = self
            if (error != nil){
                //handle here
            }
        }

    }

    func showDelayedNotification() {
         let content = NotificationContent(title: Constrant.appName, subTitle: "Sub title here", body: "and this is the body")
        if arrayData.count > 0 {
            let entry: Entry = arrayData[0]
            let dataPiece = entry.fields["piece"] as! [Any]
            let pieceFirst = dataPiece[0] as! Entry
            let infoPieceFirst = ManageContentful.sharedInstance.getInfoPiece_fromBriefing(pieceFirst)
            guard  let imageData = NSData(contentsOf: URL(string: infoPieceFirst.infoImg.url)!) else { return }
            let fileManager = FileManager.default
            let tmpSubFolderName = ProcessInfo.processInfo.globallyUniqueString
            let tmpSubFolderURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(tmpSubFolderName, isDirectory: true)

            do {
                try fileManager.createDirectory(at: tmpSubFolderURL, withIntermediateDirectories: true, attributes: nil)
                let fileURL = tmpSubFolderURL.appendingPathComponent("image.jpg")
                try imageData.write(to: fileURL, options: [])
                let imageAttachment = try UNNotificationAttachment.init(identifier: Constrant.identifier.request, url: fileURL, options: [:])
                content.attachments.append(imageAttachment)

            } catch let error {
                print("error \(error)")
            }
        }
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)




        let request = UNNotificationRequest(identifier: Constrant.identifier.request, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { error in
            UNUserNotificationCenter.current().delegate = self
            if (error != nil){
                //handle here
            }
        }
    }

    // MARK: UNUserNotificationCenterDelegate

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print(notification.request.content.attachments)
        completionHandler( [.alert, .badge, .sound])

    }

    func pushDetailFirst() {
        guard  arrayData.count > 0 else {
            return
        }
        let detail = DetailPieceVC(entry: arrayData[0])
        navigationController?.pushViewController(detail, animated: true)

    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
       pushDetailFirst()

    }
    
}

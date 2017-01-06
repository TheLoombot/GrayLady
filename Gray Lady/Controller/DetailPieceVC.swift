//
//  DetailPieceVC.swift
//  Gray Lady
//
//  Created by David on 1/6/17.
//  Copyright © 2017 QTScoder. All rights reserved.
//

import UIKit
import Contentful
import SDWebImage



private let cellId = "DetailPieceCell"
class DetailPieceVC: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate {

    var entry: Entry?
    var arrayData =  [Any]()

    convenience init(entry: Entry) {
        self.init()
        self.entry = entry
        arrayData = entry.fields["piece"] as! [Any]
    }


    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .Horizontal

        layout.minimumLineSpacing = 0
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .whiteColor()
        cv.registerClass(DetailPieceCell.self, forCellWithReuseIdentifier: cellId)
        cv.delegate = self
        cv.dataSource = self
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.pagingEnabled = true
        cv.clipsToBounds = true

        return cv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(collectionView)       
        setupLayoutCollectionview()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }

    func setupLayoutCollectionview() {
        collectionView.topAnchor.constraintEqualToAnchor(self.topLayoutGuide.topAnchor).active = true
        collectionView.bottomAnchor.constraintEqualToAnchor(self.bottomLayoutGuide.bottomAnchor).active = true
        collectionView.rightAnchor.constraintEqualToAnchor(view.rightAnchor).active = true
        collectionView.leftAnchor.constraintEqualToAnchor(view.leftAnchor).active = true
    }

    //MARK: - collection View
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayData.count
    }


    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {

        let cell = self.collectionView.dequeueReusableCellWithReuseIdentifier(cellId, forIndexPath: indexPath) as! DetailPieceCell
        let data = arrayData[indexPath.row] as! Entry
        configCell(cell, entry: data)
        return cell
        
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height - 64)
    }

    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        print("tap")
    }

    func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let pageNumber = Int(targetContentOffset.memory.x / view.frame.width)


    }

    func configCell(cell: DetailPieceCell, entry: Entry) {
        cell.lblcaptionImg.text = ManageContentful.sharedInstance.getInfoPiece_fromBriefing(entry).imgCaption
        cell.lblcontentPiece.text = ManageContentful.sharedInstance.getInfoPiece_fromBriefing(entry).pieceContent
        let str = ManageContentful.sharedInstance.getInfoPiece_fromBriefing(entry).urlImg

        cell.imgView.sd_setImageWithURL(NSURL(string: str)) { (image, error, sdcache, urlstring) in
            if (error != nil) {
                return
            }
           let aspect = image.size.height / image.size.width
            cell.heightImg?.constant = aspect * UIScreen.mainScreen().bounds.width
        }


    }


    
    
    
}

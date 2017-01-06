//
//  DetailBriefingVC.swift
//  Gray Lady
//
//  Created by David on 1/6/17.
//  Copyright © 2017 QTScoder. All rights reserved.
//

import UIKit
import Contentful
import SDWebImage

class DetailBriefingVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var collectionView: UICollectionView!
    var entry: Entry?
    var arrayData =  [Any]()

    convenience init(entry: Entry) {
        self.init()
        self.entry = entry
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setNavi()
        arrayData = entry!.fields["piece"] as! [Any]
    }


    func setNavi() {
        navigationItem.title = entry!.fields["briefingTitle"] as? String
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - CollectionView

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       
        return arrayData.count
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("DettailViewCell", forIndexPath: indexPath) as! DettailViewCell
        let data = arrayData[indexPath.row] as! Entry
        configCell(cell, entry: data)


        return cell

    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {

        return collectionView.bounds.size
    }

    func configCell(cell: DettailViewCell, entry: Entry) {
        cell.lblCaptionImg.text = entry.fields["imageCaption"] as? String
        cell.lblpieceTextContent.text = entry.fields["pieceTextContent"] as? String
        print(entry.fields["image"])





    }

    

    
    
    
}

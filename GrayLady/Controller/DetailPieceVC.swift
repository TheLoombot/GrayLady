//
//  DetailPieceVC.swift
//  Gray Lady
//
//  Created by David on 1/6/17.
//  Copyright © 2017 QTScoder. All rights reserved.
//

import UIKit
import Contentful
import Kingfisher
import SafariServices

private let cellId = "DetailPieceCell"
class DetailPieceVC: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate, UITextViewDelegate {

    var entry: Entry?
    var arrayData =  [Any]()

    convenience init(entry: Entry) {
        self.init()
        self.entry = entry
        arrayData = entry.fields["piece"] as! [Any]
    }

    let backGroundImgView = UIView()


    lazy var collectionView: UICollectionView = {

        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0

        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        cv.register(DetailPieceCell.self, forCellWithReuseIdentifier: cellId)
        cv.delegate = self
        cv.dataSource = self
        cv.isPagingEnabled = true
        cv.clipsToBounds = true
        cv.showsVerticalScrollIndicator = false
        cv.showsHorizontalScrollIndicator = false

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
        view.addConstraintsWithFormat("H:|[v0]|", views: collectionView)
        view.addConstraintsWithFormat("V:|[v0]|", views: collectionView)
    }

    //MARK: - collection View

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayData.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! DetailPieceCell
        let data = arrayData[indexPath.row] as! Entry
        configCell(cell,indexPath: indexPath, entry: data)
        return cell

    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height)
    }

    func configCell(_ cell: DetailPieceCell, indexPath: IndexPath, entry: Entry) {

        let info = ManageContentful.sharedInstance.getInfoPiece_fromBriefing(entry)
        cell.configCell(entry: entry)
        cell.txvContent.delegate = self


        cell.handTapContent = {

            if indexPath.item < self.arrayData.count - 1 {
                let nextIndexPath = IndexPath(row: indexPath.item + 1, section: 0)
                self.collectionView.scrollToItem(at: nextIndexPath, at: UICollectionViewScrollPosition(), animated: true)
            }else {
                _ = self.navigationController?.popViewController(animated: true)

            }
        }

        cell.handTapImg = {
            self.backGroundImgView.frame = self.view.frame
            self.backGroundImgView.backgroundColor = .clear

            if let startFrame = cell.imgView.superview?.convert(cell.imgView.frame, to: nil) {
                let preView = PreviewImage.init(info: info.infoImg)

                self.backGroundImgView.frame = self.view.frame
                self.view.addSubview(self.backGroundImgView)

                preView.frame = startFrame
                self.backGroundImgView.addSubview(preView)

                UIView.animate(withDuration: 0.35, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: { () -> Void in
                    preView.frame = self.view.frame
                    preView.scrollView.frame = self.view.frame
                    preView.imgView.frame = CGRect(x: 0, y: 0, width: self.view.frame.height / preView.imgInfo.aspectImg(), height: self.view.frame.size.height)
                    preView.scrollView.contentSize = preView.imgView.frame.size
                    let centerXoffset = (preView.scrollView.contentSize.width - preView.scrollView.frame.width) / 2
                    preView.scrollView.setContentOffset(CGPoint.init(x: centerXoffset, y: 0), animated: false)
                    
                }, completion: { (didComplete) -> Void in
                    self.backGroundImgView.backgroundColor = .black
                })

                preView.hadleDismissTapImg = {
                    self.backGroundImgView.backgroundColor = .clear

                    if let startFrame = cell.imgView.superview?.convert(cell.imgView.frame, to: nil) {
                        UIView.animate(withDuration: 0.35, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: { () -> Void in
                            preView.imgView.frame = startFrame
                            preView.scrollView.setContentOffset(CGPoint.init(x: 0, y: 0), animated: false)

                        }, completion: { (didComplete) -> Void in
                            preView.removeFromSuperview()
                            self.backGroundImgView.removeFromSuperview()
                        })

                    }
                }
            }
        }
       
    }

    //MARK: - TextViewDelegate


    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        let safari = SFSafariViewController(url: URL)
        safari.modalPresentationStyle = .overFullScreen
        present(safari, animated: true, completion: nil)
        return false
        
    }
    
    
    
    
    
    
    
    
    
    
}




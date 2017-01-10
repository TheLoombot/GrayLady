//
//  DetailPieceVC.swift
//  Gray Lady
//
//  Created by David on 1/6/17.
//  Copyright © 2017 QTScoder. All rights reserved.
//

import UIKit
import Contentful
import INSPhotoGallery
import Kingfisher

private let cellId = "DetailPieceCell"
class DetailPieceVC: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate {

    var entry: Entry?
    var arrayData =  [Any]()
    lazy var photos = [INSPhotoViewable]()

    convenience init(entry: Entry) {
        self.init()
        self.entry = entry
        arrayData = entry.fields["piece"] as! [Any]

        for data in arrayData {
            let tempData = data as! Entry
            let strigUrl = ManageContentful.sharedInstance.getInfoPiece_fromBriefing(tempData).urlImg
            let photo = INSPhoto.init(imageURL: URL.init(string: strigUrl), thumbnailImageURL: nil)
            photos.append(photo)

        }

    }

    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0

        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        cv.register(DetailPieceCell.self, forCellWithReuseIdentifier: cellId)
        cv.delegate = self
        cv.dataSource = self
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.isPagingEnabled = true
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
        collectionView.topAnchor.constraint(equalTo: self.topLayoutGuide.topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: self.bottomLayoutGuide.bottomAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        collectionView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
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
        return CGSize(width: view.frame.width, height: view.frame.height - 64)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        if indexPath.item < arrayData.count - 1 {
            let nextIndexPath = IndexPath(row: indexPath.item + 1, section: 0)
            collectionView.scrollToItem(at: nextIndexPath, at: UICollectionViewScrollPosition(), animated: true)
        }else {

        }
    }

    func configCell(_ cell: DetailPieceCell, indexPath: IndexPath, entry: Entry) {
        cell.lblcaptionImg.text = ManageContentful.sharedInstance.getInfoPiece_fromBriefing(entry).imgCaption
        cell.lblcontentPiece.text = ManageContentful.sharedInstance.getInfoPiece_fromBriefing(entry).pieceContent
        let str = ManageContentful.sharedInstance.getInfoPiece_fromBriefing(entry).urlImg
        cell.lblcontentPiece.text!.delectedUrl()
        cell.imgView.kf.setImage(with: URL(string: str), placeholder: nil, options: nil, progressBlock: nil) { (img, err, cache, url) in
            if err == nil  {
                if let img = img {
                    let aspect = img.size.height / img.size.width
                    cell.heightImg?.constant = aspect * UIScreen.main.bounds.width
                }

            }

        }
        cell.handTapContent = {
            if indexPath.item < self.arrayData.count - 1 {
                let nextIndexPath = IndexPath(row: indexPath.item + 1, section: 0)
                self.collectionView.scrollToItem(at: nextIndexPath, at: UICollectionViewScrollPosition(), animated: true)
            }else {
                _ = self.navigationController?.popViewController(animated: true)

            }



        }
        cell.handTapImg = {

            let galleryPreview = INSPhotosViewController(photos: self.photos, initialPhoto: self.photos[indexPath.item] as INSPhotoViewable?, referenceView: cell)

            galleryPreview.referenceViewForPhotoWhenDismissingHandler = { [weak self] photo in
                if let index = self?.photos.index(where: {$0 === photo}) {
                    let indexPath = IndexPath.init(row: index, section: 0)
                    return self?.collectionView.cellForItem(at: indexPath) as? DetailPieceCell
                }
                return nil
            }
            self.present(galleryPreview, animated: true, completion: nil)
            
            
        }
    }
    
}




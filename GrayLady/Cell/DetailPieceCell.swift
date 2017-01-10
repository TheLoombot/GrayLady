//
//  DetailPieceCell.swift
//  Gray Lady
//
//  Created by David on 1/6/17.
//  Copyright © 2017 QTScoder. All rights reserved.
//

import UIKit

class DetailPieceCell: UICollectionViewCell {

    typealias actionBlock = () ->()

    var handTapImg: actionBlock?
    var handTapContent: actionBlock?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var heightImg : NSLayoutConstraint?

    lazy var imgView: UIImageView = {
        let imgV = UIImageView()
        imgV.backgroundColor = .lightGray
        imgV.translatesAutoresizingMaskIntoConstraints = false
        imgV.contentMode = .scaleAspectFill
        imgV.clipsToBounds = true
        let tapImg = UITapGestureRecognizer(target: self, action: #selector(handleTapImg))
        imgV.addGestureRecognizer(tapImg)
        imgV.isUserInteractionEnabled = true

        return imgV
    }()

    lazy var scrollView: UIScrollView = {
        let sc = UIScrollView()
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.clipsToBounds = true
        return sc
    }()

    lazy var lblcaptionImg: UILabel = {
        let lbl = UILabel()
        lbl.textColor = UIColor.lightGray
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = UIFont().fontApp(11)
        lbl.numberOfLines = 0
        return lbl
    }()

    lazy var lblcontentPiece: UILabel = {
        let lbl = UILabel()
        lbl.textColor = UIColor.black
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = UIFont().fontApp(24)
        lbl.numberOfLines = 0
        return lbl
    }()

    func setupView() {
        backgroundColor = .white
        scrollView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapcontentView)))
        addSubview(scrollView)
        // fix collectionView didSelectItemAtIndexPath
//        scrollView.userInteractionEnabled = false
//        contentView.addGestureRecognizer(scrollView.panGestureRecognizer)

        layoutScrollview()
    }

    func layoutScrollview() {

        scrollView.addSubview(imgView)
        scrollView.addSubview(lblcaptionImg)
        scrollView.addSubview(lblcontentPiece)

        scrollView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        scrollView.widthAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
        scrollView.heightAnchor.constraint(equalTo: contentView.heightAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        scrollView.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true


        imgView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        imgView.leftAnchor.constraint(equalTo: scrollView.leftAnchor).isActive = true
        imgView.widthAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
        heightImg = imgView.heightAnchor.constraint(equalToConstant: 0)
        heightImg?.isActive = true

        lblcaptionImg.topAnchor.constraint(equalTo: imgView.bottomAnchor, constant: 10).isActive = true
        lblcaptionImg.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 10).isActive = true
        lblcaptionImg.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant:  -20).isActive = true

        lblcontentPiece.topAnchor.constraint(equalTo: lblcaptionImg.bottomAnchor, constant: 10).isActive = true
        lblcontentPiece.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant:  10).isActive = true
        lblcontentPiece.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -20).isActive = true
        lblcontentPiece.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        
        
    }

    func handleTapImg() {

        handTapImg!()
    }

    func handleTapcontentView() {
        print("tapcontent")
        handTapContent!()
    }

}

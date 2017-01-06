//
//  DetailPieceCell.swift
//  Gray Lady
//
//  Created by David on 1/6/17.
//  Copyright © 2017 QTScoder. All rights reserved.
//

import UIKit

class DetailPieceCell: UICollectionViewCell {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }


    var heightImg : NSLayoutConstraint?



    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }



    lazy var imgView: UIImageView = {
        let imgV = UIImageView()
        imgV.backgroundColor = .lightGrayColor()
        imgV.translatesAutoresizingMaskIntoConstraints = false
        imgV.contentMode = .ScaleAspectFill
        imgV.clipsToBounds = true
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
        lbl.textColor = UIColor.lightGrayColor()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = UIFont.systemFontOfSize(11)
        lbl.numberOfLines = 0
        lbl.sizeToFit()
        return lbl
    }()

    lazy var lblcontentPiece: UILabel = {
        let lbl = UILabel()
        lbl.textColor = UIColor.blackColor()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = UIFont.systemFontOfSize(11)
        lbl.numberOfLines = 0
        lbl.sizeToFit()
        return lbl
    }()

    func setupView() {
        backgroundColor = .whiteColor()
        contentView.userInteractionEnabled = true
        addSubview(scrollView)

        layoutScrollview()
    }

    func layoutScrollview() {

        scrollView.addSubview(imgView)
        scrollView.addSubview(lblcaptionImg)
        scrollView.addSubview(lblcontentPiece)

        scrollView.topAnchor.constraintEqualToAnchor(contentView.topAnchor).active = true
        scrollView.bottomAnchor.constraintEqualToAnchor(contentView.bottomAnchor).active = true
        scrollView.widthAnchor.constraintEqualToAnchor(contentView.widthAnchor).active = true
        scrollView.heightAnchor.constraintEqualToAnchor(contentView.heightAnchor).active = true
        scrollView.rightAnchor.constraintEqualToAnchor(contentView.rightAnchor).active = true
        scrollView.leftAnchor.constraintEqualToAnchor(contentView.leftAnchor).active = true


        imgView.topAnchor.constraintEqualToAnchor(scrollView.topAnchor).active = true
        imgView.leftAnchor.constraintEqualToAnchor(scrollView.leftAnchor).active = true
        imgView.widthAnchor.constraintEqualToAnchor(contentView.widthAnchor).active = true
        heightImg = imgView.heightAnchor.constraintEqualToConstant(0)
        heightImg?.active = true


        lblcaptionImg.topAnchor.constraintEqualToAnchor(imgView.bottomAnchor, constant: 10).active = true
        lblcaptionImg.leftAnchor.constraintEqualToAnchor(scrollView.leftAnchor, constant: 10).active = true
        lblcaptionImg.widthAnchor.constraintEqualToAnchor(scrollView.widthAnchor, constant:  -20).active = true

        lblcontentPiece.topAnchor.constraintEqualToAnchor(lblcaptionImg.bottomAnchor, constant: 10).active = true
        lblcontentPiece.leftAnchor.constraintEqualToAnchor(scrollView.leftAnchor, constant:  10).active = true
        lblcontentPiece.widthAnchor.constraintEqualToAnchor(scrollView.widthAnchor, constant: -20).active = true
        lblcontentPiece.bottomAnchor.constraintEqualToAnchor(scrollView.bottomAnchor).active = true
        
        
        
        
        
    }
    
    
    
    
    
    
    
}

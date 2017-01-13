//
//  DetailPieceCell.swift
//  Gray Lady
//
//  Created by David on 1/6/17.
//  Copyright © 2017 QTScoder. All rights reserved.
//

import UIKit
import Contentful
import MarkdownKit


class DetailPieceCell: UICollectionViewCell, UIGestureRecognizerDelegate {

    typealias actionBlock = () ->()
    var handTapImg: actionBlock?
    var handTapContent: actionBlock?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
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
        sc.showsHorizontalScrollIndicator = false
        sc.showsVerticalScrollIndicator = false
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
    lazy var txvContent: UITextView = {
        let txv = UITextView()
        txv.isScrollEnabled = false
        txv.isEditable = false
        txv.translatesAutoresizingMaskIntoConstraints = false
        txv.linkTextAttributes = [NSForegroundColorAttributeName: UIColor().colorLink()]
        return txv
    }()

    func setupViews() {
        backgroundColor = .white
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTapcontentView(gestureReconizer:)))
        tap.delegate = self
        scrollView.addGestureRecognizer(tap)
        tap.cancelsTouchesInView = false
        addSubview(scrollView)
        layoutScrollview()
    }

    func layoutScrollview() {

        scrollView.addSubview(imgView)
        scrollView.addSubview(lblcaptionImg)
        scrollView.addSubview(txvContent)

        addConstraintsWithFormat("H:|[v0]|", views: scrollView)
        addConstraintsWithFormat("V:|[v0]|", views: scrollView)
        scrollView.widthAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
        scrollView.heightAnchor.constraint(equalTo: contentView.heightAnchor).isActive = true


        imgView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        imgView.leftAnchor.constraint(equalTo: scrollView.leftAnchor).isActive = true
        imgView.widthAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
        heightImg = imgView.heightAnchor.constraint(equalToConstant: 150)
        heightImg?.isActive = true

        lblcaptionImg.topAnchor.constraint(equalTo: imgView.bottomAnchor, constant: 10).isActive = true
        scrollView.addConstraintsWithFormat("H:|-10-[v0]-10-|", views: lblcaptionImg)
        lblcaptionImg.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant:  -20).isActive = true

        txvContent.topAnchor.constraint(equalTo: lblcaptionImg.bottomAnchor, constant: 7).isActive = true
        txvContent.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant:  7).isActive = true
        txvContent.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -14).isActive = true
        txvContent.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true


    }

    func handleTapImg() {

        handTapImg!()
    }

    func handleTapcontentView(gestureReconizer: UITapGestureRecognizer) {
        handTapContent!()
    }

    func configCell(entry: Entry) {
        let info = ManageContentful.sharedInstance.getInfoPiece_fromBriefing(entry)
        self.lblcaptionImg.text = info.imgCaption
        let markdown = MarkdownParser.init(font: UIFont().fontApp(24), automaticLinkDetectionEnabled: false)
        txvContent.attributedText = markdown.parse(info.pieceContent)
        self.heightImg?.constant = info.infoImg.aspectImg() * UIScreen.main.bounds.width
        let str = info.infoImg.url
        imgView.kf.setImage(with: URL.init(string: str))
    }
    
}

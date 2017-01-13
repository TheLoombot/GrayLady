//
//  DetailPieceCell.swift
//  Gray Lady
//
//  Created by David on 1/6/17.
//  Copyright © 2017 QTScoder. All rights reserved.
//

import UIKit
import TTTAttributedLabel
import Contentful

class DetailPieceCell: UICollectionViewCell, UIGestureRecognizerDelegate {

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

    lazy var lblcontentPiece: TTTAttributedLabel = {
        let lbl = TTTAttributedLabel.init(frame: .zero)
        lbl.textColor = UIColor.black
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = UIFont().fontApp(24)
        lbl.numberOfLines = 0
        lbl.linkAttributes = [NSForegroundColorAttributeName: UIColor().colorLink()]
        lbl.activeLinkAttributes = [NSForegroundColorAttributeName: UIColor.black]

        return lbl
    }()

    func setupView() {
        backgroundColor = .white
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTapcontentView(gestureReconizer:)))
        tap.delegate = self
        scrollView.addGestureRecognizer(tap)
        tap.cancelsTouchesInView = false
        addSubview(scrollView)

        // fix collectionView didSelectItemAtIndexPath
        //        scrollView.isUserInteractionEnabled = false
        //        contentView.addGestureRecognizer(scrollView.panGestureRecognizer)

        layoutScrollview()
    }

    func layoutScrollview() {

        scrollView.addSubview(imgView)
        scrollView.addSubview(lblcaptionImg)
        scrollView.addSubview(lblcontentPiece)

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

        lblcontentPiece.topAnchor.constraint(equalTo: lblcaptionImg.bottomAnchor, constant: 10).isActive = true
        lblcontentPiece.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant:  10).isActive = true
        lblcontentPiece.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -20).isActive = true
        lblcontentPiece.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true


    }

    func handleTapImg() {

        handTapImg!()
    }

    func handleTapcontentView(gestureReconizer: UITapGestureRecognizer) {
        handTapContent!()
    }

    func configCell(entry: Entry) {
        let info = ManageContentful.sharedInstance.getInfoPiece_fromBriefing(entry)
        let contentText = info.pieceContent.delectedUrl()
        self.lblcaptionImg.text = info.imgCaption
        self.lblcontentPiece.text = contentText.1
        self.heightImg?.constant = info.infoImg.aspectImg() * UIScreen.main.bounds.width
        let str = info.infoImg.url
        for diectLink in contentText.0 {
            if let range = contentText.1.range(of: diectLink.strShow) {
                print(range)

                lblcontentPiece.addLink(to: URL.init(string: diectLink.url), with:(lblcontentPiece.text!.nsRange(fromRange: range)))

            }
        }
        imgView.kf.setImage(with: URL.init(string: str))
    }

    // MARK: - UIGestureRecognizerDelegate

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {

        if (touch.view?.isKind(of: TTTAttributedLabel.classForCoder()))! {
            let point = touch.location(in: lblcontentPiece)
            print(point)
            print(lblcontentPiece.containslink(at: point))
            if lblcontentPiece.containslink(at: point) {
                return false
            }else {
                return true
            }
            
        }else {
            return true
        }
    }
    
    
    
}

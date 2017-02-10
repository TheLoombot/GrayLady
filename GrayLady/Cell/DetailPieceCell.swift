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


class DetailPieceCell: UICollectionViewCell, UIGestureRecognizerDelegate, NSLayoutManagerDelegate {

    typealias actionBlock = () ->()
    var handTapImg: actionBlock?
    var handTapContent: actionBlock?
    var handTapLink: actionBlock?
    var link: URL?

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
        txv.layoutManager.delegate = self
        txv.linkTextAttributes = [NSForegroundColorAttributeName: UIColor().colorLink(), NSUnderlineStyleAttributeName: true]
        txv.isSelectable = false
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

        addConstraintsWithFormat("H:|[v0(\(contentView.frame.width))]|", views: scrollView)
        addConstraintsWithFormat("V:|[v0(\(contentView.frame.height))]|", views: scrollView)

        heightImg = imgView.heightAnchor.constraint(equalToConstant: 150)
        heightImg?.isActive = true

        scrollView.addConstraintsWithFormat("H:|[v0(\(contentView.frame.width))]|", views: imgView)
        scrollView.addConstraintsWithFormat("H:|-7-[v0]-7-|", views: txvContent)
        scrollView.addConstraintsWithFormat("H:|-10-[v0]-10-|", views: lblcaptionImg)
        scrollView.addConstraintsWithFormat("V:|[v0]-10-[v1]-7-[v2]|", views: imgView, lblcaptionImg, txvContent)

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

    // MARK: - gestureRecognizer delegate

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        guard (touch.view?.isKind(of: UITextView.classForCoder()))! else { return true

        }
        let point = touch.location(in: txvContent)
        let textPosition = txvContent.closestPosition(to: point)
        let attr = txvContent.textStyling(at: textPosition!, in: .forward)
        if let url = attr?["NSLink"]  {
            link = url as? URL
            handTapLink?()
            return false
        }
        return true
    }

    // MARK: - LayuotDelegate

    func layoutManager(_ layoutManager: NSLayoutManager, lineSpacingAfterGlyphAt glyphIndex: Int, withProposedLineFragmentRect rect: CGRect) -> CGFloat {
        return 5
    }






}

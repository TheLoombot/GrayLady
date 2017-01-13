//
//  HomeCell.swift
//  Gray Lady
//
//  Created by David on 1/13/17.
//  Copyright © 2017 QTScoder. All rights reserved.
//

import UIKit
import Contentful

class HomeCell: UITableViewCell {

    override init(style: UITableViewCellStyle , reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()

    }

    var heightImage: NSLayoutConstraint?

    lazy var imgView: UIImageView = {
        let imgV = UIImageView()
        imgV.backgroundColor = .lightGray
        imgV.translatesAutoresizingMaskIntoConstraints = false
        imgV.contentMode = .scaleAspectFill
        imgV.clipsToBounds = true

        return imgV
    }()

    let lblTitle: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont().fontApp(16)
        lbl.textColor = .black
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()

    let lblAuthor: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont().fontApp(9)
        lbl.textColor = .darkGray
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()

    let lineView: UIView = {
        let v = UIView()
        v.backgroundColor = .lightGray
        return v
    }()

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func setupViews() {
        addSubview(imgView)
        addSubview(lblTitle)
        addSubview(lblAuthor)
        addSubview(lineView)
        setUpLayoutSubViews()

    }

    func setUpLayoutSubViews() {
        addConstraintsWithFormat("H:|[v0]|", views: imgView)
        addConstraintsWithFormat("H:|-10-[v0]-10-|", views: lblTitle)
        addConstraintsWithFormat("H:|-10-[v0]-10-|", views: lblAuthor)
        addConstraintsWithFormat("H:|[v0]|", views: lineView)
        addConstraintsWithFormat("V:|[v0]-10-[v1]-5-[v2]-5-[v3(1)]|", views: imgView, lblTitle, lblAuthor,lineView)
        heightImage = imgView.heightAnchor.constraint(equalToConstant: 100)
        heightImage?.isActive = true
    }

    func configcell(entry: Entry) {
        
         let info = ManageContentful.sharedInstance.getTitleAndAuthor(entry)
        lblTitle.text = info.title
        lblAuthor.text = "by " + info.author
        
        let dataPiece = entry.fields["piece"] as! [Any]
        let pieceFirst = dataPiece[0] as! Entry
        let infoPieceFirst = ManageContentful.sharedInstance.getInfoPiece_fromBriefing(pieceFirst)
        heightImage?.constant = infoPieceFirst.infoImg.aspectImg() * UIScreen.main.bounds.width
        imgView.kf.setImage(with: URL.init(string: infoPieceFirst.infoImg.url))
    }

}

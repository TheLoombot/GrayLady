//
//  LoadMoreCell.swift
//  Gray Lady
//
//  Created by David on 1/22/17.
//  Copyright © 2017 QTScoder. All rights reserved.
//

import UIKit

class LoadMoreCell: UITableViewCell {

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        contentView.addSubview(activiView)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    let activiView: UIActivityIndicatorView = {
        let activi = UIActivityIndicatorView()
        activi.activityIndicatorViewStyle = .gray
        activi.startAnimating()
        return activi
    }()

    func setupViews() {
        contentView.addConstraintsWithFormat("V:|-8-[v0]", views: activiView)
        activiView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true

    }
}

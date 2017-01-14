//
//  PreviewImage.swift
//  Gray Lady
//
//  Created by David on 1/10/17.
//  Copyright © 2017 QTScoder. All rights reserved.
//

import UIKit

class PreviewImage: UIView {

    typealias actionBLock = () -> ()
    var hadleDismissTapImg: actionBLock?

    var imgInfo: InfoImage = {
        let info = InfoImage.init(url: "", height: 0, width: 1)
        return info
    }()

    let scrollView: UIScrollView = {
        let sc = UIScrollView()
        sc.showsVerticalScrollIndicator = false
        sc.showsHorizontalScrollIndicator = false
        return sc
    }()

    lazy var imgView: UIImageView = {
        let imgV = UIImageView()
        imgV.backgroundColor = .lightGray
        imgV.contentMode = .scaleAspectFit
        imgV.clipsToBounds = true

        return imgV
    }()

    init(info: InfoImage) {

        self.imgInfo = info
        super.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width * info.aspectImg()))
        addSubview(scrollView)
        imgView.frame = scrollView.frame
        scrollView.frame = self.frame
        scrollView.addSubview(imgView)
        imgView.frame = self.frame
        imgView.isUserInteractionEnabled = true
        imgView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleZoomOut)))
        imgView.kf.setImage(with: URL(string: info.url))

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func handleZoomOut() {
        hadleDismissTapImg!()
    }

}

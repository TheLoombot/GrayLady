//
//  PreviewImage.swift
//  Gray Lady
//
//  Created by David on 1/10/17.
//  Copyright © 2017 QTScoder. All rights reserved.
//

import UIKit

class PreviewImage: UIViewController {

    var urlImg: String?


   let scrollView: UIScrollView = {
        let sc = UIScrollView()
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.clipsToBounds = true
        sc.backgroundColor = .red
        return sc
    }()

    let activity: UIActivityIndicatorView = {
        let aiV = UIActivityIndicatorView()
        return aiV
    }()

    let btnClose: UIButton = {
        let btn = UIButton()
        btn.setTitle("Close", for: UIControlState())
        btn.tintColor = .white
        return btn
    }()

    lazy var imgView: UIImageView = {
        let imgV = UIImageView()
        imgV.backgroundColor = .black
        imgV.contentMode = .scaleAspectFill
        imgV.translatesAutoresizingMaskIntoConstraints = false
        return imgV
    }()

    let cationImgView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.init(white: 0, alpha: 0.5)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    let lblcaption: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.numberOfLines = 0
        lbl.font = UIFont().fontApp(13)
        lbl.isHidden = true
        return lbl
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(scrollView)
        view.addSubview(btnClose)
        layoutView()


    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }

    // MARK: - Layout Scroll

    func layoutView() {
//        scrollView.addSubview(imgView)
//        scrollView.addSubview(activity)
//        activity.startAnimating()
//        scrollView.addSubview(cationImgView)
//        cationImgView.addSubview(lblcaption)
        scrollView.topAnchor.constraint(equalTo: self.topLayoutGuide.bottomAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: self.bottomLayoutGuide.topAnchor).isActive = true
        scrollView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        scrollView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        scrollView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true

//        activity.centerXAnchor.constraintEqualToAnchor(scrollView.centerXAnchor).active = true
//        activity.centerYAnchor.constraintEqualToAnchor(scrollView.centerYAnchor).active = true

//        imgView.topAnchor.constraintEqualToAnchor(scrollView.topAnchor).active = true
////        imgView.bottomAnchor.constraintEqualToAnchor(scrollView.bottomAnchor).active = true
//        imgView.leftAnchor.constraintEqualToAnchor(scrollView.leftAnchor).active = true
//        imgView.topAnchor.constraintEqualToAnchor(scrollView.rightAnchor).active = true
//        imgView.widthAnchor.constraintEqualToAnchor(scrollView.widthAnchor)
//        
//
//        cationImgView.bottomAnchor.constraintEqualToAnchor(scrollView.bottomAnchor).active = true
//        cationImgView.heightAnchor.constraintEqualToConstant(50).active = true
//        cationImgView.leftAnchor.constraintEqualToAnchor(scrollView.leftAnchor).active = true
//        cationImgView.rightAnchor.constraintEqualToAnchor(scrollView.rightAnchor).active = true
//
//        lblcaption.leftAnchor.constraintEqualToAnchor(cationImgView.leftAnchor, constant: 10).active = true
//        lblcaption.rightAnchor.constraintEqualToAnchor(cationImgView.rightAnchor, constant: 10).active = true
//        lblcaption.bottomAnchor.constraintEqualToAnchor(cationImgView.bottomAnchor, constant: 10).active = true
//        lblcaption.topAnchor.constraintEqualToAnchor(cationImgView.topAnchor, constant: 10).active = true
        btnClose.topAnchor.constraint(equalTo: self.topLayoutGuide.bottomAnchor, constant: 30).isActive = true
        btnClose.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 10).isActive = true
        btnClose.widthAnchor.constraint(equalToConstant: 100).isActive = true
        btnClose.heightAnchor.constraint(equalToConstant: 44).isActive = true

    }


    



}

//
//  Extensions.swift
//  Gray Lady
//
//  Created by David on 1/10/17.
//  Copyright © 2017 QTScoder. All rights reserved.
//

import UIKit

// MARK: - UIFont

extension UIFont {

    func fontApp() -> UIFont {
        return UIFont(name: "Hoefler Text", size: 13)!
    }

    func fontApp(_ size: CGFloat) -> UIFont {
        return UIFont(name: "Hoefler Text", size: size)!
    }

}

// MARK: - String

extension String {
    

    func delectedUrl() {

        let array = self.components(separatedBy: "[")
        print(array)
    }
//        let types: NSTextCheckingType = .Link
//        var URLStrings = [NSURL]()
//        let detector = try? NSDataDetector(types: types.rawValue)
//        let matches = detector!.matchesInString(self, options: .ReportCompletion, range: NSMakeRange(0, self.characters.count))
//
//        for match in matches {
//            print(match.URL!)
//            URLStrings.append(match.URL!)
//           self = self.stringByReplacingOccurrencesOfString(String(match.URL), withString: "")
//
//        }
//        print(self)
//    }
}

// MARK: - UIVIew

extension UIView {
    func addConstraintsWithFormat(_ format: String, views: UIView...) {
        var viewsDictionnary = [String: UIView]()
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            viewsDictionnary[key] = view
        }
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionnary))

    }

}

// MARK: - UIRefreshControlre
extension UIRefreshControl {
    func setText() {
        self.attributedTitle = NSAttributedString(string: "Pull to Refresh")
    }

    func setTextRefreshing() {
        self.attributedTitle = NSAttributedString(string: "Refreshing data...")
    }


}

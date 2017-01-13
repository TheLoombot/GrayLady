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
    func substring(_ r: Range<Int>) -> String {
        let fromIndex = self.index(self.startIndex, offsetBy: r.lowerBound)
        let toIndex = self.index(self.startIndex, offsetBy: r.upperBound)
        return self.substring(with: Range<String.Index>(uncheckedBounds: (lower: fromIndex, upper: toIndex)))
    }

    func between(_ left: String, _ right: String) -> String? {
        guard
            let leftRange = range(of: left), let rightRange = range(of: right, options: .backwards)
            , left != right && leftRange.upperBound < rightRange.lowerBound
            else { return nil }

        let sub = self.substring(from: leftRange.upperBound)
        let closestToLeftRange = sub.range(of: right)!
        return sub.substring(to: closestToLeftRange.lowerBound)
    }

    func index(of char: Character) -> Int? {
        if let idx = characters.index(of: char) {
            return characters.distance(from: startIndex, to: idx)
        }
        return nil
    }

    func nsRange(fromRange range: Range<Index>) -> NSRange {
        let from = range.lowerBound
        let to = range.upperBound

        let location = characters.distance(from: startIndex, to: from)
        let length = characters.distance(from: from, to: to)

        return NSRange(location: location, length: length)
    }


    func delectedUrl() -> ([FormatUrl], String) {

        var strRemoveFormat = ""

        var httpFormat = [FormatUrl]()
        let array = self.components(separatedBy: "[")

        for str in array {
            if str == "" || str.contains("]") == false {
                strRemoveFormat += str
                continue
            }
            let strTem = "[" + str
            let  subStr = strTem.between("[", "]")
            let httpSub = str.between("(", ")")
            if subStr != nil && httpSub != nil {
                let formatUrl = FormatUrl(strShow: subStr!, url: httpSub!)
                httpFormat.append(formatUrl)
                if let index = str.index(of: ")") {
                    strRemoveFormat += subStr! + str.substring((index + 1) ..< (str.characters.count))
                }else {
                    strRemoveFormat += str
                }
            }
        }
        return (httpFormat, strRemoveFormat)
    }



}

// MARK: - UIVIew

extension UIView {
    func addConstraintsWithFormat(_ format: String, views: UIView...) {
        var viewsDictionnary = [String: UIView]()
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            viewsDictionnary[key] = view
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionnary))

    }
}

// MARK: - UIRefreshControlre

extension UIRefreshControl {

    func setText(isFirstload: Bool) {
        if (!isFirstload) {
            self.attributedTitle = NSAttributedString(string: "Pull to Refresh")
        }else {
            self.attributedTitle = NSAttributedString(string: "Loading...")
        }
    }

    func setTextRefreshing(isFirstload: Bool) {
        if !isFirstload {
            self.attributedTitle = NSAttributedString(string: "Refreshing data...")
        }
    }
}

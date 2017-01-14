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

//MARK: - UIColor

extension UIColor {

    func colorLink() -> UIColor {
        return UIColor.init(red: 52/255, green: 104/255, blue: 141/255, alpha: 1)
    }

}

// MARK: - String

extension String {

    func heightWithConstrainedWidth(width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)

        return boundingBox.height
    }

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


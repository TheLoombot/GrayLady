//
//  InfoImage.swift
//  Gray Lady
//
//  Created by David on 1/11/17.
//  Copyright © 2017 QTScoder. All rights reserved.
//

import UIKit

class InfoImage: NSObject {
    var url = ""
    var height: CGFloat
    var width: CGFloat

    init(url: String, height: CGFloat, width: CGFloat) {
        self.url = url
        self.height = height
        self.width = width
    }

    func aspectImg() ->CGFloat {
        guard width != 0 else {
            return 1
        }
        let aspect = height / width
        return aspect
    }
}



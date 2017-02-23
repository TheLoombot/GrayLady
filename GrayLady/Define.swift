//
//  Define.swift
//  Gray Lady
//
//  Created by David on 1/5/17.
//  Copyright © 2017 QTScoder. All rights reserved.
//

import UIKit

public struct Constrant {

    static let appName = Bundle.main.infoDictionary![kCFBundleNameKey as String] as! String


    struct keyContentful {
        static let space = "clmzlcmno5rw"
        static let token = "771810c7a4005456c7eb61e902ebfb6c620f06f012ad3b1e4e201d1bfae3b3b9"
    }

    struct keyAPI {
        static let content_type = "content_type"
        static let briefingTitle = "briefingTitle"
        
    }

    struct identifier {
        static let reply = "replyIdentifier"
        static let request = "requestIdentifier"
        static let url = "urlIdentifier"
        static let image = "imageIdentifier"
        static let category = "catgeoryIdentifier"
    }

    
}

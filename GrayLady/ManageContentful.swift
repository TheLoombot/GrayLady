//
//  ManageContentful.swift
//  Gray Lady
//
//  Created by David on 1/6/17.
//  Copyright © 2017 QTScoder. All rights reserved.
//

import UIKit
import Contentful
class ManageContentful {
    
    let client = Client(spaceIdentifier: Constrant.keyContentful.space, accessToken: Constrant.keyContentful.token)
    static let sharedInstance = ManageContentful()

    func getEntryTypeBriefing (_ completer:@escaping ([Entry]?) -> Void) {

        _ = client.fetchEntries(matching: [Constrant.keyAPI.content_type : "briefing"]) { (resulft) in

            switch resulft {
            case let .success(entry):
                completer(entry.items.map({$0}))
            case .error(_):
                completer(nil)
            }
        }
    }

    func getTitleAndAuthor(_ entryBriefing: Entry) ->(title: String, author: String) {

        var titleStr = ""
        var authorStr = ""
        if let titLe = entryBriefing.fields["briefingTitle"] as? String {
            titleStr = titLe
        }
        if let au = entryBriefing.fields["briefingAuthor"] as? String {
            authorStr = au
        }

        return (titleStr, authorStr)
    }

    func getPiecefromBriefing(_ entryBriefing: Entry) -> [Entry] {
        var arr = [Entry]()
        if let arrData = entryBriefing.fields["piece"] as? [Entry] {
            arr = arrData
        }
        return arr

    }

    func getInfoPiece_fromBriefing(_ entry: Entry) -> (imgCaption: String, pieceContent: String, infoImg: InfoImage) {
        var imageCap = ""
        var pieceText = ""

        let info = InfoImage.init(url: "", height: 0, width: 0)


        if let imgCapTemp = entry.fields["imageCaption"] as? String {
            imageCap = imgCapTemp
        }

        if let pieceTextTemp = entry.fields["pieceTextContent"] as? String {
            pieceText = pieceTextTemp
        }

        if let assetUrl = entry.fields["image"] as? Asset {
            if let dict = assetUrl.fields["file"] as? NSDictionary {
                if let str = dict["url"] as? String {
                    info.url = "http:" + str
                }

                if let details = dict["details"] as? NSDictionary {
                    if let image = details["image"] as? NSDictionary {

                        if let heightImg = image["height"] as? CGFloat {

                            info.height = heightImg
                        }
                        if let widthImg = image["width"] as? CGFloat {
                            info.width = widthImg
                        }
                        
                    }
                }
            }
        }
        
        return(imageCap, pieceText, info)
        
        
    }
    
    
    
    
    
}

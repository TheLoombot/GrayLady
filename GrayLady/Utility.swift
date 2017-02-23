//
//  Utility.swift
//  Gray Lady
//
//  Created by David on 2/23/17.
//  Copyright © 2017 QTScoder. All rights reserved.
//

import UIKit

public func saveImage(_ name: String) -> URL? {
    guard let image = UIImage(named: name) else {
        return nil
    }

    let imageData = UIImagePNGRepresentation(image)
    let documentsURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
    do {
        let imageURL = documentsURL.appendingPathComponent("\(name).png")
        _ = try imageData?.write(to: imageURL)
        return imageURL
    } catch {
        return nil
    }
}


//
//  File.swift
//  
//
//  Created by JEONGEUN KIM on 11/2/23.
//

import UIKit

public extension NSObject {
    static var identifier: String {
        return String(describing: self)
    }
}

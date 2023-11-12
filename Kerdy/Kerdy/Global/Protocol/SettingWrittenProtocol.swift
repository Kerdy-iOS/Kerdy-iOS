//
//  MyWrittenProtocol.swift
//  Kerdy
//
//  Created by JEONGEUN KIM on 11/11/23.
//

import Foundation

protocol SettingWrittenProtocol: Hashable {
    var title: String { get }
    var content: String { get }
    var updateDate: String { get }
}

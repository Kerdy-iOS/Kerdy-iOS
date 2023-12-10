//
//  SettingSectionModel.swift
//  Kerdy
//
//  Created by JEONGEUN KIM on 12/1/23.
//

import RxDataSources

struct SettingSectionItem {
    typealias Model = SectionModel<Section, Item>
    
    enum Section: Int, Equatable {
        case profile
        case basic
    }
    
    enum Item: Equatable {
        case profile(MemberProfileResponseDTO)  
        case basic(SettingBasicModel)
    }
}

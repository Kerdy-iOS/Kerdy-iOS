//
//  CellProtocol.swift
//  Kerdy
//
//  Created by 이동현 on 11/25/23.
//

import Foundation

protocol ConfigurableCell {
    associatedtype CellType
    func configure(with data: CellType)
}

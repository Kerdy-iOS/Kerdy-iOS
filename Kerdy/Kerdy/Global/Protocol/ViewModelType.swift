//
//  ViewModelType.swift
//  Kerdy
//
//  Created by JEONGEUN KIM on 11/11/23.
//

import Foundation
import RxSwift

protocol ViewModelType {
    associatedtype Input
    associatedtype Output

    var disposeBag: DisposeBag { get set }
    func transform(input: Input) -> Output
}

//
//  BaseVC.swift
//  Kerdy
//
//  Created by JEONGEUN KIM on 11/11/23.
//

import UIKit

import Core
import SnapKit

import RxSwift
import RxCocoa

class BaseVC: UIViewController {
    
    // MARK: - Property
    
    lazy var safeArea = self.view.safeAreaLayoutGuide

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setBackgroundColor()

    }
    
    func setBackgroundColor() {
        view.backgroundColor = .kerdyBackground
    }
}

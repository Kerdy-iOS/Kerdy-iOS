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
    
    // MARK: Properties
      
    private(set) lazy var className: String = type(of: self).description().components(separatedBy: ".").last ?? ""
    
    lazy var safeArea = self.view.safeAreaLayoutGuide
    var disposeBag = DisposeBag()
    
    // MARK: Initializing
      
    override init(nibName _: String?, bundle _: Bundle?) {
      super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder _: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }
      
    deinit {
      print("DEINIT: \(className)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setBackgroundColor()
    }
    
    override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
          
      navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func setBackgroundColor() {
        view.backgroundColor = .kerdyBackground
    }
}

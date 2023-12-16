//
//  TermsOfUseVC.swift
//  Kerdy
//
//  Created by JEONGEUN KIM on 11/2/23.
//

import UIKit

import Core
import SnapKit
import WebKit

final class TermsOfUseVC: UIViewController {
    
    // MARK: - Property
    
    private lazy var safeArea = self.view.safeAreaLayoutGuide
    
    // MARK: - UI Property
    
    private let navigationBar: NavigationBarView = {
        let view = NavigationBarView()
        view.configureUI(to: Strings.termsOfUseTitle)
        return view
    }()
    
    private let webView = WKWebView()
    
    // MARK: - Lice Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLayout()
        setUI()
        setWebViewURL()
    }

}

// MARK: - Methods

extension TermsOfUseVC {
    
    private func setLayout() {
        
        view.addSubview(navigationBar)
        navigationBar.snp.makeConstraints {
            $0.top.equalTo(safeArea)
            $0.horizontalEdges.equalTo(safeArea)
        }
        
        view.addSubview(webView)
        webView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.horizontalEdges.equalTo(safeArea)
            $0.bottom.equalToSuperview()
        }
    }
    
    private func setUI() {
        
        view.backgroundColor = .kerdyBackground
        navigationBar.delegate = self
        
    }
    
    private func setWebViewURL() {
        
        guard let url = URL(string: ExternalURL.url)
        else { return }
        
        let request = URLRequest(url: url)
        webView.load(request)
        
    }
}

// MARK: - Navi BackButton Delegate

extension TermsOfUseVC: BackButtonActionProtocol {
    
    func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
}

//
//  SceneDelegate.swift
//  Kerdy
//
//  Created by 이동현 on 2023/10/20.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    static var shared: SceneDelegate? { UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate }
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.overrideUserInterfaceStyle = UIUserInterfaceStyle.light
            
            let tabBarVC = TabBarVC()
            let authVC = AuthVC(viewModel: AuthViewModel(loginManager: LoginManager.shared))
            let hasKeychain = KeyChainManager.hasKeychain(forkey: .accessToken)
            let rootViewController: UIViewController = hasKeychain ? tabBarVC : authVC
            
            let navigationController = UINavigationController(rootViewController: rootViewController)
            navigationController.isNavigationBarHidden = true
            window.rootViewController = navigationController
            window.makeKeyAndVisible()
            self.window = window
        }
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let url = URLContexts.first?.url,
              let code = url.absoluteString.components(separatedBy: "code=").last
        else { return }
        
        KeyChainManager.save(forKey: .githubCode, value: code)
        LoginManager.shared.handleAuthorizationCode(code)
    }
}

extension SceneDelegate {
    
    func changeRootViewControllerTo(_ viewController: UIViewController) {
        guard let window = window else { return }
        
        let rootViewController = viewController
        let navigationController = UINavigationController(rootViewController: rootViewController)
        navigationController.isNavigationBarHidden = true
        window.rootViewController = navigationController
    }
}

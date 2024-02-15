//
//  File.swift
//
//
//  Created by JEONGEUN KIM on 2/2/24.
//

import UIKit

public extension UIApplication {
    private static let notificationSettingsURL: URL? = {
        let settingsString: String
        if #available(iOS 16, *) {
            settingsString = UIApplication.openNotificationSettingsURLString
        } else if #available(iOS 15.4, *) {
            settingsString = UIApplicationOpenNotificationSettingsURLString
        } else {
            settingsString = UIApplication.openSettingsURLString
        }
        return URL(string: settingsString)
    }()
    
    func openAppNotificationSettings() {
        guard
            let url = UIApplication.notificationSettingsURL,
            self.canOpenURL(url) else { return }
        return open(url)
    }
}

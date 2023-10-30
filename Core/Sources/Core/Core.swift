// The Swift Programming Language
// https://docs.swift.org/swift-book

import UIKit

public extension UIColor {
    
    static let bg = UIColor(named: "kerdy_background")
    static let kerdy_black = UIColor(named: "kerdy_black")
    static let kerdy_main = UIColor(named: "kerdy_main")
    static let kerdy_sub = UIColor(named: "kerdy_sub")
    static let kerdy_gray01 = UIColor(named: "kerdy_gray01")
    static let kerdy_gray02 = UIColor(named: "kerdy_gray02")
    static let kerdy_gray03 = UIColor(named: "kerdy_gray03")
    static let kerdy_gray04 = UIColor(named: "kerdy_gray04")
}

public extension UIFont {
    
    // MARK: - Naru Font
    
    enum NanumSquareType: String {
        case regular = "R"
        case bold = "B"
        case extraBold = "EB"
    }
    
    static func nanumSquare(to type: NanumSquareType, size: CGFloat) -> UIFont {
        return UIFont(name: "NanumSquare"+type.rawValue, size: size)!
    }
}

public extension NSObject {
    static var identifier: String {
        return String(describing: self)
    }
}

public extension UIView {
    
    func addSubviews(_ views: UIView...) {
        views.forEach { self.addSubview($0) }
    }
    
    func makeCornerRound (radius: CGFloat) {
        layer.cornerRadius = radius
        layer.masksToBounds = true
    }
    
    func makeBorder(width: CGFloat, color: UIColor) {
        layer.borderWidth = width
        layer.borderColor = color.cgColor
    }
    
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}

public extension UIStackView {
    func addArrangedSubviews(_ views: UIView...) {
        for view in views {
            self.addArrangedSubview(view)
        }
    }
}

public extension UILabel {
    
    /// 행간 조정 메서드
    func setLineSpacing(lineSpacing: CGFloat) {
        if let text = self.text {
            let attributedStr = NSMutableAttributedString(string: text)
            let style = NSMutableParagraphStyle()
            style.lineSpacing = lineSpacing
            attributedStr.addAttribute(NSAttributedString.Key.paragraphStyle, value: style, range: NSRange(location: 0, length: attributedStr.length))
            self.attributedText = attributedStr
        }
    }
}

public extension UIButton {
    @available(iOS 15.0, *)
    
    static func kerdyStyle(to title: String) -> UIButton.Configuration {
        var configuration = UIButton.Configuration.plain()
        configuration.titleAlignment = .center
        configuration.baseBackgroundColor = .clear
        configuration.baseForegroundColor = .kerdy_black
        configuration.background.cornerRadius = 10
        configuration.background.strokeWidth = 0.5
        configuration.background.strokeColor = .kerdy_gray01
        configuration.attributedTitle =  AttributedString(title, attributes: AttributeContainer([NSAttributedString.Key.font : UIFont.nanumSquare(to: .regular, size: 11)]))
        
        return configuration
    }
}

public extension UIImage {
    static let arrowIcon = UIImage(named: "ic_arrow")!.withRenderingMode(.alwaysOriginal)
}

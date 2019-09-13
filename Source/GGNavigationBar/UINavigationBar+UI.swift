//
//  UINavigationBar+UI.swift
//  GGUI
//
//  Created by John on 2019/3/11.
//  Copyright © 2019 Ganguo. All rights reserved.
//

import UIKit

public extension UINavigationBar {
    func setup(navigationAppearance: NavigationAppearance) {
        barTintColor = navigationAppearance.barTintColor
        tintColor = navigationAppearance.tintColor
        setTitle(color: navigationAppearance.titleColor, font: navigationAppearance.titleFont)
        setBackground(alpha: navigationAppearance.backgroundAlpha)
        setupShadowLine(remove: !navigationAppearance.showShadowLine)
    }

    /// 改变背景 alpha http://developer.limneos.net/?ios=11.1.2&framework=InCallService.framework&header=PHAudioCallViewController.h
    var barBackgroundView: UIView? {
        return self.subviews
            .filter { NSStringFromClass(type(of: $0)) == "_UIBarBackground" }
            .first
    }

    func setBackground(alpha: CGFloat) {
        guard let barBackgroundView = barBackgroundView else { return }
        let valueForKey = barBackgroundView.value(forKey:)
        /// MARK: 尝试过很多方法，isTranslucent == false 无论怎么改都没有效果
        guard isTranslucent else { return }
        if let backgroundEffectView = recursiveFindSubview(of: "UIVisualEffectView") as? UIView,
            backgroundImage(for: .default) == nil {
            backgroundEffectView.alpha = alpha
            return
        }
    }

    /// 设置标题颜色，字体
    ///
    /// - Parameters:
    ///   - color: 颜色
    ///   - font: 字体
    func setTitle(color: UIColor, font: UIFont) {
        titleTextAttributes = [.font: font,
                               .foregroundColor: color]
    }

    /// 设置分割线
    /// - Parameter remove: 是否移除
    func setupShadowLine(remove: Bool) {
        if remove {
            shadowImage = UIImage()
        } else {
            shadowImage = UIImage(color: GGUI.LineView.color, size: CGSize(width: 1, height: 0.5))
        }
    }
}

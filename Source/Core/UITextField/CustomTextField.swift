//
//  CustomTextField.swift
//  GGUI
//
//  Created by John on 2019/3/27.
//  Copyright © 2019 Ganguo. All rights reserved.
//

import UIKit
import SwifterSwift

public class CustomTextField: UITextField {
    /// 点击清除按钮执行
    public var backKeyPressed: VoidBlock?
    /// 点击显示查看密码的图标，设置的话就会显示，且点击显示密码，再次点击显示为密码点
    @IBInspectable public var checkPasswordImage: UIImage?
    /// 查看密码显示图标
    @IBInspectable public var checkPasswordSelectedImage: UIImage?
    /// 左间距
    @IBInspectable public var leftInset: CGFloat = 0.0
    /// 右间距
    @IBInspectable public var rightInset: CGFloat = 0.0
    /// 底部横线的高度，设置了才会显示，横线颜色参靠 SingleLineView 设置
    @IBInspectable public var bottomLineHeight: CGFloat = 0
    /// placeholder 颜色， 默认为 lightGray，可在 GGUI-CustomTextField-placeholderColor 设置以方便统一设置
    @IBInspectable public var placeholderColor: UIColor = GGUI.CustomTextField.placeholderColor

    @IBInspectable public var bottomLineColor: UIColor = GGUI.LineView.color {
        didSet {
            lineView.lineColor = bottomLineColor
        }
    }

    private lazy var lineView: SingleLineView = SingleLineView(frame: CGRect(x: 0, y: 0, width: 0, height: bottomLineHeight))

    private var isShowLineView: Bool {
        return bottomLineHeight > 0
    }

    private var isCheckPassword: Bool {
        return checkPasswordImage != nil
    }

    private lazy var checkPasswordButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImageForAllStates(checkPasswordImage!)
        if let image = checkPasswordSelectedImage {
            button.setImage(image, for: .selected)
        }
        button.sizeToFit()
        _ = button.on(.touchUpInside, invokeHandler: { [weak self] (_) in
            guard let strongSelf = self else { return }
            strongSelf.checkPasswordButton.isSelected = !strongSelf.checkPasswordButton.isSelected
            strongSelf.isSecureTextEntry = !strongSelf.checkPasswordButton.isSelected
        })
        return button
    }()

    override public func layoutSubviews() {
        super.layoutSubviews()
        lineView.frame = CGRect(x: 0, y: height-bottomLineHeight, width: width, height: bottomLineHeight)
        if isCheckPassword {
            checkPasswordButton.frame = CGRect(x: width - checkPasswordButton.width - rightInset,
                                               y: (height - checkPasswordButton.height)/2,
                                               width: checkPasswordButton.width, height: checkPasswordButton.height)
        }
    }

    override public func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }

    private func setupUI() {
        autocorrectionType = .no
        if let placeholder = placeholder {
            attributedPlaceholder = placeholder.attributedString(font: self.font!, color: placeholderColor)
        }
        if isShowLineView {
            addSubview(lineView)
        }
        if leftInset > 0 {
            leftViewMode = .always
            leftView = UIView(frame: CGRect(x: 0, y: 0, width: leftInset, height: self.height))
        }
        if rightInset > 0 || isCheckPassword {
            rightViewMode = .always
            if isCheckPassword {
                rightView = checkPasswordButton
            } else {
                rightView = UIView(frame: CGRect(x: 0, y: 0, width: rightInset, height: self.height))
            }
        }
    }

    public override func deleteBackward() {
        super.deleteBackward()
        backKeyPressed?()
    }
}
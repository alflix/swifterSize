//
//  AudioItem.swift
//  MessageUI
//
//  Created by John on 2019/10/24.
//  Copyright © 2019 MessageUI. All rights reserved.
//

import UIKit
import class AVFoundation.AVAudioPlayer

/// 音频消息协议
public protocol AudioItem {
    /// 资源 url
    var url: URL { get }
    /// 音频时长秒数
    var duration: Float { get }
    /// 尺寸
    var size: CGSize { get }
    /// 音频播放按钮
    var audioPlayImage: UIImage? { get }
    /// 音频暂停按钮
    var audioPauseImage: UIImage? { get }
}

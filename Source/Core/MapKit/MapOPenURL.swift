//
//  MapOPenURL.swift
//  GGUI
//
//  Created by John on 2018/10/25.
//  Copyright © 2018年 Ganguo. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

public enum MapApp {
    case apple
    case goolge
    case amap
    case baidu
    case tencent
}

public extension UIApplication {
    /// 拨打系统电话
    ///
    /// - Parameter number: 电话号码
    static func makePhoneCall(number: String) {
        let phoneScheme = "tel:\(number)"
        guard let url = URL(string: phoneScheme) else { return }
        guard UIApplication.shared.canOpenURL(url) else { return }
        UIApplication.shared.open(url, options: [:]) { (_) in }
    }

    /// 显示 actionSheet 的 AlertController 打开地图 app，支持 系统地图，Google 地图，高德地图，百度地图，腾讯地图
    /// - 需要在 LSApplicationQueriesSchemes 中设置白名单：
    ///   - 高德： iosamap
    ///   - Google：comgooglemaps
    ///   - 腾讯：qqmap
    ///   - 百度：baidumap
    /// - Parameters:
    ///   - coordinate: 目的地的坐标
    ///   - destination: 目的地名称
    ///   - viewController: 控制器
    static func openMap(to coordinate: CLLocationCoordinate2D,
                        _ destination: String,
                        by viewController: UIViewController) {
        let openAction: (_ url: String) -> Void = { url in
            var allowedCharacters = CharacterSet.alphanumerics
            allowedCharacters.insert(charactersIn: ".:/,&?=")
            if let encodedUrl = url.addingPercentEncoding(withAllowedCharacters: allowedCharacters), let openURL = URL(string: encodedUrl) {
                UIApplication.shared.open(openURL, options: [:], completionHandler: nil)
            }
        }
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        if UIApplication.canOpen(map: .apple) {
            alert.addAction(UIAlertAction(title: "系统地图", style: .default, handler: { (_) in
                let regionDistance: CLLocationDistance = 10000
                let regionSpan = MKCoordinateRegion(center: coordinate, latitudinalMeters: regionDistance, longitudinalMeters: regionDistance)
                let options = [
                    MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
                    MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
                ]
                let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: nil)
                let mapItem = MKMapItem(placemark: placemark)
                mapItem.name = destination
                mapItem.openInMaps(launchOptions: options)
            }))
        }
        if UIApplication.canOpen(map: .goolge) {
            alert.addAction(UIAlertAction(title: "Google 地图", style: .default, handler: { (_) in
                let url = "comgooglemaps://?saddr=&daddr=\(coordinate.latitude),\(coordinate.longitude)&directionsmode=driving"
                openAction(url)
            }))
        }
        if UIApplication.canOpen(map: .amap) {
            alert.addAction(UIAlertAction(title: "高德地图", style: .default, handler: { (_) in
                let url = "iosamap://path?sourceApplication=applicationName&sid=BGVIS1&sname=我的位置&did=BGVIS2&dlat=\(coordinate.latitude)&dlon=\(coordinate.longitude)&dname=\(destination)&dev=0&m=0&t=0"
                openAction(url)
            }))
        }
        if UIApplication.canOpen(map: .baidu) {
            alert.addAction(UIAlertAction(title: "百度地图", style: .default, handler: { (_) in
                let url = "baidumap://map/direction?origin={{我的位置}}&destination=\(coordinate.latitude),\(coordinate.longitude)&mode=driving&src=JumpMapDemo"
                openAction(url)
            }))
        }
        if UIApplication.canOpen(map: .tencent) {
            alert.addAction(UIAlertAction(title: "腾讯地图", style: .default, handler: { (_) in
                let url = "qqmap://map/routeplan?type=drive&from=我的位置&to=\(destination)&tocoord=\(coordinate.latitude),\(coordinate.longitude)&policy=1&referer=MapJump"
                openAction(url)
            }))
        }
        alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: { (_) in

        }))
        viewController.present(alert, animated: false, completion: nil)
    }

    static func canOpen(map: MapApp) -> Bool {
        switch map {
        case .apple:
            return UIApplication.shared.canOpenURL(URL(string: "maps://")!)
        case .goolge:
            return UIApplication.shared.canOpenURL(URL(string: "comgooglemaps://")!)
        case .amap:
            return UIApplication.shared.canOpenURL(URL(string: "iosamap://")!)
        case .baidu:
            return UIApplication.shared.canOpenURL(URL(string: "baidumap://")!)
        case .tencent:
            return UIApplication.shared.canOpenURL(URL(string: "qqmap://")!)
        }
    }
}
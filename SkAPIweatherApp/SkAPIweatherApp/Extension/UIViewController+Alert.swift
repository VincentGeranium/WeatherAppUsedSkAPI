//
//  UIViewController+Alert.swift
//  SkAPIweatherApp
//
//  Created by 김광준 on 2020/05/09.
//  Copyright © 2020 VincentGeranium. All rights reserved.
//

import UIKit

extension UIViewController {
    func show(message: String) {
        let alert = UIAlertController(title: "알림", message: message, preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "확인", style: .default, handler: nil)
        alert.addAction(ok)
        
        present(alert, animated: true, completion: nil)
    }
}

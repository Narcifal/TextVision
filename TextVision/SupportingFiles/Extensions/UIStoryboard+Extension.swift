//
//  UIStoryboard+Extension.swift
//  TextVision
//
//  Created by Denys Niestierov on 27.06.2023.
//

import UIKit

enum Storyboards: String {
    case startMenu = "StartMenu"
    case scanResult = "ScanResult"
}

extension UIViewController {
    
    class func instantiate<T: UIViewController>(storyboard: Storyboards) -> T {
        let storyboard = UIStoryboard(name: storyboard.rawValue, bundle: nil)
        let identifier = String(describing: self)
        
        guard let vc = storyboard.instantiateViewController(withIdentifier: identifier) as? T else {
            fatalError("Cannot create \(T.self)")
        }
        return vc
    }
}

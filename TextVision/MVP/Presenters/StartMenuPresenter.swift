//
//  StartMenuPresenter.swift
//  TextVision
//
//  Created by Denys Niestierov on 07.06.2023.
//

import UIKit

protocol StartMenuPresenterDelegate: AnyObject {
    
}

final class StartMenuPresenter {
    
    weak var startMenuPresenterDelegate: StartMenuPresenterDelegate?
    
    public func setViewDelegate(startMenuPresenterDelegate: StartMenuPresenterDelegate) {
        self.startMenuPresenterDelegate = startMenuPresenterDelegate
    }
}


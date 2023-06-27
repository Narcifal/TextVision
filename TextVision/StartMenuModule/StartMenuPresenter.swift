//
//  StartMenuPresenter.swift
//  TextVision
//
//  Created by Denys Niestierov on 23.06.2023.
//

import UIKit

protocol StartMenuPresenterProtocol: AnyObject {
    func showScanResult(with imageModel: ImageModel)
}

final class StartMenuPresenter: StartMenuPresenterProtocol {
    
    //MARK: - Properties -
    private weak var view: StartMenuViewProtocol?
    private let router: RouterProtocol
    
    //MARK: - Life Cycle -
    required init(router: RouterProtocol) {
        self.router = router
    }

    // MARK: - Iternal -
    func inject(view: StartMenuViewProtocol) {
        self.view = view
    }
    
    func showScanResult(with imageModel: ImageModel) {
        router.showScanResultViewController(with: imageModel)
    }
}

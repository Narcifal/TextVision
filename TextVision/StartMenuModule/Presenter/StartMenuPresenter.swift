//
//  StartMenuPresenter.swift
//  TextVision
//
//  Created by Denys Niestierov on 23.06.2023.
//

import Foundation

protocol StartMenuPresenterProtocol: AnyObject {
    init(view: StartMenuViewProtocol,
         router: RouterProtocol)
    func showScanResult(with imageModel: ImageModel)
}

final class StartMenuPresenter: StartMenuPresenterProtocol {
    
    //MARK: - Properties -
    private weak var view: StartMenuViewProtocol?
    private let router: RouterProtocol
    
    //MARK: - Life Cycle -
    required init(view: StartMenuViewProtocol,
                  router: RouterProtocol
    ) {
        self.view = view
        self.router = router
    }

    // MARK: - Iternal -
    func showScanResult(with imageModel: ImageModel) {
        router.showScanResultViewController(with: imageModel)
    }
}

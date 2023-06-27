//
//  AssemblyBuilderProtocol.swift
//  TextVision
//
//  Created by Denys Niestierov on 23.06.2023.
//

import UIKit

protocol AssemblyBuilderProtocol {
    func createStartMenuModule(router: RouterProtocol) -> UIViewController
    func createScanResultModule(router: RouterProtocol, imageModel: ImageModel) -> UIViewController
}

final class AssemblyModelBuilder: AssemblyBuilderProtocol {
    
    //MARK: - Internal -
    func createStartMenuModule(router: RouterProtocol) -> UIViewController {
        let presenter = StartMenuPresenter(router: router)
        let viewController = StartMenuViewController.instantiate(with: presenter)

        presenter.inject(view: viewController)
        return viewController
    }
    
    func createScanResultModule(router: RouterProtocol, imageModel: ImageModel) -> UIViewController {
        let presenter = ScanResultPresenter(imageModel: imageModel)
        let viewController = ScanResultViewController.instantiate(with: presenter)
        
        presenter.inject(view: viewController)
        return viewController
    }
}

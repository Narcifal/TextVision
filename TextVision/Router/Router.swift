//
//  Router.swift
//  TextVision
//
//  Created by Denys Niestierov on 23.06.2023.
//

import UIKit

protocol RouterMain: AnyObject {
    var navigationController: UINavigationController? { get set }
    var assemblyBuilder: AssemblyBuilderProtocol { get set }
}

protocol RouterProtocol: RouterMain {
    func showStartMenuViewController()
    func showScanResultViewController(with imageModel: ImageModel)
}

final class Router: RouterProtocol {
    
    //MARK: - Variables -
    var assemblyBuilder: AssemblyBuilderProtocol
    var navigationController: UINavigationController?
    
    //MARK: - Life Cycle -
    init(navigationController: UINavigationController,
         assemblyBuilder: AssemblyBuilderProtocol) {
        self.navigationController = navigationController
        self.assemblyBuilder = assemblyBuilder
    }
    
    //MARK: - Internal -
        func showStartMenuViewController() {
            let startMenuModule = assemblyBuilder.createStartMenuModule(router: self)
            navigationController?.setViewControllers([startMenuModule], animated: true)
        }
        
        func showScanResultViewController(with imageModel: ImageModel) {
            let scanResultModule = assemblyBuilder.createScanResultModule(
                router: self,
                imageModel: imageModel
            )
            navigationController?.pushViewController(scanResultModule, animated: true)
        }
}

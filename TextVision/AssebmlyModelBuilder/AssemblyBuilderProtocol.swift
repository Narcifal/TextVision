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
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let view = storyboard.instantiateViewController(withIdentifier: "StartMenuViewControllerID") as! StartMenuViewController
        let presenter = StartMenuPresenter(view: view,
                                          router: router)
        view.presenter = presenter
        return view
    }
    
    func createScanResultModule(router: RouterProtocol, imageModel: ImageModel) -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let view = storyboard.instantiateViewController(withIdentifier: "ScanResultViewControllerID") as! ScanResultViewController
        let presenter = ScanResultPresenter(view: view,
                                            router: router,
                                            imageModel: imageModel)
        view.presenter = presenter
        return view
    }
}

//
//  SceneDelegate.swift
//  TextVision
//
//  Created by Denys Niestierov on 04.06.2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        startRootScreen(for: windowScene)
    }
    
    func startRootScreen(for windowScene: UIWindowScene) {
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        
        let navigationController = UINavigationController()
        let assemblyBuilder = AssemblyModelBuilder()
        let router = Router(navigationController: navigationController,
                            assemblyBuilder: assemblyBuilder)
        router.showStartMenuViewController()
        
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
}


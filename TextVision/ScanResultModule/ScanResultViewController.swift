//
//  ResultViewController.swift
//  TextVision
//
//  Created by Denys Niestierov on 05.06.2023.
//

import UIKit

@MainActor
protocol ScanResultViewProtocol: AnyObject {
    func setRecognizedText(_: String)
    func setRenderImage(_: UIImage)
}

final class ScanResultViewController: UIViewController {
    
    static func instantiate(with presenter: ScanResultPresenterProtocol) -> ScanResultViewController {
        let viewController: ScanResultViewController = .instantiate(storyboard: .scanResult)
        viewController.presenter = presenter
        return viewController
    }
    
    //MARK: - IBOutlets -
    @IBOutlet private weak var label: UILabel!
    @IBOutlet private weak var imageView: UIImageView!
    
    //MARK: - Properties -
    var presenter: ScanResultPresenterProtocol!
    
    //MARK: - Life Cycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
    }
}

extension ScanResultViewController: ScanResultViewProtocol {
    func setRecognizedText(_ recognizedText: String) {
        label.text = recognizedText
    }
    
    func setRenderImage(_ image: UIImage) {
        imageView.image = image
    }
}

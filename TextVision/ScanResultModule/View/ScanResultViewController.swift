//
//  ResultViewController.swift
//  TextVision
//
//  Created by Denys Niestierov on 05.06.2023.
//

import UIKit

protocol ScanResultViewProtocol: AnyObject {
    func setLableText(with recognizedText: String)
    func setImage(with image: UIImage)
}

final class ScanResultViewController: UIViewController {
    
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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if self.isMovingFromParent {
            navigationController?.popViewController(animated: true)
        }
    }
}

// MARK: - ScanResultViewProtocol -
extension ScanResultViewController: ScanResultViewProtocol {
    func setLableText(with recognizedText: String) {
        self.label.text = recognizedText
    }
    
    func setImage(with image: UIImage) {
        self.imageView.image = image
    }
}

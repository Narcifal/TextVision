//
//  ViewController.swift
//  TextVision
//
//  Created by Denys Niestierov on 04.06.2023.
//

import UIKit

protocol StartMenuViewProtocol: AnyObject { }

final class StartMenuViewController: UIViewController {
    
    private enum Constants {
        static let startMenuBackground = "StartMenuBackground.jpeg"
    }
    
    static func instantiate(with presenter: StartMenuPresenterProtocol) -> StartMenuViewController {
        let viewController: StartMenuViewController = .instantiate(storyboard: .startMenu)
        viewController.presenter = presenter
        return viewController
    }
    
    //MARK: - IBOutlets -
    @IBOutlet private weak var cameraButton: UIButton!
    @IBOutlet private weak var galleryButton: UIButton!

    //MARK: - UIElements -
    private lazy var backgroundImageView: UIImageView = {
        let background = UIImage(named: Constants.startMenuBackground)
        let imageView = UIImageView(frame: view.bounds)
        imageView.contentMode =  UIView.ContentMode.scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = background
        imageView.center = view.center
        view.addSubview(imageView)
        return imageView
    }()
    
    //MARK: - Properties -
    var presenter: StartMenuPresenterProtocol!
    
    //MARK: - Life Cycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        view.sendSubviewToBack(backgroundImageView)
    }
}

//MARK: - Private -
private extension StartMenuViewController {

    //MARK: - IBActions -
    @IBAction func cameraButtonTapped(_ sender: UIButton) {
        showImagePicker(sourceType: .camera)
    }
    
    @IBAction func galleryButtonTapped(_ sender: UIButton) {
        showImagePicker(sourceType: .photoLibrary)
    }
    
    func showImagePicker(sourceType: UIImagePickerController.SourceType) {
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func showScanResult(with imageModel: ImageModel) {
        presenter.showScanResult(with: imageModel)
    }
}

//MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate -
extension StartMenuViewController:
    UIImagePickerControllerDelegate,
    UINavigationControllerDelegate
{
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
    ) {
        guard let originalImage = info[.originalImage] as? UIImage else {
            return
        }
        let cgImage = originalImage.cgImage
        
        picker.dismiss(animated: true)

        let imageModel = ImageModel(
            originalImage: originalImage,
            transformedCgImage: cgImage
        )
        showScanResult(with: imageModel)
    }
}

extension StartMenuViewController: StartMenuViewProtocol { }

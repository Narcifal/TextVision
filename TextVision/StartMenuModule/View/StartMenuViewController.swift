//
//  ViewController.swift
//  TextVision
//
//  Created by Denys Niestierov on 04.06.2023.
//

import UIKit

protocol StartMenuViewProtocol: AnyObject { }

final class StartMenuViewController: UIViewController {
    
    //MARK: - IBOutlets -
    @IBOutlet private weak var cameraButton: UIButton!
    @IBOutlet private weak var galleryButton: UIButton!

    //MARK: - Properties -
    public var presenter: StartMenuPresenterProtocol!
    
    //MARK: - Life Cycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        setBackground()
    }
}

//MARK: - Private -
private extension StartMenuViewController {

    //MARK: - IBActions -
    @IBAction func cameraButtonTapped(_ sender: UIButton) {
        pickerPresentor(sourceType: .camera)
    }
    
    @IBAction func galleryButtonTapped(_ sender: UIButton) {
        pickerPresentor(sourceType: .photoLibrary)
    }
    
    func pickerPresentor(sourceType: UIImagePickerController.SourceType) {
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func showScanResult(with imageModel: ImageModel) {
        presenter.showScanResult(with: imageModel)
    }
    
    func setBackground() {
        let background = UIImage(named: Constats.startMenuBackground)
        let imageView : UIImageView = UIImageView(frame: view.bounds)
        imageView.contentMode =  UIView.ContentMode.scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = background
        imageView.center = view.center
        view.addSubview(imageView)
        self.view.sendSubviewToBack(imageView)
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
        guard let cgImage = originalImage.cgImage else { return }
        
        picker.dismiss(animated: true)

        let imageModel = ImageModel(
            image: originalImage,
            cgImage: cgImage
        )
        showScanResult(with: imageModel)
    }
}

// MARK: - StartMenuViewProtocol -
extension StartMenuViewController: StartMenuViewProtocol { }

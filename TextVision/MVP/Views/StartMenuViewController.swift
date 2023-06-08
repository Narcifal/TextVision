//
//  ViewController.swift
//  TextVision
//
//  Created by Denys Niestierov on 04.06.2023.
//

import UIKit

final class StartMenuViewController: UIViewController, StartMenuPresenterDelegate {
    
    //MARK: - IBOutlets -
    @IBOutlet private weak var cameraButton: UIButton!
    @IBOutlet private weak var galleryButton: UIButton!
    
    //MARK: - Constants -
    private let presenter = StartMenuPresenter()
    
    //MARK: - Variables -
    private var selectedImage = UIImage()
    
    //MARK: - Life Cycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.setViewDelegate(startMenuPresenterDelegate: self)
    }
    
    //MARK: - Iternal -
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constats.Segue.toScanResult {
            if let destinationVC = segue.destination as? ScanResultViewController {
                destinationVC.image = selectedImage
            }
        }
    }
}

//MARK: - Private -
private extension StartMenuViewController {
    
    //MARK: - IBActions -
    @IBAction func cameraButtonTapped(_ sender: UIButton) {
        pickerPresentor(sourceType: .camera)
    }
    
    //will be deprecated, PHPicker
    @IBAction func galleryButtonTapped(_ sender: UIButton) {
        pickerPresentor(sourceType: .photoLibrary)
    }
    
    func pickerPresentor(sourceType: UIImagePickerController.SourceType) {
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.delegate = self
        present(picker, animated: true)
    }
}

//MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate -
extension StartMenuViewController: UIImagePickerControllerDelegate,  UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            selectedImage = image
        }

        picker.dismiss(animated: true)
        
        let segue = Constats.Segue.toScanResult
        self.performSegue(withIdentifier: segue, sender: self)
    }
}

extension StartMenuViewController: ScanResultPresenterDelegate {
    
}

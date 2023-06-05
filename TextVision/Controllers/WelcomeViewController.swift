//
//  ViewController.swift
//  TextVision
//
//  Created by Denys Niestierov on 04.06.2023.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    //MARK: - IBOutlets -
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var galleryButton: UIButton!
    
    //MARK: - Variables -
    private var selectedImage = UIImage()
    
    //MARK: - Life Cycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    //MARK: - IBActions -
    @IBAction func cameraButtonTapped(_ sender: UIButton) {
        pickerPresentor(sourceType: .camera)
    }
    
    //will be deprecated, PHPicker
    @IBAction func galleryButtonTapped(_ sender: UIButton) {
        pickerPresentor(sourceType: .photoLibrary)
    }
}

//MARK: - Private -
private extension WelcomeViewController {
    func pickerPresentor(sourceType: UIImagePickerController.SourceType) {
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.delegate = self
        present(picker, animated: true)
    }
}

//MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate -
extension WelcomeViewController: UIImagePickerControllerDelegate,  UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            selectedImage = image
        }

        picker.dismiss(animated: true)
        
        self.performSegue(withIdentifier: "testSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "testSegue" {
            if let destinationVC = segue.destination as? ResultViewController {
                destinationVC.image = selectedImage
            }
        }
    }
}

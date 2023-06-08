//
//  ResultViewController.swift
//  TextVision
//
//  Created by Denys Niestierov on 05.06.2023.
//

import UIKit
import Vision

final class ScanResultViewController: UIViewController {

    //MARK: - IBOutlets -
    @IBOutlet private weak var label: UILabel!
    @IBOutlet private weak var imageView: UIImageView!
    
    //MARK: - Constants -
    private let presenter = ScanResultPresenter()
    
    //MARK: - Variables -
    public var image = UIImage()
    
    //MARK: - Life Cycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        recognizeText(image: image)
    }
    
    //MARK: - Private -
    private func recognizeText(image: UIImage?) {
        // CGImage on which to perform requests.
        guard let cgImage = image?.cgImage else { return }

        // Handler
        let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        
        // Request
        let textRecognitionRequest = VNRecognizeTextRequest { (request, error) in
            guard let observations =
                    request.results as? [VNRecognizedTextObservation] else {
                return
            }
            
            if (!observations.isEmpty) {
                for _ in observations {
                    let recognizedStrings = observations.compactMap({
                        $0.topCandidates(1).first?.string
                    }).joined(separator: " ")

                    DispatchQueue.main.async {
                        self.label.text = recognizedStrings
                        if let image = image {
                            self.imageView.image = self.presenter.drawBoundingBoxes(
                                image: image,
                                observations: observations)
                            //self.imageView.image = image
                        }
                    }
                }
            }
            else {
                self.label.text = "The program did not recognize the text."
            }
        }
        textRecognitionRequest.recognitionLevel = .accurate
        textRecognitionRequest.usesLanguageCorrection = true
        textRecognitionRequest.minimumTextHeight = 0.014
        
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                // Perform the text-recognition request.
                try requestHandler.perform([textRecognitionRequest])
            } catch let error as NSError {
                print("Failed to perform image request: \(error)")
                return
            }
        }
    }
}

extension ScanResultViewController: ScanResultPresenterDelegate {
    
}

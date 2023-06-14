//
//  ResultViewController.swift
//  TextVision
//
//  Created by Denys Niestierov on 05.06.2023.
//

import UIKit
import Vision
import AVFoundation

final class ScanResultViewController: UIViewController {

    //MARK: - IBOutlets -
    @IBOutlet private weak var label: UILabel!
    @IBOutlet private weak var imageView: UIImageView!
    
    //MARK: - Constants -
    private var presenter = ScanResultPresenter()
    
    //MARK: - Variables -
    public var image: UIImage?
    
    //MARK: - Life Cycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.setViewDelegate(scanResultPresenterDelegate: self)
        recognizeText(image: image)
    }
    
    //MARK: - Private -
    private func recognizeText(image: UIImage?) {
        guard let cgImage = image?.cgImage else { return }

        let cgOrientation = CGImagePropertyOrientation(rawValue: UInt32(image!.imageOrientation.rawValue))

        let requestHandler = VNImageRequestHandler(cgImage: cgImage,
                                                   orientation: cgOrientation!,
                                                   options: [:])

        let textRecognitionRequest = VNRecognizeTextRequest { [weak self] (request, error) in
            guard let results = request.results as? [VNRecognizedTextObservation] else {
                return
            }

            if (!results.isEmpty) {
                for currentObservation in results {
                    let recognizedStrings = results.compactMap({
                        $0.topCandidates(1).first?.string
                    }).joined(separator: " ")

                    DispatchQueue.main.async {
                        self?.label.text = recognizedStrings

                        if let image = image {
                            self?.imageView.image = self?.presenter.drawBoundingBoxes(
                                image: image,
                                observations: results)
                        }
                    }
                }
            }
            else {
                self?.label.text = "The program did not recognize the text."
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

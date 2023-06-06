//
//  ResultViewController.swift
//  TextVision
//
//  Created by Denys Niestierov on 05.06.2023.
//

import UIKit
import Vision

struct RecognizedTextBlock {
    let textValue: String
    let recognizedTextRect: CGRect
}

extension CGRect {
    func scaled(to size: CGSize) -> CGRect {
        return CGRect(
            x: self.origin.x * size.width,
            y: self.origin.y * size.height,
            width: self.size.width * size.width,
            height: self.size.height * size.height
        )
    }
}

class ResultViewController: UIViewController {

    //MARK: - IBOutlets -
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
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
                for currentObservations in observations {
                    let recognizedStrings = observations.compactMap({
                        $0.topCandidates(1).first?.string
                    }).joined(separator: " ")
                    
                    DispatchQueue.main.async {
                        self.label.text = recognizedStrings
                        self.imageView.image = image
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
        
        do {
            // Perform the text-recognition request.
            try requestHandler.perform([textRecognitionRequest])
        } catch {
            print(error)
        }
    }
}

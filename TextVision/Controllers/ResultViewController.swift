//
//  ResultViewController.swift
//  TextVision
//
//  Created by Denys Niestierov on 05.06.2023.
//

import UIKit
import Vision


class ResultViewController: UIViewController {
    
    //MARK: - IBOutlets -
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var imageView: UIImageView!
    
    //MARK: - Variables -
    public var image = UIImage()
    
    //MARK: - Life Cycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = image
        recognizeText(image: image)
    }
    
    //MARK: - Private -
    private func recognizeText(image: UIImage?) {
        guard let cgImage = image?.cgImage else { return }

        //Handler
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])

        //Request
        let request = VNRecognizeTextRequest() { request, error in
            guard let observations = request.results as? [VNRecognizedTextObservation],
                  error == nil else {
                return
            }
            let text = observations.compactMap({
                $0.topCandidates(1).first?.string
            }).joined(separator: " ")
            
            self.textView.text = text
        }

        //Process request
        do {
            try handler.perform([request])
        }
        catch {
            print(error)
        }
    }
}

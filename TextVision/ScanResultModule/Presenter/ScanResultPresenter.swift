//
//  ScanResultPresenter.swift
//  TextVision
//
//  Created by Denys Niestierov on 23.06.2023.
//

import UIKit
import Vision

protocol ScanResultPresenterProtocol: AnyObject {
    init(view: ScanResultViewProtocol,
         router: RouterProtocol, imageModel: ImageModel)
    func viewDidLoad()
}

final class ScanResultPresenter: ScanResultPresenterProtocol {
    
    //MARK: - Properties -
    private weak var view: ScanResultViewProtocol?
    private let router: RouterProtocol?
    private let imageModel: ImageModel
    
    //MARK: - Life Cycle -
    required init(view: ScanResultViewProtocol,
                  router: RouterProtocol,
                  imageModel: ImageModel
    ) {
        self.view = view
        self.router = router
        self.imageModel = imageModel
    }
    
    // MARK: - Iternal -
    func viewDidLoad() {
        if let image = imageModel.image,
           let cgImage = imageModel.cgImage {
            textRecognitionRequest(
                image: image,
                cgImage: cgImage
            )
        }
    }
}

//MARK: - Private -
private extension ScanResultPresenter {
    func textRecognitionRequest(image: UIImage, cgImage: CGImage) {

        //Request Handler
        let requestHandler = VNImageRequestHandler(
            cgImage: cgImage,
            options: [:]
        )

        //Text Recognition Request
        let textRecognitionRequest = VNRecognizeTextRequest { [weak self] (request, error) in
            guard let self,
                  let results = request.results as? [VNRecognizedTextObservation] else {
                return
            }

            let recognizedStrings = results.compactMap({
                $0.topCandidates(1).first?.string
            }).joined(separator: " ")
            
            DispatchQueue.main.async {
                if !recognizedStrings.isEmpty {
                    self.view?.setLableText(with: recognizedStrings)
                } else {
                    self.view?.setLableText(with: Constats.noneText)
                }

                guard let resultImage = self.drawBoundingBoxesOnText(
                    image: image,
                    observations: results
                ) else {
                    return
                }
                self.view?.setImage(with: resultImage)
            }
        }
        textRequestProperties(request: textRecognitionRequest)

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
    
    func textRequestProperties(request: VNRecognizeTextRequest) {
        request.recognitionLevel = .accurate
        request.usesLanguageCorrection = true
        request.minimumTextHeight = 0.014
    }
    
    func drawBoundingBoxesOnText(
        image: UIImage,
        observations: [VNRecognizedTextObservation]
    ) -> UIImage? {
        let imageTransform = CGAffineTransform.identity
            .scaledBy(x: 1, y: -1)
            .translatedBy(x: 0, y: -image.size.height)
            .scaledBy(x: image.size.width, y: image.size.height)
        
        UIGraphicsBeginImageContextWithOptions(image.size, false, 0.0)

        image.draw(at: CGPoint.zero)

        let strokeColor = UIColor.red
        var unionRect: CGRect?
        
        for currentObservation in observations {
            let boundingBox = currentObservation.boundingBox
            let adjustedBoundingBox = boundingBox.applying(imageTransform)
            let rectPath = UIBezierPath(rect: adjustedBoundingBox)
            
            if let currentRect = unionRect {
                unionRect = currentRect.union(adjustedBoundingBox)
            } else {
                unionRect = adjustedBoundingBox
            }
            
            strokeColor.setStroke()
            rectPath.lineWidth = 2.0
            rectPath.stroke()
        }
        
        if let unionRect = unionRect {
            let unionPath = UIBezierPath(rect: unionRect)
            strokeColor.setStroke()
            unionPath.lineWidth = 2.0
            unionPath.stroke()
        }
        
        let drawnImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return drawnImage
    }
}


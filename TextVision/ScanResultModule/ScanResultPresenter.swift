//
//  ScanResultPresenter.swift
//  TextVision
//
//  Created by Denys Niestierov on 23.06.2023.
//

import UIKit
import Vision

protocol ScanResultPresenterProtocol: AnyObject {
    func viewDidLoad()
}

final class ScanResultPresenter: ScanResultPresenterProtocol {
    
    private enum Constants {
        static let minimumTextHeight: Float = 0.014
        static let rectPathLineWidth = 2.0
        static let unionPathLineWidth = 2.0
        static let noneText = "The program did not recognize the text."
    }
    
    //MARK: - Properties -
    private weak var view: ScanResultViewProtocol?
    private let imageModel: ImageModel
    
    //MARK: - Life Cycle -
    required init(imageModel: ImageModel) {
        self.imageModel = imageModel
    }
    
    // MARK: - Iternal -
    func inject(view: ScanResultViewProtocol) {
        self.view = view
    }
    
    func viewDidLoad() {
        if let importCgImage = imageModel.transformedCgImage {
            performVisionRequest(cgImage: importCgImage)
        }
    }
}


//MARK: - Private -
private extension ScanResultPresenter {
    func performVisionRequest(cgImage: CGImage) {
        let requestHandler = VNImageRequestHandler(
            cgImage: cgImage,
            options: [:]
        )
        
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                try requestHandler.perform([self.createTextRequest()])
            } catch let error as NSError {
                debugPrint("Failed to perform image request: \(error)")
                return
            }
        }
    }
    
    func createTextRequest() -> VNRecognizeTextRequest {
        let textDetectRequest = VNRecognizeTextRequest(completionHandler: handleDetectedText)

        textRequestProperties(request: textDetectRequest)
        return textDetectRequest
    }
    
    func textRequestProperties(request: VNRecognizeTextRequest) {
        request.recognitionLevel = .accurate
        request.usesLanguageCorrection = true
        request.minimumTextHeight = Constants.minimumTextHeight
    }

    @MainActor
    func handleDetectedText(request: VNRequest?, error: Error?) {
        guard let results = request?.results as? [VNRecognizedTextObservation] else {
            return
        }
        
        let recognizedStrings = results.compactMap({
            $0.topCandidates(1).first?.string
        }).joined(separator: " ")
        
        let labelText = recognizedStrings.isEmpty ? Constants.noneText : recognizedStrings
        view?.setRecognizedText(labelText)

        if let image = imageModel.originalImage,
           let resultImage = drawBoundingBoxesOnText(
            image: image,
            observations: results
           ) {
            view?.setRenderImage(resultImage)
        }
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
            rectPath.lineWidth = Constants.rectPathLineWidth
            rectPath.stroke()
        }
        
        if let unionRect = unionRect {
            let unionPath = UIBezierPath(rect: unionRect)
            strokeColor.setStroke()
            unionPath.lineWidth = Constants.unionPathLineWidth
            unionPath.stroke()
        }
        
        let drawnImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return drawnImage
    }
}

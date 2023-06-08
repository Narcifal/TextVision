//
//  Presenter.swift
//  TextVision
//
//  Created by Denys Niestierov on 07.06.2023.
//

import UIKit
import Vision

protocol ScanResultPresenterDelegate: AnyObject {
     
}

final class ScanResultPresenter {
    
    weak var scanResultPresenterDelegate: ScanResultPresenterDelegate?
    
    public func setViewDelegate(scanResultPresenterDelegate: ScanResultPresenterDelegate) {
        self.scanResultPresenterDelegate = scanResultPresenterDelegate
    }
    
    func drawBoundingBoxes(image: UIImage, observations: [VNRecognizedTextObservation]) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(image.size, false, image.scale)
        image.draw(at: .zero)

        let context = UIGraphicsGetCurrentContext()
        context?.setStrokeColor(UIColor.red.cgColor)
        context?.setLineWidth(3.0)

        var boundingBoxUnion: CGRect?

        observations.forEach { observation in
            let boundingBox = observation.boundingBox

            // Flip vertically
            var transformedBoundingBox = boundingBox
            transformedBoundingBox.origin.y = 1 - transformedBoundingBox.origin.y - transformedBoundingBox.size.height

            let transformedRect = VNImageRectForNormalizedRect(transformedBoundingBox,
                                                               Int(image.size.width),
                                                               Int(image.size.height))
            context?.stroke(transformedRect)

            // Calculate union
            if let previousUnion = boundingBoxUnion {
                boundingBoxUnion = previousUnion.union(transformedRect)
            } else {
                boundingBoxUnion = transformedRect
            }
        }

        // Draw the union bounding box
        if let union = boundingBoxUnion {
            context?.setStrokeColor(UIColor.green.cgColor)
            context?.stroke(union)
        }

        let imageWithBoundingBoxes = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return imageWithBoundingBoxes
    }
}

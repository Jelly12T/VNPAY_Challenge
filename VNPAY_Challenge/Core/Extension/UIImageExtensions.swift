//  CollectionViewExtension.swift
//  VNPAY_Challenge
//
//  Created by lê thạch on 23/02/2024.
//

import Foundation
import UIKit
public extension UIImage {
    static func getImagesFromGifData(_ data: Data) -> [UIImage] {
        guard let imageSource = CGImageSourceCreateWithData(data as CFData, nil) else { return [] }
        let frameCount = CGImageSourceGetCount(imageSource)
        var frames = [UIImage]()

        for index in 0..<frameCount {
            if let imageRef = CGImageSourceCreateImageAtIndex(imageSource, index, nil) {
                let image = UIImage(cgImage: imageRef)
                frames.append(image)
            }
        }

        return frames
    }
    
    static func firstFrameFrom(gifURL: URL) -> UIImage? {
        guard let imageData = try? Data(contentsOf: gifURL) else {
            return nil
        }
        
        return self.getFirstFrameOfGifData(imageData)
    }

    static func getFirstFrameOfGifData(_ data: Data) -> UIImage? {
        guard let imageSource = CGImageSourceCreateWithData(data as CFData, nil) else { return nil }
        let frameCount = CGImageSourceGetCount(imageSource)
        if frameCount == 0 {
            return nil
        }

        if let imageRef = CGImageSourceCreateImageAtIndex(imageSource, 0, nil) {
            return UIImage(cgImage: imageRef)
        }

        return nil
    }

    func resize(to size: CGSize) -> UIImage {
        UIGraphicsBeginImageContext(size)
        draw(in: CGRect(origin: CGPoint.zero, size:size))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage ?? UIImage()
    }

    func crop(rect: CGRect) -> UIImage {
        guard let cgImage = self.cgImage else {
            return self
        }
        guard let cropImage = cgImage.cropping(to: rect) else {
            return self
        }
        return UIImage.init(cgImage: cropImage) 
    }

    func fixOrientation() -> UIImage {
        if self.imageOrientation == .up {
            return self
        }
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        self.draw(in: CGRect.init(origin: .zero, size: size))
        let normalImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return normalImage ?? self
    }
    
    func flipHorizontally() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        let context = UIGraphicsGetCurrentContext()!
        
        context.translateBy(x: self.size.width / 2, y: self.size.height / 2)
        context.scaleBy(x: -1.0, y: 1.0)
        context.translateBy(x: -self.size.width / 2, y: -self.size.height / 2)
        
        self.draw(in: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage ?? self
    }
    
    func resizeToFill(size: CGSize) -> UIImage {
        UIGraphicsBeginImageContext(size)

        var targetSize: CGSize = .zero
        if size.width / self.size.width * self.size.height < size.height {
            targetSize.height = size.height
            targetSize.width = targetSize.height * self.size.width / self.size.height
        } else {
            targetSize.width = size.width
            targetSize.height = targetSize.width * self.size.height / self.size.width
        }

        let insetLeft = (targetSize.width - size.width)/2
        let insetTop = (targetSize.height - size.height)/2
        
        self.draw(in: CGRect(x: -insetLeft, y: -insetTop, width: targetSize.width, height: targetSize.height))
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    func resizeToFit(maxSize: CGFloat) -> UIImage {
        if self.size.width < size.width && self.size.height < size.height {
            return self
        }
        
        let originSizeRatio = self.size.width/self.size.height
        var targetSize: CGSize
        
        if self.size.width < self.size.height {
            let height = CGFloat.minimum(maxSize, self.size.height)
            targetSize = CGSize(width: height * originSizeRatio, height: height)
        } else {
            let width = CGFloat.minimum(maxSize, self.size.width)
            targetSize = CGSize(width: width, height: width/originSizeRatio)
        }
        
        return self.resize(to: targetSize)
    }
    
    func generateThumbnail() -> UIImage {
        let maxSize: CGFloat = 800
        
        return resizeToFit(maxSize: maxSize)
    }
    
    func makeSquareImage(withBackgroundColor bgColor: UIColor) -> UIImage {
        let size = CGFloat.maximum(self.size.width, self.size.height)
        let contextSize = CGSize(width: size, height: size)
        UIGraphicsBeginImageContext(contextSize)
        bgColor.setFill()
        let context = UIGraphicsGetCurrentContext()
        context?.fill(CGRect(origin: .zero, size: contextSize))
        
        let drawLocation = CGPoint(x: (contextSize.width - self.size.width)/2, y: (contextSize.height - self.size.height)/2)
        self.draw(at: drawLocation)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }

    static func makeImage(size: CGSize, color: UIColor) -> UIImage {
        UIGraphicsBeginImageContext(size)
        color.setFill()
        UIBezierPath(rect: CGRect(origin: .zero, size: size)).fill()
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        return image
    }
}

extension UIImage {
    func merge(in viewSize: CGSize, with imageTuples: [(image: UIImage, viewSize: CGSize, transform: CGAffineTransform)]) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 1)

        guard let context = UIGraphicsGetCurrentContext() else { return nil }

        context.scaleBy(x: size.width / viewSize.width, y: size.height / viewSize.height)

        draw(in: CGRect(origin: .zero, size: viewSize), blendMode: .normal, alpha: 1)

        for imageTuple in imageTuples {
            let areaRect = CGRect(origin: .zero, size: imageTuple.viewSize)

            context.saveGState()
            context.concatenate(imageTuple.transform)

            context.setBlendMode(.color)
            UIColor.clear.setFill()
            context.fill(areaRect)

            imageTuple.image.draw(in: areaRect, blendMode: .normal, alpha: 1)

            context.restoreGState()
        }

        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return image
    }
}

extension UIImage {
    func maskWithColor(color: UIColor) -> UIImage {
        let maskImage = cgImage!

        let width = size.width
        let height = size.height
        let bounds = CGRect(x: 0, y: 0, width: width, height: height)

        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        let context = CGContext(data: nil, width: Int(width), height: Int(height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)!

        context.clip(to: bounds, mask: maskImage)
        context.setFillColor(color.cgColor)
        context.fill(bounds)

        if let cgImage = context.makeImage() {
            let coloredImage = UIImage(cgImage: cgImage)
            return coloredImage
        } else {
            return UIImage()
        }
    }
}

extension UIImage {
    func addFilter(filterKey: String, size: CGSize? = nil) -> UIImage {
        var originImage = self
        if let size = size {
            originImage = self.resize(to: size)
        }
        
        let filter = CIFilter(name: filterKey)
        let ciInput = CIImage(image: originImage)
        let ciContext = CIContext()
        
        filter?.setValue(ciInput, forKey: "inputImage")
        
        guard let ciOutput = filter?.outputImage,
              let cgImage = ciContext.createCGImage(ciOutput, from: ciOutput.extent)
            else { return UIImage() }
        
        return UIImage(cgImage: cgImage)
    }
}


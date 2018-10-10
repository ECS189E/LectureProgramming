import UIKit

var str = "Hello, playground"

extension UIImage {
    // add a crop function to UIImage
    func crop(to: CGRect) -> UIImage? {
        switch (self.cgImage, self.ciImage) {
        // check if cgImage is some, ciImage is nil and unwrap self.cgImage, storing it in cgImage
        case (.some(let cgImage), nil):
            let image = cgImage.cropping(to: to)
            return image.map { UIImage(cgImage: $0) }
        case (nil, .some(let ciImage)):
            return UIImage(ciImage: ciImage.cropped(to: to))
        default:
            print("I don't know why cgImage and ciImage are equal")
            return nil
        }
    }
}

var image: UIImage = UIImage() // assume set elsewhere
let croppedImage = image.crop(to: CGRect(x: 0.0, y: 0.0, width: 25.0, height: 25.0))

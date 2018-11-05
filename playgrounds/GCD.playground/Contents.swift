import UIKit

let myImage = UIImage()

func characterBoxes(from boundingBox: CGRect) -> [CGRect] {
    // divide the bounding box into 16 even width parts
    let dx = boundingBox.width / 16.0
    return stride(from: boundingBox.origin.x, to: boundingBox.size.width + boundingBox.origin.x, by: dx)
        .map { CGRect(x: $0, y: boundingBox.origin.y, width: dx, height: boundingBox.height) }
}

func detectNumberEmbossed(image: UIImage) -> [CGRect] {
    Thread.sleep(until: Date() + 3.0)
    print("checking predicted embossed number")
    return characterBoxes(from: CGRect(x: 10, y: 120, width: 480, height: 40))
}

func detectNumberFlat(image: UIImage) -> [CGRect] {
    Thread.sleep(until: Date() + 2.0)
    print("checking predicted flat number")
    return characterBoxes(from: CGRect(x: 10, y: 10, width: 240, height: 28))
}

func recognizeCharacter(image: UIImage, characterBox: CGRect) -> String {
    Thread.sleep(until: Date() + 0.1)
    return "9"
}

// (1) Execute on the main thread

// (2) create our own serial thread and run it in parallel, no longer locks up the UI thread

// (3) now run on parallel threads

// (4) now run recognition in parallel

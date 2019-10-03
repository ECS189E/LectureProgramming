import UIKit

let image = UIImage()

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

func recognizeCharacters(image: UIImage, characterBox: CGRect) -> String {
    Thread.sleep(until: Date() + 0.1)
    return "9"
}

// (1) Execute on the main thread
// Question: what's wrong with this solution?
func main() {
    let startTime = Date()
    let embossedCharacterBoxes = detectNumberEmbossed(image: image)
    let embossedNumber = embossedCharacterBoxes.map { recognizeCharacters(image: image, characterBox: $0) }.joined()
    let flatCharacterBoxes = detectNumberFlat(image: image)
    let flatNumber = flatCharacterBoxes.map { recognizeCharacters(image: image, characterBox: $0) }.joined()
    print("main thread \(embossedNumber) \(flatNumber)")
    let elapsedTime = -startTime.timeIntervalSinceNow
    print(elapsedTime)
}

main()

// (2) create our own serial thread and run it in parallel, no longer locks up the UI thread
// post result back to the main thread
let machineLearningQueue = DispatchQueue(label: "machine learning queue")
machineLearningQueue.async {
    let startTime = Date()
    let embossedCharacterBoxes = detectNumberEmbossed(image: image)
    let embossedNumber = embossedCharacterBoxes.map { recognizeCharacters(image: image, characterBox: $0) }.joined()
    let flatCharacterBoxes = detectNumberFlat(image: image)
    let flatNumber = flatCharacterBoxes.map { recognizeCharacters(image: image, characterBox: $0) }.joined()
    let elapsedTime = -startTime.timeIntervalSinceNow
    // interleaving between this block on the main queue and the rest of the code in the machineLearningQueue is undefined
    DispatchQueue.main.async { print("main thread from serial queue \(embossedNumber) \(flatNumber)") }
    // Warning warning warning, if you find yourself needing to add a sleep statement to your code something is wrong and you need
    // to redesign your synchronization scheme
    Thread.sleep(until: Date() + 0.1)
    print(elapsedTime)
}

// (3) now run on parallel threads
//     - First show how you can run in concurrent thread but that you need to have some synchronization

/*
machineLearningQueue.async {
    let startTime = Date()
    var embossedNumber: String?
    var flatNumber: String?
    
    DispatchQueue.global(qos: .userInitiated).async {
        let embossedCharacterBoxes = detectNumberEmbossed(image: image)
        let number = embossedCharacterBoxes.map { recognizeCharacters(image: image, characterBox: $0) }.joined()
        machineLearningQueue.async { embossedNumber = number }
    }
    
    DispatchQueue.global(qos: .userInitiated).async {
        let flatCharacterBoxes = detectNumberFlat(image: image)
        let number = flatCharacterBoxes.map { recognizeCharacters(image: image, characterBox: $0) }.joined()
        machineLearningQueue.async { flatNumber = number }
    }
    
    let elapsedTime = -startTime.timeIntervalSinceNow
    // interleaving between this block on the main queue and the rest of the code in the machineLearningQueue is undefined
    DispatchQueue.main.async { print("parallel threads \(embossedNumber) \(flatNumber)") }
    print(elapsedTime)
}
*/

//     - Next show how to use a semaphore to coordinate, but deadlock first
//     QUESTION: why didn't this finish -- what happened?
//     Answer: deadlock
/*
machineLearningQueue.async {
    let startTime = Date()
    var embossedNumber: String?
    var flatNumber: String?
    
    let semaphore = DispatchSemaphore(value: 0)
    
    DispatchQueue.global(qos: .userInitiated).async {
        let embossedCharacterBoxes = detectNumberEmbossed(image: image)
        let number = embossedCharacterBoxes.map { recognizeCharacters(image: image, characterBox: $0) }.joined()
        machineLearningQueue.async {
            embossedNumber = number
            semaphore.signal()
        }
    }

    DispatchQueue.global(qos: .userInitiated).async {
        let flatCharacterBoxes = detectNumberFlat(image: image)
        let number = flatCharacterBoxes.map { recognizeCharacters(image: image, characterBox: $0) }.joined()
        machineLearningQueue.async {
            flatNumber = number
            semaphore.signal()
        }
    }
    
    semaphore.wait()
    semaphore.wait()
    let elapsedTime = -startTime.timeIntervalSinceNow
    // interleaving between this block on the main queue and the rest of the code in the machineLearningQueue is undefined
    DispatchQueue.main.async { print("parallel threads \(embossedNumber) \(flatNumber)") }
    print(elapsedTime)
}
*/

/*
machineLearningQueue.async {
    let startTime = Date()
    var embossedNumber: String?
    var flatNumber: String?
    
    let semaphore = DispatchSemaphore(value: 0)
    
    DispatchQueue.global(qos: .userInitiated).async {
        let embossedCharacterBoxes = detectNumberEmbossed(image: image)
        let number = embossedCharacterBoxes.map { recognizeCharacters(image: image, characterBox: $0) }.joined()
        embossedNumber = number
        semaphore.signal()
    }
    
    DispatchQueue.global(qos: .userInitiated).async {
        let flatCharacterBoxes = detectNumberFlat(image: image)
        let number = flatCharacterBoxes.map { recognizeCharacters(image: image, characterBox: $0) }.joined()
        flatNumber = number
        semaphore.signal()
    }
    
    semaphore.wait()
    semaphore.wait()
    let elapsedTime = -startTime.timeIntervalSinceNow
    // interleaving between this block on the main queue and the rest of the code in the machineLearningQueue is undefined
    DispatchQueue.main.async { print("parallel threads \(embossedNumber) \(flatNumber)") }
    print(elapsedTime)
}
*/

machineLearningQueue.async {
    let startTime = Date()
    var embossedNumber: String?
    var flatNumber: String?
    
    let group = DispatchGroup()
    
    group.enter()
    DispatchQueue.global(qos: .userInitiated).async {
        let embossedCharacterBoxes = detectNumberEmbossed(image: image)
        let number = embossedCharacterBoxes.map { recognizeCharacters(image: image, characterBox: $0) }.joined()
        embossedNumber = number
        group.leave()
    }
    
    group.enter()
    DispatchQueue.global(qos: .userInitiated).async {
        let flatCharacterBoxes = detectNumberFlat(image: image)
        let number = flatCharacterBoxes.map { recognizeCharacters(image: image, characterBox: $0) }.joined()
        flatNumber = number
        group.leave()
    }
    
    group.wait()
    let elapsedTime = -startTime.timeIntervalSinceNow
    // interleaving between this block on the main queue and the rest of the code in the machineLearningQueue is undefined
    DispatchQueue.main.async { print("parallel threads \(embossedNumber) \(flatNumber)") }
    print(elapsedTime)
}


// (4) now run recognition in parallel
let queue = DispatchQueue(label: "Machine Learning")
queue.async {
    
    let dispatchGroup = DispatchGroup()
    var result: String?
    print("deadlock example")
    dispatchGroup.enter()
    DispatchQueue.global(qos: .userInitiated).async {
        let foo = "asdf"
        queue.async {
            result = foo
            dispatchGroup.leave()
        }
    }
    
    dispatchGroup.wait()
    DispatchQueue.main.async {
        print(result ?? "none")
    }
}

func blockingNetworkRequest(url: String) {
    print("bnetwork request")
}

let dictLock = DispatchSemaphore(value: 1)
var originSemaphores: [String: DispatchSemaphore] = [:]

// make a non blocking HTTP request
func makeHttpRequest(url: String, origin: String, complete: @escaping (() -> Void)) {
    dictLock.wait()
    if originSemaphores[origin] == nil {
        originSemaphores[origin] = DispatchSemaphore(value: 2)
    }
    let semaphore = originSemaphores[origin]!
    dictLock.signal()
    
    DispatchQueue.global(qos: .default).async {
        semaphore.wait()
        blockingNetworkRequest(url: url)
        complete()
        semaphore.signal()
    }
}



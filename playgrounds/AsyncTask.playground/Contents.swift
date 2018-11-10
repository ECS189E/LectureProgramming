import UIKit

protocol AsyncTask {
    // executes in a background dispatch queue
    func doInBackground(parameters: [String]) -> Int
    
    // executes in the main dispatch queue, used to show progress
    func onUpdate(progress: Int)
    
    // executes in the main disptach queue, used after the background task is done
    func onPostExecute(result: Int)
}

extension AsyncTask {
    func publish(progress: Int) {
        // IMPLEMENT THIS
    }
    
    func execute(_ parameters: [String]) {
        // IMPLEMENT THIS
    }
}

func downloadFile(_ url: String) -> Int {
    // emulates downloading of a file, returns the number of bytes downloaded
    Thread.sleep(until: Date() + 2.0)
    return 1000
}

class DownloadFilesTask: AsyncTask {
    func doInBackground(parameters: [String]) -> Int {
        if Thread.current == Thread.main {
            print("ERROR: on main thread")
        }
        let count = parameters.count
        var totalSize = 0
        for (idx, url) in parameters.enumerated() {
            totalSize += downloadFile(url)
            publish(progress: (100 * idx / count))
        }
        
        return totalSize
    }
    
    func onUpdate(progress: Int) {
        print("progress = \(progress)")
        if Thread.current != Thread.main {
            print("ERROR: not on main thread")
        }
    }
    
    func onPostExecute(result: Int) {
        print("downloaded \(result) bytes")
        if Thread.current != Thread.main {
            print("ERROR: not on main thread")
        }
    }
}

// this is a non blocking call
let _ = DownloadFilesTask().execute(["a.com", "b.com", "c.com"])
print("execute returned")

// a correct run of this tasks should print:
//
//   execute returned
//   progress = 0
//   progress = 33
//   progress = 66
//   progress = 100
//   downloaded 3000 bytes

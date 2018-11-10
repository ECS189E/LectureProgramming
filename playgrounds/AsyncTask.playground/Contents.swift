import UIKit

protocol AsyncTask {
    // executes in a background dispatch queue
    func doInBackground(parameters: [String]) -> Int
    
    // executes in the main dispatch queue, used to show progress
    func onProgressUpdate(progress: Int)
    
    // executes in the main disptach queue, used after the background task is done
    func onPostExecute(result: Int)
}

extension AsyncTask {
    func publishProgress(progress: Int) {
        // implement this function
    }
    
    func execute(_ parameters: [String]) {
        // implement this function
    }
}

func downloadFile(_ url: String) -> Int {
    // emulates downloading of a file, returns the number of bytes downloaded
    Thread.sleep(until: Date() + 2.0)
    return 1000
}

class DownloadFilesTask: AsyncTask {
    func doInBackground(parameters: [String]) -> Int {
        let count = parameters.count
        var totalSize = 0
        for (idx, url) in parameters.enumerated() {
            totalSize += downloadFile(url)
            publishProgress(progress: (idx / count))
        }
        
        return totalSize
    }
    
    func onProgressUpdate(progress: Int) {
        print("progress = \(progress)")
    }
    
    func onPostExecute(result: Int) {
        print("downloaded \(result) bytes")
    }
}

let _ = DownloadFilesTask().execute(["a.com", "b.com", "c.com"])

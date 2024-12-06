import Foundation

class CSVWriter {

    // Function to create a CSV string from a generic array of objects
    func createCSV<T>(from data: [T], using headers: [String], valueExtractor: (T) -> [String]) -> String {
        var csvString: String = headers.joined(separator: ",") + "\n" // Add header

        for item: T in data {
            let values: [String] = valueExtractor(item)
            let rowString: String = values.joined(separator: ",")
            csvString.append("\(rowString)\n")
        }

        return csvString
    }

  func writeCSV(to filename: String, content: String) {
    
    // Get the current directory path
    let currentDirectory: String = FileManager.default.currentDirectoryPath
    
    // Create the CsvFiles directory path
    let csvDirectory: URL = URL(fileURLWithPath: currentDirectory).appendingPathComponent("CsvFiles")
    
    // Ensure the CsvFiles directory exists
    do {
      try FileManager.default.createDirectory(at: csvDirectory, withIntermediateDirectories: true, attributes: nil)
    } catch {
      print("Failed to create directory: \(error)")
      return
    }
    
    // Create the full file URL
    let fileURL: URL = csvDirectory.appendingPathComponent(filename)

    // Write the content to the CSV file
    do {
      try content.write(to: fileURL, atomically: true, encoding: .utf8)
      print("CSV file created at: \(fileURL.path)")
    } catch {
      print("Failed to write CSV file: \(error)")
    }
  }
}
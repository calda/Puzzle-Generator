//
//  main.swift
//  Puzzle Generator
//
//  Created by Cal Stephens on 12/16/16.
//  Copyright © 2016 Cal Stephens. All rights reserved.
//

import Foundation
import AppKit

let fileManager = FileManager.default
let path = "/Users/cal/Documents/Puzzles/"//fileManager.currentDirectoryPath
let allFiles = (try? fileManager.contentsOfDirectory(at: URL(string: path)!, includingPropertiesForKeys: nil, options: [])) ?? []

//filter down to just images in current folder
let imageFiles = allFiles.filter { filePath in
    let imageExtensions = ["png", "jpg", "jpeg"]
    for ext in imageExtensions {
        if filePath.absoluteString.lowercased().hasSuffix(ext) {
            return true
        }
    }
    
    return false
}

if imageFiles.count == 0 {
    print("\nNo images found in directory (\(path)).\n")
    print("Puzzle Generator supports PNG and JPG.\n")
    exit(0)
}

print("Found \(imageFiles.count) image\(imageFiles.count == 1 ? "" : "s") in the current directory.\n")

//user input
func requestInteger(text: String) -> Int {
    var integer: Int?
    
    while integer == nil {
        print("\(text) ", terminator: "")
        let input = readLine(strippingNewline: true)
        integer = Int(input ?? "")
        
        if (integer ?? 0) <= 0 { integer = nil }
        
        if integer == nil {
            print("Input must be a positive integer.\n")
        }
    }
    
    return integer!
}

let rows = requestInteger(text: "Number of rows?")
let cols = requestInteger(text: "Number of columns?")

//delete old puzzles if they exist
let generatedPuzzlesFolder = path + "/Generated Puzzles/"

var isDirectory = ObjCBool(booleanLiteral: true)
if fileManager.fileExists(atPath: generatedPuzzlesFolder, isDirectory: &isDirectory) {
    try fileManager.removeItem(atPath: generatedPuzzlesFolder)
}

//process the images
for imageFile in imageFiles {
    if let image = NSImage(contentsOf: imageFile) {
        
        let puzzle = Puzzle(rows: rows, cols: cols)
        let puzzlePieces = puzzle.createImages(from: image)
        
        let fileName = imageFile.pathComponents.last!
        let imageName = fileName.components(separatedBy: ".").first!
        print("Generating \(imageName)")
        
        //create puzzle folder
        let puzzleFolder = generatedPuzzlesFolder + imageName
        try fileManager.createDirectory(atPath: puzzleFolder, withIntermediateDirectories: true, attributes: nil)
        
        //save specification file
        let spec = puzzle.dictionaryRepresentation(with: image)
        let json = try JSONSerialization.data(withJSONObject: spec, options: [.prettyPrinted])
        let specPath = puzzleFolder + "/\(imageName)-spec.json"
        try json.write(to: URL(fileURLWithPath: specPath)) 
        
        
        //save images to folder
        for (image, _, row, col) in puzzlePieces {
            let bitmap = NSBitmapImageRep(cgImage: image.cgImage!)
            let pngData = bitmap.representation(using: NSPNGFileType, properties: [:])
            
            if let imageData = pngData {
                let imagePath = puzzleFolder + "/\(imageName)-row\(row)-col\(col).png"
                try imageData.write(to: URL(fileURLWithPath: imagePath))
            }
        }
        
    }
}

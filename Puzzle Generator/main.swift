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
let path = fileManager.currentDirectoryPath
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
    print("No images found in directory (\(path)).\n")
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

//process the images
for imageFile in imageFiles {
    if let image = NSImage(contentsOf: imageFile) {
        
        let puzzlePieces = Puzzle(rows: rows, cols: cols).createImages(from: image)
        
        let fileName = imageFile.pathComponents.last!
        let imageName = fileName.components(separatedBy: ".").first!
        print("Generating \(imageName)")
        
        //create new folder
        let newFolderName = path + "/Generated Puzzles/\(imageName)/"
        try fileManager.createDirectory(atPath: newFolderName, withIntermediateDirectories: true, attributes: nil)
        
        //save images to folder
        for (image, puzzlePiece, row, col) in puzzlePieces {
            let bitmap = NSBitmapImageRep(cgImage: image.cgImage!)
            let pngData = bitmap.representation(using: NSPNGFileType, properties: [:])
            
            if let imageData = pngData {
                let imagePath = newFolderName + "/\(imageName)-row\(row)-col\(col).png"
                try imageData.write(to: URL(fileURLWithPath: imagePath))
            }
        }
        
    }
}

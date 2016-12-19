//
//  Puzzle.swift
//  Phonics
//
//  Created by Cal Stephens on 8/16/16.
//  Copyright © 2016 Cal Stephens. All rights reserved.
//

import Foundation
import AppKit

struct Puzzle {
    
    let pieces: [[PuzzlePiece]]
    let rowCount: Int
    let colCount: Int
    
    init(rows: Int, cols: Int) {
        
        self.rowCount = rows
        self.colCount = cols
        
        let emptyRow = [PuzzlePiece?](repeating: nil, count: cols)
        var puzzle = [[PuzzlePiece?]](repeating: emptyRow, count: rows)
        
        func pieceAt(_ row: Int, _ col: Int) -> PuzzlePiece? {
            if !(0 ..< rows).contains(row) { return nil }
            if !(0 ..< cols).contains(col) { return nil }
            return puzzle[row][col] ?? PuzzlePiece.withRandomNubs
        }
        
        for row in 0 ..< rows {
            for col in 0 ..< cols {
                puzzle[row][col] = PuzzlePiece(topNeighbor: pieceAt(row - 1, col),
                                               rightNeighbor: pieceAt(row, col + 1),
                                               bottomNeighbor: pieceAt(row + 1, col),
                                               leftNeighbor: pieceAt(row, col - 1))
                puzzle[row][col]?.row = row
                puzzle[row][col]?.col = col
            }
        }
        
        //reduce [[PuzzlePiece?]] to [[PuzzlePiece]]
        self.pieces = puzzle.map { pieceRow in
            return pieceRow.flatMap{ $0 }
        }
    }
    
    
    //MARK: - Serialization
    
    func dictionaryRepresentation(with image: NSImage) -> [String : Any] {
        
        var piecesDictionary = [String : [String : String]]()
        
        for pieceRow in self.pieces {
            for piece in pieceRow {
                guard let row = piece.row, let col = piece.col else { continue }
                let name = "row\(row)-col\(col)"
                piecesDictionary[name] = piece.dictionaryRepresentation
            }
        }
    
        let imageSize = image.croppedToAspectRatio(width: colCount, height: rowCount).actualPixelSize

        return [
            "rows" : rowCount,
            "cols" : colCount,
            "pieces" : piecesDictionary,
            "pixelsWide" : imageSize.width,
            "pixelsTall" : imageSize.height
        ]
    }
    
}


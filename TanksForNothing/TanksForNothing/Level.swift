//
//  Level.swift
//  TanksForNothing
//
//  Created by Philip Leaning on 31/01/2015.
//  Copyright (c) 2015 bluetatami. All rights reserved.
//

import Foundation

struct Level {
    let width:  Int
    let height: Int
    
    var wallsArray: [(rightWall: Bool, topWall: Bool)]
    
    init(width: Int, height: Int) {
        self.width  = width
        self.height = height
        // Don't have last column and top row
        wallsArray = Array(count: (width - 1) * (height - 1), repeatedValue: (false,false))
    }
    
    mutating func addWalls(x: Int, y: Int, right: Bool, top: Bool) {
        let index = (y * (width - 1)) + x
        wallsArray[index] = (rightWall: right, topWall: top)
    }
    
    func getPoints(forFrame frame: CGRect) -> [(CGPoint, CGPoint)] {
        var pointPairsArray = [(CGPoint, CGPoint)]()
        let squareHeight    = frame.height  / CGFloat(height)
        let squareWidth     = frame.width   / CGFloat(width )
        
        for (index, square) in enumerate(wallsArray) {
            let squareX = CGFloat(index % (width  - 1))
            let squareY = CGFloat(index / (height - 1))
            
            if square.topWall {
                let point0 = CGPoint(x: squareWidth * (squareX    ), y: squareHeight * (squareY + 1))
                let point1 = CGPoint(x: squareWidth * (squareX + 1), y: squareHeight * (squareY + 1))
                
                pointPairsArray.append(point0, point1)
            }
            
            if square.rightWall {
                let point0 = CGPoint(x: squareWidth * (squareX + 1), y: squareHeight * (squareY    ))
                let point1 = CGPoint(x: squareWidth * (squareX + 1), y: squareHeight * (squareY + 1))
                
                pointPairsArray.append(point0, point1)
            }
        }
        
        return pointPairsArray
    }
    
    func getMidSquarePoints(forFrame frame: CGRect) -> (leftSquare: CGPoint, rightSquare: CGPoint) {
        let squareHeight    = frame.height  / CGFloat(height * 2)
        let squareWidth     = frame.width   / CGFloat(width  * 2)
        
        let squaresY   = frame.height / CGFloat(2.0)
        
        return (CGPoint(x:squareWidth, y:squaresY), CGPoint(x: frame.width - squareWidth, y: squaresY))
    }
}


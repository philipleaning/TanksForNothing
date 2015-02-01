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
    
    var wallsArray: [(startPoint: (Int, Int), endPoint: (Int, Int))] = []
    
    init(width: Int, height: Int) {
        self.width  = width
        self.height = height
        
    }
    
    mutating func addWall(#startIntersectionX: Int, startIntersectionY: Int, endIntersectionX: Int, endIntersectionY: Int) {
        wallsArray.append(startPoint: (startIntersectionX, startIntersectionY), endPoint: (endIntersectionX, endIntersectionY))
    }
    
    func getPoints(forFrame frame: CGRect) -> [(CGPoint, CGPoint)] {
        var pointPairsArray = [(CGPoint, CGPoint)]()
        let squareHeight    = frame.height  / CGFloat(height * 2)
        let squareWidth     = frame.width   / CGFloat(width  * 2)
        
        pointPairsArray = wallsArray.map({(startPoint: (Int, Int), endPoint: (Int, Int)) in
            
            
            return (CGPoint(x: squareWidth * CGFloat(startPoint.0), y: squareHeight * CGFloat(startPoint.1)), CGPoint(x: squareWidth * CGFloat(endPoint.0), y: squareHeight * CGFloat(endPoint.1)))
        })
        
        return pointPairsArray
    }
    
    func getMidSquarePoints(forFrame frame: CGRect) -> (leftSquare: CGPoint, rightSquare: CGPoint) {
        let squareHeight    = frame.height  / CGFloat(height * 2)
        let squareWidth     = frame.width   / CGFloat(width  * 2)
        
        let squaresY   = frame.height / CGFloat(2.0)
        
        return (CGPoint(x:squareWidth, y:squaresY), CGPoint(x: frame.width - squareWidth, y: squaresY))
    }
}


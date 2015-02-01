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
    
    var wallsArray: [(rightWall: Bool, bottomWall: Bool)]
    
    init(width: Int, height: Int) {
        self.width  = width
        self.height = height
        // Don't have last column and top row
        wallsArray = Array(count: (width - 1) * (height - 1), repeatedValue: (false,false))
    }
    
    mutating func addWalls(x: Int, y: Int, right: Bool, bottom: Bool) {
        wallsArray[(y * (width - 1)) + x] = (rightWall: right, bottomWall: bottom)
    }
    
    func getPoints(forFrame frame: CGRect) -> [(CGPoint, CGPoint)] {
        var pointsArray = [(CGPoint, CGPoint)]()
        
        for square in wallsArray {
            if square.bottomWall {
//                let point1 = CGPoint s(x: , y: )
                
//                pointsArray.append()
            }
        }
        
        return pointsArray
    }
}



struct Wall {
    var startPoint: CGPoint
    var endPoint: CGPoint
}
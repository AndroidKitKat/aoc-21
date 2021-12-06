//
//  main.swift
//  day05
//
//  Created by skg on 12/5/21.
//  Copyright © 2021 WaifuPaste Ltd. All rights reserved.
//

import Foundation

struct Line {
    let leftPoint: (Int, Int)
    let rightPoint: (Int, Int)
}

extension Line {
    /// Init function for making a line with a strings for the endpoints
    /// - Parameter coords: A String Array of the coordinates
    init(leftPoint: String, rightPoint: String) {
        self.leftPoint = (Int(leftPoint.split(separator: ",")[0])!, Int(leftPoint.split(separator: ",")[1])!)
        self.rightPoint = (Int(rightPoint.split(separator: ",")[0])!, Int(rightPoint.split(separator: ",")[1])!)
    }
    
    var isStraight: Bool {
        leftPoint.0 == rightPoint.0  || leftPoint.1 == rightPoint.1
    }
    
    // (dy, dx)
    var slope: (Int, Int) {
        if leftPoint.0 == rightPoint.0 { // vert
            return (leftPoint.1 < rightPoint.1 ? 1 : -1 ,0)
        } else if leftPoint.1 == rightPoint.1 { // horiz
            return (0, (leftPoint.0 < rightPoint.0 ? 1 : -1))
        } else {
            return (leftPoint.1 < rightPoint.1 ? 1 : -1, leftPoint.0 < rightPoint.0 ? 1 : -1)
        }
    }
}

class Grid {
    var grid: [[Int]]
    
    init(length: Int, height: Int) {
        self.grid = Array(repeating: Array(repeating: 0, count: height), count: length)
    }
    
    /// Plots a line on the grid
    /// - Parameters:
    ///   - left: (x,y) coordinates of the line's left endpoint
    ///   - right: (x,y) coordinates of the line's right endpoint.
    func plot(line: Line) {
        // we will plot points starting in the top left to the bottom right
        /*
         ______________
         |\
         | \
         |  \
         |   \
         |    \
         |     \
         |      v
         
         like this
         */
        // always make sure the left point is smaller
        let plottingLine: Line
        if line.rightPoint.0 < line.leftPoint.0 || line.rightPoint.1 < line.leftPoint.1 {
            plottingLine = Line(leftPoint: line.rightPoint, rightPoint: line.leftPoint)
        } else {
            plottingLine = line
        }
        
        var plottingPoint: (Int, Int) = (plottingLine.leftPoint.0, plottingLine.leftPoint.1)
        plotPoint(plottingPoint)
        while plottingPoint.0 != plottingLine.rightPoint.0 || plottingPoint.1 != plottingLine.rightPoint.1 {
            plottingPoint.0 += plottingLine.slope.1
            plottingPoint.1 += plottingLine.slope.0
            plotPoint(plottingPoint)
        }
        
    }
    
    internal func plotPoint(_ point: (Int, Int)) {
        self.grid[point.1][point.0] += 1
    }
    
    func countOverlap() -> Int {
        return self.grid.flatMap { $0 }.filter { $0 > 1}.count
    }
    
    func printGrid() {
        for row in grid {
            print(row)
        }
    }
}

var lines: [Line] = []

while let line = readLine() {
    let rawLines = line.components(separatedBy: CharacterSet(charactersIn: " -> ")).filter { !$0.isEmpty }
    lines.append(Line(leftPoint: rawLines[0], rightPoint: rawLines[1]))
}

// now we need to determine the size of our grid
var len: Int = 0
var hgt: Int = 0

for line in lines {
    // handle Xs
    len = line.leftPoint.0 > len ? line.leftPoint.0 : len
    len = line.rightPoint.0 > len ? line.rightPoint.0 : len

    // handle Ys
    hgt = line.leftPoint.1 > hgt ? line.leftPoint.1 : hgt
    hgt = line.rightPoint.1 > hgt ? line.rightPoint.1 : hgt
}

let g: Grid = Grid(length: len+10, height: hgt+10) // 10 for good measure

for line in lines where line.isStraight {
    g.plot(line: line)
}

print(g.countOverlap())


let g2: Grid = Grid(length: len+10, height: hgt+10)
for line in lines {
    g2.plot(line: line)
}

print(g2.countOverlap())

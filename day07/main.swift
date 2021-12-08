//
//  main.swift
//  day07
//
//  Created by Michael Eisemann on 12/7/21.
//  Copyright © 2021 WaifuPaste Ltd. All rights reserved.
//

import Foundation

func gauss(_ n: Int) -> Int {
    return (n * (n + 1))  / 2
}

var crabPositions: [Int] = []

while let line = readLine() {
    crabPositions = line.split(separator: ",").map { Int(String($0))! }
}


let optimalPosition: Int = crabPositions.sorted(by: <)[crabPositions.count / 2]
let optimalFuelCost: Int = crabPositions.map { abs(optimalPosition - $0) }.reduce(0, +)
print(optimalFuelCost)

var smallestDistance: Int = Int.max
let minPos:Int = crabPositions.min()!
let maxPos:Int = crabPositions.max()!

for i in minPos...maxPos {
    let dyanmicDistances:[Int] = crabPositions.map { gauss(abs(i - $0)) }
    let dynamicFuelCost: Int = dyanmicDistances.reduce(0, +)
    if smallestDistance > dynamicFuelCost {
        smallestDistance = dynamicFuelCost
    }
}

print(smallestDistance)


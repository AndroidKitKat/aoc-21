//
//  main.swift
//  day06
//
//  Created by Michael Eisemann on 12/6/21.
//  Copyright © 2021 WaifuPaste Ltd. All rights reserved.
//

import Foundation

struct Lanternfish {
    var daysLeft: Int
}

class School {
    var fishBuckets: [Int: Int]

    init(_ fishes: [Lanternfish] = []) {
        self.fishBuckets = [:]
        for f in fishes {
            self.fishBuckets[f.daysLeft] = self.fishBuckets[f.daysLeft, default: 0] + 1
        }
    }


    func simulateDay() {

        var fishDict: [Int:Int] = [:]
        // shoutout to pbui for the algo
        // first, age all the fish in the bucket (aka, move the buckets down)
        // (akaka, day 4 fish become day 3 fish etc)
        for (daysLeft, count) in self.fishBuckets {
            fishDict[daysLeft - 1] = count
        }

        // handle fish that gave birth
        if fishDict.keys.contains(-1) {
            fishDict[6] = fishDict[6, default: 0] + fishDict[-1, default: 0]
            fishDict[8] = fishDict[8, default: 0] + fishDict[-1, default: 0]
            fishDict.removeValue(forKey: -1)
        }

        self.fishBuckets = fishDict
        
    }
}

var initialSchool: [Lanternfish] = []

while let line = readLine() {
    initialSchool = line.split(separator: ",").map { Lanternfish(daysLeft: Int(String($0))!) }
}

var s = School(initialSchool)
for _ in 1...80 {
    s.simulateDay()
}

print(s.fishBuckets.values.reduce(0, +))

for _ in 81...256 {
    s.simulateDay()
}

print(s.fishBuckets.values.reduce(0,+))



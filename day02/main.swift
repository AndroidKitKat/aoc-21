//
//  main.swift
//  day02
//
//  Created by Michael Eisemann on 12/2/21.
//

import Foundation

enum Heading: String {
  case up = "up"
  case down = "down"
  case forward = "forward"
}

struct Direction {
  let heading: Heading
  let magnitude: Int
}

class Submarine {
 var directions: [Direction] = []
 var depth: Int = 0
 var aim: Int = 0
 var horizontalPosition: Int = 0
 func processDirectionsAndResetPosition(calculateAim: Bool) {
   for direction in directions {
     switch direction.heading {
        case .up:
        if calculateAim {
          aim = aim - direction.magnitude
        } else {
          depth = depth - direction.magnitude
        }
        case .down:
        if calculateAim {
          aim = aim + direction.magnitude
        } else {
          depth = depth + direction.magnitude
        }
        case .forward:
        if calculateAim {
          horizontalPosition = horizontalPosition + direction.magnitude
          depth = depth + (aim * direction.magnitude)
        } else {
          horizontalPosition = horizontalPosition + direction.magnitude
        }
     }
   }
   print("\(self.depth * self.horizontalPosition)")
   self.resetPosition()
 }
 private func resetPosition() {
   self.aim = 0
   self.depth = 0
   self.horizontalPosition = 0
 }
}

var sub = Submarine()

while let line = readLine() {
  let splitLine = line.components(separatedBy: " ")
  let direction = Direction(heading: Heading(rawValue: String(splitLine[0]))!, magnitude: Int(splitLine[1])!)
  sub.directions.append(direction)
}

sub.processDirectionsAndResetPosition(calculateAim: false)
sub.processDirectionsAndResetPosition(calculateAim: true)


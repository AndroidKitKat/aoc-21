//
//  main.swift
//  day03
//
//  Created by Michael Eisemann on 12/3/21.
//

import Foundation

extension String {
    
    var length: Int {
        return count
    }
    
    subscript (i: Int) -> String {
        return self[i ..< i + 1]
    }
    
    func substring(fromIndex: Int) -> String {
        return self[min(fromIndex, length) ..< length]
    }
    
    func substring(toIndex: Int) -> String {
        return self[0 ..< max(0, toIndex)]
    }
    
    subscript (r: Range<Int>) -> String {
        let range = Range(uncheckedBounds: (lower: max(0, min(length, r.lowerBound)),
                                            upper: min(length, max(0, r.upperBound))))
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
        return String(self[start ..< end])
    }
}

struct Transmission {
    var bits: [Int]
}

extension Transmission {
    init(_ raw: String) {
        bits = []
        for bit in raw {
            bits.append(Int(String(bit))!)
        }
    }
}

class DiagnosticsReport {
    let transmissions: [Transmission]
    internal var commonBits: [Int] = []
    
    init(_ transmissions: [Transmission]) {
        self.transmissions = transmissions
        self.commonBits = DiagnosticsReport.getCommonBits(self.transmissions)
    }
    
    static func getCommonBits(_ transmissions:[Transmission]) -> [Int] {
        var columnSum: [Int] = []
        var commonBits: [Int] = []
        for i in 0..<transmissions[0].bits.count {
            var summit: Int = 0
            for transmission in transmissions {
                summit = summit + transmission.bits[i]
            }
            columnSum.append(summit)
        }
        for num in columnSum {
            if (num > transmissions.count - num) {
                commonBits.append(1)
            } else if (num < transmissions.count - num) {
                commonBits.append(0)
            } else {
                commonBits.append(3)
            }
        }
        return commonBits
    }
    
    func getGamma() -> Int {
        return Int(commonBits.map(String.init).joined(), radix: 2)!
    }
    
    class func transBinToDec(transmission: Transmission) -> Int {
        return Int(transmission.bits.map(String.init).joined(), radix: 2)!
    }
    
    func getEpsilon() -> Int {
        //Replace all the 1's with 2's, then replace the 0's with 1's, finally replacing the 2's with 0's.
        return Int(commonBits.map(String.init).joined().replacingOccurrences(of: "1", with: "2").replacingOccurrences(of: "0", with: "1").replacingOccurrences(of:"2", with: "0"), radix: 2)!
    }
    
    class func bitCriteriaFilter(filterTransmissions: [Transmission], position: Int, prefers: Int) -> [Transmission] {
        // we need to check for a tiebreaker BEFORE we add anything
        var commonBits = DiagnosticsReport.getCommonBits(filterTransmissions)
        if prefers == 0 {
            commonBits = flipBits(commonBits)
        }
        var leftoverTransitions: [Transmission] = []
        if (commonBits[position] == 3 ) {
            for transmission in filterTransmissions {
                if transmission.bits[position] == prefers {
                    leftoverTransitions.append(transmission)
                }
            }
        } else {
            let filterCriteria: Int = commonBits[position]
//            if prefers == 0 {
//                filterCriteria = flipBits(filterTransmissions[0].bits)[position]
//            } else {
//                filterCriteria = commonBits[position]
//            }
            // let filterCriteria: Int = prefers == 0 ? DiagnosticsReport.flipBits([commonBits[position]])[0]: commonBits[position]
            for transmission in filterTransmissions {
                if transmission.bits[position] == filterCriteria {
                    leftoverTransitions.append(transmission)
                }
            }
        }
        return leftoverTransitions
    }
    
    static func flipBits(_ toFlip: [Int]) -> [Int] {
        // return Int(commonBits.map(String.init).joined().replacingOccurrences(of: "1", with: "2").replacingOccurrences(of: "0", with: "1").replacingOccurrences(of:"2", with: "0"), radix: 2)!
        return toFlip.map(String.init).joined().replacingOccurrences(of: "1", with: "2").replacingOccurrences(of: "0", with: "1").replacingOccurrences(of:"2", with: "0").map { Int(String($0))! }
    }
}

let report: DiagnosticsReport
var transmissions: [Transmission] = []

while let line = readLine() {
    transmissions.append(Transmission(line))
}

let reportOne = DiagnosticsReport(transmissions)
print(reportOne.getEpsilon() * reportOne.getGamma())

var oxygenTransmissions: [Transmission] = reportOne.transmissions
var coTwoTransmissions: [Transmission] = reportOne.transmissions

// oxygen scrub
for bit in 0..<reportOne.transmissions[0].bits.count {
    oxygenTransmissions = DiagnosticsReport.bitCriteriaFilter(filterTransmissions: oxygenTransmissions, position: bit, prefers: 1)
}

print(oxygenTransmissions)


// co2 scrub
for bit in 0..<reportOne.transmissions[0].bits.count {
    if coTwoTransmissions.count == 1 {
        break
    }
    coTwoTransmissions = DiagnosticsReport.bitCriteriaFilter(filterTransmissions: coTwoTransmissions, position: bit, prefers: 0)
}

print(coTwoTransmissions)

print(DiagnosticsReport.transBinToDec(transmission: oxygenTransmissions[0]) * DiagnosticsReport.transBinToDec(transmission: coTwoTransmissions[0]))

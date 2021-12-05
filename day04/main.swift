//
//  main.swift
//  day04
//
//  Created by Michael Eisemann on 12/4/21.
//  Copyright © 2021 WaifuPaste Ltd. All rights reserved.
//

import Foundation

class Board {
    let standard: [[Int]]
    var marked: [[Int]]

    init(_ board: [[Int]]) {
        self.standard = board
        self.marked = Array(repeating: Array(repeating: 0, count: board.count), count: board[0].count)
    }
    
    internal func markBoard(_ number: Int) {
        for rowPos in 0..<self.standard.count {
            for colPos in 0..<self.standard[0].count {
                if self.standard[rowPos][colPos] == number {
                    self.marked[rowPos][colPos] = 1
                }
            }
        }
    }
    
    internal func checkWinner(_ board: [[Int]]) -> Bool {
        // since I am using transpose, all I need to check is if a row is all True
        for row in board {
            if row.allSatisfy({ $0 == 1}) {
                 return true
            }
        }
        return false
    }
    
    internal func sumNonWinners() -> Int {
        var sum: Int = 0
        for rowPos in 0..<self.standard.count {
            for colPos in 0..<self.standard[0].count {
                if self.marked[rowPos][colPos] == 0 {
                    sum = sum + self.standard[rowPos][colPos]
                }
            }
        }
        return sum
    }
    
    internal func transpose(_ board: [[Int]]) -> [[Int]] {
        let rowCount = board.count
        let colCount = board[0].count
        var transposed: [[Int]] = Array(repeating: Array(repeating: 0, count: rowCount), count: colCount)
        for rowPos in 0..<board.count {
            for colPos in 0..<board[0].count {
                transposed[colPos][rowPos] = board[rowPos][colPos]
            }
        }
        return transposed
    }
}

class Game {
    var boards: [Board]
    var numbers: [Int]
    
    init(boards: [Board] = [], numbers: [Int] = []) {
        self.boards = boards
        self.numbers = numbers
    }
}

var puzzleActive: Bool = false
var bingoBoard: [[Int]] = []

var squid: Game = Game()

while let line = readLine() {
    if line.contains(",") { // numbers called
        squid.numbers = line.split(separator: ",").map{ Int($0)! }
    } else if line.isEmpty {
        if !puzzleActive {
            puzzleActive = true
            continue
        }
        // add the puzzle here
        squid.boards.append(Board(bingoBoard))
        bingoBoard.removeAll()
    } else if puzzleActive {
        bingoBoard.append(line.split(separator: " ").map { Int($0)! })
    }
}
// handle the last board
squid.boards.append(Board(bingoBoard))

outerLoop: for number in squid.numbers {
    // mark a number
    for board in squid.boards {
        board.markBoard(number)
    }
    // check if we have a winner
    for board in squid.boards {
        if board.checkWinner(board.marked) || board.checkWinner(board.transpose(board.marked)) {
            print(number * board.sumNonWinners())
            break outerLoop
        }
    }
}

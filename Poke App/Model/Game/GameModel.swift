//
//  GameModel.swift
//  Poke App
//
//  Created by Erix on 25/07/23.
//

import Foundation

struct GameModel {
    private var score = 0
    
    //Check Answer
    mutating func checkAnswer(userAnswer: String, correctAnswer: String) -> Bool {
        if userAnswer.lowercased() == correctAnswer.lowercased() {
            score += 1
            return true
        }
        return false
    }
    
    func getScore() -> Int {
        return score
    }
    
    mutating func setScore(score: Int) {
        self.score = score
    }
}

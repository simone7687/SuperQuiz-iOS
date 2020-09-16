//
//  Quiz.swift
//  Quiz-IOS
//
//  Created by Simone on 16/09/2020.
//  Copyright © 2020 Simone Massaro. All rights reserved.
//

import Foundation

enum QuizType {
    case Normat
    case Multiple
    case Open
}

struct Quiz {
    var type : QuizType
    var question : String
    var answers : [String]?
    var correctAnswers : [Int]?
    var correctAnswerText : String?
    
    init(type : QuizType, question : String, answers : [String]?, correctAnswers : [Int]?, correctAnswerText : String?) {
        self.type = type
        self.question = question
        self.answers = answers
        self.correctAnswers = correctAnswers
        self.correctAnswerText = correctAnswerText
    }
}

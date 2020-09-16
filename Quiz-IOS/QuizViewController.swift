//
//  QuizViewController.swift
//  Quiz-IOS
//
//  Created by Simone on 16/09/2020.
//  Copyright © 2020 Simone Massaro. All rights reserved.
//

import UIKit

class QuizViewController: UIViewController {
    @IBOutlet weak var questionText: UILabel!
    @IBOutlet weak var answer1: UIButton!
    @IBOutlet weak var answer2: UIButton!
    @IBOutlet weak var answer3: UIButton!
    @IBOutlet weak var answer4: UIButton!
    @IBOutlet weak var continueButton: UIButton!

    var score : Int = 0
    var currentAnswers : [Int] = []
    var currentQuiz : Int = 0
    var quizzes = [Quiz]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Initialize the quiz
        createQuiz()
        // Start Game
        startGame()
    }

    /**
     * Create a set of quizzes
     */
    func createQuiz() {
        // Randomize the questions
        quizzes.shuffle()
    }

    /**
     * Start the game
     */
    func startGame() {
        score = 0
        currentQuiz = 0
        showQuiz(quiz: quizzes[currentQuiz])
    }
}

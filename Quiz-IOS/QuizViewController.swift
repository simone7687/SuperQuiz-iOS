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
    @IBOutlet weak var answerField: UITextField!
    @IBOutlet weak var answer1: UIButton!
    @IBOutlet weak var answer2: UIButton!
    @IBOutlet weak var answer3: UIButton!
    @IBOutlet weak var answer4: UIButton!
    @IBOutlet weak var continueButton: UIButton!

    @IBAction func answer1Click(_ sender: Any) {
        clickAnswerButton(selectAnswer: 0)
    }
    @IBAction func answer2Click(_ sender: Any) {
        clickAnswerButton(selectAnswer: 1)
    }
    @IBAction func answer3Click(_ sender: Any) {
        clickAnswerButton(selectAnswer: 2)
    }
    @IBAction func answer4Click(_ sender: Any) {
        clickAnswerButton(selectAnswer: 3)
    }
    @IBAction func continueClick(_ sender: Any) {
        if(quizzes[currentQuiz].type == QuizType.Multiple) {
        } else if (quizzes[currentQuiz].type == QuizType.Open) {
            let textAnswer = answerField.text?.lowercased()
            if (checkAnswer(text: textAnswer))  {
                // Correct
                // Todo: sound
                score += 1
                dialogResult(result: true)
            } else {
                // Wrong
                // Todo: sound
                dialogResult(result: false)
            }
        }
    }

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
     * Hides the buttons
     */
    func setHiddenButtons(disp : Bool) {
        answer1.isHidden = disp
        answer2.isHidden = disp
        answer3.isHidden = disp
        answer4.isHidden = disp
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
        showQuiz(quiz: quizzes[0])
    }

    /**
     * Show quiz by type
     */
    func showQuiz(quiz : Quiz) {
        answerField.text = ""
        questionText.text = quiz.question
        questionText.isHidden = false
        currentAnswers.removeAll()
        
        if (quiz.type == QuizType.Normal || quiz.type == QuizType.Multiple) {
            answer1.setTitle(quiz.answers?[0], for: .normal)
            answer2.setTitle(quiz.answers?[1], for: .normal)
            answer3.setTitle(quiz.answers?[2], for: .normal)
            answer4.setTitle(quiz.answers?[3], for: .normal)
            
            answerField.isHidden = true
            continueButton.isHidden = true
            setHiddenButtons(disp : false)
        }
        else if (quiz.type == QuizType.Open) {
            answerField.isHidden = false
            setHiddenButtons(disp : true)
        }
        if (quiz.type == QuizType.Multiple || quiz.type == QuizType.Open) {
            continueButton.isHidden = false
        }
    }

    func clickAnswerButton(selectAnswer : Int?) {
        if(quizzes[currentQuiz].type == QuizType.Normal) {
            if (checkAnswer(selectAnswer : selectAnswer)) {
                // Correct
                // Todo: sound
                score += 1
                dialogResult(result: true)
            } else {
                // Wrong
                // Todo: sound
                dialogResult(result: false)
            }
        }
        else if (quizzes[currentQuiz].type == QuizType.Multiple) {
    }

    /**
     * Check the answer
     */
    func checkAnswer(selectAnswer : Int?) -> Bool {
        if (quizzes[currentQuiz].type == QuizType.Normal) {
            if (quizzes[currentQuiz].correctAnswers!.contains(selectAnswer!)) {
                return true
            }
            else {
                return false
            }
        }
        return false
    }
    func checkAnswer(text : String?) -> Bool {
        return text!.contains(String(quizzes[currentQuiz].correctAnswerText!.lowercased()))
    }

    /**
     * Show a message to know if your answer is correct.
     */
    func dialogResult(result : Bool)
    {
        let description = result ? "Well, your answer is correct." : "Argh! the answer is wrong."
        
        let dialogMessage = UIAlertController(title: "Result of the answer", message: description, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            self.nextQuiz()
        })
        //Add OK button to a dialog message
        dialogMessage.addAction(ok)
        // Present Alert to 
        self.present(dialogMessage, animated: true, completion: nil)
    }

    /**
     * End of the game
     */
    func endGame() {
        let dialogMessage = UIAlertController(title: "End of the game", message: "Your score is: " + String(self.score), preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            // Todo: Come back
        })
        //Add OK button to a dialog message
        dialogMessage.addAction(ok)
        // Present Alert to 
        self.present(dialogMessage, animated: true, completion: nil)
    }
    
    /**
     * Move on to the next quiz if the quizzes are finished finish the game
     */
    func nextQuiz() {
        if (currentQuiz < quizzes.count - 1) {
            currentQuiz += 1;
            showQuiz(quiz: quizzes[currentQuiz])
        }
        else {
            self.endGame()
        }
    }
}

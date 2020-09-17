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
        clickAnswerButton(answer: 0)
    }
    @IBAction func answer2Click(_ sender: Any) {
        clickAnswerButton(answer: 1)
    }
    @IBAction func answer3Click(_ sender: Any) {
        clickAnswerButton(answer: 2)
    }
    @IBAction func answer4Click(_ sender: Any) {
        clickAnswerButton(answer: 3)
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
        currentAnswers.removeAll()
        questionText.text = quiz.question
        
        if (quiz.type == QuizType.Normal || quiz.type == QuizType.Multiple) {
            let txt1 = quiz.answers?[0]
            let txt2 = quiz.answers?[1]
            let txt3 = quiz.answers?[2]
            let txt4 = quiz.answers?[3]
            answer1.setTitle(txt1, for: .normal)
            answer2.setTitle(txt2, for: .normal)
            answer3.setTitle(txt3, for: .normal)
            answer4.setTitle(txt4, for: .normal)
            
            answerField.isHidden = true
            continueButton.isHidden = true

            setHiddenButtons(disp : false)
        }
        else if (quiz.type == QuizType.Open) {
            setHiddenButtons(disp : true)
            answerField.isHidden = false
            continueButton.isHidden = false
        }
        questionText.isHidden = false
        
        if (quiz.type == QuizType.Multiple) {
            continueButton.isHidden = false
        }
    }

    func clickAnswerButton(answer : Int?) {
        if(quizzes[currentQuiz].type == QuizType.Normal) {
            if (checkAnswer(answer : answer)) {
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

    /**
     * Check the answer
     */
    func checkAnswer(answer : Int?) -> Bool {
        if (quizzes[currentQuiz].type == QuizType.Normal) {
            if ((quizzes[currentQuiz].correctAnswers?.contains(answer!)) != nil) {
                return true
            }
            else {
                return false
            }
        }
        return false
    }

    /**
     * Show a message to know if your answer is correct.
     */
    func dialogResult(result : Bool)
    {
        var description = result ? "Well, your answer is correct." : "Argh! the answer is wrong."
        
        let dialogMessage = UIAlertController(title: "Result of the answer", message: description, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            nextQuiz()
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

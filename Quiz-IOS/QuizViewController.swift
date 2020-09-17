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
        if (quizzes[currentQuiz].type == QuizType.Normal) {
            clickAnswerButton(selectAnswer: 0)
        }
        else if (quizzes[currentQuiz].type == QuizType.Multiple) {
            pressedButton(button: answer1)
        }
    }
    @IBAction func answer2Click(_ sender: Any) {
        if (quizzes[currentQuiz].type == QuizType.Normal) {
            clickAnswerButton(selectAnswer: 1)
        }
        else if (quizzes[currentQuiz].type == QuizType.Multiple) {
            pressedButton(button: answer2)
        }
    }
    @IBAction func answer3Click(_ sender: Any) {
        if (quizzes[currentQuiz].type == QuizType.Normal) {
            clickAnswerButton(selectAnswer: 2)
        }
        else if (quizzes[currentQuiz].type == QuizType.Multiple) {
            pressedButton(button: answer3)
        }
    }
    @IBAction func answer4Click(_ sender: Any) {
        if (quizzes[currentQuiz].type == QuizType.Normal) {
            clickAnswerButton(selectAnswer: 3)
        }
        else if (quizzes[currentQuiz].type == QuizType.Multiple) {
            pressedButton(button: answer4)
        }
    }
    @IBAction func continueClick(_ sender: Any) {
        if(quizzes[currentQuiz].type == QuizType.Multiple) {
            var answers : [Int] = []
            if(answer1.backgroundColor == UIColor.gray) {answers.append(0)}
            if(answer2.backgroundColor == UIColor.gray) {answers.append(1)}
            if(answer3.backgroundColor == UIColor.gray) {answers.append(2)}
            if(answer4.backgroundColor == UIColor.gray) {answers.append(3)}
            if (checkAnswer(answers: answers))  {
                // Correct
                // Todo: sound
                score += 1
                dialogResult(result: true)
            } else {
                // Wrong
                // Todo: sound
                dialogResult(result: false)
            }
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
    var currentQuiz : Int = 0
    var quizzes = [Quiz]()

    override func viewDidLoad() {
        super.viewDidLoad()

        setNotPressedButtons()

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

    func pressedButton(button : UIButton) {
        if button.backgroundColor == UIColor.gray {
            button.backgroundColor = UIColor.blue
        }
        else if button.backgroundColor == UIColor.blue {
            button.backgroundColor = UIColor.gray
        }
    }

    func setNotPressedButtons() {
        answer1.backgroundColor = UIColor.blue
        answer2.backgroundColor = UIColor.blue
        answer3.backgroundColor = UIColor.blue
        answer4.backgroundColor = UIColor.blue
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
        setNotPressedButtons()
        answerField.text = ""
        questionText.text = quiz.question
        
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
    func checkAnswer(answers : [Int]?) -> Bool {
        if (quizzes[currentQuiz].type == QuizType.Multiple) {
            return !(answers!.sorted() == quizzes[currentQuiz].correctAnswers!.sorted())
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

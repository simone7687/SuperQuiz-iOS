//
//  QuizViewController.swift
//  Quiz-IOS
//
//  Created by Simone on 16/09/2020.
//  Copyright © 2020 Simone Massaro. All rights reserved.
//

import AVFoundation
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
            if(answer1.tintColor == UIColor.gray) {answers.append(0)}
            if(answer2.tintColor == UIColor.gray) {answers.append(1)}
            if(answer3.tintColor == UIColor.gray) {answers.append(2)}
            if(answer4.tintColor == UIColor.gray) {answers.append(3)}
            if (checkAnswer(answers: answers))  {
                // Correct
                playSound(file: "correct", fileType: "mp3")
                score += 1
                dialogResult(result: true)
            } else {
                // Wrong
                playSound(file: "error", fileType: "mp3")
                dialogResult(result: false)
            }
        } else if (quizzes[currentQuiz].type == QuizType.Open) {
            let textAnswer = answerField.text?.lowercased()
            if (checkAnswer(text: textAnswer))  {
                // Correct
                playSound(file: "correct", fileType: "mp3")
                score += 1
                dialogResult(result: true)
            } else {
                // Wrong
                playSound(file: "error", fileType: "mp3")
                dialogResult(result: false)
            }
        }
    }

    var score : Int = 0
    var currentQuiz : Int = 0
    var quizzes = [Quiz]()
    var colorButton = UIColor.blue
    var player: AVAudioPlayer?

    override func viewDidLoad() {
        super.viewDidLoad()

        colorButton = answer1.tintColor

        // Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))

        // tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)

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
        if button.tintColor == UIColor.gray {
            button.tintColor = colorButton
        }
        else if button.tintColor == colorButton {
            button.tintColor = UIColor.gray
        }
    }

    func setNotPressedButtons() {
        answer1.tintColor = colorButton
        answer2.tintColor = colorButton
        answer3.tintColor = colorButton
        answer4.tintColor = colorButton
    }

    /**
     * Create a set of quizzes
     */
    func createQuiz() {

        let quiz1 = Quiz(type: QuizType.Normal, question: "What is the largest state in the world?", answers: ["United States", "Russia", "Canada", "China"], correctAnswers: [1], correctAnswerText: nil)
        let quiz2 = Quiz(type: QuizType.Normal, question: "Who is the current American president?", answers: ["George Washington", "George W. Bush", "Barack Obama", "Donald Trump"], correctAnswers: [3], correctAnswerText: nil)
        let quiz3 = Quiz(type: QuizType.Normal, question: "Which man took the first step on the moon?", answers: ["Neil Armstrong", "Cristoforo Colombo", "Peter Griffin", "Michael Collins"], correctAnswers: [0], correctAnswerText: nil)
        let quiz4 = Quiz(type: QuizType.Open, question: "How much is 60 + 54?", answers: nil, correctAnswers: nil, correctAnswerText: "114")
        let quiz5 = Quiz(type: QuizType.Multiple, question: "What are the primary colors?", answers: ["Blue", "Violet", "Green", "Red"], correctAnswers: [0,3], correctAnswerText: nil)
        let quiz6 = Quiz(type: QuizType.Open, question: "In what year was America discovered?", answers: nil, correctAnswers: nil, correctAnswerText: "1492")
        let quiz7 = Quiz(type: QuizType.Normal, question: "Who is the founder of Apple?", answers: ["Silvio Berlusconi", "Steve Jobs", "Bill Gates", "Mark Zuckerberg"], correctAnswers: [1], correctAnswerText: nil)
        let quiz8 = Quiz(type: QuizType.Normal, question: "Who is the founder of Facebook?", answers: ["Silvio Berlusconi", "Steve Jobs", "Bill Gates", "Mark Zuckerberg"], correctAnswers: [3], correctAnswerText: nil)
        let quiz9 = Quiz(type: QuizType.Multiple, question: "What are the primitive numbers?", answers: ["17", "11", "4", "9"], correctAnswers: [0,1], correctAnswerText: nil)
        let quiz10 = Quiz(type: QuizType.Multiple, question: "What numbers are divisible by 3?", answers: ["9", "8", "12", "20"], correctAnswers: [0,2], correctAnswerText: nil)
        quizzes = [quiz1, quiz2, quiz3, quiz4, quiz5, quiz6, quiz7, quiz8, quiz9, quiz10]

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
                playSound(file: "correct", fileType: "mp3")
                score += 1
                dialogResult(result: true)
            } else {
                // Wrong
                playSound(file: "error", fileType: "mp3")
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
            return (answers!.sorted() == quizzes[currentQuiz].correctAnswers!.sorted())
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
            self.navigationController?.popViewController(animated: true)
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

    /**
     * Plays a sound based on the answer correctness
     */
    func playSound(file : String, fileType : String) {
        guard let url = Bundle.main.url(forResource: file, withExtension: fileType) else { return }

        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)            
            try AVAudioSession.sharedInstance().setActive(true)

            /* The following line is required for the player to work on iOS 11. Change the file type accordingly*/
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)

            /* iOS 10 and earlier require the following line:
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileTypeMPEGLayer3) */

            guard let player = player else { return }

            player.play()

        } catch let error {
            print(error.localizedDescription)
        }
    }

    // Calls this function when the tap is recognized.
    @objc func dismissKeyboard() {
        // Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
}

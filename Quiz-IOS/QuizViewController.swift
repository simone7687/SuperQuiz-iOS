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

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

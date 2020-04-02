//
//  QuestionViewController.swift
//  quiz
//
//  Created by Vladimir Dyakov on 02/04/2020.
//  Copyright © 2020 Vladimir Dyakov. All rights reserved.
//

import UIKit

class QuestionViewController: UIViewController {
    
    @IBOutlet var questionLabel: UILabel!
    @IBOutlet var questionProgress: UIProgressView!
    
    //Single
    @IBOutlet var singleStackview: UIStackView!
    @IBOutlet var singleButtons: [UIButton]!
    
    //Multiple
    @IBOutlet var multipleStackview: UIStackView!
    @IBOutlet var multipleLabels: [UILabel]!
    @IBOutlet var multipleSwitches: [UISwitch]!
    
    //Ranged
    @IBOutlet var rangedStackview: UIStackView!
    @IBOutlet var rangedLabels: [UILabel]!
    @IBOutlet var rangedSlider: UISlider!
    
    private let questions = Question.getQuestions()
    private var questionIndex = 0
    private var answersChoosen: [Answer] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    @IBAction func singleAnswersButtonPressed(_ sender: UIButton) {
        let currentAnswers = questions[questionIndex].answers
        guard let currentIndex = singleButtons.firstIndex(of: sender) else {return}
        
        let currentAnswer = currentAnswers[currentIndex]
        answersChoosen.append(currentAnswer)
        
        nextQuestion()
    }
    
    @IBAction func multipleAnswersButtonPressed() {
        let currentAnswers = questions[questionIndex].answers
        
        for (multipleSwitch, answer) in zip(multipleSwitches, currentAnswers) {
            if multipleSwitch.isOn {
                answersChoosen.append(answer)
            }
        }
        
        nextQuestion()
    }
    
    @IBAction func rangedAnswersButtonPressed() {
        let currentAnswers = questions[questionIndex].answers
        let index = Int(round(rangedSlider.value * Float(currentAnswers.count - 1)))
        
        answersChoosen.append(currentAnswers[index])
        
        nextQuestion()
    }
    
    private func updateUI() {
        for stackview in [singleStackview, multipleStackview, rangedStackview] {
            stackview?.isHidden = true
        }
        
        let currentQuestion = questions[questionIndex]
        
        questionLabel.text = currentQuestion.text
        
        let totalProgress = Float(questionIndex) / Float(questions.count)
        questionProgress.setProgress(totalProgress, animated: true)
        
        title = "Вопрос № \(questionIndex + 1) из \(questions.count)"
        
        let currentAnswers = currentQuestion.answers
        
        switch currentQuestion.type {
        case .single:
            updateSingleStackview(using: currentAnswers)
        case .multiple:
            updateMultipleStackview(using: currentAnswers)
        case .ranged:
            updateRangedStackview(using: currentAnswers)
        }
    }
    
    private func updateSingleStackview(using answers: [Answer]) {
        singleStackview.isHidden = false
        
        for (button, answer) in zip(singleButtons, answers) {
            button.setTitle(answer.text, for: .normal)
        }
    }
    
    private func updateMultipleStackview(using answers: [Answer]) {
        multipleStackview.isHidden = false
        
        for (label, answer) in zip(multipleLabels, answers) {
            label.text = answer.text
        }
    }
    
    private func updateRangedStackview(using answers: [Answer]) {
        rangedStackview.isHidden = false
        
        rangedLabels.first?.text = answers.first?.text
        rangedLabels.last?.text = answers.last?.text
    }
    
    private func nextQuestion(){
        questionIndex += 1
        
        if questionIndex < questions.count {
            updateUI()
        } else {
            performSegue(withIdentifier: "resultSegue", sender: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "resultSegue" else { return }
        let resultVC = segue.destination as! ResultsViewController
        resultVC.responses = answersChoosen
    }
}

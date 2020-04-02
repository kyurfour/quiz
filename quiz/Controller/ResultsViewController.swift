//
//  ResultsViewController.swift
//  quiz
//
//  Created by Vladimir Dyakov on 02/04/2020.
//  Copyright © 2020 Vladimir Dyakov. All rights reserved.
//

import UIKit

class ResultsViewController: UIViewController {

    var responses: [Answer]!

    @IBOutlet var resultAnswerLabel: UILabel!
    @IBOutlet var resultDefinitionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        updateResults()
    }
    
    private func updateResults(){
        var frequencyOfAnimals: [AnimalType: Int] = [:]
        let animals = responses.map {$0.type}
        
        for animal in animals {
            frequencyOfAnimals[animal] = (frequencyOfAnimals[animal] ?? 0) + 1
        }
        
        let sortedFrecuencyOfAnimals = frequencyOfAnimals.sorted { $0.value > $1.value }
        
        guard let mostFrecuencyAnimal = sortedFrecuencyOfAnimals.first?.key else { return }
        
        updateUI(with: mostFrecuencyAnimal)
    }
    
    private func updateUI(with animal: AnimalType) {
        resultAnswerLabel.text = "Вы - \(animal.rawValue)"
        resultDefinitionLabel.text = "\(animal.definition)"
    }
}

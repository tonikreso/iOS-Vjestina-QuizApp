//
//  Quiz+CD.swift
//  QuizApp
//
//  Created by Kompjuter on 27/05/2021.
//

import CoreData
import UIKit

extension Quiz {
    
    init(with entity: CDQuiz) {
        id = Int(entity.identifier)
        title = entity.title!
        description = entity.quizdescription!
        category = QuizCategory(rawValue: entity.category!)!
        level = Int(entity.level)
        imageUrl = entity.imageUrl!
        storedImageData = entity.image
        questions = entity.getQuestions()
        
    }
    
    func populate(_ entity: CDQuiz, in context: NSManagedObjectContext) {
        entity.identifier = Int32(id)
        entity.title = title
        entity.quizdescription = description
        entity.category = category.rawValue
        entity.level = Int32(level)
        entity.imageUrl = imageUrl
        
        let url = URL(string: imageUrl)!
        if let data = try? Data(contentsOf: url) {
            entity.image = UIImage(data: data)?.pngData()
        }
    }
    
}

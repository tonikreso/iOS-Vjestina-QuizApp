//
//  Quiz+CD.swift
//  QuizApp
//
//  Created by Kompjuter on 27/05/2021.
//

import CoreData

extension Quiz {
    
    init(with entity: CDQuiz) {
        id = Int(entity.identifier)
        title = entity.title!
        description = entity.quizdescription!
        category = QuizCategory(rawValue: entity.category!)!
        level = Int(entity.level)
        imageUrl = entity.imageUrl!
        questions = entity.getQuestions()
        
    }
    
    func populate(_ entity: CDQuiz, in context: NSManagedObjectContext) {
        entity.identifier = Int32(id)
        entity.title = title
        entity.quizdescription = description
        entity.category = category.rawValue
        entity.level = Int32(level)
        entity.imageUrl = imageUrl
        
//        let fetch: NSFetchRequest<CDQuestion> = CDQuestion.fetchRequest()
//        do {
//            let results = try context.fetch(fetch)
//            for result in results {
//                entity.questions?.append(result)
//            }
//        } catch {
//            //pass
//        }
        //let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Question")
//        for index in 0...questions.count {
//
//            let cdQuestion = CDQuestion(context: context)
//            questions[index].populate(cdQuestion)
//            entity.questions?.append(cdQuestion)
//        }
    }
}

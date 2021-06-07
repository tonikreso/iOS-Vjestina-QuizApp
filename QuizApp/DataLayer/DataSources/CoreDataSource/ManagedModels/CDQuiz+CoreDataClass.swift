//
//  CDQuiz+CoreDataClass.swift
//  QuizApp
//
//  Created by Kompjuter on 06/06/2021.
//
//

import Foundation
import CoreData

@objc(CDQuiz)
public class CDQuiz: NSManagedObject {
    func getQuestions() -> [Question] {
        var tmpList: [Question] = []
        for index in 1...self.questions!.count {
            tmpList.append(Question(with: (self.questions![index-1]) as! CDQuestion))
        }
        return tmpList
    }
}

//
//  CDQuiz+CoreDataClass.swift
//  QuizApp
//
//  Created by Kompjuter on 26/05/2021.
//
//

import Foundation
import CoreData

@objc(CDQuiz)
public class CDQuiz: NSManagedObject {
    func getQuestions() -> [Question] {
        var tmpList: [Question] = []
        for index in 0...self.questions!.count-1 {
            tmpList.append(Question(with: self.questions![index]))
        }
        return tmpList
    }
}

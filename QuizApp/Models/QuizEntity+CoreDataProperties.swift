//
//  QuizEntity+CoreDataProperties.swift
//  QuizApp
//
//  Created by Lara on 25/05/2021.
//  Copyright © 2021 Lara. All rights reserved.
//
//

import Foundation
import CoreData


extension QuizEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<QuizEntity> {
        return NSFetchRequest<QuizEntity>(entityName: "QuizEntity")
    }

    @NSManaged public var category: String?
    @NSManaged public var id: Int16
    @NSManaged public var imageURL: String?
    @NSManaged public var level: Int16
    @NSManaged public var quizDescription: String?
    @NSManaged public var title: String?
    @NSManaged public var questions: NSSet

}

// MARK: Generated accessors for question
extension QuizEntity {

    @objc(addQuestionsObject:)
    @NSManaged public func addToQuestions(_ value: QuestionEntity)

    @objc(removeQuestionsObject:)
    @NSManaged public func removeFromQuestions(_ value: QuestionEntity)

    @objc(addQuestions:)
    @NSManaged public func addToQuestions(_ values: NSSet)

    @objc(removeQuestions:)
    @NSManaged public func removeFromQuestions(_ values: NSSet)

}

//
//  QuestionEntity+CoreDataProperties.swift
//  QuizApp
//
//  Created by Lara on 25/05/2021.
//  Copyright © 2021 Lara. All rights reserved.
//
//

import Foundation
import CoreData


extension QuestionEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<QuestionEntity> {
        return NSFetchRequest<QuestionEntity>(entityName: "QuestionEntity")
    }

    @NSManaged public var answers: [String]
    @NSManaged public var correctAnswer: Int16
    @NSManaged public var id: Int16
    @NSManaged public var question: String?
    @NSManaged public var quiz: QuizEntity?

}

//
//  QuestionsHelper.swift
//  TriviaApp
//
//  Created by Asim Karel on 28/03/19.
//  Copyright © 2019 Asim. All rights reserved.
//

import Foundation
class QuestionsHelper {
    static var questionHelper:QuestionsHelper!;
    
    public static func sharedInstance() -> QuestionsHelper{
        if questionHelper == nil{
            questionHelper = QuestionsHelper();
        }
        return questionHelper;
    }
    private init(){};
    
    
    func getQuestion(id:Int) -> QuestionModel {
        switch id {
        case 1:
            let question1 = QuestionModel();
            question1.qid = id;
            question1.title = "Who is the best cricketer in the world?"
            question1.options = ["Sachin Tendulkar", "Virat Kolli", "Adam Gilchirst", "Jacques Kallis"]
            question1.isMultiSelect = false;
            return question1;
        case 2:
            let question2 = QuestionModel();
            question2.qid = id;
            question2.title = "What are the colors in the Indian national flag? Select all:"
            question2.options = ["White", "Yellow", "Orange", "Green"]
            question2.isMultiSelect = true;
            return question2;
        default:
            return QuestionModel();
        }
        
    }
    
}

//
//  UserModel.swift
//  TriviaApp
//
//  Created by Asim Karel on 28/03/19.
//  Copyright © 2019 Asim. All rights reserved.
//

import Foundation
import FMDB
class PlayerModel{
    var id:Int32!;
    var name:String!;
    var questions:[QuestionModel]!;
    var selectedOptions:[OptionModel]!
    
    init() {
        selectedOptions = [OptionModel]();
        questions = [QuestionModel]();
        questions.append(DBManager.shared.getQuestion(id: 1));
        questions.append(DBManager.shared.getQuestion(id: 2));
    }
    
    init(result:FMResultSet) {
        questions = [QuestionModel]();
        while result.next(){
            if result.int(forColumn: "UID") != 0{
                id = result.int(forColumn: "UID")
            }
            if result.string(forColumn: "UNAME") != nil{
                name = result.string(forColumn: "UNAME")!;
            }
            if result.string(forColumn: "QID") != nil{
                self.questions.append(QuestionModel(result: result));
            }
            if result.string(forColumn: "SOID") != nil{
                self.selectedOptions.append(OptionModel(result: result));
            }
        }
        
        
    }
    
}

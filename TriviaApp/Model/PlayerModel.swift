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
    var questions:[QuestionModel] = [QuestionModel]();
    var selectedOptions:[OptionModel] = [OptionModel]();
    
    init() {
        selectedOptions = [OptionModel]();
        questions = [QuestionModel]();
        questions.append(DBManager.shared.getQuestion(id: 1));
        questions.append(DBManager.shared.getQuestion(id: 2));
    }
    
    init(result:FMResultSet) {
        questions = [QuestionModel]();
            if result.int(forColumn: "PID") != 0{
                id = result.int(forColumn: "PID")
            }
            if result.string(forColumn: "PNAME") != nil{
                name = result.string(forColumn: "PNAME")!;
            }
//            if result.string(forColumn: "QID") != nil{
//                self.questions.append(QuestionModel(result: result));
//            }
//            if result.string(forColumn: "OID") != nil{
//                self.selectedOptions.append(OptionModel(result: result));
//            }
        
        
    }
    
}

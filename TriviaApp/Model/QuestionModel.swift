//
//  QuestionModel.swift
//  TriviaApp
//
//  Created by Asim Karel on 28/03/19.
//  Copyright © 2019 Asim. All rights reserved.
//

import Foundation
import FMDB
class QuestionModel{
    var id:Int32!;
    var title:String!;
    var options:[OptionModel] = [OptionModel]();
    
    
    init(result:FMResultSet) {
            if result.int(forColumn: "QID") != 0{
                id = result.int(forColumn: "QID")
            }
            if result.string(forColumn: "QTITLE") != nil{
                title = result.string(forColumn: "QTITLE")!;
            }
            
        printMe();
    }
    
    init() {
        
    }
    
    func printMe(){
        print(id)
        print(title)
        print(options)
    }
}



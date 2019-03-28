//
//  OptionModel.swift
//  TriviaApp
//
//  Created by Asim Karel on 28/03/19.
//  Copyright © 2019 Asim. All rights reserved.
//

import Foundation
import FMDB
class OptionModel {
    var id:Int32!;
    var title:String!;
    
    init(result:FMResultSet) {
        if result.int(forColumn: "OID") != 0{
            id = result.int(forColumn: "OID")
        }
        if result.string(forColumn: "OTITLE") != nil{
            title = result.string(forColumn: "OTITLE")!;
        }
    }
}

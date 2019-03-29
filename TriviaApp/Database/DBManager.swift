//
//  DBManager.swift
//  TriviaApp
//
//  Created by Asim Karel on 28/03/19.
//  Copyright © 2019 Asim. All rights reserved.
//

import Foundation
import FMDB
class DBManager: NSObject{
    static let shared: DBManager = DBManager()
    
    let databaseFileName = "database.sqlite"
    
    var pathToDatabase: String!
    
    var database: FMDatabase!
    
    
    override init() {
        super.init()
        
        let documentsDirectory = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString) as String
        pathToDatabase = documentsDirectory.appending("/\(databaseFileName)")
    }
    
    
    
    func createDatabase() -> Bool {
        var created = false
        
        if !FileManager.default.fileExists(atPath: pathToDatabase) {
            database = FMDatabase(path: pathToDatabase!)
            
            if database != nil {
                // Open the database.
                if database.open() {
                    let createQuestionsTableQuery = "CREATE TABLE Questions( id integer primary key autoincrement not null, title text not null)"
                    let createOptionsTableQuery = "CREATE TABLE Options( id integer primary key autoincrement not null, qId integer not null, title text not null)"
                    let createAnswersTableQuery = "CREATE TABLE Answers( id integer primary key autoincrement not null, qId integer not null, oId integer not null, pId integer not null)"
                    let createPlayersTableQuery = "CREATE TABLE Players( id integer primary key autoincrement not null, name text not null)"
                    
                    do {
                        try database.executeUpdate(createQuestionsTableQuery, values: nil)
                        try database.executeUpdate(createOptionsTableQuery, values: nil)
                        try database.executeUpdate(createAnswersTableQuery, values: nil)
                        try database.executeUpdate(createPlayersTableQuery, values: nil)
                        
                        created = true
                    }
                    catch {
                        print("Could not create tables.")
                        print(error.localizedDescription)
                    }
                    
                    database.close()
                }
                else {
                    print("Could not open the database.")
                }
            }
        }
        
        return created
    }
    
    
    func openDatabase() -> Bool {
        if database == nil {
            if FileManager.default.fileExists(atPath: pathToDatabase) {
                database = FMDatabase(path: pathToDatabase)
            }
        }
        
        if database != nil {
            if database.open() {
                return true
            }
        }
        
        return false
    }
    
    func createQuestionsAndOptions(){
        if openDatabase() {
            var question = "INSERT INTO Questions(title) values('Who is the best cricketer in the world?')"
            do {
                try database.executeUpdate(question, values: nil)
                let qid = database.lastInsertRowId
                let options = ["Sachin Tendulkar", "Virat Kolli", "Adam Gilchirst", "Jacques Kallis"]
                for option in options{
                    let optQuery = "INSERT INTO Options (qId, title) VALUES (\(qid),'\(option)')";
                    do {
                        try database.executeUpdate(optQuery, values: nil)
                    }
                }
            }
            catch {
                print("Could not insert into tables.")
                print(error.localizedDescription)
            }
            
            question = "INSERT INTO Questions(title) values('What are the colors in the Indian national flag? Select all:')"
            do {
                try database.executeUpdate(question, values: nil)
                let qid = database.lastInsertRowId
                let options = ["White", "Yellow", "Orange", "Green"]
                for option in options{
                    let optQuery = "INSERT INTO Options (qId, title) VALUES (\(qid),'\(option)')";
                    do {
                        try database.executeUpdate(optQuery, values: nil)
                    }
                }
            }
            catch {
                print("Could not insert into tables.")
                print(error.localizedDescription)
            }
        }
        database.close();
    }
    
    func getQuestion(id:Int) -> QuestionModel {
        if openDatabase() {
            let query = "SELECT Q.id QID, Q.title QTITLE, O.id OID, O.title OTITLE FROM Questions Q  left join Options O on Q.id = O.qID where Q.id=\(id)"
            do {
                let result = try database.executeQuery(query, values: nil)
                var model:QuestionModel!;
                while result.next(){
                    model = QuestionModel(result: result);
                    model.options.append(OptionModel(result: result));
                    while result.next(){
                        model.options.append(OptionModel(result: result));
                    }
                }
                return model;
            }
            catch {
                print("Could not insert into tables.")
                print(error.localizedDescription)
            }
        }
        return QuestionModel()
    }
    
    func savePlayer(player:PlayerModel) -> Int32 {
        if openDatabase() {
            let query = "INSERT INTO Players(name) VALUES ('\(player.name!)')"
            do {
                try database.executeUpdate(query, values: nil)
                return Int32(database!.lastInsertRowId);
            }
            catch {
                print("Could not insert into tables.")
                print(error.localizedDescription)
            }
        }
        return 0;
    }
    
    func saveResult(option:OptionModel, player:Int32){
        if openDatabase() {
            let query = "INSERT INTO Answers(qId, oId, pId) VALUES \(option.qId!, option.id!, player)"
            do {
                try database.executeUpdate(query, values: nil)
            }
            catch {
                print("Could not insert into tables.")
                print(error.localizedDescription)
            }
        }
    }
    
    
    func getHistory() {
        var players:[PlayerModel] = [PlayerModel]();
        if openDatabase() {
            let query = "SELECT P.id PID, P.name PNAME, Q.id QID, Q.title QTITLE, O.id OID, O.title OTITLE from Players P left join Answers A on P.id = A.pId left join Options O on A.oId = O.id left join Questions Q on Q.id = O.qID"
            do {
                let result = try database.executeQuery(query, values: nil)
                print(result)
                let masterDict = NSMutableDictionary();
                var dict:NSMutableDictionary?;
                while result.next(){
//                    for dict in dicts{
                    dict = masterDict[result.int(forColumn: "PID")] as? NSMutableDictionary;
                    if dict == nil{
                        dict = NSMutableDictionary();
                            dict!["PID"] = result.int(forColumn: "PID")
                            dict!["PNAME"] = result.string(forColumn: "PNAME")!
                            var questionsDict = dict!["QUESTIONS"] as? [NSMutableDictionary];
                            if questionsDict == nil{
                                questionsDict = [NSMutableDictionary]();
                                let qdict = dict![result.int(forColumn: "QID")]
                                if qdict == nil{
                                    dict![result.int(forColumn: "QID")] = NSMutableDictionary();
                                    let question = NSMutableDictionary();
                                    question["QID"] = result.int(forColumn: "QID")
                                    question["QTITLE"] = result.string(forColumn: "QTITLE")!
                                    var optionsDict = question["OPTIONS"] as? [NSMutableDictionary];
                                    if optionsDict == nil{
                                        optionsDict = [NSMutableDictionary]();
                                        let option = NSMutableDictionary();
                                        option["OID"] = result.int(forColumn: "OID")
                                        option["OTITLE"] = result.string(forColumn: "OTITLE")!
                                        optionsDict!.append(option)
                                        question["OPTIONS"] = optionsDict;
                                    }
                                    else{
                                        //                                    dict!["OPTIONS"] = [NSMutableDictionary]();
                                        optionsDict = question["OPTIONS"] as? [NSMutableDictionary];
                                        let option = NSMutableDictionary();
                                        option["OID"] = result.int(forColumn: "OID")
                                        option["OTITLE"] = result.string(forColumn: "OTITLE")!
                                        optionsDict!.append(option)
                                        question["OPTIONS"] = optionsDict;
                                    }
                                    questionsDict!.append(question)
                                }
                                else{
                                    let question = NSMutableDictionary();
                                    question["QID"] = result.int(forColumn: "QID")
                                    question["QTITLE"] = result.string(forColumn: "QTITLE")!
                                    var optionsDict = question["OPTIONS"] as? [NSMutableDictionary];
                                    if optionsDict == nil{
                                        optionsDict = [NSMutableDictionary]();
                                        let option = NSMutableDictionary();
                                        option["OID"] = result.int(forColumn: "OID")
                                        option["OTITLE"] = result.string(forColumn: "OTITLE")!
                                        optionsDict!.append(option)
                                        question["OPTIONS"] = optionsDict;
                                    }
                                    else{
                                        //                                    dict!["OPTIONS"] = [NSMutableDictionary]();
                                        optionsDict = question["OPTIONS"] as? [NSMutableDictionary];
                                        let option = NSMutableDictionary();
                                        option["OID"] = result.int(forColumn: "OID")
                                        option["OTITLE"] = result.string(forColumn: "OTITLE")!
                                        optionsDict!.append(option)
                                        question["OPTIONS"] = optionsDict;
                                    }
                                    questionsDict!.append(question)
                                }
                                (dict![result.int(forColumn: "QID")] as! NSMutableDictionary)["QUESTIONS"] = questionsDict;
                            }
                            else{
                                let qdict = dict![result.int(forColumn: "QID")]
                                if qdict == nil{
                                    dict![result.int(forColumn: "QID")] = NSMutableDictionary();
                                    let question = NSMutableDictionary();
                                    question["QID"] = result.int(forColumn: "QID")
                                    question["QTITLE"] = result.string(forColumn: "QTITLE")!
                                    var optionsDict = question["OPTIONS"] as? [NSMutableDictionary];
                                    if optionsDict == nil{
                                        optionsDict = [NSMutableDictionary]();
                                        let option = NSMutableDictionary();
                                        option["OID"] = result.int(forColumn: "OID")
                                        option["OTITLE"] = result.string(forColumn: "OTITLE")!
                                        optionsDict!.append(option)
                                        question["OPTIONS"] = optionsDict;
                                    }
                                    else{
                                        //                                    dict!["OPTIONS"] = [NSMutableDictionary]();
                                        optionsDict = question["OPTIONS"] as? [NSMutableDictionary];
                                        let option = NSMutableDictionary();
                                        option["OID"] = result.int(forColumn: "OID")
                                        option["OTITLE"] = result.string(forColumn: "OTITLE")!
                                        optionsDict!.append(option)
                                        question["OPTIONS"] = optionsDict;
                                    }
                                    questionsDict!.append(question)
                                }
                                else{
                                    let question = dict![result.int(forColumn: "QID")] as! NSMutableDictionary;
                                    var optionsDict = question["OPTIONS"] as? [NSMutableDictionary];
                                    if optionsDict == nil{
                                        optionsDict = [NSMutableDictionary]();
                                        let option = NSMutableDictionary();
                                        option["OID"] = result.int(forColumn: "OID")
                                        option["OTITLE"] = result.string(forColumn: "OTITLE")!
                                        optionsDict!.append(option)
                                        question["OPTIONS"] = optionsDict;
                                    }
                                    else{
                                        //                                    dict!["OPTIONS"] = [NSMutableDictionary]();
                                        optionsDict = question["OPTIONS"] as? [NSMutableDictionary];
                                        let option = NSMutableDictionary();
                                        option["OID"] = result.int(forColumn: "OID")
                                        option["OTITLE"] = result.string(forColumn: "OTITLE")!
                                        optionsDict!.append(option)
                                        question["OPTIONS"] = optionsDict;
                                    }
                                    questionsDict!.append(question)
                                }
                                (dict![result.int(forColumn: "QID")] as! NSMutableDictionary)["QUESTIONS"] = questionsDict;
                            }
                        masterDict[result.int(forColumn: "PID")] = dict;
                    }
                    else{
                        dict  = masterDict[result.int(forColumn: "PID")] as? NSMutableDictionary
                        //                        if dict!["PID"] == nil{
                        dict!["PID"] = result.int(forColumn: "PID")
                        dict!["PNAME"] = result.string(forColumn: "PNAME")!
                        var questionsDict = dict!["QUESTIONS"] as? [NSMutableDictionary];
                        if questionsDict == nil{
                            questionsDict = [NSMutableDictionary]();
                            let qdict = dict![result.int(forColumn: "QID")]
                            if qdict == nil{
                                dict![result.int(forColumn: "QID")] = NSMutableDictionary();
                                let question = NSMutableDictionary();
                                question["QID"] = result.int(forColumn: "QID")
                                question["QTITLE"] = result.string(forColumn: "QTITLE")!
                                var optionsDict = question["OPTIONS"] as? [NSMutableDictionary];
                                if optionsDict == nil{
                                    optionsDict = [NSMutableDictionary]();
                                    let option = NSMutableDictionary();
                                    option["OID"] = result.int(forColumn: "OID")
                                    option["OTITLE"] = result.string(forColumn: "OTITLE")!
                                    optionsDict!.append(option)
                                    question["OPTIONS"] = optionsDict;
                                }
                                else{
                                    //                                    dict!["OPTIONS"] = [NSMutableDictionary]();
                                    optionsDict = question["OPTIONS"] as? [NSMutableDictionary];
                                    let option = NSMutableDictionary();
                                    option["OID"] = result.int(forColumn: "OID")
                                    option["OTITLE"] = result.string(forColumn: "OTITLE")!
                                    optionsDict!.append(option)
                                    question["OPTIONS"] = optionsDict;
                                }
                                questionsDict!.append(question)
                            }
                            else{
                                let question = dict![result.int(forColumn: "QID")] as! NSMutableDictionary;
                                var optionsDict = question["OPTIONS"] as? [NSMutableDictionary];
                                if optionsDict == nil{
                                    optionsDict = [NSMutableDictionary]();
                                    let option = NSMutableDictionary();
                                    option["OID"] = result.int(forColumn: "OID")
                                    option["OTITLE"] = result.string(forColumn: "OTITLE")!
                                    optionsDict!.append(option)
                                    question["OPTIONS"] = optionsDict;
                                }
                                else{
                                    //                                    dict!["OPTIONS"] = [NSMutableDictionary]();
                                    optionsDict = question["OPTIONS"] as? [NSMutableDictionary];
                                    let option = NSMutableDictionary();
                                    option["OID"] = result.int(forColumn: "OID")
                                    option["OTITLE"] = result.string(forColumn: "OTITLE")!
                                    optionsDict!.append(option)
                                    question["OPTIONS"] = optionsDict;
                                }
                                questionsDict!.append(question)
                            }
                            (dict![result.int(forColumn: "QID")] as! NSMutableDictionary)["QUESTIONS"] = questionsDict;
                        }
                        else{
                            let qdict = dict![result.int(forColumn: "QID")]
                            if qdict == nil{
                                dict![result.int(forColumn: "QID")] = NSMutableDictionary();
                                let question = NSMutableDictionary();
                                question["QID"] = result.int(forColumn: "QID")
                                question["QTITLE"] = result.string(forColumn: "QTITLE")!
                                var optionsDict = question["OPTIONS"] as? [NSMutableDictionary];
                                if optionsDict == nil{
                                    optionsDict = [NSMutableDictionary]();
                                    let option = NSMutableDictionary();
                                    option["OID"] = result.int(forColumn: "OID")
                                    option["OTITLE"] = result.string(forColumn: "OTITLE")!
                                    optionsDict!.append(option)
                                    question["OPTIONS"] = optionsDict;
                                }
                                else{
                                    //                                    dict!["OPTIONS"] = [NSMutableDictionary]();
                                    optionsDict = question["OPTIONS"] as? [NSMutableDictionary];
                                    let option = NSMutableDictionary();
                                    option["OID"] = result.int(forColumn: "OID")
                                    option["OTITLE"] = result.string(forColumn: "OTITLE")!
                                    optionsDict!.append(option)
                                    question["OPTIONS"] = optionsDict;
                                }
                                questionsDict!.append(question)
                            }
                            else{
                                let question = dict![result.int(forColumn: "QID")] as! NSMutableDictionary;
                                var optionsDict = question["OPTIONS"] as? [NSMutableDictionary];
                                if optionsDict == nil{
                                    optionsDict = [NSMutableDictionary]();
                                    let option = NSMutableDictionary();
                                    option["OID"] = result.int(forColumn: "OID")
                                    option["OTITLE"] = result.string(forColumn: "OTITLE")!
                                    optionsDict!.append(option)
                                    question["OPTIONS"] = optionsDict;
                                }
                                else{
                                    //                                    dict!["OPTIONS"] = [NSMutableDictionary]();
                                    optionsDict = question["OPTIONS"] as? [NSMutableDictionary];
                                    let option = NSMutableDictionary();
                                    option["OID"] = result.int(forColumn: "OID")
                                    option["OTITLE"] = result.string(forColumn: "OTITLE")!
                                    optionsDict!.append(option)
                                    question["OPTIONS"] = optionsDict;
                                }
                                questionsDict!.append(question)
                            }
                            (dict![result.int(forColumn: "QID")] as! NSMutableDictionary)["QUESTIONS"] = questionsDict;
                        }
                        masterDict[result.int(forColumn: "PID")] = dict;
                    }
                    
                }
                    
                var arr = [NSMutableDictionary]()
                for key in masterDict.keyEnumerator(){
                    arr.append(masterDict[key] as! NSMutableDictionary)
                }
               
                    
                    
//                    let player = PlayerModel(result: result)
//                    player.selectedOptions.append(OptionModel(result: result))
//                    while result.next(){
//                        player.selectedOptions.append(OptionModel(result: result))
//                    }
//                    while result.next(){
//                        player.questions.append(QuestionModel(result: result))
//                    }
//                    players.append(player);
//                }
                
//                return QuestionModel(result: result);
            }
            catch {
                print("Could not insert into tables.")
                print(error.localizedDescription)
            }
        }
        
        
//        print(query)
    }
    
    public func ParameterToString(JSON:[String:Any]) -> String{
        do {
            let data = try JSONSerialization.data(withJSONObject: JSON, options: .prettyPrinted)
            return String(data: data, encoding: String.Encoding.utf8)!
        } catch {
            print("Unable to convert json to string")
            return ""
        }
    }
    
    public func MutableDictionaryArrayToString(dictArray:[NSMutableDictionary]) -> String{
        do {
            let data = try JSONSerialization.data(withJSONObject: dictArray, options: .prettyPrinted)
            return String(data: data, encoding: String.Encoding.utf8)!
        } catch {
            print("Unable to convert json to string")
            return ""
        }
    }
}

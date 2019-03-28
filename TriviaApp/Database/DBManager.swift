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
                return QuestionModel(result: result);
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
        if openDatabase() {
            let query = "SELECT P.id PID, P.name PNAME, Q.id QID, Q.title QNAME, O.id OID, O.title ONAME from Players P left join Answers A on P.id = A.pId left join Options O on A.oId = O.id left join Questions Q on Q.id = O.qID"
            do {
                let result = try database.executeQuery(query, values: nil)
                print(result)
                
                
//                return QuestionModel(result: result);
            }
            catch {
                print("Could not insert into tables.")
                print(error.localizedDescription)
            }
        }
        
        
//        print(query)
    }
}

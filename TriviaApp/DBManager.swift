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
                    let createAnswersTableQuery = "CREATE TABLE Answers( id integer primary key autoincrement not null, qId integer not null, aId integer not null, pId integer not null)"
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
    
    func getPlayer(id:Int) -> PlayerModel {
        if openDatabase() {
            let query = ""
            do {
                let result = try database.executeQuery(query, values: nil)
                return PlayerModel(result: result);
            }
            catch {
                print("Could not insert into tables.")
                print(error.localizedDescription)
            }
        }
        return PlayerModel()
    }
}

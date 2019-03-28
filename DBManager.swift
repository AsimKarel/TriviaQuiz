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
                    let createQuestionsTableQuery = "CREATE TABLE QUESTIONS( id integer primary key autoincrement not null, title text not null)"
                    let createOptionsTableQuery = "CREATE TABLE OPTIONS( id integer primary key autoincrement not null, qId integer not null, title text not null)"
                    let createAnswersTableQuery = "CREATE TABLE ANSWERS( id integer primary key autoincrement not null, qId integer not null, aId integer not null, pId integer not null)"
                    let createPlayersTableQuery = "CREATE TABLE PLAYERS( id integer primary key autoincrement not null, name text not null)"
                    
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
}

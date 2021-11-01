//
//  DBProcessing.swift
//  SQLite3
//
//  Created by Davin Henrik on 10/31/21.
//

import UIKit


class DBProcessing {
    
    init(){
        db = openDatabase()
        createTable()
    }
    
    let dbPath : String = "client.sqlite"
    var db:OpaquePointer? //Opaque pointer are used to represent C pointers
    
    func openDatabase() -> OpaquePointer? {
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent(dbPath)
        print("\(fileURL)")
        
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("Error opening DB")
            return nil
        }
        else{
            print("Successfully Opened connection at \(dbPath)")
            return db
        }
    }
    
    //creating a table
    func createTable(){
        let createTableQuery = "CREATE TABLE IF NOT EXISTS userProfile (Id INTEGER PRIMARY KEY, username TEXT, age INTEGER);"
        
        var createTableStatement : OpaquePointer? = nil
        if sqlite3_prepare_v2(db, createTableQuery, -1, &createTableStatement, nil) == SQLITE_OK {
            if sqlite3_step(createTableStatement) == SQLITE_DONE {
                print("User table created!!")
            }
            else{
                print("Not able to create a user table")
            }
        }
        else{
            print("Create table failed could not be prepared")
        }
        sqlite3_finalize(createTableStatement)
    }
    
//Inserting a data to the table
    func insert(id: Int, username: String, age: Int){
        let insertQuery = "INSERT INTO userProfile (Id, username, age) VALUES (?, ?, ?);"
        var insertStatement : OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, insertQuery, -1, &insertStatement, nil) == SQLITE_OK {
            sqlite3_bind_int(insertStatement, 1, Int32(id))
            sqlite3_bind_text(insertStatement, 2, (username as NSString).utf8String, -1, nil)
            sqlite3_bind_int(insertStatement, 3, Int32(age))
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("Successfully inserted row")
            }else{
                print("User has been previously inserted")
            }
        }
        else {
            print("Insert statement failed......")
        }
        sqlite3_finalize(insertStatement)
    }
    
    //Read table function
    
    func read() -> [ClientData]{
        let queryStatementString = "SELECT * FROM userProfile"
        var queryStatement : OpaquePointer? = nil
        var userInfo : [ClientData] = []
        
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let id = sqlite3_column_int(queryStatement, 0)
                let username = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
                
                let age = sqlite3_column_int(queryStatement, 2)
                userInfo.append(ClientData(id: Int(id), username: username, age: Int(age)))
                print("Query results : ----")
                print("\(id) | \(username) | \(age)")
            }
        }
        else {
            print("Operation Failed")
        }
        sqlite3_finalize(queryStatement)
        return userInfo
    }
    
}





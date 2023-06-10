//
//  dbswift.swift
//  SQLiteLMPM
//
//  Created by Наталья on 21.03.2023.
//

import Foundation
import SQLite
class Database {
static let shared = Database()
public let connection: Connection?
private init(){
do {
let dbPath = Bundle.main.path(forResource: "tableVukalovich", ofType: "db")!
connection = try Connection(dbPath)
} catch {
connection = nil
let nserror = error as NSError
print ("Cannot connect to Database. Error is: (nserror), (nserror.userInfo)")
}
}
}


//
//  structures.swift
//  SQLiteLMPM
//
//  Created by Greenhaze on 30.04.2023.
//

import Foundation


struct Task: Hashable, Equatable,Identifiable {
    

    var caption: String
    var GUID: String
    var id = UUID()
    static func ==(lhs: Task, rhs: Task) -> Bool {
        return lhs.caption == rhs.caption && lhs.GUID == rhs.GUID
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(caption)
        hasher.combine(GUID)
    }
}



struct Sobstvennost: Hashable, Equatable {
    var caption: String
    var id = UUID()
    func hash(into hasher: inout Hasher) {
        hasher.combine(caption)
    }

    static func ==(lhs: Sobstvennost, rhs: Sobstvennost) -> Bool {
        return lhs.caption == rhs.caption
    }
}
struct Address1: Hashable, Equatable, Identifiable {
    var id = UUID()
    var caption: String
    var GUIDAddress: String
}


struct ObjectsByUser {
    
    
    //• Тип права
    //• Помещение (уже есть, вы добавили)
    //• Дата начала
    //• Дата окончания
    //• Тип объекта
    //• Адрес (уже есть, вы добавили)
    //• Кадастровый номер
    //• Этаж помещения
    //• Площадь (уже есть, вы добавили)
     
    
    var GUID: String //GUID
    var SPACENAME: String //имя помещения
    var SPACETYPE: String//тип помещения
    var SPACEFLOOR:String//Этаж
    var SQUARE: Double //Площадь
    var ADDRESS: String//Адрес
    var CADNUM :String//кадастровый номер
    var DATEACTBEG: String
    var DATEACTEND: String

   
}
struct ObjectsByAdress {
    var GUID: String
    var SPACENAME: String
    var SPACETYPE: String
    
    var SPACEFLOOR: String //row[6]
    
    var SQUARE:String //row[8]
    //var ADDRESS String
    var DATEACTBEG: String
    var DATEACTEND: String
    
    
   
    
}
enum WindowType {
    case Empty
    case ObjectsByUser
    case PersonByAddress
}

struct MeetingData {
    var guid: String
    var notes: String
    var meetingDate: String
    var regTimeBeg: String
    var meetingForm: String
}
struct CaseData {
    var title: String
}

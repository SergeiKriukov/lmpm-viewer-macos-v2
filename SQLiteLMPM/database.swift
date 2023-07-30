//
//  database.swift
//  SQLiteLMPM
//
//  Created by Greenhaze on 27.03.2023.
//

import Foundation
import SQLite
public class database {
    
    var db: Connection = try! Connection("") // provide default value
    var url: String
    var name: Task
    var address: Address1?
    var DateAct: String
    
    
    init(url: String, name: Task, DateAct:String, address: Address1) {
        self.url = url
        self.address = address
        self.name = name
        self.DateAct = DateAct
        do {
            self.db = try Connection(url)
        } catch {
            print("Error creating database connection: \(error)")
        }
    }
    
    let query = "SELECT FULLNAME, GUID FROM PERSON_DATA"
    let query2 = "SELECT objectname FROM OBJECT_DATA"
    let queryAddress = "SELECT address, guid FROM ADDRESS_DATA"
    
    
    
    func readTask() -> [Task] {
        do {
            var tempTasks = [Task]()
            for row in try self.db.prepare(query) {
                let taskCaption = row[0] as! String
                let GUID = row[1] as! String
                let task = Task(caption: taskCaption, GUID: GUID)
                tempTasks.append(task)
                
            }
            return tempTasks
        }
        catch {
            print("Error creating database connection: \(error)")
            return []
        }
    }
    
    func readAdress() -> [Sobstvennost]{
        do {
            var tempSobstvennosts = [Sobstvennost]()
            for row in try self.db.prepare(query2) {
                let SobstvennostCaption = row[0] as! String
                let sobstvennost = Sobstvennost(caption: SobstvennostCaption)
                tempSobstvennosts.append(sobstvennost)
            }
            return tempSobstvennosts
        } catch {
            print("Error creating database connection: \(error)")
            return []
        }
        
    }
    
    func readBuildings() -> [Address1]{
        do {
            var tempAddress2 = [Address1]()
            for row in try self.db.prepare(queryAddress) {
                let Address1Caption = row[0] as! String
                let GUIDddress1Caption = row[1] as! String
                let Address1 = Address1(caption: Address1Caption, GUIDAddress: GUIDddress1Caption)
                tempAddress2.append(Address1)
            }
            return tempAddress2
        } catch {
            print("Error creating database connection: \(error)")
            return []
            
        }
    }
    
    
    func readSelectedAdress(isOn: Bool, targetDate: Date) -> [ObjectsByUser] {
        var tempOBU = [ObjectsByUser]()
        do {
            for row in try self.db.prepare("select s.GUID, s.SpaceName, s.SpaceType, s.CadastreNum, s.InventNum, s.ObjectFloor, s.SpaceFloor, s.Square, a.Address, w.FracNumer || '/' || w.FracDenom as FracText, w.Square as OwnSquare, w.GUID as OwnerGUID, w.DateActBeg, w.DateActEnd, r.Value as RightType from OWNER_DATA w join SPACE_DATA s on (w.SpaceGUID = s.GUID) left join ADDRESS_DATA a on (s.GUID = a.GUID) left join REF_RIGHTS r on (w.Right_Type = r.Code) where w.PersonGUID = ?", name.GUID) {
                let GUID = row[0] as? String ?? ""
                let SPACENAME = row[1] as? String ?? ""
                let SPACETYPE = row[2] as? String ?? ""
                let SPACEFLOOR = row[6] as? String ?? ""
                let SQUARE = row[7] as? Double ?? 0.0
                let ADDRESS = row[8] as? String ?? ""
                let CADNUM = row[3] as? String ?? ""
                let DATEACTBEG = row[12] as? String ?? ""
                let DATEACTEND = row[13] as? String ?? "0.0.0.0"
                let Address1 = ObjectsByUser(GUID: GUID, SPACENAME: SPACENAME, SPACETYPE: SPACETYPE, SPACEFLOOR: SPACEFLOOR, SQUARE: SQUARE, ADDRESS: ADDRESS, CADNUM: CADNUM, DATEACTBEG: DATEACTBEG, DATEACTEND: DATEACTEND)
                tempOBU.append(Address1)
            }
        } catch {
            print("Error creating database connection: \(error)")
            return []
        }

        if isOn {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd" // Specify the format of the date string

            return tempOBU.filter { obj in
                guard let dateActBeg = dateFormatter.date(from: obj.DATEACTBEG) else {
                    return false
                }

                if obj.DATEACTEND != "0.0.0.0", let dateActEndValue = dateFormatter.date(from: obj.DATEACTEND) {
                    return dateActBeg < targetDate && dateActEndValue > targetDate
                } else {
                    return dateActBeg < targetDate
                }
            }
        } else {
            return tempOBU
        }
    }

    
    
    func readPersonByAddress(isOn: Bool, targetDate: Date) -> [ObjectsByAdress] {
        
        var tempOBU = [ObjectsByAdress]()
        do {
            
            for row in try self.db.prepare("select   w.PersonGUID, w.SpaceGUID,  w.GUID, p.FullName,   w.FracNumer || '/' || FracDenom FracText, w.DateActBeg,   w.DateActEnd, w.Square, s.SPACEFLOOR, r.Value RightType from  SPACE_DATA s join OWNER_DATA w on (s.GUID = w.SpaceGUID)     join PERSON_DATA p on (w.PersonGUID = p.GUID) left join REF_RIGHTS r on (w.Right_Type = r.Code) where w.SpaceGUID = '\(address!.GUIDAddress)'") { ///ОПАСНО. ТАК ПЕРЕДАВАТЬ ПАРАМЕТРЫ ЗАПРОСА КАТЕГОРИЧЕСКИ НЕЛЬЗЯ
                let GUID = row[0] as! String
                let SPACENAME = row[3] as! String
                let SPACETYPE = row[2] as! String
                let SPACEFLOOR = row[9] as! String
                let SQUARE = row[8] as! String
                let DATEACTBEG = row[5] as! String
                let DATEACTEND = row[6] as? String ?? "0.0.0.0"
                let Address1 = ObjectsByAdress(GUID: GUID, SPACENAME: SPACENAME, SPACETYPE: SPACETYPE, SPACEFLOOR: SPACEFLOOR, SQUARE: SQUARE, DATEACTBEG: DATEACTBEG, DATEACTEND: DATEACTEND)
                tempOBU.append(Address1)
            }
            return tempOBU
        } catch {
            print("Error creating database connection: \(error)")
            return []
            
        }
        if isOn{
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd" // Specify the format of the date string
            
            return tempOBU.filter {
                let dateActBeg = dateFormatter.date(from: $0.DATEACTBEG)!
                if $0.DATEACTEND != "0.0.0.0" {
                    let dateActEndValue = dateFormatter.date(from: $0.DATEACTEND)!
                    return dateActBeg < targetDate && dateActEndValue > targetDate
                } else {
                    return dateActBeg < targetDate
                }
            }
        }
        else{
            return tempOBU
        }
    }
    func saveDatabasePath(dbPath: String) {
        UserDefaults.standard.set(dbPath, forKey: "DbPath")
    }
    
    func readDatabasePath() -> String {
        if let savedDbPath = UserDefaults.standard.string(forKey: "DbPath") {
            return savedDbPath
            
        } else {
            return "empty"
        }
    }
    func readMeetingData() -> [MeetingData] {
        do {
            var tempMeetingData = [MeetingData]()
            for row in try self.db.prepare("SELECT guid,notes,meetingdate,regtimebeg, meetingform FROM MEETING_DATA ") {
                if let guid = row[0] as? String,
                   let notes = row[1] as? String,
                   let meetingDate = row[2] as? String,
                   let regTimeBeg = row[3] as? String,
                   let meetingForm = row[4] as? String {
                    let data = MeetingData(guid: guid, notes: notes, meetingDate: meetingDate, regTimeBeg: regTimeBeg, meetingForm: meetingForm)
                    tempMeetingData.append(data)
                } else {
                    // Если какое-то значение равно nil, вы можете обработать эту ситуацию здесь, например, пропустить эту запись или установить значения по умолчанию
                }
            }
            return tempMeetingData
        } catch {
            print("Error creating database connection: \(error)")
            return []
        }
    }

    
    
    
    func readCaseData() -> [CaseData] {
        do {
            var tempCaseData = [CaseData]()
            for row in try self.db.prepare("SELECT title FROM CASE_DATA ") {
                if let title = row[0] as? String {
                    let data = CaseData(title: title)
                    tempCaseData.append(data)
                } else {
                    // Если title равно nil, вы можете обработать эту ситуацию здесь, например, пропустить эту запись или установить значение по умолчанию
                }
            }
            return tempCaseData
        } catch {
            print("Error creating database connection: \(error)")
            return []
        }
    }

}

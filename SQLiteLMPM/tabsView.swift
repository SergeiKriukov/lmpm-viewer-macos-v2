//
//  tabsView.swift
//  SQLiteLMPM
//
//  Created by Greenhaze on 30.04.2023.
//

import SwiftUI

struct tabsView: View {
    var filteredTasks: [Task]
   var filteredSpaces: [Address1]
    @Binding var sobstvennosts:[Sobstvennost]
    @Binding var searchText: String
    @Binding var selectionTask: Task
    @Binding var selectionSobst:Address1
    @Binding var windowType: WindowType
    @Binding var databasePath: String!
    let adr3: Address1 = Address1(caption: "123", GUIDAddress: "empty")
    @Binding var isOn: Bool
    @Binding var selectedDate: Date
    @Binding var selectedTask: Task
    @State var SM: [ObjectsByUser] = []
    @State  var selectedTaskobj: Address1 = Address1(caption: "13wdscxzxvfa", GUIDAddress: "qefdxcszczxc")
    var body: some View {
        TabView {// main window
            HStack{
                TaskView(selectedTask: $selectionTask, Tasks: filteredTasks,WinType: $windowType)
                if databasePath != nil {
                    var SecondWindowSpacesContent:[ObjectsByUser] = database(url: databasePath!, name: selectedTask, DateAct: "\(selectedDate.date)", address: adr3).readSelectedAdress(isOn: isOn, targetDate: selectedDate)
                    HStack {
                        SwiftUI.List {
                            ForEach(SecondWindowSpacesContent, id: \.GUID) { selTask in
                                HStack{
                                    Text(selTask.ADDRESS)
                                        .frame(width: 320,height:10, alignment: .leading)
                                    Text(selTask.CADNUM)
                                        .frame(maxWidth: 90, maxHeight: 20, alignment: .leading)
                                    Text(selTask.SPACEFLOOR)
                                        .frame(maxWidth: 90, maxHeight: 20,  alignment: .leading)
                                    Text(selTask.SPACETYPE)
                                        .frame(maxWidth: 40, maxHeight: 20, alignment: .leading)
                                    Text("\(selTask.DATEACTBEG)")
                                    Text(selTask.DATEACTEND).frame(width: 100, alignment: .leading)
                                        .frame(maxWidth: 40, maxHeight: 20, alignment: .leading)
                                }.frame(maxHeight:20).padding(1)
                            }
                        }
                    }
                }
            }.tabItem {Text("Собственники (" + String(filteredTasks.count) + ")")}
            // Объекты (здания)
            SwiftUI.List {
                ForEach(sobstvennosts, id: \.caption) { sobstvennost in
                    Text(sobstvennost.caption)
                }
            }.tabItem {Text("Объекты (здания)")}
            
            HStack{
                SobstView(selection: $selectionSobst,items: filteredSpaces, WinType: $windowType)
                // Помещения
                if databasePath != nil {
                    let dbx:database = database(url: databasePath!, name: Task(caption: "12", GUID: "123"), DateAct: "\(selectedDate.date)", address: selectionSobst)
                    
                    HStack {
                        SwiftUI.List {
                            ForEach(dbx.readPersonByAddress(isOn: isOn, targetDate: selectedDate), id: \.GUID) { selTask in
                                HStack{
                                    //    Text("testesttest")
                                    Text(selTask.SPACENAME).frame(width: 110,height:20, alignment: .leading)
                                    
                                    
                                    Text(selTask.SPACEFLOOR).frame(width: 110,height:20, alignment: .leading)
                                    Text(selTask.DATEACTEND).frame(width: 110,height:20, alignment: .leading)
                                    Text(selTask.DATEACTEND).frame(width: 110,height:20, alignment: .leading)
                                }.padding(1)
                            }
                        }
                    }
                }
            }.tabItem {
                
                Image(systemName: "2.circle")
                Text("Помещения (\(filteredSpaces.count))")
            }
            HStack{
            if databasePath != nil {
                // selectedTask = nil
                let dbx:database = database(url: databasePath!, name: Task(caption: "12", GUID: "123"), DateAct: "\(selectedDate.date)", address: selectionSobst)
               
                    List(dbx.readMeetingData(), id: \.guid) { data in
                        HStack() {
                            Text("\(data.guid)")
                            Text("\(data.notes)")
                            Text("\(data.meetingDate)")
                            Text("\(data.regTimeBeg)")
                            Text("\(data.meetingForm)")
                        }
                    }
                }
            }.tabItem {
                Image(systemName: "2.circle")
                Text("Собрания")
            }
            
            HStack{
            // Конец раздела Собрания
            if databasePath != nil {
                let dbx:database = database(url: databasePath!, name: Task(caption: "12", GUID: "123"), DateAct: "\(selectedDate.date)", address: selectionSobst)
                List(dbx.readCaseData(), id: \.title) { data in
                    Text("\(data.title)")
                }
                
            }}
            
            .tabItem {
                Image(systemName: "2.circle")
                Text("Дела по ЖКУ")
            }
        }
        .navigationTitle("Просмотр LMPM")
        .navigationSubtitle("Просмотр баз данных *.lmpm из LawMatic Управление недвижимостью").searchable(text: $searchText)
      
        
    }
    }


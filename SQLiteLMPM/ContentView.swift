// ContentView.swift
import SwiftUI
import SQLite
struct ContentView: SwiftUI.View {
    @State private var isOn = false
    @State private var selectedDate = Date()
    @State private var caption: String = ""
    @State private var caption2: String = ""
    @State private var databasePath: String?
    @State var DownWindowType: WindowType = .Empty
    @State private var shouldShowData: Bool = false
    let adr3: Address1 = Address1(caption: "123", GUIDAddress: "empty")
    @State var tasks = [Task]()
    @State var sobstvennosts = [Sobstvennost]()
    @State var Address2 = [Address1]()
    @State  var isPresented:Bool = false //is shown info
    @State var selectedTask: Task = Task(caption: "dadsidoiosdfnisjif", GUID: "adfasdjasidoapsdosa")
    @State  var selectedTaskobj: Address1 = Address1(caption: "13wdscxzxvfa", GUIDAddress: "qefdxcszczxc")
    @State private var searchText = ""
     var filteredTasks: [Task] {
        if searchText.isEmpty {
            return tasks
        } else {
            return tasks.filter { $0.caption.localizedCaseInsensitiveContains(searchText) }
        }
    }
    var filteredSpaces: [Address1] {
        if searchText.isEmpty {
            return Address2
        } else {
            return Address2.filter { $0.caption.localizedCaseInsensitiveContains(searchText) }
        }
    }
    var body: some SwiftUI.View {
        HStack{ //header
            Image("iconapps")
                .resizable()
                .frame(width: 32, height: 32)
            Button("Выберите базу данных *.lmpm") {
                let openPanel = NSOpenPanel()
                openPanel.allowedFileTypes = ["sqlite", "lmpm"]
                openPanel.canChooseFiles = true
                openPanel.canChooseDirectories = false
                if openPanel.runModal() == .OK { //reading database
                    if let url = openPanel.urls.first {
                        databasePath = url.path
                        shouldShowData = true
                        do { //getting data
                            let dbm:database = try  database(url: databasePath!,name:Task(caption: " ", GUID: " "), DateAct: "\(selectedDate.date)", address: adr3) // name тут не нужен
                            tasks = dbm.readTask()
                            sobstvennosts = dbm.readAdress()
                            Address2 = dbm.readBuildings()
                        } catch {
                            print("Failed to establish connection to database: \(error)")
                        }
                    }
                }
            }
            Toggle("Данные на дату:", isOn: $isOn)
            DatePicker("", selection: $selectedDate, displayedComponents: [.date])
                .datePickerStyle(.automatic)
                .frame(width: 120)
            Text("Без выбора даты данные полные, но не все актуальные")
            Spacer()
        }.padding()
        //content 
        HStack {
            tabsView(filteredTasks: filteredTasks, filteredSpaces: filteredSpaces, sobstvennosts: $sobstvennosts, searchText: $searchText, selectionTask: $selectedTask, selectionSobst: $selectedTaskobj, windowType: $DownWindowType, databasePath: $databasePath, isOn: $isOn, selectedDate: $selectedDate, selectedTask: $selectedTask)
        }
    }
}

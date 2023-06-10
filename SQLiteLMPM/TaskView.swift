//
//  TaskView.swift
//  SQLiteLMPM
//
//  Created by Greenhaze on 29.04.2023.
//

import SwiftUI

struct TaskView: View {
    @Binding var selectedTask: Task
    var Tasks:[Task]
    @Binding var WinType: WindowType
    var body: some View {
            List(selection: $selectedTask) {
                ForEach(Tasks) { task in
                    HStack {
                        Text(task.caption)
                        Spacer()
                       
                    }.onAppear{
                        
                        if Tasks.count > 0 {
                            selectedTask = Tasks[0]
                        }
                    }
                    .tag(task)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
        }
    }

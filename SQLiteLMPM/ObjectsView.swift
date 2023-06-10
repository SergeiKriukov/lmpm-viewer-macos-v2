//
//  ObjectsView.swift
//  SQLiteLMPM
//
//  Created by Greenhaze on 26.03.2023.
//

import SwiftUI

struct PeopleTable: View {
    var data: [ObjectsByAdress]
    var body: some View {
        Table(data) {
            TableColumn("Given Name", value: \.GUID)
            TableColumn("Family Name", value: \.SPACETYPE)
            TableColumn("E-Mail Address", value: \.SPACENAME)
        }
    }
}


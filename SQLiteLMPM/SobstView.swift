//
//  SobstView.swift
//  SQLiteLMPM
//
//  Created by Greenhaze on 29.04.2023.
//

import SwiftUI

struct SobstView: View {
    @Binding var selection: Address1
     var items: [Address1]
    @Binding var WinType: WindowType
    var body: some View {
            List(selection: $selection) {
                ForEach(items) { address in
                    HStack {
                        Text(address.caption)
                        Spacer()
                        
                    }
                    .tag(address).onAppear{
                        
                        if items.count > 0 {
                            selection = items[0]
                        }
                    }
                    
                }
            }
        }
}


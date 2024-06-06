//
//  viewCourses.swift
//  cep
//
//  Created by Maria Novikova on 02.07.2023.
//

import SwiftUI

struct viewMyCourses: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                viewTopPanel()
                //viewCourses()
                //viewBottomPanel()
                
                Spacer()
                
                HStack {
                    NavigationLink(destination: viewSearchCourses()) {
                        baseButtonLabel("Добавить курс", colorName: "BaseOrange", systemImageName: "plus")
                    }
                    .padding(.vertical, 15)
                    .padding(.horizontal, 3)
                    
                    
                }
                .padding(globalBasePadding)
            }
            
        }
    }
}

struct viewMyCourses_Previews: PreviewProvider {
    static var previews: some View {
        viewMyCourses()
    }
}

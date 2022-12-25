//
//  ViewStudy.swift
//  23234234
//
//  Created by Maria Novikova on 05.06.2022.
//

import SwiftUI

//@available(iOS 16.0, *)
struct viewCourses: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                viewTopPanel()
                viewCoursesList()
                //viewBottomPanel()
            }
        }
    }
    
}

//@available(iOS 16.0, *)
struct ViewStudy_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(["iPhone SE (3rd generation)", "iPhone 13 Pro Max"], id: \.self) { deviceName in
            viewCourses()
                .previewDevice(PreviewDevice(rawValue: deviceName))
                .previewDisplayName(deviceName)
        }
    }
}

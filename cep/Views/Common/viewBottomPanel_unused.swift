//  Created by Maria Novikova on 19.12.2022.

import SwiftUI

struct viewBottomPanel: View {
    var body: some View {
        HStack {
            //Spacer()
            VStack {
                Image("tab_learning").renderingMode(.template)
                Text("Обучение")
            }
            .foregroundColor(Color(uiColor: UIColor(named: "TabBlue")!))
            Spacer()
            //Spacer()
            VStack {
                Image("tab_church")
                Text("Церковь")
            }
            Spacer()
            //Spacer()
            VStack {
                Image("tab_target")
                Text("Цели")
            }
            Spacer()
            //Spacer()
            VStack {
                Image("tab_profile")
                Text("Профиль")
            }
            //Spacer()
        }
        .foregroundColor(.white)
        .font(.system(size: 12))
        .padding(.top, 8)
        .padding(.horizontal, 20)
        //.background(designColors.TabGray)
        .background(Color(uiColor: UIColor(named: "TabGray")!))
        //.padding(.bottom, -8)
    }
}

struct viewBottomPanel_Previews: PreviewProvider {
    static var previews: some View {
        viewBottomPanel()
    }
}

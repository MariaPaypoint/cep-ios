//  Created by Maria Novikova on 19.12.2022.

import SwiftUI

struct viewTopPanel: View {
    var body: some View {
        HStack {
            Image("top_icon_star")
            Text("315")
                .padding(.trailing)
            Image("top_icon_fire")
            Text("112")
            Spacer()
            Image("top_icon_mail")
            Text("+5 уведомлений")
        }
        .foregroundColor(.white)
        .font(.system(size: 12))
        .padding()
        .background(Color(uiColor: UIColor(named: "TabGray")!))
        //.padding(.bottom, -8)
    }
}

struct viewTopPanel_Previews: PreviewProvider {
    static var previews: some View {
        viewTopPanel()
    }
}

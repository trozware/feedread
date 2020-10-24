//  SettingsView.swift - FeedRead
//  Sarah Reichelt - 25/10/20.

import SwiftUI

struct SettingsView: View {
    @AppStorage("articleLimit") var articleLimit: Int = 0
    @AppStorage("appearance") var appearance = AppAppearance.system

    var body: some View {
        TabView {
            VStack {
                Stepper("Show newest \(articleLimit) articles",
                        value: $articleLimit,
                        in: 0 ... 300,
                        step: 5)
                Text("Set to 0 to show all available articles.")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            .tabItem {
                Image(systemName: "note.text")
                Text("Articles")
            }
            .navigationTitle("FeedRead Preferences")

            Picker(selection: $appearance, label: Text(""), content: {
                Text("Dark mode").tag(AppAppearance.dark)
                Text("Light mode").tag(AppAppearance.light)
                Text("System mode").tag(AppAppearance.system)
            })
            .pickerStyle(RadioGroupPickerStyle())
            .tabItem {
                Image(systemName: "moon.circle.fill")
                Text("Appearance")
            }
            .navigationTitle("FeedRead Preferences")
        }
        .frame(width: 320, height: 120, alignment: .center)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}

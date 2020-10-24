//  FeedReadApp.swift - FeedRead
//  Sarah Reichelt - 24/10/20.

import SwiftUI

@main
struct FeedReadApp: App {
    @StateObject var feedList = FeedList()
    @AppStorage("appearance") var appearance = AppAppearance.system

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(feedList)
                .onAppear { updateMode() }
        }
        .commands {
            CommandGroup(after: CommandGroupPlacement.printItem) {
                Button(action: { feedList.refreshAllFeeds() }, label: {
                    Text("Refresh All")
                })
                .keyboardShortcut("r", modifiers: .command)
            }

            CommandMenu("Useful Links") {
                ForEach(Link.sampleLinks) { link in
                    Button(action: { link.openLink() }, label: {
                        Text(link.title)
                    })
                }
            }
        }
        .onChange(of: appearance) { _ in
            updateMode()
        }

        Settings {
            SettingsView()
                .environmentObject(feedList)
        }
    }

    func updateMode() {
        switch appearance {
        case .dark:
            NSApp.appearance = NSAppearance(named: .darkAqua)
        case .light:
            NSApp.appearance = NSAppearance(named: .aqua)
        case .system:
            NSApp.appearance = nil
        }
    }
}

enum AppAppearance: String {
    case dark
    case light
    case system
}

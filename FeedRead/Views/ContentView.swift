//  ContentView.swift - FeedRead
//  Sarah Reichelt - 24/10/20.

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            FeedListView()
            ArticleListView(feed: Feed.blankFeed)
            ArticleView(article: FeedArticle.blankArticle)
        }
        .toolbar {
            ToolbarItem(placement: .navigation) {
                Button(action: toggleSidebar, label: {
                    Image(systemName: "sidebar.left")
                })
            }
        }
    }

    func toggleSidebar() {
        NSApp.keyWindow?.firstResponder?.tryToPerform(
            #selector(NSSplitViewController.toggleSidebar(_:)), with: nil)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

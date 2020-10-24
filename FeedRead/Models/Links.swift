//
//  Links.swift
//  FeedRead
//
//  Created by Sarah Reichelt on 14/10/20.
//

import AppKit

struct Link: Identifiable {
    let id = UUID()
    let title: String
    let address: String

    static var sampleLinks: [Link] {
        return [
            Link(title: "TrozWare", address: "https://troz.net"),
            Link(title: "Back to the Mac", address: "https://backtomac.org"),
            Link(title: "Apple - SwiftUI", address: "https://developer.apple.com/xcode/swiftui/"),
            Link(title: "Top 100 World News RSS Feeds", address: "https://blog.feedspot.com/world_news_rss_feeds/"),
            Link(title: "Popular RSS Feeds", address: "https://rss.com/blog/popular-rss-feeds/"),
        ]
    }

    func openLink() {
        guard let url = URL(string: address) else {
            return
        }
        NSWorkspace.shared.open(url)
    }
}

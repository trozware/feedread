//
//  Feed.swift
//  FeedRead
//
//  Created by Sarah Reichelt on 15/9/20.
//

import SwiftUI

struct Feed: Identifiable  {
    var id = UUID()
    var feedTitle: String
    var feedDescription: String
    var feedUrl: URL
    var feedDate: Date
    var feedArticles: [FeedArticle]

    static var blankFeed: Feed {
        let blankUrl = URL(string: "https://www.apple.com")!
        return Feed(feedTitle: "", feedDescription: "", feedUrl: blankUrl, feedDate: Date(), feedArticles: [])
    }
}

extension Feed: Codable {
    enum CodingKeys: String, CodingKey {
        case feedTitle
        case feedDescription
        case feedUrl
        case feedDate
        case feedArticles
    }
}

extension Feed: Equatable, Hashable {
    static func ==(lhs: Feed, rhs: Feed) -> Bool {
        return lhs.feedUrl == rhs.feedUrl
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(feedUrl)
    }
}

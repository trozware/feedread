//
//  FeedEntry.swift
//  FeedRead
//
//  Created by Sarah Reichelt on 15/9/20.
//

import Foundation
import FeedKit

struct FeedArticle: Identifiable {
    let id = UUID()
    let title: String
    var content: String
    let date: Date
    let url: URL

    static var blankArticle: FeedArticle {
        let blankUrl = URL(string: "https://www.apple.com")!
        return FeedArticle(title: "", content: "", date: Date(), url: blankUrl)
    }
}

extension FeedArticle: Codable {
    enum CodingKeys: String, CodingKey {
        case title
        case content
        case date
        case url
    }
}

extension FeedArticle {
    init?(fromAtom entry: AtomFeedEntry) {
        guard let title = entry.title,
              let content = entry.content?.value,
              let link = entry.links?.first?.attributes?.href,
              let url = URL(string: link) else {
            return nil
        }
        let date = entry.updated ?? Date()

        self.title = title
        self.content = content
        self.date = date
        self.url = url
    }

    init?(fromRss item: RSSFeedItem) {
        guard let title = item.title,
              let content = item.description,
              let link = item.link,
              let url = URL(string: link) else {
            return nil
        }
        let date = item.pubDate ?? Date()

        self.title = title
        self.content = content
        self.date = date
        self.url = url
    }

    init?(fromJson item: JSONFeedItem) {
        guard let title = item.title,
              let content = item.contentHtml,
              let link = item.url,
              let url = URL(string: link) else {
            return nil
        }
        let date = item.datePublished ?? Date()

        self.title = title
        self.content = content
        self.date = date
        self.url = url
    }
}

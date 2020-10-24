//
//  FeedReader.swift
//  FeedRead
//
//  Created by Sarah Reichelt on 15/9/20.
//

import SwiftUI
import FeedKit

struct FeedReader {
  let feedUrl: URL

  func readFeed(callback: @escaping (Feed?) -> ()) {
    let parser = FeedParser(URL: feedUrl)
    let queue = DispatchQueue.global()
    parser.parseAsync(queue: queue) { result in
      DispatchQueue.main.async {
        switch result {
        case .success(let feed):
          switch feed {
          case let .atom(feed):
            let feed = processAtomFeed(feed)
            callback(feed)
          case let .rss(feed):
            let feed = processRssFeed(feed)
            callback(feed)
          case let .json(feed):
            let feed = processJsonFeed(feed)
            callback(feed)
          }
        case .failure(let error):
          print(error.localizedDescription)
          callback(nil)
        }
      }
    }
  }

  func processAtomFeed(_ feed: AtomFeed) -> Feed {
    let title = feed.title ?? titleFrom(url: feedUrl)
    let description = feed.subtitle?.value ?? ""
    let date = feed.updated ?? Date()

    var feedItems: [FeedArticle] = []
    if let entries = feed.entries {
      feedItems = entries.compactMap { entry in
        if let feedEntry = FeedArticle(fromAtom: entry) {
          return feedEntry
        }
        return nil
      }
    }

    let newFeed = Feed(feedTitle: title,
                       feedDescription: description.withoutHtmlTags(),
                       feedUrl: feedUrl,
                       feedDate: date,
                       feedArticles: feedItems)
    return newFeed
  }

  func processRssFeed(_ feed: RSSFeed) -> Feed {
    let title = feed.title ?? titleFrom(url: feedUrl)
    let description = feed.description ?? ""
    let date = feed.pubDate ?? Date()

    var feedItems: [FeedArticle] = []
    if let items = feed.items {
      feedItems = items.compactMap { item in
        if let feedEntry = FeedArticle(fromRss: item) {
          return feedEntry
        }
        return nil
      }
    }

    let newFeed = Feed(feedTitle: title,
                       feedDescription: description.withoutHtmlTags(),
                       feedUrl: feedUrl,
                       feedDate: date,
                       feedArticles: feedItems)
    return newFeed
  }

  func processJsonFeed(_ feed: JSONFeed) -> Feed {
    let title = feed.title ?? titleFrom(url: feedUrl)
    let description = feed.description ?? ""
    let date = Date()

    var feedItems: [FeedArticle] = []
    if let items = feed.items {
      feedItems = items.compactMap { item in
        if let feedEntry = FeedArticle(fromJson: item) {
          return feedEntry
        }
        return nil
      }
    }

    let newFeed = Feed(feedTitle: title,
                       feedDescription: description.withoutHtmlTags(),
                       feedUrl: feedUrl,
                       feedDate: date,
                       feedArticles: feedItems)
    return newFeed
  }

  func titleFrom(url: URL) -> String {
    return url.deletingPathExtension().lastPathComponent
  }
}


extension String {
  func withoutHtmlTags() -> String {
    return self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
      .trimmingCharacters(in: .whitespacesAndNewlines)
  }
}

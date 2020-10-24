//
//  FeedList.swift
//  FeedRead
//
//  Created by Sarah Reichelt on 15/9/20.
//

import SwiftUI

class FeedList: ObservableObject {
    @Published var feedsUrls: [URL] = []
    @Published var feeds: [Feed] = []

    var updateIndex = 0

    init() {
        readUrls()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.getAllFeeds()
        }
    }

    func refreshAllFeeds() {
        updateIndex = 0
        refreshNextFeed()
    }

    // MARK: - Updates
    
    private func getAllFeeds() {
        feeds = []
        for url in feedsUrls {
            getFeed(for: url)
        }
    }

    private func refreshNextFeed() {
        if updateIndex >= feeds.count {
            return
        }
        getFeed(at: updateIndex)
        updateIndex += 1
    }

    private func getFeed(for feedUrl: URL) {
        let reader = FeedReader(feedUrl: feedUrl)
        reader.readFeed { feed in
            if let feed = feed {
                var feeds = self.feeds

                feeds.append(feed)
                feeds.sort { (a, b) -> Bool in
                    return a.feedTitle.lowercased() < b.feedTitle.lowercased()
                }

                self.feeds = feeds

                // un-comment this line to create the sample data for previews
                // self.saveTestData()
            }
        }
    }

    private func getFeed(at index: Int) {
        let feedToUpdate = feeds[index]
        let reader = FeedReader(feedUrl: feedToUpdate.feedUrl)
        reader.readFeed { feed in
            if let feed = feed {
                self.feeds[index] = feed
            }
            self.refreshNextFeed()
        }
    }
}

// MARK: - Data Storage

extension FeedList {

    func readUrls() {
        // un-comment this line to use test URLs only
        // useDefaultUrls()

        if let links = UserDefaults.standard.array(forKey: "feedUrls") as? [String],
           links.count > 0 {
            feedsUrls = links.compactMap { link in
                return URL(string: link)
            }
        } else {
            useDefaultUrls()
        }
    }

    func addToUrls(link: String) {
        if let url = URL(string: link), !feedsUrls.contains(url) {
            feedsUrls.append(url)
            saveUrls()
            getFeed(for: url)
        }
    }

    func remove(feedTitle: String) {
        guard let feedIndex = feeds.firstIndex(where: { feed in
            feed.feedTitle == feedTitle
        }) else {
            return
        }

        let feed = feeds[feedIndex]
        remove(url: feed.feedUrl)
        feeds.remove(at: feedIndex)
    }

    func remove(url: URL) {
        if let index = feedsUrls.firstIndex(of: url) {
            feedsUrls.remove(at: index)
            saveUrls()
        }
    }

    private func saveUrls() {
        let links = feedsUrls.map { $0.absoluteString }
        UserDefaults.standard.setValue(links, forKey: "feedUrls")
    }

}

// MARK: - Sample Data

extension FeedList {
    private func useDefaultUrls() {
        let links = [
            "https://www.apple.com/au/newsroom/rss-feed.rss",
            "https://theguardian.com/world/rss",
            "https://troz.net/index.xml"
        ]
        let urls = links.compactMap { link in
            return URL(string: link)
        }

        feedsUrls =  urls
        saveUrls()
    }

    private func saveTestData() {
        do {
            let feedJson = try JSONEncoder().encode(feeds)
            let fileManager = FileManager.default
            let downloadsFolder = try fileManager.url(for: .downloadsDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let dataFile = downloadsFolder.appendingPathComponent("sample_feed.json")
            try feedJson.write(to: dataFile)
        } catch {
            print(error)
        }
    }

    static func useTestData() -> [Feed] {
        do {
            guard let sampleDataUrl = Bundle.main.url(forResource: "sample_feed", withExtension: "json") else {
                return []
            }
            let sampleData = try Data(contentsOf: sampleDataUrl)
            let sampleFeeds = try JSONDecoder().decode([Feed].self, from: sampleData)
            return sampleFeeds
        } catch {
            print(error)
        }
        return []
    }


    static var sampleFeed: Feed {
        let sampleFeeds = FeedList.useTestData()
        return sampleFeeds[0]
    }

    static var sampleArticle: FeedArticle {
        let sampleFeeds = FeedList.useTestData()
        return sampleFeeds[2].feedArticles[0]
    }
}

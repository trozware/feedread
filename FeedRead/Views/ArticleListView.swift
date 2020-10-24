//  ArticleListView.swift - FeedRead
//  Sarah Reichelt - 24/10/20.

import SwiftUI

struct ArticleListView: View {
    var feed: Feed
    @AppStorage("articleLimit") var articleLimit: Int = 0

    var body: some View {
        List(trimArticles()) { article in
            NavigationLink(destination: ArticleView(article: article)) {
                ArticleListRow(article: article)
            }
        }
    }

    func trimArticles() -> [FeedArticle] {
        var validArticles = feed.feedArticles
        if articleLimit > 0 && validArticles.count > articleLimit {
            validArticles = Array(validArticles[0 ..< articleLimit])
        }
        return validArticles
    }
}

struct ArticleListView_Previews: PreviewProvider {
    static var previews: some View {
        ArticleListView(feed: FeedList.sampleFeed)
            .previewLayout(.fixed(width: 200, height: 500))
    }
}

struct ArticleListRow: View {
    var article: FeedArticle

    var body: some View {
        VStack(alignment: .leading) {
            Text(article.title)
                .font(.title3)
                .fixedSize(horizontal: false, vertical: true)
                .lineLimit(3)
                .padding(.vertical, 2)

            Text(dateFormatter.string(from: article.date))
                .font(.subheadline)
        }
        .padding(.bottom, 4)
        .padding(.vertical, 4)
    }
}

var dateFormatter: DateFormatter {
    let df = DateFormatter()
    df.dateStyle = .long
    df.timeStyle = .none
    return df
}

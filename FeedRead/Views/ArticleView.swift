//  ArticleView.swift - FeedRead
//  Sarah Reichelt - 24/10/20.

import SwiftUI

struct ArticleView: View {
    var article: FeedArticle

    var body: some View {
        if article.title.isEmpty {
            EmptyView()
        } else {
            VStack {
                Text(article.title)
                    .font(.title)
                    .multilineTextAlignment(.center)
                    .padding(.top)

                WebView(html: article.content)
                    .padding([.bottom, .horizontal])
            }
            .frame(minWidth: 300, idealWidth: 500, maxWidth: .infinity,
                   minHeight: 300, idealHeight: 400, maxHeight: .infinity,
                   alignment: .center)
        }
    }
}

struct ArticleView_Previews: PreviewProvider {
    static var previews: some View {
        ArticleView(article: FeedList.sampleArticle)
    }
}

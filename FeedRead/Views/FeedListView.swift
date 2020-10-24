//  FeedListView.swift - FeedRead
//  Sarah Reichelt - 24/10/20.

import SwiftUI

struct FeedListView: View {
    @EnvironmentObject var feedList: FeedList
    @State private var selectedFeed: Feed? = nil
    @State private var showAddSheet = false
    @State private var showDeleteAlert = false

    var body: some View {
        VStack {
            List(feedList.feeds) { feed in
                NavigationLink(destination: ArticleListView(feed: feed),
                               tag: feed,
                               selection: $selectedFeed) {
                    FeedListRow(feed: feed)
                }
            }
            .listStyle(SidebarListStyle())

            HStack {
                Button(action: { showAddSheet = true }, label: {
                    Label("Add", systemImage: "note.text.badge.plus")
                })

                Spacer()

                Button(action: { showDeleteAlert = true }, label: {
                    Label("Delete", systemImage: "trash")
                        .foregroundColor(.red)
                })
            }
            .padding(.horizontal, 6)
            .padding(6)
        }
        .alert(isPresented: $showDeleteAlert) {
            deleteAlert()
        }
        .sheet(isPresented: $showAddSheet) {
            AddFeedView()
        }
    }

    func deleteAlert() -> Alert {
        if let deleteTitle = selectedFeed?.feedTitle {
            return Alert(title: Text("Delete"),
                         message: Text("Really delete the \(deleteTitle) feed?"),
                         primaryButton: .default(Text("Delete"), action: {
                            feedList.remove(feedTitle: deleteTitle)
                         }),
                         secondaryButton: .cancel({}))
        } else {
            return Alert(title: Text("Delete Feed"),
                         message: Text("Select a feed before clicking Delete."),
                         dismissButton: .default(Text("OK")))
        }
    }
}

struct FeedListView_Previews: PreviewProvider {
    static var previews: some View {
        FeedListView()
            .environmentObject(FeedList())
            .previewLayout(.fixed(width: 200, height: 500))
    }
}

struct FeedListRow: View {
    var feed: Feed
    @AppStorage("articleLimit") var articleLimit: Int = 0

    var body: some View {
        VStack(alignment: .leading) {
            Text(feed.feedTitle)
                .font(.title2)
                .padding(.top, 4)
            if !feed.feedDescription.isEmpty {
                Text(feed.feedDescription)
                    .font(.body)
                    .fixedSize(horizontal: false, vertical: true)
                    .lineLimit(2)
            }
            Text("\(trimArticlesCount()) articles")
                .font(.subheadline)
                .bold()
        }
        .padding(.bottom, 4)
        .padding(.vertical, 4)
    }

    func trimArticlesCount() -> Int {
        var validArticles = feed.feedArticles
        if articleLimit > 0 && validArticles.count > articleLimit {
            validArticles = Array(validArticles[0 ..< articleLimit])
        }
        return validArticles.count
    }
}

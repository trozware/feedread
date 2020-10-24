//  AddFeedView.swift - FeedRead
//  Sarah Reichelt - 24/10/20.

import SwiftUI

struct AddFeedView: View {
    @EnvironmentObject var feedList: FeedList
    @Environment(\.presentationMode) var presentationMode
    @State private var newFeedAddress = ""

    var body: some View {
        VStack {
            Text("Adding a New Feed")
                .font(.title)

            Text("Enter the URL for the feed to add:")
            TextField("Feed URL", text: $newFeedAddress)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.vertical)

            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()

                }, label: {
                    Text("Cancel")
                })
                .keyboardShortcut(.cancelAction)


                Spacer()

                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                    feedList.addToUrls(link: newFeedAddress)

                }, label: {
                    Text("Add Feed")
                })
                .keyboardShortcut(.defaultAction)
                .disabled(newFeedAddress.isEmpty)
            }
        }
        .padding()
        .frame(width: 400)

    }
}

struct AddFeedView_Previews: PreviewProvider {
    static var previews: some View {
        AddFeedView()
    }
}

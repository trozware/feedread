//  WebView.swift - FeedRead
//  Sarah Reichelt - 24/10/20.

import SwiftUI
import WebKit

final class WebView: NSViewRepresentable {
    var html: String

    init(html: String) {
        self.html = html
    }

    func makeNSView(context: Context) -> WKWebView {
        let webView = WKWebView()
        return webView
    }

    func updateNSView(_ nsView: WKWebView, context: Context) {
        nsView.loadHTMLString(styledHtml, baseURL: nil)
    }

    var styledHtml: String {
        return """
        <html>
            <head>
                <style>
                body { width: 96%; font-family: sans-serif; font-size: 14px; }
                img { max-width: 100% }
                @media (prefers-color-scheme: dark) {
                  body { background-color: rgb(50, 50, 50); color: white; }
                  a { color: orange; }
                }
                @media (prefers-color-scheme: light) {
                  body  { background-color: rgb(236, 236, 236); color:  #555; }
                  a { color: blue; }
                }
                </style>
            </head>
            <body>
                \(html)
            </body>
        </html>
        """
    }
}

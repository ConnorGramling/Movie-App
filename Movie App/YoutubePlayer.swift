//
//  YoutubePlayer.swift
//  Movie App
//
//  Created by Connor on 11/4/26.
//

import SwiftUI
import WebKit

struct YoutubePlayer: UIViewRepresentable {
    let videoId: String
    let youtubeBaseURL = APIConfig.shared?.youtubeBaseURL
    
    func makeUIView(context: Context) -> WKWebView {
        let config = WKWebViewConfiguration()
        config.allowsInlineMediaPlayback = true
        return WKWebView(frame: .zero, configuration: config)
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        guard let baseURLString = youtubeBaseURL,
              let baseURL = URL(string: baseURLString),
              let bundleID = Bundle.main.bundleIdentifier else { return }
        
        let fullURL = baseURL.appending(path: videoId)
        var request = URLRequest(url: fullURL)
        request.setValue("https://" + bundleID.lowercased(), forHTTPHeaderField: "Referer")
        uiView.load(request)
    }
}

// HTML APPROACH

//struct YoutubePlayer: UIViewRepresentable {
//    let videoId: String
//    let youtubeBaseURL = APIConfig.shared?.youtubeBaseURL
//    
//    func makeUIView(context: Context) -> WKWebView {
//        let config = WKWebViewConfiguration()
//        config.allowsInlineMediaPlayback = true
//        return WKWebView(frame: .zero, configuration: config)
//    }
//    
//    func updateUIView(_ uiView: WKWebView, context: Context) {
//        guard let baseURLString = youtubeBaseURL else { return }
//        let html = """
//        <html>
//        <head>
//        <meta name="viewport" content="width=device-width, initial-scale=1">
//        </head>
//        <body style="margin:0; background:black;">
//        <iframe width="100%" height="100%"
//            src="\(baseURLString)/\(videoId)"
//            frameborder="0"
//            allow="autoplay; encrypted-media; fullscreen"
//            allowfullscreen
//            referrerpolicy="strict-origin-when-cross-origin">
//        </iframe>
//        </body>
//        </html>
//        """
//        uiView.loadHTMLString(html, baseURL: URL(string: "https://www.example.com"))
//    }
//}

// OLDER version Google no longer supports

//struct YoutubePlayer: UIViewRepresentable {
//    let webView = WKWebView()
//    let videoId: String
//    let youtubeBaseURL = APIConfig.shared?.youtubeBaseURL
//
//    func makeUIView(context: Context) -> some UIView {
//        webView
//    }
//
//    func updateUIView(_ uiView: UIViewType, context: Context) {
//        guard let baseURLString = youtubeBaseURL,
//              let baseURL = URL(string: baseURLString) else {return}
//        let fullURL = baseURL.appending(path: videoId)
//        webView.load(URLRequest(url: fullURL))
//    }
//}

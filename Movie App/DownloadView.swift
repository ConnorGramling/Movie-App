//
//  DownloadView.swift
//  Movie App
//
//  Created by Connor on 11/18/26.
//

import SwiftUI
import SwiftData

struct DownloadView: View {
    @Query(sort: \Title.title) var savedTitles: [Title]
    
    var body: some View {
        NavigationStack {
            if savedTitles.isEmpty {
                Text("No Downloads")
                    .padding()
                    .font(.title3)
                    .bold()
            } else {
                VerticalListView(titles: savedTitles, canDelete: true)
            }
        }
    }
}

#Preview {
    DownloadView()
}

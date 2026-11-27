//
//  VerticalListView.swift
//  Movie App
//
//  Created by Connor on 11/8/26.
//

import SwiftUI
import SwiftData

struct VerticalListView: View {
    var titles: [Title]
    let canDelete: Bool
    @Environment(\.modelContext) var modelContext

    var body: some View {
        List(titles) { title in
            NavigationLink {        // simpler way to create navigation but loses features
                TitleDetailView(title: title)
            } label: {
                AsyncImage(url: URL(string: title.posterPath ?? "")) { image in
                    HStack {
                        image
                            .resizable()
                            .scaledToFit()
                            .clipShape(.rect(cornerRadius: 10))
                            .padding(5)

                        Text((title.name ?? title.title) ?? "")  //tv or movie
                            .font(.system(size: 14))
                            .bold()
                    }
                } placeholder: {
                    ProgressView()
                }
                .frame(height: 150)
            }
            .swipeActions(edge: .trailing) {
                if canDelete {
                    Button {
                        modelContext.delete(title)
                    } label: {
                        Image(systemName: "trash")
                            .tint(.red)
                    }
                }
            }
        }
    }
}

#Preview {
    VerticalListView(titles: Title.previewTitles, canDelete: true)
}

//
//  HorizontalListView.swift
//  Movie App
//
//  Created by Connor on 10/12/26.
//

import SwiftUI

struct HorizontalListView: View {
    let header : String
    var titles : [Title]
    let onSelect : (Title) -> Void
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(header)
                .font(.title)
            
            ScrollView (.horizontal) {
                LazyHStack {
                    ForEach(titles) {title in
                        AsyncImage(url: URL(string: title.posterPath ?? "")) {image in
                            image
                                .resizable()
                                .scaledToFit()
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        } placeholder: {
                            ProgressView()  //place holder while images are loading, loading ring
                        }
                        .frame(width: 120, height: 200)
                        .onTapGesture {
                            onSelect(title)
                        }
                    }
                }
            }
            .frame(height: 250)
            .padding(10)
            //.padding(.top, -25)  // bring title closer to scroll
        }
    }
}

#Preview {
    HorizontalListView(header: Constants.trendingMovieString, titles: Title.previewTitles) { title in
        
    }
}

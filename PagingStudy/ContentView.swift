//
//  ContentView.swift
//  PagingStudy
//
//  Created by 홍희표 on 2022/06/11.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = ContentViewModel()
    
    var body: some View {
        ScrollView {
            let state = viewModel.state
            
            LazyVStack(alignment: .leading) {
                ForEach(Array(state.items.enumerated()), id: \.offset) { i, item in
                    VStack(alignment: .leading) {
                        Text(item.title).font(.system(size: 20))
                        Spacer(minLength: 8)
                        Text(item.description)
                    }.padding(16).onAppear {
                        if i >= state.items.count - 1 && !state.endReached && !state.isLoading {
                            viewModel.loadNextItems()
                        }
                    }
                }
                if viewModel.state.isLoading {
                    HStack(alignment: .center) {
                        ProgressView().progressViewStyle(CircularProgressViewStyle.init())
                    }.padding(8).frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

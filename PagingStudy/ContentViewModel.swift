//
//  ContentViewModel.swift
//  PagingStudy
//
//  Created by 홍희표 on 2022/06/11.
//

import Foundation

class ContentViewModel : ObservableObject {
    @Published var state = State()
    
    private let repository = Repository()
    
    private lazy var paginator = DefaultPaginator<Int, ListItem>(
        initialKey: state.page,
        onLoadUpdated: { isLoading in
            DispatchQueue.main.async {
                self.state = State(
                    isLoading: isLoading,
                    items: self.state.items,
                    error: self.state.error,
                    endReached: self.state.endReached,
                    page: self.state.page
                )
            }
        },
        onRequest: { nextPage in
            await self.repository.getItems(nextPage, 20)
        },
        getNextKey: { _ in
            self.state.page + 1
        },
        onError: {
            self.state = State(
                isLoading: self.state.isLoading,
                items: self.state.items,
                error: $0.localizedDescription,
                endReached: self.state.endReached,
                page: self.state.page
            )
        },
        onSuccess: { items, newKey in
            DispatchQueue.main.async {
                self.state = State(
                    isLoading: self.state.isLoading,
                    items: self.state.items + items,
                    error: self.state.error,
                    endReached: items.isEmpty,
                    page: newKey
                )
            }
        }
    )
    
    func loadNextItems() {
        Task.init {
            await paginator.loadNextItems()
        }
    }
    
    init() {
        loadNextItems()
    }
    
    struct State {
        var isLoading: Bool = false
        
        var items: [ListItem] = []
        
        var error: String? = nil
        
        var endReached: Bool = false
        
        var page: Int = 0
    }
}

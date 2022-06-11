//
//  DefaultPaginator.swift
//  PagingStudy
//
//  Created by 홍희표 on 2022/06/11.
//

import Foundation

class DefaultPaginator<Key, Item> : Paginator {
    private let initialKey: Key
    
    @inline(__always) private let onLoadUpdated: (Bool) -> Void
    
    @inline(__always) private let onRequest: (Key) async -> Result<[Item], Error>
    
    @inline(__always) private let getNextKey: ([Item]) async -> Key
    
    @inline(__always) private let onError: (Error) async -> Void
    
    @inline(__always) private let onSuccess: ([Item], Key) async -> Void
    
    private var currentKey: Key
    
    private var isMakingRequest = false
    
    func loadNextItems() async {
        guard !isMakingRequest else {
            return
        }
        isMakingRequest = true
        onLoadUpdated(true)
        let result = await onRequest(currentKey)
        isMakingRequest = false
        guard let items = try? result.get() else {
            //onError()
            onLoadUpdated(false)
            return
        }
        currentKey = await getNextKey(items)
        await onSuccess(items, currentKey)
        onLoadUpdated(false)
    }
    
    func reset() {
        self.currentKey = initialKey
    }
    
    init(
        initialKey: Key,
        onLoadUpdated: @escaping (Bool) -> Void,
        onRequest: @escaping (Key) async -> Result<[Item], Error>,
        getNextKey: @escaping ([Item]) async -> Key,
        onError: @escaping (Error) async -> Void,
        onSuccess: @escaping ([Item], Key) async -> Void
    ) {
        self.initialKey = initialKey
        self.onLoadUpdated = onLoadUpdated
        self.onRequest = onRequest
        self.getNextKey = getNextKey
        self.onError = onError
        self.onSuccess = onSuccess
        self.currentKey = self.initialKey
    }
}

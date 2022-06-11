//
//  Repository.swift
//  PagingStudy
//
//  Created by 홍희표 on 2022/06/11.
//

import Foundation

class Repository {
    private let remoteDataSource = (1...100).map {
        ListItem(title: "Item \($0)", description: "Description \($0)")
    }
    
    func getItems(_ page: Int, _ pageSize: Int) async -> Result<[ListItem], Error> {
        sleep(2)
        let startingIndex = page * pageSize
        return Result.success(startingIndex + pageSize <= remoteDataSource.count ? remoteDataSource.slice(indices: startingIndex..<startingIndex - 1 + pageSize) : [])
    }
}

extension Array {
   func slice(indices: Range<Int>) -> [Element] {
       if indices.isEmpty {
           return []
       }
       return Array(self[indices.first!...indices.last! + 1])
   }
}

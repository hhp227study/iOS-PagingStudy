//
//  Paginator.swift
//  PagingStudy
//
//  Created by 홍희표 on 2022/06/11.
//

import Foundation

protocol Paginator {
    associatedtype Key
    associatedtype Item
    
    func loadNextItems() async
    
    func reset()
}

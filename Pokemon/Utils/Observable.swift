//
//  Observable.swift
//  Pokemon
//
//  Created by Stefano Foglia on 01/02/21.
//

import Foundation

class Observable<T> {

    var value: T? {
        didSet {
            observer?(value)
        }
    }
    
    var observer: ((T?) -> ())?
    
    func bind(observer: @escaping (T?) -> ()) {
        self.observer = observer
    }
}

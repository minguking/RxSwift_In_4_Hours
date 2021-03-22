//
//  MenuListViewModel.swift
//  RxSwift+MVVM
//
//  Created by Kang Mingu on 2021/03/22.
//  Copyright © 2021 iamchiwon. All rights reserved.
//

import Foundation

import RxSwift

class MenuListViewModel {
    
    let disposeBag = DisposeBag()
    
    var menuObservable = BehaviorSubject<[Menu]>(value: [])
    
    lazy var itemCount = menuObservable.map {
        $0.map { $0.count }.reduce(0, +)
    }
    
    lazy var totalPrice = menuObservable.map {
        $0.map { $0.price * $0.count }.reduce(0, +)
    }
    
    init() {
        let menus: [Menu] = [
            Menu(id: 0, name: "fried1", price: 100, count: 0),
            Menu(id: 1, name: "fried2", price: 200, count: 0),
            Menu(id: 2, name: "fried3", price: 300, count: 0),
            Menu(id: 3, name: "fried4", price: 400, count: 0)
        ]
        
        menuObservable.onNext(menus)
    }
    
    func clearAllItemSelections() {
        _ = menuObservable
            .map { menus in
                return menus.map { m in
                    Menu(id: m.id, name: m.name, price: m.price, count: 0)
                }
        }
        .take(1)
        .subscribe(onNext: {
            self.menuObservable.onNext($0)
        })
    }
    
    func changeCount(item: Menu, increase: Int) {
        _ = menuObservable
            .map { menus in
                menus.map { m in
                    if m.id == item.id {
                        return Menu(id: m.id,
                                    name: m.name,
                                    price: m.price,
                                    count: m.count + increase)
                    } else {
                        return Menu(id: m.id,
                                    name: m.name,
                                    price: m.price,
                                    count: m.count)
                    }
                }
        }
        .take(1)
        .subscribe(onNext: {
            self.menuObservable.onNext($0)
        })
    }
    
}

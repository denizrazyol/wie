//
//  MenuItem.swift
//  wie
//
//  Created by raziye yolasigmazoglu on 09/11/2023.
//

import Foundation


struct MenuItem: Identifiable, Codable {
    let id: Int
    let title: String 
}

struct Menu {
    static let options: [MenuItem] = [
        MenuItem(id: 1, title: "Common Exception Words"),
        MenuItem(id: 2, title: "What's on the Tray"),
        MenuItem(id: 3, title: "Word Search Pack"),
        //MenuItem(id: 5, title: "Think And Write"),
        //MenuItem(id: 5, title: "Story Writing"),
    ]
}


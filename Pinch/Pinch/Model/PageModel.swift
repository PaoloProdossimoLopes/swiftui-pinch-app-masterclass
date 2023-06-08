//
//  PageModel.swift
//  Pinch
//
//  Created by Paolo Prodossimo Lopes on 08/06/23.
//

import Foundation

struct Page: Identifiable {
    let id: Int
    let imageName: String
    
    var thumnailImageName: String {
        "thumb-" + imageName
    }
}

//
//  ArrayExtension.swift
//  Exitek Tech Task
//
//  Created by Иван Бегичев on 02.09.2022.
//

import Foundation

extension Array where Element: Equatable {
    func doesNotContain(_ element: Element) -> Bool {
        return !contains(element)
    }
}

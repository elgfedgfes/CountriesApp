//
//  String+Extensions.swift
//  CountriesApp
//
//  Created by Luis Fernando Sánchez Palma on 08/05/24.
//

import UIKit

extension String {
    
    var localized: String {
        NSLocalizedString(self, comment: " ")
    }
    
    func localizedFill(_ arguments: CVarArg...) -> String {
        let localizedSelf = self.localized
        let spots = (localizedSelf.components(separatedBy: "%@").count - 1)
        
        guard spots == arguments.count else {
            return ""
        }
        
        return String(format: localizedSelf, arguments)
    }
    
}

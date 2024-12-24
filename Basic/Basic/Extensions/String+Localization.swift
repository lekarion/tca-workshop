//
//  String+Localization.swift
//  Basic
//
//  Created by developer on 12.12.2024.
//

import Foundation

extension String {
    var localized: String {
        NSLocalizedString(self, comment: "") as String
    }

    var localizedFlag: String {
        "\(self).flag".localized
    }
}

//
//  HTML.swift
//  Pods
//
//  Created by Thuyen Trinh on 4/2/17.
//
//

import Foundation

extension String {
    public func richTextHTML() -> NSAttributedString? {
        guard let data = data(using: .unicode, allowLossyConversion: true) else { return nil }
        do {
            
            return try NSAttributedString(
                data: data,
                options: [.documentType: NSAttributedString.DocumentType.html],
                documentAttributes: nil
            )
        } catch {
            return nil
        }
    }
}

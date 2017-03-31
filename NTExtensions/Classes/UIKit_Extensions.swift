//
//  UIKit_Extensions.swift
//  NTKit
//
//  Created by Thuyen Trinh on 03/31/2017.
//  Copyright (c) 2017 Thuyen Trinh. All rights reserved.
//

import UIKit

// MARK: - NTViewType
protocol NTViewType {
    var nt_view: UIView { get }
}

extension UIView: NTViewType {
    public var nt_view: UIView { return self }
}

extension NTViewType {
    @discardableResult
    public func config(closure: (Self) -> Void) -> Self {
        closure(self)
        return self
    }
    
    @discardableResult
    public func addTo(parent: UIView) -> Self {
        parent.addSubview(nt_view)
        return self
    }
    
    @discardableResult
    public func addSubview<T: NTViewType>(subview: T, config: (T) -> Void) -> Self {
        nt_view.addSubview(subview.nt_view)
        config(subview)
        return self
    }
}

extension UIView {
    @inline(__always)
    public func addSubviews(_ subviews: UIView...) {
        subviews.forEach { self.addSubview($0) }
    }
}

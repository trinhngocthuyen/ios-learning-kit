//
//  ItemsViewController.swift
//  NTKit
//
//  Created by Thuyen Trinh on 4/1/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit


open class ItemsViewController<ItemType, CellType: UITableViewCell>: UITableViewController {
    public typealias CellConfigurer = (CellType, ItemType, IndexPath) -> ()
    public typealias CellSelectHandler = (CellType, ItemType, IndexPath) -> ()
    
    let reuseIdentifier = "\(CellType.self)-\(ItemType.self)"
    
    public var items: [ItemType] = []
    public var configureCell: ((CellType, ItemType, IndexPath) -> ())?
    public var didSelectCell: ((CellType, ItemType, IndexPath) -> ())?
    
    public init(items: [ItemType], configureCell: CellConfigurer?) {
        self.items = items
        self.configureCell = configureCell
        super.init(nibName: nil, bundle: nil)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(CellType.self, forCellReuseIdentifier: reuseIdentifier)
    }
    
    open override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    open override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! CellType
        let item = items[indexPath.row]
        
        configureCell?(cell, item, indexPath)
        
        return cell
    }
    
    open override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! CellType
        let item = items[indexPath.row]
        didSelectCell?(cell, item, indexPath)
    }
}

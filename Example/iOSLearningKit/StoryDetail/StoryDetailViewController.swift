//
//  StoryDetailViewController.swift
//  iOSLearningKit
//
//  Created by Thuyen Trinh on 4/1/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit
import WebKit

final class CommentTableViewCell: UITableViewCell {
    let titleLabel = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .none
        contentView.addSubviews(titleLabel)
        titleLabel.font = UIFont.systemFont(ofSize: 12)
        titleLabel.lineBreakMode = .byTruncatingTail
        
        titleLabel.snp.remakeConstraints { (make) in
            make.top.equalToSuperview().offset(10)
            make.left.equalToSuperview().offset(10)
            make.center.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - CommentsViewController
final class CommentsViewController: ItemsViewController<HNComment, CommentTableViewCell> {
    
    fileprivate let viewModel: StoryDetailViewModel
    
    // TODO: Discussion: Which is more efficient: Dictionary or Set?
    fileprivate var expandingIndexPaths: Set<IndexPath> = []
    
    init(viewModel: StoryDetailViewModel) {
        self.viewModel = viewModel
        super.init(items: [], configureCell: nil)
        self.title = viewModel.story.title
        
        self.configureCell = { [weak self] (cell, comment, indexPath) in
            guard let strongSelf = self else { return }
            cell.titleLabel.text = comment.content.richTextHTML()?.string
            
            let isExpanding = strongSelf.expandingIndexPaths.contains(indexPath)
            cell.titleLabel.numberOfLines = isExpanding ? 0 : 3
        }
        
        self.didSelectCell = { [weak self] (cell, item, indexPath) in
            guard let strongSelf = self else { return }
            
            if strongSelf.expandingIndexPaths.contains(indexPath) {
                // If it's currently expanding --> Should collapse
                strongSelf.expandingIndexPaths.remove(indexPath)
            } else {
                // Otherwise, it should be expanded
                strongSelf.expandingIndexPaths.insert(indexPath)
            }
            
            strongSelf.tableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NSLog("--- Deinit \(self.self)")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupViewModel()
    }
    
    private func setupView() {
        view.backgroundColor = .white
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 60
    }
    
    private func setupViewModel() {
        viewModel.fetchComments()
            .take(during: self.reactive.lifetime)
            .throttle(1, on: QueueScheduler.main)
            .observeOnMain()
            .startWithValue { [unowned self] comments in
                guard let tableView = self.tableView else { return }
                
                self.items = comments
                tableView.reloadData()
        }
    }
}

typealias StoryDetailViewController = CommentsViewController

// MARK: - StoryDetailViewController
/*
final class StoryDetailViewController: UIViewController {
    fileprivate let commentsViewController: CommentsViewController
    fileprivate let webView = WKWebView()
    
    let viewModel: StoryDetailViewModel
    
    init(viewModel: StoryDetailViewModel) {
        self.viewModel = viewModel
        self.commentsViewController = CommentsViewController(viewModel: viewModel)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupViewModel()
    }
    
    private func setupView() {
        view.backgroundColor = .white
        
        addChildViewController(commentsViewController)
        view.addSubview(commentsViewController.view)
        commentsViewController.didMove(toParentViewController: self)
        
        view.addSubview(webView)
        
        webView.snp.remakeConstraints { (make) in
            make.left.equalToSuperview()
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.6)
        }
        
        commentsViewController.view.snp.remakeConstraints { (make) in
            make.left.equalToSuperview()
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
            make.top.equalTo(webView.snp.bottom)
        }
        
        // TODO: UI/UX: Need a button to expand/collapse comments
        // When tapping it, comments take the whole screen. Otherwise, the screen is for the web view
    }
    
    private func setupViewModel() {
        guard let url = URL(string: viewModel.story.urlString) else { return }
        webView.load(URLRequest(url: url))
    }
}
*/

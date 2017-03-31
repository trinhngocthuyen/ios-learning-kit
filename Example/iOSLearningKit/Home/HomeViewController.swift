//
//  HomeViewController.swift
//  iOSLearningKit
//
//  Created by Thuyen Trinh on 4/1/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit

final class HNStoryTableViewCell: UITableViewCell {
    let titleLabel = UILabel()
    let scoreLabel = UILabel()
    let commentsLabel = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubviews(titleLabel, scoreLabel, commentsLabel)
        titleLabel.font = UIFont.boldSystemFont(ofSize: 13)
        titleLabel.numberOfLines = 2
        titleLabel.lineBreakMode = .byTruncatingTail
        
        scoreLabel.font = UIFont.systemFont(ofSize: 10)
        scoreLabel.textColor = .lightGray
        
        commentsLabel.font = UIFont.systemFont(ofSize: 10)
        commentsLabel.textColor = .lightGray
        
        titleLabel.snp.remakeConstraints { (make) in
            make.top.equalToSuperview().offset(10)
            make.left.equalToSuperview().offset(10)
            make.centerX.equalToSuperview()
        }
        
        scoreLabel.snp.remakeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.left.equalTo(titleLabel)
            make.bottom.equalToSuperview().offset(-10)
        }
        
        commentsLabel.snp.remakeConstraints { (make) in
            make.centerY.equalTo(scoreLabel)
            make.left.equalTo(scoreLabel.snp.right).offset(20)
            make.right.lessThanOrEqualTo(-10)
            make.height.equalTo(scoreLabel)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

final class HomeViewController: ItemsViewController<HNStory, HNStoryTableViewCell> {
    
    fileprivate let viewModel: HomeViewModel
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        
        super.init(items: [], configureCell: { (cell, story, indexPath) in
            cell.titleLabel.text = story.title
            cell.scoreLabel.text = "\(story.score) points"
            cell.commentsLabel.text = "\(story.nNestedComments) comments"
        })
        
        self.didSelectCell = { [weak self] (cell, story, indexPath) in
            guard let strongSelf = self else { return }
            let detailViewModel = StoryDetailViewModel(story: story, apiClient: strongSelf.viewModel.apiClient)
            let detailVC = StoryDetailViewController(viewModel: detailViewModel)
            strongSelf.navigationController?.pushViewController(detailVC, animated: true)
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
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 80
        
        view.layoutIfNeeded()
    }
    
    private func setupViewModel() {
        viewModel.fetchBestStories()
            .take(during: self.reactive.lifetime)
            .throttle(1, on: QueueScheduler.main)
            .observeOnMain()
            .startWithValue { [weak self] stories in
                guard let strongSelf = self, let tableView = strongSelf.tableView else { return }
                
                strongSelf.items = stories
                tableView.reloadData()
        }
    }
    
}

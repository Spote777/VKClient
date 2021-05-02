//
//  NewsTableViewController.swift
//  VKAccount
//
//  Created by Заруцков Павел on 31.08.2020.
//  Copyright © 2020 Павел. All rights reserved.
//

import UIKit

class NewsTableViewController: UITableViewController, UITableViewDataSourcePrefetching, NewsPostCellDelegate {
    
    // MARK: - Properties
    
    private var news = [NewsFeed]()
    private var nextFeed = ""
    private var isLoading = true
    var formateData = FormatData()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.prefetchDataSource = self
        nextNewsFeed()
        refresh()
    }
    
    enum NewsCellTypes: Int, CaseIterable {
        case header
        case content
        case footer
    }
    
    //MARK: - Pull to refresh
    
    func refresh() {
        refreshControl = UIRefreshControl()
        refreshControl?.tintColor = .black
        refreshControl?.attributedTitle = NSAttributedString(string: "Loading...")
        refreshControl?.addTarget(self, action: #selector(reload), for: .valueChanged)
    }
    
    // MARK: - Function
    
    @objc private func reload() {
        nextNewsFeed { [weak self] (news,_) in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.refreshControl?.endRefreshing()
            }
            guard news.count > 0 else { return }
            self.news = news + self.news
        }
    }
    
    func nextNewsFeed(nextFeed: String = "", complition:(([NewsFeed], String?) -> ())? = nil) {
        VKService().getNewsFeed(nextFeed: nextFeed) { [weak self] (news, nextFeed) in
            self?.nextFeed = nextFeed
            self?.news = news
            complition?(news, nextFeed)
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        guard let maxRow = indexPaths
                .map({ $0.row })
                .max()
        else { return }
        
        if maxRow > news.count - 3,
           !isLoading {
            isLoading = true
            
            nextNewsFeed(nextFeed: nextFeed) { [weak self] (news,_) in
                guard let self = self else { return }
                self.news.append(contentsOf: news)
                self.isLoading = false
            }
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        if news.isEmpty {
            tableView.showEmptyMessage("No news loaded\nPull the screen down")
        } else {
            tableView.hideEmptyMessage()
        }
        return news.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return NewsCellTypes.allCases.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let item = news[indexPath.section]
        guard let cell = NewsCellTypes(rawValue: indexPath.row),
              cell == .content,
              let photo = item.attachments?.last?.photo?.sizes.last
        else { return UITableView.automaticDimension }
        let tableWidth = tableView.bounds.width
        let cellHeight = tableWidth * photo.aspectRatio
        return cellHeight
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = news[indexPath.section]
        let cellType = NewsCellTypes.init(rawValue: indexPath.row) ?? .content        
        switch cellType {
        case .header:
            let cell = tableView.dequeueReusableCell(withIdentifier: "NewsHeaderCell", for: indexPath) as! NewsHeaderCell
            cell.date.text = formateData.getCellDateText(forIndexPath: indexPath, andTimestamp: item.date)
            cell.separatorInset = UIEdgeInsets(top: 0, left: cell.bounds.size.width, bottom: 0, right: 0)
            cell.configureUser(item: item)
            return cell
            
        case .content:
            let cell = tableView.dequeueReusableCell(withIdentifier: "NewsPostCell", for: indexPath) as! NewsPostCell
            cell.delegate = self
            cell.separatorInset = UIEdgeInsets(top: 0, left: cell.bounds.size.width, bottom: 0, right: 0)
            if cell.post.text?.count ?? 0 <= 200 {
                cell.showMore.isHidden = false
            }
            cell.configure(item: item)
            return cell
            
        case .footer:
            let cell = tableView.dequeueReusableCell(withIdentifier: "NewsFooterCell", for: indexPath) as! NewsFooterCell
            cell.configure(item: item)
            return cell
        }
    }
    
    //MARK: - NewsPostCellDelegate
    
    func didTappedShowMore(_ cell: NewsPostCell) {
        tableView?.beginUpdates()
        cell.isExpanded.toggle()
        tableView?.endUpdates()
    }
    
}

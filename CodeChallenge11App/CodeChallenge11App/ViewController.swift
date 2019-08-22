//
//  ViewController.swift
//  CodeChallenge11App
//
//  Created by Chris Thomas on 22/08/2019.
//  Copyright © 2019 John Lewis plc. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    private let refreshControl = UIRefreshControl()
    
    @IBOutlet var tableView: UITableView!
    
    var pubs: [Pub] = [] {
        didSet {
            beers = obtainListOfBeers(from: pubs)
            
        }
    }
    
    var beers: [Beer] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "BeerCell", bundle: Bundle.main), forCellReuseIdentifier: BeerCell.reuseIdentifier)
        self.tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshPubs(_:)), for: .valueChanged)
        getPubs()
    }
    
    @objc private func refreshPubs(_ sender: Any) {
        // Fetch Weather Data
        getPubs()
    }
}


extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return beers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BeerCell.reuseIdentifier, for: indexPath) as? BeerCell else {
            return UITableViewCell()
        }
        
        let beer = beers[indexPath.row]
        cell.update(with: beer)
        return cell
    }
    
    
}

extension ViewController {
    private func obtainListOfBeers(from pubs: [Pub]) -> [Beer] {
        let beers = pubs.flatMap { pub -> [Beer] in
            let regularBeers = pub.regularBeers.map { name in
                Beer(name: name, pubName: pub.name, pubService: pub.pubService, beerType: .regular)
            }
            let guestBeers = pub.guestBeers.map { name in
                Beer(name: name, pubName: pub.name, pubService: pub.pubService, beerType: .guest)
            }
            return regularBeers + guestBeers
            }
        
        return beers.sorted { $0.name < $1.name }
    }
    
    private func fetchData(_ completion:@escaping (Bool, [Pub], Error?)->()) {
        let pubURL = URL(string: "https://pubcrawlapi.appspot.com/pubcache/?uId=mike&lng=-0.141499&lat=51.496466&deg=0.003")
        
        guard let url = pubURL else { return }
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error == nil{
                do {
                    guard let data = data else { return }
                    let response = try JSONDecoder().decode(API.Pubs.self, from: data)
                    let pubs = response.pubs.map {
                        Pub($0)
                    }
                    completion(true, pubs, nil)
                } catch {
                    completion(false, [], error)
                }
            }
            completion(false, [], error)
        }
        
        task.resume()
    }
    
    private func getPubs() {
        self.fetchData { success, pubs, error in
            
            // Fetching APIs happen Async, but we need to update the UI stuff on the main thread
            DispatchQueue.main.async {
                if success {
                    self.refreshControl.endRefreshing()
                    self.pubs = pubs
                }
            }
        }
    }
}


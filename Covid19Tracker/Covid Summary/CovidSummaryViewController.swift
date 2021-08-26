//
//  CovidSummaryViewController.swift
//  Covid19Tracker
//
//  Created by Chaithra Thalpanaje Shrikrishna on 19/08/21.
//

import Foundation
import UIKit
class CovidSummaryViewController: UIViewController, Alertable {
    
    enum Segments {
        case allCountries
        case visitedCountries
        
        init(selectedIndex: Int) {
            switch selectedIndex {
            case 0:
                self = .allCountries
            case 1:
                self = .visitedCountries
            default:
                self = .allCountries
            }
        }
    }
    var selectedSegment = Segments.allCountries
    var searchText = ""
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noResultsLabel: UILabel!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    var viewModel: CovidSummaryViewModel!
    var visitedCountryList = UserDefaults.standard.structArrayData(Countries.self, forKey: "visitedCountryList") as? [Countries] ?? [Countries]()
    var summary: CovidSummary?
    
    var allCountries = [Countries]()
    var visitedCountries = [Countries]()
    var searchResults = [Countries]()
    
    static func viewController() -> CovidSummaryViewController {
        return (UIStoryboard(name: "CovidSummary", bundle: nil).instantiateInitialViewController() as! UINavigationController).viewControllers.first as! CovidSummaryViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.noResultsLabel.isHidden = true
        self.tableView.isHidden = false
        fetchSummary()
        searchBar.delegate = self
        hideKeyboardWhenTappedAround()
    }
    
    private func checkInternet() {
        guard NetworkReachability().isReachable else {
            showAlertWithSettings(title: "No Internet", message: "Please connect to your mobile network or enable wifi in settings")
            self.activityIndicator.stopAnimating()
            return
        }
    }
    
    @objc func fetchSummary() {
        checkInternet()
        let group = DispatchGroup()
        group.enter()
        self.activityIndicator.startAnimating()
        NetworkManager.shared.fetchCovidSummary(url: "https://api.covid19api.com/summary", completionHandler: { result in
            switch result {
            case .success(let summary):
                print(summary)
                group.leave()
                self.summary = summary
                self.allCountries = summary.countries
                self.activityIndicator.stopAnimating()
                self.tableView.reloadData()
            case .failure(let error):
                print(error)
                self.activityIndicator.stopAnimating()
            }
        })
    }
    
    
    @IBAction func segementChanged(_ sender: UISegmentedControl) {
        self.selectedSegment = Segments(selectedIndex: sender.selectedSegmentIndex)
        switch selectedSegment {
        case .allCountries:
            self.allCountries = self.summary?.countries ?? [Countries]()
        case .visitedCountries:
            self.visitedCountries = UserDefaults.standard.structArrayData(Countries.self, forKey: "visitedCountryList")
        }
        if !searchText.isEmpty {
            searchTriggered()
        }
        self.tableView.reloadData()
    }
}

extension CovidSummaryViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchText.isEmpty {
            switch selectedSegment {
            case .allCountries:
                return allCountries.count
            case .visitedCountries:
                return visitedCountries.count
            }
        }else {
            return searchResults.count
        }
     
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell: ListCell? = tableView.dequeueReusableCell(withIdentifier: "ListCell") as? ListCell
        if cell == nil {
            tableView.register(UINib.init(nibName: "ListCell", bundle: nil), forCellReuseIdentifier: "LogViweCell")
            let arrNib: Array = Bundle.main.loadNibNamed("ListCell", owner: self, options: nil)!
            cell = arrNib.first as? ListCell
        }
        var countryObject: Countries?
        if searchText.isEmpty {
            switch selectedSegment {
            case .allCountries:
                countryObject = allCountries[indexPath.row]
            case .visitedCountries:
                countryObject = visitedCountries[indexPath.row]
            }
        }else {
            countryObject = searchResults[indexPath.row]
        }
        cell?.lblCountryName.text = countryObject?.country
        if let countryCcode = countryObject?.countryCode {
            cell?.lblType.text = countryCcode
            cell?.countryImageview?.image = UIImage(named: countryCcode.lowercased())
        }
       
        return cell!
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90.5
    }

    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
            return .none
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var countryObject: Countries?
        if searchText.isEmpty {
            switch selectedSegment {
            case .allCountries:
                countryObject = allCountries[indexPath.row]
            case .visitedCountries:
                countryObject = visitedCountries[indexPath.row]
            }
        }else {
            countryObject = searchResults[indexPath.row]
        }
        if let countryObject = countryObject {
            visitedCountryList.append(countryObject)
            viewModel.showCovidSummary(covidSummary: countryObject)
        }
        UserDefaults.standard.setStructArray(visitedCountryList.uniqued(), forKey: "visitedCountryList")
    }

    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
       return nil
    }
}

extension CovidSummaryViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
        searchTriggered()
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchTriggered()
    }
}
extension CovidSummaryViewController {
    func searchTriggered() {
        self.searchText = searchBar.text ?? ""
        var list = [Countries]()
        if let searchText = searchBar.text, !searchText.isEmpty {
            switch selectedSegment {
            case .allCountries:
                list = allCountries
            case .visitedCountries:
                list = visitedCountries
            }
            let filteredList = list.filter { $0.country.contains(searchText)}
            self.searchResults = filteredList
            self.tableView.reloadData()
        }else {
            self.searchText = ""
            self.tableView.reloadData()
        }
    }
}
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

public extension Array where Element: Hashable {
    func uniqued() -> [Element] {
        var seen = Set<Element>()
        return filter{ seen.insert($0).inserted }
    }
}

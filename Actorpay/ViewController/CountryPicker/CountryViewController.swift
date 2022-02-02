//
//  CountryViewController.swift
//  Actorpay
//
//  Created by iMac on 07/01/22.
//

import UIKit

class CountryViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.tableHeaderView = UISearchBar()
        }
    }
    
    @IBOutlet weak var searchBar: UISearchBar! {
        didSet {
            searchBar.delegate = self
        }
    }
    
    var countries: [(letter: Character, countries: [CountryList])] = []
    var sections : [String] = []
    var countryLists : [CountryList] = []
    var filtterCountryLists : [CountryList] = []
    typealias CompletionBlock = (_ code: String,_ flag: String, _ country: String) -> Void
    var onCompletion:CompletionBlock?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Choose Country"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelClicked(sender:)))
        navigationItem.leftBarButtonItem?.tintColor = .black
        getCountryListAPI()
        // Do any additional setup after loading the view.
    }
    @objc func cancelClicked(sender: UIBarButtonItem) {
        print("Cancel clicked!")
        self.dismiss(animated: true, completion: nil)
    }
    
    func getCountryListAPI() {
        showLoading()
        APIHelper.getCountryListAPI() { (success, response) in
            if !success {
                dissmissLoader()
                let message = response.message
                print(message)
            }else {
                dissmissLoader()
                let data = response.response.data
                self.filtterCountryLists = data.arrayValue.map({CountryList(json: $0)})
                self.countryLists = self.filtterCountryLists
                self.data()
                self.tableView.reloadData()
            }
        }
    }
    
    func data(){
        countries = Dictionary(grouping: countryLists) { (country) -> Character in
            if let char = country.country?.first {
                return char
            }
            return "".first!
        }
        .map { (key: Character, value: [CountryList]) -> (letter: Character, countries: [CountryList]) in
            sections.append("\(key)")
            self.sections = sections.removeDuplicates()
            return (letter: key, countries: value)
        }
        .sorted { (left, right) -> Bool in
            left.letter < right.letter
        }
        print(sections)
    }
}

extension CountryViewController: UITableViewDelegate, UITableViewDataSource {
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return sections
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return countries.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let value = "\(countries[section].letter)"
        return value
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countries[section].countries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CountryCell", for: indexPath) as! CountryCell
        let countryList = countries[indexPath.section].countries[indexPath.row]
        cell.countryList = countryList
        let view = UIView()
        view.backgroundColor = .clear
        cell.selectedBackgroundView = view
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let countryList = countries[indexPath.section].countries[indexPath.row]
        if let codeCompletion = onCompletion {
            codeCompletion(countryList.countryCode ?? "",countryList.countryFlag ?? "",countryList.country ?? "")
            self.dismiss(animated: true, completion: nil)
        }
    }
}

extension CountryViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText != "" {
            print(searchText)
            self.countryLists = self.filtterCountryLists.filter({
                ($0.country ?? "").localizedCaseInsensitiveContains(searchText) || ($0.countryCode ?? "").localizedCaseInsensitiveContains(searchText)
            })
        }else{
            self.countryLists = self.filtterCountryLists
        }
        self.data()
        self.tableView.reloadData()
    }
}

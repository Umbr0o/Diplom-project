//
//  FilterViewController.swift
//  Diplom-project
//
//  Created by Артем Томило on 23.06.22.
//

import UIKit

final class FilterViewController: UIViewController {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var closeButon: UIButton!
    @IBOutlet weak var acceptButton: UIButton!
    @IBOutlet weak var resetFilterButton: UIButton!
    
    //MARK: - properties
    
    weak var delegate: FilterViewControllerDelegate?
    
    private var servicesDictionary: Dictionary <ProfServices, Bool> = [:]
    
    static let cellIdentifier = "cell"
    
    //MARK: - View did load
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.allowsMultipleSelection = true
        
        servicesDictionary = DataManager.shared.decodeServices()
        
        if servicesDictionary.isEmpty {
            servicesDictionary = Dictionary(uniqueKeysWithValues: zip(ProfServices.allCases, repeatElement(false, count: ProfServices.allCases.count)))
        }
        
        for i in ProfServices.allCases {
            if servicesDictionary[i] == true {
                let index = IndexPath(row: i.rawValue, section: 0)
                tableView.selectRow(at: index, animated: false, scrollPosition: .none)
            }
        }
        
        tableView.register(CustomCell.self, forCellReuseIdentifier: Self.cellIdentifier)
    }
    
    //MARK: - Filter func
    
    func filterFunc() -> Set<ProfServices>  {
        var services: Set<ProfServices> = []
        
        for (key, value) in servicesDictionary {
            if value {
                services.insert(key)
            }
        }
        
        return services
    }
    
    //MARK: - Button actions
    
    @IBAction func closeVC(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    @IBAction func acceptFilterFunc(_ sender: UIButton) {
        DataManager.shared.encodeServices(type: servicesDictionary)
        delegate?.filterMap(with: filterFunc())
        dismiss(animated: true)
    }
    
    @IBAction func clearAll(_ sender: UIButton) {
        for (key, value) in servicesDictionary {
            if value {
                servicesDictionary[key] = false
            }
        }
        DataManager.shared.encodeServices(type: servicesDictionary)
        
        delegate?.filterMap(with: filterFunc())
        
        dismiss(animated: true)
    }
}

//MARK: - Extension table view

extension FilterViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ProfServices.allCases.count
    }
}

extension FilterViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Self.cellIdentifier, for: indexPath) as? CustomCell else { return UITableViewCell() }
        
        let services = ProfServices.allCases[indexPath.row]
        
        cell.text = services.title
        
        cell.picture.image = UIImage(named: services.image)
        
        tableView.rowHeight = 70
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentService = ProfServices.allCases[indexPath.row]
        servicesDictionary[currentService] = true
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let currentService = ProfServices.allCases[indexPath.row]
        servicesDictionary[currentService] = false
    }
}

//MARK: - Protocol FilterViewControllerDelegate

protocol FilterViewControllerDelegate: AnyObject {
    func filterMap(with set: Set<ProfServices>)
}

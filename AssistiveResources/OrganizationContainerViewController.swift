//
//  OrganizationContainerViewController.swift
//  AssistiveResources
//
//  Created by Bill Johnson on 2/4/17.
//  Copyright © 2017 SevenPlusTwo. All rights reserved.
//

import UIKit


let updateOrgListNotificationKey = NSNotification.Name(rawValue: "key_notify_organization_list_changed")


protocol OrganizationListContainerNotificationProtocol: class {
    func notifyRowDetailSelected(rowIndex: Int)
    func notifyFilterSelected()
}


class OrganizationContainerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var containerTableView: UITableView!

    weak private var resources: RegionalResourcesModelController!
    weak private var notificationDelegate:OrganizationListContainerNotificationProtocol?
    private var expandedRowIndex = -1
    private var showLoadingIndicatorAtStartup: Bool?
    
    //MARK: - inherited
    
    func dependencies(rsrcModelController: RegionalResourcesModelController, delegate: OrganizationListContainerNotificationProtocol) {
        
        self.resources = rsrcModelController
        self.notificationDelegate = delegate
        self.showLoadingIndicatorAtStartup = self.resources!.organizations.isLoading()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshOrgContent), name: updateOrgListNotificationKey, object: nil)
    }
    
    deinit {
        print("deallocating OrganizationContainerVC")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        precondition(self.resources != nil)
        precondition(self.notificationDelegate != nil)
        
        self.containerTableView.delegate = self
        self.containerTableView.dataSource = self
        
        self.containerTableView.separatorInset = UIEdgeInsets.zero
        self.containerTableView.separatorColor = UIColor.blue
        self.containerTableView.backgroundColor = UIColor.white
        
        //tableView.allowsSelection = false
        self.containerTableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))   // this gets rid of separator lines for empty cells
        
        if (self.showLoadingIndicatorAtStartup!) {
            startActivityIndicator(title: nil, message: "loading...")
        }

        self.containerTableView.rowHeight = UITableViewAutomaticDimension
        self.containerTableView.estimatedRowHeight = 140}
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        //freeMemory()
    }
    


    //MARK: - tableView delegates
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        //return (expandedRowIndex == indexPath.row) ? 286.0 : 100
//        //return 286.0
//        return 0.0
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return resources!.organizations.count
        return self.resources.organizations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let kOrganizationListCellID = "OrganizationListCellIdentifier"
        
        let cell:OrganizationListTableViewCell = tableView.dequeueReusableCell(withIdentifier: kOrganizationListCellID) as! OrganizationListTableViewCell
        
        let organiz:Organization = resources!.organizations[indexPath.row]
        cell.configureCell(org: organiz, expand: expandedRowIndex == indexPath.row)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        //expandCollapseRow(row: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    
    //MARK: - utils
    
    func refreshOrgContent() {
        if (self.showLoadingIndicatorAtStartup!) {
            self.showLoadingIndicatorAtStartup = false
            stopActivityIndicator()
        }
        
        self.containerTableView.reloadData()
    }
    
    // MARK: - @IBAction
    
    @IBAction func showOrgDetailButtonAction(_ sender: UIButton) {
        let row = getRowFrom(sender, self.containerTableView)
        if row > -1 {
            notificationDelegate?.notifyRowDetailSelected(rowIndex: row)
        }
    }
    
    @IBAction func filterButtonAction(_ sender: Any) {
        notificationDelegate?.notifyFilterSelected()
    }
    
}

func requestOrgListRefresh() {
    NotificationCenter.default.post(name: updateOrgListNotificationKey, object: nil)
}



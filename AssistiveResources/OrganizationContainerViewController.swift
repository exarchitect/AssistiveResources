//
//  OrganizationContainerViewController.swift
//  AssistiveResources
//
//  Created by Bill Johnson on 2/4/17.
//  Copyright © 2017 SevenPlusTwo. All rights reserved.
//

import UIKit



protocol OrganizationListContainerNotificationProtocol: class {
    func notifyDetailSelected(for descriptor: OrganizationDescriptor)
    func notifyFilterSelected()
}


class OrganizationContainerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CacheUpdateProtocol {

    @IBOutlet weak var containerTableView: UITableView!

    weak private var notificationDelegate:OrganizationListContainerNotificationProtocol?
    private var expandedRowIndex = -1
    private var showLoadingIndicator: Bool = false
    private var organizationAccessor: OrganizationCacheAccessor!
    
    //MARK: - INHERITED
    
    func configuration(rsrcModelController: RegionalResourcesModelController, delegate: OrganizationListContainerNotificationProtocol) {
        
        self.notificationDelegate = delegate

        self.organizationAccessor = rsrcModelController.createOrganizationAccessor(delegate: self)
        guard self.organizationAccessor != nil else {
            return      // TODO - need actual fail mechanism
        }
    }
    
    deinit {
        let _ = 0
        //print("deallocating OrganizationContainerVC")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //precondition(self.resources != nil)
        precondition(self.notificationDelegate != nil)
        
        self.containerTableView.delegate = self
        self.containerTableView.dataSource = self
        
        self.containerTableView.separatorInset = UIEdgeInsets.zero
        self.containerTableView.separatorColor = UIColor.blue
        self.containerTableView.backgroundColor = UIColor.white
        
        //tableView.allowsSelection = false
        self.containerTableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))   // this gets rid of separator lines for empty cells
        
        self.containerTableView.rowHeight = UITableViewAutomaticDimension
        self.containerTableView.estimatedRowHeight = 140

        self.organizationAccessor.loadCache(using: FilterDictionary())
        if self.organizationAccessor.cacheState == .notLoaded {
            self.showLoadingIndicator = true
            DispatchQueue.main.asyncAfter(deadline: (DispatchTime.now())) {
                startActivityIndicator(title: nil, message: "loading...")
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        //freeMemory()
    }
    
    // MARK: - REPOSITORY ACCESSOR PROTOCOL
    
    func notifyRepositoryWasUpdated() {
        if self.showLoadingIndicator {
            self.showLoadingIndicator = false
            stopActivityIndicator()
        }
        
        self.containerTableView.reloadData()
    }


    // MARK: - TABLE VIEW DELEGATES
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.organizationAccessor.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let kOrganizationListCellID = "OrganizationListCellIdentifier"
        
        let cell:OrganizationListTableViewCell = tableView.dequeueReusableCell(withIdentifier: kOrganizationListCellID) as! OrganizationListTableViewCell
        
        guard let organizr = self.organizationAccessor[indexPath.row] else {
            return cell
        }
        cell.configureCell(org: organizr, expand: expandedRowIndex == indexPath.row)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        //expandCollapseRow(row: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    
    // MARK: - UTILITIES
    
    func refreshOrgContent() {
        if self.showLoadingIndicator {
            self.showLoadingIndicator = false
            stopActivityIndicator()
        }
        
        self.containerTableView.reloadData()
    }
    
    // MARK: - @IBAction
    
    @IBAction func showOrgDetailButtonAction(_ sender: UIButton) {
        let row = getRowFrom(sender, containerTableView)
        guard row > -1, let descriptor = organizationAccessor[row]?.descriptor else {
            return
        }
        notificationDelegate?.notifyDetailSelected(for: descriptor)
    }
    
    @IBAction func filterButtonAction(_ sender: Any) {
        notificationDelegate?.notifyFilterSelected()
    }
    
}


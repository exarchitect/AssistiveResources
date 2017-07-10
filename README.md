# AssistiveResources

Assistive Resources Readme

Assistive Resources is an app that is designed to provide access to critical information and resources needed by parents/caregivers of special needs kids.  The information displayed to a user must be scoped to their location.

UI Architecture 
The app is structured around 3 types of controllers:
 - app controller contains the high-level logic of the app.  There is a single app controller for each app.
 - model controller(s) encapsulate the high level logic for a data domain.  A model controller provides an interface to access the data in the model.  Each MC has an interface that is specific to the data in the model and how it is used.  
 - process controller(s) manage a reusable unit of the UI, such as user login/authentication, displaying a list from a model object, or detail from a single model object.  A PC has a standard interface and coordinates view controllers and any other user-facing functionality.  At present, each process controller manages a primary view controller, supporting view controllers needed (if any), and a storyboard for this portion of the UI.

Interaction between these 3 types of Controllers
A single App Controller manages high-level coordination and instantiation of the other 2 types of controllers.  
 - when a specific process controller is needed, the app controller instantiates any model controller(s) needed and created/pushes the process controller with the model(s).  
 - a process controller passes Command structs back to the app controller to handle.  Commands include:
	* dismiss self (process controller)
	* navigate to ‘x’
	* user authentication success
	* etc.

Startup Process
The startup process of the current app looks like this:
 - misc setup
 - load the user model controller
 - push the navigation process controller (the ‘root’ process controller, which needs no model)
 - request the user model controller authorize the user.  If it has stored user credentials, it will attempt to use them. if it has no stored credentials or user logged is not successful, it returns success=false
 - If the user model controller CANNOT authorize the user, the app controller will push the authentication process controller. It will ask for credentials, or allow the user to signup, or continue as a guest.  This process controller manages all activity until there is a successful login, at which point it sends 2 commands to the app controller:
	* dismissProcessController (self)
	* userLoginSuccessful
 - after successful login, only the navigation process controller is visible.
 - after this point, the app controller responds to commands sent by the topmost process controller, typically to push a specific process controller, or to dismiss a process controller (so far each process controller requests it own dismissal) 

RegionalResources Data Architecture 
The RegionalResources model controller manages access to the resources that get shown to the user.  The resources that are currently supported are Organizations and Events.  Requirements for this data:
 - resources must be filtered by location
 - they must be cached locally in case of network access interruptions
 - resources can be shown to the user (temporarily) if outdated
 - as much as possible the local storage and network api details need to be managed by the model controller and its objects, NOT by the process controller(s)

RegionalResources Objects and Responsibilities
 - RegionalResources model controller
	* load the local repository (a Realm db) from a remote source (currently dummy data)
	* create EventAccessor and OrganizationAccessor objects so that objects outside the model can retrieve filtered data
 - RegionalResources repository
	* manage realm db containing: events, organizations, and a single LocationProfile that indicates the location that the cached data was filtered for
	* manage updates if cached data does not exist, is not for the current location, or is out of date
 - Accessor objects 
	* allow clients to retrieve/filter a data type (Event or Organization) from a repository
	* provide notification if data changes

Using the RegionalResources model controller
 - get an accessor of the type needed from the RegionalResources model controller.  The delegate is for update notifications
	self.eventAccessor = rsrcModelController.createEventAccessor(delegate: self)
 - request data
	self.eventAccessor.requestData(filteredBy: NeedsProfile(mobility: .AnyLimitation, delay: .AnyDelay, dx: .AnyDiagnosis))
 - check data availability
	if (self.eventAccessor.state == .NotLoaded) {…}     If .state == .NotLoaded, we put up a progress alert until the delegate is called to notify that the data is available.  Otherwise the .state == .Loaded.
 - access the data
	the Accessor objects provide access to the data using subscripts, i.e.    let event:StoredEvent = self.eventAccessor[indexPath.row]

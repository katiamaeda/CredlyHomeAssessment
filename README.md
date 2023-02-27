# Credly User List App

## Requirements 
* Xcode 14
* To run the app just open "CredlyUsersKatia.xcodeproj"

## Architect
* This app was architected using MVVM, you can find groups for Models, Views and ViewModels. 
* You can find the Network layer inside Services
* UsersListViewModel is responsible to fetch data from the API to populate the initial list. When fetchUsers() finishes downloading the data, it sends the new feched data to the published users property. UsersListViewController is subscribed to $users and will reload the tableview and update all UI components based on the new users data.
* The group wirings contains the classes used for navigation. UIFactory is responsible to create all ViewControllers, MainCoordinator controls the navigation between ViewControllers.
* Other than unit tests for the Network Layer I include tests for the ViewModel

## 3rd party libraries added using Swift Package Manager
* Alamofire for API requests
* Mocker for API requests mocks



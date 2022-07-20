# Create an iOS Custom Keyboard extension

Custom keyboard implementation doing requests API and later saving those in a local database for rendering items on the keyboard view.

This implementation is conformed to three main folders which are the next:

* Business.- This folder contains all use cases based on business rules.

* DataAccess.- This folder contains all kinds of repositories in our case LocalRepository and RestRepository.

* UI.- This folder contains al related to Views and ViewModels.

## NOTE:
In order to avoid issues with Realm, Please install pod extension deintegrate:

1) > sudo gem install cocoapods-deintegrate cocoapods-clean

and uset it in the main folder of the project:
 
2) > pod deintegrate

and later reinstall the dependencies
> pod install

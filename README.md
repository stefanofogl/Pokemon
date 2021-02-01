# Pokemon
## Overview

Pokemon is a simple app that displays a list of Pokemon with image and name, when the
user selects a Pokemon, the app shows the detail with the Pokemon name, images,
stats and type.

It is possibile to search specific Pokemon by the search bar and it's possible to work even offline by saving favourites Pokemon on the device in "Favourite" section.

The app is written without storyboard or xib and support both iPhone and iPad.

## Frameworks
In this app there aren't any external libraries, I just used native framework.

I used "CoreData" to store saved Pokemon on the device; "URLSession" to call API; "UIKit" for the UI; "SystemConfiguration" to check internet connection, and I made a "Observable" class to work with MVVM.

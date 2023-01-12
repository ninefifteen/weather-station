# iOS Team Project

## Project Overview
As a mapping company, the ability to display information effectively on a map is paramount. For this project you will fetch weather station data and display those stations as points on a map.

The weather station data is contained in two hosted JSON files (links below). The first JSON file contains forecast data for weather stations reporting ‘today’, the other contains forecast data for weather stations reporting ‘tomorrow’. In the context of this app, launch/wake time is always ‘today’.

# Core Functionality
Using UIKit or SwiftUI, shoot for adding the following functionality:
* Display a MapKit map on screen
  * Target iPhone 11 Simulator
  * Center your map on 40°55‘26.40"N 108°05’43.80”W 
  * Make your map span 25°Δ latitude and 20°Δ longitude (Hint: MKCoordinateSpan) 
* Consume and parse weather station data (Treat endpoints as if they're not serving static data)
  * Today’s Station Data ([Link](https://gist.githubusercontent.com/rcedwards/4ff0a1510551295be0ec0369186d83ed/raw/fc7b5308546c0e1085d8748134138cef4281ac11/today.json))
  * Tomorrow’s Station Data ([Link](https://gist.githubusercontent.com/rcedwards/6421fa7f0f3789801935d6d37df55922/raw/e673021836819aa20018853643c8769fd4d129fd/tomorrow.json))
* Create and add to the map a MapKit annotation only for each station within the visible map area (this is contrary to Apple’s documentation which states to add all annotations even if not currently in view.) 
  * The annotation should show the weather station’s current temperature, if available, else blank
* After the user pans or zooms the map, filter and update the current set of annotations to be only those that are visible in the newly displayed map region. You may opt to continuously update the set of annotation during a map interaction, or opt to update only after the interaction ends  
* Add a UI element that toggles between today’s and tomorrow’s station data data 
* Add a callout view with station/condition details when tapping on a station

# Extra Credit
The following are a list of additional features you could add to your base solution (in no particular
order):
* Add a UI element that toggles station annotation display between temperature, wind speed, and precipitation chance
  * Really extra: if wind speed is selected, add to the annotation an accurate indication of wind direction
* Persist station data and display data from this store if the app is launched with no connectivity
* Add Unit Tests
* Add support for rotation / other device sizes
* Keep the station callout view visible while toggling Date or Condition Information (Temp, Wind, Precep)

Group Project - README Template
===

# litterly

## Table of Contents
1. [Overview](#Overview)
1. [Product Spec](#Product-Spec)
1. [Wireframes](#Wireframes)
2. [Schema](#Schema)

## Overview
### Description
litterly is an app that encourages any individual to help clean up their environment together as a community through a gamified points system.

### App Evaluation
- **Category: Social/Environment**
- **Mobile: This app relies heavily on the GPS functionality of a phone. However if we do decide to build a website for it, it will have limited functionality**
- **Story: Mark any location on the map that is dirty and then team up with others to clean up the site**
- **Market: Any individual that would like to help their community to be trash free**
- **Habit: After your clean up, you would be rewarded with points. The points then later can be used to help acquire real world objects**
- **Scope: Potentially the world. You need google maps enabled for your country and internet access**

## Product Spec

### 1. User Stories (Required and Optional)

**Required Must-have Stories**

* User can Sign-in using google
* User can view their current location on mapView
* User can see the markers that is posted by others on the mapView
* User is able to tap on a marker and view the event details (e.g. date, time of event and a picture)
* User is able to tap on a marker and join the event
* User is able to tap on a marker and host an event for that location
* User is able to view the profile icons of all the people that are going to the event
* User is able to create a marker on the map based on their location and become the event lead
* User is able to view all the events that they are going to on the events view page
* A logout button
* A profile view where user is able to view their past clean up events
* User is able to earn points after completting a successful clean up event

**Optional Nice-to-have Stories**

* Subtle animations to enhance user experience
* The implementation of cleanup roles
* A way to contact the event lead when joining an event (messaging perhaps within the app)
* A way to redeem the points for some real world value

### 2. Screen Archetypes

* Login screen
   * User can sign-in with google
* mapView screen
   * User can view their current location on mapView
   * User can see the markers that is posted by others on the mapView
   * User is able to tap on a marker and view the event details (e.g. date, time of event and a picture)
   * User is able to tap on a marker and join the event
   * User is able to tap on a marker and host an event for that location
   * User is able to view the profile icons of all the people that are going to the event
   * User is able to create a marker on the map based on their location and become the event lead

* Collection Table View
    * User is able to view all the events that they are going to
    * User is able to view the profile icons of all the people that are going to the event
    
* Profile View
    * A view where user is able to view their past clean up events
    * User is able to see a breakdown of the points they have earned from the clean ups


### 3. Navigation

**Tab Navigation** (Tab to Screen)

* Map View screen
* Collection events Table View 

**Flow Navigation** (Screen to Screen)

* Intro Page
   * Sign-in page
   * Maps View Page
* Maps View page
   * Tap to open Profile page

## Wireframes
This was our initial idea. We eneded up going a totally different route as shown with the digital mockup.
<img src="https://i.imgur.com/XSRA5tX.jpg">

### [BONUS] Digital Wireframes & Mockups
<img src="https://i.imgur.com/jwIO0w6.jpg">

## Schema 
### Models
#### User 

   | Property      | Type     | Description |
   | ------------- | -------- | ------------|
   | name          | String   | User's display name from googleAuth API |
   | city          | String   | The home city of USer |
   | profileImage  | URL      | Image url from googleAuth API |
   | tags          | Int      | Number of trash spots that the user has tagged, pointer to the Trash |
   | points        | Int      | Number of points that the user has earned |
   
#### Trash

   | Property      | Type     | Description |
   | ------------- | -------- | ------------|
   | lat           | Float    | The latitude of trash |
   | lon           | Float    | The longititude of trash |
   | trashType     | String   | The type of trash this is [organic, plastic, metal] |
   | address       | String   | Address stored from google places |
   | author        | User     | The tagger of this trash pile |
   | picture       | ImageFile| The picture taken during the tag |
   | isEventScheduled| Bool   | Does the trash have a cleanup event scheduled |
   if isEventScheduled == true:
   | listOfUsers  | [URL]    | [profile_imageURL] |
   
#### Events

   | Property      | Type     | Description |
   | ------------- | -------- | ------------|
   | lat           | Float    | The latitude of trash |
   | lon           | Float    | The longititude of trash |
   | trashType     | String   | The type of trash this is [organic, plastic, metal] |
   | address       | String   | Address stored from google places |
   | date          | String   | Date of the event |
   | time          | String   | Time of the event |
   | listOfUsers   | [URL]    | [profile imageURL] |

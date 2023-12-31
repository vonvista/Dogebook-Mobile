# Project - Social Media Application
### Von Vincent O. Vista
### 2019-09230
### X-1L

# Project Presentation

https://youtu.be/TnyYvtAyJ64

# Project Installation

## Dependencies 

### MongoDB 

Installation guide: https://www.mongodb.com/docs/manual/installation/

### Node

Installation guide: https://phoenixnap.com/kb/install-node-js-npm-on-windows

## Setup

- Clone the repository on your machine
- Open the terminal and go to ```db``` directory by performing ```cd db```. Once in db directory, perform ```npm install```
- Once ```node_modules``` are installed, do ```npm start``` and wait for the message ```Server started at port 3001```
<p float="left">
  <img src="/screenshots/dep%20(1).png" width="40%" />
</p>

- Go to the ```db_helper.dart``` file in the directory ```./project/lib/db_helper.dart```
- Modify the ```serverIP``` variable inside class ```DBHelper```, it will change depending on your setup and device used to run the project. See common setups below:
  - AVD (Android Emulator) - 10.0.2.2
  - Using Chrome or Windows - 127.0.0.1
  - Using external phone or device - IP of your network (usually wifi, must be connected with the same network)

<p float="left">
  <img src="/screenshots/dep%20(2).png" width="40%" />
</p>

- Once done, you can now press ```Fn + F5``` on any of the ```.dart``` files under the ```lib``` directory to build and run the project.

## Integration Testing

Test cases in widget_test.dart are all successful locally, please look at NOTE on the file before running tests

<p float="left">
  <img src="/screenshots/tests%20(1).png" width="40%" />
</p>

For a copy of my version of my database on the state of the testing, mongodump is in Project23 folder on root

- For restoring mongodb database, see https://www.mongodb.com/docs/database-tools/mongorestore/

## Common Problems

### MongoDB - ```MongooseServerSelectionError: connect ECONNREFUSED 127.0.0.1:27017``` upon npm start on db directory

Error is caused by MongoDB not running / the MongoDB service hasn't started yet

On Windows

- Go to services, look for MongoDB Server (MongoDB) servcie and start the service

For other systems see here: https://www.mongodb.com/community/forums/t/error-couldnt-connect-to-server-127-0-0-1-27017/705

### Application - No route to host

This may happen for two reasons, do the first bullet first before doing the second bullet

- Disconnect and reconnect to your network in both the host (the computer machine) and the client (the emulator or device)
- Change the ```serverIP```, IP address configuration is inccorect

# Challenges met while doing the exercise.
There were many challenges that I faced during the development of the project. First is the sheer amount of features you need to implement, not only that but you also need to design not only the backend, but the UI as well. I also had the extra challenge which is making my own http endpoints and database using MongoDB because I started the project at the time wherein the project API was not yet given. However, because of that, I think that I improved and learned a lot with working with MongoDB and Mongoose, which is a win for me, and because I created my own server, I have full control of the functionality of the http requests.

I also am challenged a lot with working with Futures, but with experimentation, trial and error, and many failures, I had a more deeper understanding on how they work, how to manipulate them, and how to use them easily. I also encountered a problem with the Navigator and getting previous widgets to refresh upon navigation pop, which made me understand the concept of keys in widgets. I also had a challenge with creating an independent class for status messages using snackbar, which made me understand how to use and create global variables in flutter. 

These aren't all the challenges that I have faced in the development of the project, but one thing is for sure, that I learned a lot from the experience, mistakes, and accomplishments that I had with this project.

# Happy paths and Unhappy paths encountered.

## Signup Page
<p float="left">
  <img src="/screenshots/sc%20(1).jpg" width="40%" />
</p>

### 🙁 Pressing sign up without any of the fields filled up
<p float="left">
  <img src="/screenshots/sc%20(2).jpg" width="40%" />
</p>
🛠️ <strong>To reproduce:</strong> Do not fill any of the fields and press sign up
</br>
💻 <strong>Result:</strong> Messages are shown to fill up the fields without any entries
</br>

### 🙁 Signing up with non-matching passwords on password and repeat password fields
<p float="left">
  <img src="/screenshots/sc%20(3).jpg" width="40%" />
  <img src="/screenshots/sc%20(4).jpg" width="40%" />
</p>
🛠️ <strong>To reproduce:</strong> Fill up all of the fields with appropriate details and have password and repeat password fields mismatch in input. Press sign up
</br>
💻 <strong>Result:</strong> A message is shown that passwords do not match
</br>

### 😀 Signing up with all fields field appropriately
<p float="left">
  <img src="/screenshots/sc%20(5).jpg" width="40%" />
  <img src="/screenshots/sc%20(6).jpg" width="40%" />
</p>
🛠️ <strong>To reproduce:</strong> Fill up all of the fields with appropriate details and matching passwords. Press sign up
</br>
💻 <strong>Result:</strong> A success status message is shown and you are redirected back to login screen
</br>

### 🙁 Signing up with an email that is already registered
<p float="left">
  <img src="/screenshots/sc%20(7).jpg" width="40%" />
</p>
🛠️ <strong>To reproduce:</strong> Fill up all of the fields with appropriate details, but with an email that is already registered
</br>
💻 <strong>Result:</strong> An error status message is shown saying that there is already a user with the email
</br>

### 🙁  Signing up with invalid email
<p float="left">
  <img src="/screenshots/sc%20(8).jpg" width="40%" />
</p>
🛠️ <strong>To reproduce:</strong> Fill up all of the fields with appropriate details, but with an email that is an invalid mail format
</br>
💻 <strong>Result:</strong> An message is shown saying to enter a valid email
</br>

## Login Page
<p float="left">
  <img src="/screenshots/sc%20(9).jpg" width="40%" />
</p>

### 🙁 Logging in with an email not registered in the system
<p float="left">
  <img src="/screenshots/sc%20(11).jpg" width="40%" />
</p>
🛠️ <strong>To reproduce:</strong> Fill up the email field with an email not in the system (password can be anything)
</br>
💻 <strong>Result:</strong> An error status message is shown saying email is not registered
</br>

### 🙁 Logging in with an incorrect password
<p float="left">
  <img src="/screenshots/sc%20(12).jpg" width="40%" />
</p>
🛠️ <strong>To reproduce:</strong> Fill up the email field with an email in the system but with the wrong passsword
</br>
💻 <strong>Result:</strong> An error status message is shown saying incorrect passworwd
</br>

### 😀 Correct email and passsword
<p float="left">
  <img src="/screenshots/sc%20(13).jpg" width="40%" />
  <img src="/screenshots/sc%20(14).jpg" width="40%" />
</p>
🛠️ <strong>To reproduce:</strong> Fill up the email field with an email in the system and with the correct password
</br>
💻 <strong>Result:</strong> An success status message is shown and user is redirected to the feed page of the application
</br>

//From this point onwards, I'll not modify the happy/unahppy emoji

### 🙁 Login without filling fields
<p float="left">
  <img src="/screenshots/sc%20(15).jpg" width="40%" />
</p>
🛠️ <strong>To reproduce:</strong> Do not fill up any of the fields
</br>
💻 <strong>Result:</strong> Messages are shown to fill up the fields without any entries
</br>


## Feed Page
<p float="left">
  <img src="/screenshots/sc%20(16).jpg" width="40%" />
</p>

### 😀 Create a post
<p float="left">
  <img src="/screenshots/sc%20(17).jpg" width="40%" />
  <img src="/screenshots/sc%20(18).jpg" width="40%" />
</p>
🛠️ <strong>To reproduce:</strong> Press the create post button and fill up the text field, set the privacy on the dropdown and press post
</br>
💻 <strong>Result:</strong> A success status message is shown saying that post is created and post can be seen on the wall
</br>

### 🙁 Create an empty post
<p float="left">
  <img src="/screenshots/sc%20(19).jpg" width="40%" />
</p>
🛠️ <strong>To reproduce:</strong> Press the create post button and do not type on the text field, press post
</br>
💻 <strong>Result:</strong> Nothing will happen and nothing will be posted as it needs to have something to be posted
</br>

### 😀 Editing a post
<p float="left">
  <img src="/screenshots/sc%20(20).jpg" width="40%" />
  <img src="/screenshots/sc%20(21).jpg" width="40%" />
</p>
🛠️ <strong>To reproduce:</strong> Press on the edit button on posts that are your own and edit your post or privacy (or just leave it as is) and press post
</br>
💻 <strong>Result:</strong>A success status message is shown saying that post is edited and changes can be seen on your wall
</br>

### 🙁 Editing a post and removing the content completely
<p float="left">
  <img src="/screenshots/sc%20(22).jpg" width="40%" />
</p>
🛠️ <strong>To reproduce:</strong> Press on the edit button on posts that are your own and clear your post content. Press post
</br>
💻 <strong>Result:</strong>An error status message is shown saying that it is unable to save post, a post needs content to be edited
</br>

### 😀 Deleting a post
<p float="left">
  <img src="/screenshots/sc%20(23).jpg" width="40%" />
  <img src="/screenshots/sc%20(24).jpg" width="40%" />
</p>
🛠️ <strong>To reproduce:</strong> Press on the delete button on posts that are your own and 
</br>
💻 <strong>Result:</strong>A success status message is shown saying that post is edited and changes can be seen on your wall
</br>

### 😀 Loading more posts
<p float="left">
  <img src="/screenshots/sc%20(69).jpg" width="40%" />
  <img src="/screenshots/sc%20(70).jpg" width="40%" />
</p>
🛠️ <strong>To reproduce:</strong> Go to the bottom of the list of the feed and press the load more button
</br>
💻 <strong>Result:</strong> It fetches at most 10 posts. If there are no more posts, the bottom of the feed will say no more posts
</br>

## Comments Page
<p float="left">
  <img src="/screenshots/sc%20(63).jpg" width="40%" />
</p>

### 😀 Add comment
<p float="left">
  <img src="/screenshots/sc%20(64).jpg" width="40%" />
  <img src="/screenshots/sc%20(65).jpg" width="40%" />
</p>
🛠️ <strong>To reproduce:</strong> Type on the comment field and press the send button
</br>
💻 <strong>Result:</strong> A success status message is shown saying that a comment is added an comment can be seen
</br>

### 😀 Delete comment
<p float="left">
  <img src="/screenshots/sc%20(23).jpg" width="40%" />
  <img src="/screenshots/sc%20(24).jpg" width="40%" />
</p>
🛠️ <strong>To reproduce:</strong> Press on the delete button on comments that are your own 
</br>
💻 <strong>Result:</strong> A success status message is shown saying that comment has been deleted and comment is removed from comment list
</br>

## Search Page
<p float="left">
  <img src="/screenshots/sc%20(25).jpg" width="40%" />
</p>

### 😀 Searching for a user using first name or last name
<p float="left">
  <img src="/screenshots/sc%20(26).jpg" width="40%" />
</p>
🛠️ <strong>To reproduce:</strong> Type on the search field the name of the user you want to search (either first name, last name, or both) and press the search button
</br>
💻 <strong>Result:</strong> A list of users matching the search query is shown, if no users exist with the search query then no users will be shown
</br>

### 😀 Tapping on a user on the search page
<p float="left">
  <img src="/screenshots/sc%20(27).jpg" width="40%" />
</p>
🛠️ <strong>To reproduce:</strong> Tap on a user that is on the list after having a successful search query
</br>
💻 <strong>Result:</strong> You will be redirected to the profile page of the tapped user
</br>

## Profile Page
<p float="left">
  <img src="/screenshots/sc%20(28).jpg" width="40%" />
</p>

### 😀 Sending a friend request
<p float="left">
  <img src="/screenshots/sc%20(29).jpg" width="40%" />
</p>
🛠️ <strong>To reproduce:</strong> Tap on the send friend request button, this will only be visible if the user on the profile page is still not your friend
</br>
💻 <strong>Result:</strong> A success status message is shown saying that friend request is sent.
</br>

### 😀 Visiting a profile wherein you're already friends
<p float="left">
  <img src="/screenshots/sc%20(68).jpg" width="40%" />
  <img src="/screenshots/sc%20(30).jpg" width="40%" />
</p>
🛠️ <strong>To reproduce:</strong> Visit a profile of a user you're already friends with
</br>
💻 <strong>Result:</strong> The posts wall of the user will display both public and friends post
</br>

### 🙁 Sending a friend request wherein you've already sent a request before
<p float="left">
  <img src="/screenshots/sc%20(31).jpg" width="40%" />
</p>
🛠️ <strong>To reproduce:</strong> Tap the send friend request button to a user you've already sent a friend request
</br>
💻 <strong>Result:</strong> An error status message is shown saying that friend request is already sent
</br>

### 😀 Visiting your own profile
<p float="left">
  <img src="/screenshots/sc%20(31).jpg" width="40%" />
</p>
🛠️ <strong>To reproduce:</strong> Tap your own profile
</br>
💻 <strong>Result:</strong> Your own profile can be viewed along with your public and friends post, as well as a button to edit profile
</br>

## Friends Page
<p float="left">
  <img src="/screenshots/sc%20(33).jpg" width="40%" />
</p>

### 😀 Accepting friend request
<p float="left">
  <img src="/screenshots/sc%20(34).jpg" width="40%" />
  <img src="/screenshots/sc%20(35).jpg" width="40%" />
</p>
🛠️ <strong>To reproduce:</strong> Tap on the check button on a user tile that is on the friend request section
</br>
💻 <strong>Result:</strong> A success status message is shown saying the friend request is accepted
</br>

### 😀 Rejecting friend request
<p float="left">
  <img src="/screenshots/sc%20(36).jpg" width="40%" />
  <img src="/screenshots/sc%20(37).jpg" width="40%" />
</p>
🛠️ <strong>To reproduce:</strong> Tap on the cross button on a user tile that is on the friend request section
</br>
💻 <strong>Result:</strong> A success status message is shown saying the friend request is rejected
</br>

### 😀 Remove friend
<p float="left">
  <img src="/screenshots/sc%20(38).jpg" width="40%" />
  <img src="/screenshots/sc%20(39).jpg" width="40%" />
</p>
🛠️ <strong>To reproduce:</strong> Tap on the remove friend button on a user tile that is on the friend section
</br>
💻 <strong>Result:</strong> A success status message is shown saying the friend is removed
</br>

### 🙁 Accepting a friend request when friend count is already on the friend limit
<p float="left">
  <img src="/screenshots/sc%20(40).jpg" width="40%" />
  <img src="/screenshots/sc%20(41).jpg" width="40%" />
</p>
🛠️ <strong>To reproduce:</strong> Tap on the check button on a user tile that is on the friend request section while having 8 friends already
</br>
💻 <strong>Result:</strong> An error status message is shown saying that the friend limit is reached
</br>

## User Page
<p float="left">
  <img src="/screenshots/sc%20(42).jpg" width="40%" />
</p>

### 😀 Tapping on your own profile
<p float="left">
  <img src="/screenshots/sc%20(43).jpg" width="40%" />
</p>
🛠️ <strong>To reproduce:</strong> Tap on the user tile with your name
</br>
💻 <strong>Result:</strong> You are redirected to your own profile page
</br>

### 😀 Tapping on update password
<p float="left">
  <img src="/screenshots/sc%20(44).jpg" width="40%" />
</p>
🛠️ <strong>To reproduce:</strong> Tap on the update password button
</br>
💻 <strong>Result:</strong> You are redirected to the update password page
</br>

### 😀 Tapping on log out
<p float="left">
  <img src="/screenshots/sc%20(45).jpg" width="40%" />
</p>
🛠️ <strong>To reproduce:</strong> Tap on the logout button
</br>
💻 <strong>Result:</strong> You are loggedo out of the system and you are redirected to the login page
</br>

## Update Password Page
<p float="left">
  <img src="/screenshots/sc%20(49).jpg" width="40%" />
</p>

### 🙁 Not filling up any of the fields
<p float="left">
  <img src="/screenshots/sc%20(46).jpg" width="40%" />
</p>
🛠️ <strong>To reproduce:</strong> Tap on the update password button without filling up the fields
</br>
💻 <strong>Result:</strong> Messages are shown to fill up the fields without any entries
</br>

### 🙁 Entering wrong old password
<p float="left">
  <img src="/screenshots/sc%20(47).jpg" width="40%" />
</p>
🛠️ <strong>To reproduce:</strong> Fill up all the fields appropriately, enter the wrong old password. Press update password
</br>
💻 <strong>Result:</strong> An error status message is shown saying incorrect old password
</br>

### 🙁 Having new password and repeat new password mismatch
<p float="left">
  <img src="/screenshots/sc%20(48).jpg" width="40%" />
</p>
🛠️ <strong>To reproduce:</strong> Fill up all the fields appropriately, have different entries for the new password and repeat password fields. Press update password
</br>
💻 <strong>Result:</strong> An error status message is shown saying passwords do not match
</br>

### 😀 Having all appropriate and correct details
<p float="left">
  <img src="/screenshots/sc%20(49).jpg" width="40%" />
  <img src="/screenshots/sc%20(50).jpg" width="40%" />
</p>
🛠️ <strong>To reproduce:</strong> Fill up all the fields appropriately. Press update password
</br>
💻 <strong>Result:</strong> A success status message is shown saying that password is updated and user is redirected to user page
</br>

## Update Profile Page
<p float="left">
  <img src="/screenshots/sc%20(51).jpg" width="40%" />
</p>

### 🙁 Not filling up any of the fields
<p float="left">
  <img src="/screenshots/sc%20(56).jpg" width="40%" />
</p>
🛠️ <strong>To reproduce:</strong> Tap on the update profile button without filling up the fields
</br>
💻 <strong>Result:</strong> Messages are shown to fill up the fields without any entries
</br>

### 🙁 Entering invalid email
<p float="left">
  <img src="/screenshots/sc%20(55).jpg" width="40%" />
</p>
🛠️ <strong>To reproduce:</strong> Fill up the fields appropriately, enter an invalid email. Press update password
</br>
💻 <strong>Result:</strong> Message is shown to enter a valid email on the email field
</br>

### 🙁 Updating email to an email linked to an account
<p float="left">
  <img src="/screenshots/sc%20(54).jpg" width="40%" />
</p>
🛠️ <strong>To reproduce:</strong> Fill up the fields appropriately, enter an email that is already linked to another account. Press update password
</br>
💻 <strong>Result:</strong> An error status message is shown that email is already taken
</br>

### 😀 Having all appropriate and correct details
<p float="left">
  <img src="/screenshots/sc%20(53).jpg" width="40%" />
  <img src="/screenshots/sc%20(52).jpg" width="40%" />
</p>
🛠️ <strong>To reproduce:</strong> Fill up all the fields appropriately. Press update profile
</br>
💻 <strong>Result:</strong> A success status message is shown saying that user is updated and user is redirected to profile page
</br>

## GENERAL - Doing application functions while having no internet connection / not connected to the network

<p float="left">
  <img src="/screenshots/sc%20(57).jpg" width="28%" />
  <img src="/screenshots/sc%20(58).jpg" width="28%" />
  <img src="/screenshots/sc%20(59).jpg" width="28%" />
</p>
<p float="left">
  <img src="/screenshots/sc%20(60).jpg" width="28%" />
  <img src="/screenshots/sc%20(61).jpg" width="28%" />
  <img src="/screenshots/sc%20(62).jpg" width="28%" />
</p>
🛠️ <strong>To reproduce:</strong> Do any of the application functions without internet
</br>
💻 <strong>Result:</strong> An error status message is shown saying SocketException. Error is handled
</br>









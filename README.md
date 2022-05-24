# Project - Social Media Application
### Von Vincent O. Vista
### 2019-09230
### X-1L

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

# Documentation

## Challenges met while doing the exercise.
The main challenge in the exercise in learning how to work with Futures with this kind of data. Since we are essentially working with "fake" data, nothing is really saved in the API, which brings many problems especially with how to display the data being processed. This brings a pain point I had with this exercise, with having most of my time wasted with figuring out how to work with jsonplaceholder, even though the networking part is fast to work with. I have to make some workarounds in order to make certain things in the exercise work.

## Happy paths and Unhappy paths encountered.

NOTE: Some of the systems and variables in place here is due to how jsonplaceholder works. Since we are working with fake data, we are not actually saving anything to the server. So I implemented workarounds just to make things display correctly with the application.

### 😃 Opening the application
<p float="left">
  <img src="/screenshots/sc%20(3).jpg" width="40%" />
  <img src="/screenshots/sc%20(4).jpg" width="40%" /> 
</p>
🛠️ <strong>To reproduce:</strong> Open and start the application </br>
💻 <strong>Result:</strong> Todos are fetched in the API and we can scroll through all the todos in the list </br>

### 😃 Adding a new todo
<p float="left">
  <img src="/screenshots/sc%20(5).jpg" width="40%" />
  <img src="/screenshots/sc%20(6).jpg" width="40%" /> 
</p>
🛠️ <strong>To reproduce:</strong> Tap the floating action button on the bottom right, fill up the title, and uncheck/check the completed box. Press save </br>
💻 <strong>Result:</strong> Todo is added on the list and a success message is shown </br>

### 😃 Editing a todo from the fetched todos
<p float="left">
  <img src="/screenshots/sc%20(7).jpg" width="40%" />
  <img src="/screenshots/sc%20(8).jpg" width="40%" /> 
</p>
🛠️ <strong>To reproduce:</strong> Press the pencil icon from any of the tiles from the fetched todos. Edit the title or completed status or just leave it as it is </br>
💻 <strong>Result:</strong> Changes for the todo is reflected on the list and a success message is shown </br>

### 😃 Deleting a todo from the fetched todos
<p float="left">
  <img src="/screenshots/sc%20(9).jpg" width="40%" />
  <img src="/screenshots/sc%20(10).jpg" width="40%" /> 
</p>
🛠️ <strong>To reproduce:</strong> Press the trash icon from any of the tiles from the fetched todos </br>
💻 <strong>Result:</strong> Todo is removed from the list and a success message is shown </br>

### ☹️ Adding a todo without a title
<p float="left">
  <img src="/screenshots/sc%20(11).jpg" width="40%" />
  <img src="/screenshots/sc%20(12).jpg" width="40%" /> 
</p>
🛠️ <strong>To reproduce:</strong> Tap the floating action button on the bottom right, do not fill up anything. Press save </br>
💻 <strong>Result:</strong> A message is shown to enter a todo title </br>

### 😃 Adding another todo after adding a todo previously
<p float="left">
  <img src="/screenshots/sc%20(13).jpg" width="40%" />
  <img src="/screenshots/sc%20(14).jpg" width="40%" /> 
</p>
🛠️ <strong>To reproduce:</strong> Add another todo after a todo was added previously  </br>
💻 <strong>Result:</strong> The todo that is added previously is replaced by the new todo and a success message is shown. This happens because all of the added todo in jsonplaceholder returns an id of 201 (this is a workaround to how jsonplaceholder works) </br>

### ☹️ Editing the added todo
<p float="left">
  <img src="/screenshots/sc%20(15).jpg" width="40%" />
  <img src="/screenshots/sc%20(16).jpg" width="40%" /> 
</p>
🛠️ <strong>To reproduce:</strong> Edit the todo that is added </br>
💻 <strong>Result:</strong> A error message is shown with error 500: internal server error. This happens because the id of added todo which is 201 is not really added in the API, hence the API doesn't know about the existence of todo 201, returning an error. Error is handled </br>

### 😃 Deleting the added todo
<p float="left">
  <img src="/screenshots/sc%20(17).jpg" width="40%" />
  <img src="/screenshots/sc%20(18).jpg" width="40%" /> 
</p>
🛠️ <strong>To reproduce:</strong> Delete the added todo </br>
💻 <strong>Result:</strong> The added todo is deleted and a success message is shown </br>

### ☹️ Adding a todo without internet
<p float="left">
  <img src="/screenshots/sc%20(19).jpg" width="40%" />
  <img src="/screenshots/sc%20(20).jpg" width="40%" /> 
</p>
🛠️ <strong>To reproduce:</strong> Add a todo without internet connectivity (turning off wifi and data) </br>
💻 <strong>Result:</strong> An error message is shown with the error as SocketException. Error is handled </br>

### ☹️ Editing a todo without internet
<p float="left">
  <img src="/screenshots/sc%20(21).jpg" width="40%" />
  <img src="/screenshots/sc%20(22).jpg" width="40%" /> 
</p>
🛠️ <strong>To reproduce:</strong> Edit a todo without internet connectivity (turning off wifi and data) </br>
💻 <strong>Result:</strong> An error message is shown with the error as SocketException. Error is handled </br>

### ☹️ Deleting a todo without internet
<p float="left">
  <img src="/screenshots/sc%20(23).jpg" width="40%" />
  <img src="/screenshots/sc%20(24).jpg" width="40%" /> 
</p>
🛠️ <strong>To reproduce:</strong> Delete a todo without internet connectivity (turning off wifi and data) </br>
💻 <strong>Result:</strong> An error message is shown with the error as SocketException. Error is handled </br>

### ☹️ Opening the application without internet
<p float="left">
  <img src="/screenshots/sc%20(25).jpg" width="40%" />
  <img src="/screenshots/sc%20(26).jpg" width="40%" /> 
</p>
🛠️ <strong>To reproduce:</strong> Open the application without internet connectivity (turning off wifi and data) </br>
💻 <strong>Result:</strong> No todos are displayed and an error message is shown with the error as SocketException. Error is handled </br>












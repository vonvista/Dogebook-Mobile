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

### 😃 Opening the application
<p float="left">
  <img src="/screenshots/sc%20(3).jpg" width="40%" />
  <img src="/screenshots/sc%20(4).jpg" width="40%" /> 
</p>
🛠️ <strong>To reproduce:</strong> Open and start the application 
</br>
💻 <strong>Result:</strong> Todos are fetched in the API and we can scroll through all the todos in the list 
</br>











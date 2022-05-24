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
There were many challenges that I faced during the development of the project. First is the sheer amount of features you need to implement, not only that but you also need to design not only the backend, but the UI as well. I also had the extra challenge which is making my own http endpoints and database using MongoDB because I started the project at the time wherein the project API was not yet given. However, because of that, I think that I improved and learned a lot with working with MongoDB and Mongoose, which is a win for me, and because I created my own server, I have full control of the functionality of the http requests.

I also am challenged a lot with working with Futures, but with experimentation, trial and error, and many failures, I had a more deeper understanding on how they work, how to manipulate them, and how to use them easily. I also encountered a problem with the Navigator and getting previous widgets to refresh upon navigation pop, which made me understand the concept of keys in widgets. I also had a challenge with creating an independent class for status messages using snackbar, which made me understand how to use and create global variables in flutter. 

These aren't all the challenges that I have faced in the development of the project, but one thing is for sure, that I learned a lot from the experience, mistakes, and accomplishments that I had with this project.

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











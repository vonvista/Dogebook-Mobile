const mongoose = require('mongoose');
const bcrypt = require('bcrypt')
const Schema = mongoose.Schema;
var _ = require('underscore');
const e = require('express');

saltRounds = 10;

const db = mongoose.createConnection("mongodb://localhost:27017/Project23", {
  useNewUrlParser: true,
  useUnifiedTopology: true
})

exports.homepage = (req, res) => {
  res.send("Welcome to homepage");
}

// USERS

const userSchema = new Schema({
  firstName: {type: String, required : true},
  lastName: {type: String, required : true},
  email: {type: String, required: true, unique: true},
  password : {type: String, required : true},
  friends: [{type: Schema.Types.ObjectId, ref: 'user'}],
  friendRequests: [
    {type: Schema.Types.ObjectId, ref: 'user'}
  ]
},{autoCreate:true});



const User = db.model('user',userSchema);

// add user
exports.userAdd = async function(req, res, next) {
  // UNCOMMENT TO SEE REQUEST CONTENTS AND MAPPING TO USER MODEL
  // console.log(req.body);

  var hashedPassword = await bcrypt.hash(req.body.password, saltRounds); //encrpyt password first -vov

  //check if there's a user with the same email, if not create a new user
  const user = await User.findOne({email: req.body.email});
  if(user){
    res.send({err:'There is already a user with this email'});
    return;
  }
  
  var newUser = new User({
    firstName: req.body.firstName,
    lastName: req.body.lastName,
    email: req.body.email,
    password: hashedPassword,
    friends: [],
    friendRequests: []
  });
  console.log(newUser);

  newUser.save(function(err) {
    if (!err) { 
      res.send(newUser)
    }
    else { 
      res.send({err:'Unable to save user'}) 
      console.log(err)
    }
  });
}

//user login
exports.userLogin = async function(req, res, next) {
  
  const user = await User.findOne({email: req.body.email});
  if(user){
    const passwordMatch = await bcrypt.compare(req.body.password, user.password);
    if(passwordMatch){
      res.send(user);
    } else {
      res.send({err:'Incorrect password'});
    }
  }
  else {
    res.send({err:'User not found'});
  }
}

//get all users
exports.getAllUsers = async function(req, res, next) {
  const users = await User.find({});
  res.send(users);
}

//find all users who matches the username using regex
exports.findUsers = async function(req, res, next) {
  // const users = await User.find({firstName: {$regex: req.body.firstName, $options: 'i'}});
  //find users whose first name and last name matches the regex 
  const searchNames = req.body.username.split(' ');
  var users = new Set();
  //find users whose first name or last name matches any of the searchNames
  for (var i = 0; i < searchNames.length; i++) {
    //find users whose first name or last name matches any of the searchNames
    if(searchNames[i] == ''){
      continue;
    }
    const searchedUsers = await User.find({$or: [{firstName: {$regex: searchNames[i], $options: 'i'}}, {lastName: {$regex: searchNames[i], $options: 'i'}}]});
    for (var j = 0; j < searchedUsers.length; j++) {

      users.add(searchedUsers[j]);
    }
  }

  console.log([...users])
  if(users){
    res.send([...users]);
  }
  else {
    res.send({err:'User not found'});
  }
}

//update password 
exports.updatePassword = async function(req, res, next) {
  //find user by userId
  const user = await User.findById(req.body.userId);
  if(user){
    const passwordMatch = await bcrypt.compare(req.body.oldPassword, user.password);
    if(passwordMatch){
      const hashedPassword = await bcrypt.hash(req.body.newPassword, saltRounds);
      user.password = hashedPassword;
      user.save(function(err) {
        if (!err) {
          res.send(user);
        }
        else {
          res.send({err:'Unable to save user'});
          console.log(err);
        }
      });
    }
    else {
      res.send({err:'Incorrect password'});
    }
  }
  else {
    res.send({err:'User not found'});
  }
}

//find user by id
exports.findUserById = async function(req, res, next) {
  console.log(req.body)
  const user = await User.findById(req.body.id);
  
  if(user){
    res.send(user);
  }
  else {
    res.send({err:'User not found'});
  }
}

//update first name, last name, and email (email must not be taken)
exports.updateUser = async function(req, res, next) {
  //find user by userId
  const user = await User.findById(req.body.userId);
  if(user){
    //check if email is taken, other than the current user
    const emailExists = await User.findOne({email: req.body.email, _id: {$ne: req.body.userId}});
    if(emailExists){
      res.send({err:'Email already taken'});
    }
    else {
      user.firstName = req.body.firstName;
      user.lastName = req.body.lastName;
      user.email = req.body.email;
      user.save(function(err) {
        if (!err) {
          res.send(user);
        }
        else {
          res.send({err:'Unable to save user'});
          console.log(err);
        }
      });
    }
  }
  else {
    res.send({err:'User not found'});
  }
}

//aggregate friend requests
exports.getFriendRequests = async function(req, res, next) {
  const user = await User.findById(req.body.id);
  if(user){
    //send friend requests with user info
    const friendRequests = await User.find({_id: {$in: user.friendRequests}});
    console.log(friendRequests);
    res.send(friendRequests);
  }
  else {
    res.send({err:'User not found'});
  }
}

//aggregate friends
exports.getFriends = async function(req, res, next) {
  const user = await User.findById(req.body.id);
  if(user){
    //send friend requests with user info
    const friends = await User.find({_id: {$in: user.friends}});
    console.log(friends);
    res.send(friends);
  }
  else {
    res.send({err:'User not found'});
  }
}


//friend requests

//send friend request
exports.sendFriendRequest = async function(req, res, next) {
  const user = await User.findById(req.body.userId);
  const friend = await User.findById(req.body.friendId);
  // console.log(user, friend);
  if(user && friend){
    //check if friend request already exists
    if(user.friendRequests.includes(friend._id)){
      res.send({err:'Friend request already sent'});
    }
    else {
      user.friendRequests.push(friend._id);
      user.save(function(err) {
        if (!err) {
          res.send(user);
        }
        else {
          res.send({err:'Unable to save user'});
          console.log(err);
        }
      });
    }
  }
  else {
    res.send({err:'User not found'});
  }
}

//accept friend request
exports.acceptFriendRequest = async function(req, res, next) {
  const user = await User.findById(req.body.userId);
  const friend = await User.findById(req.body.friendId);

  console.log(user._id, friend._id)
  if(user && friend){
    //add user id and friend id to each other's friends list
    await user.friends.push(friend._id);
    await friend.friends.push(user._id);
    //pull friend request from user
    await friend.friendRequests.pull(user._id);
    

    await user.save(function(err) {
      if (!err) {
      }
      else {
        res.send({err:'Unable to save user'});
        console.log(err);
      }
    });
    await friend.save(function(err) {
      if (!err) {
      }
      else {
        res.send({err:'Unable to save user'});
        console.log(err);
      }
    });
    res.send({suc: 'Friend request accepted'});
  }
  else {
    res.send({err:'User not found'});
  }
}

//reject friend request
exports.rejectFriendRequest = async function(req, res, next) {
  const user = await User.findById(req.body.userId);
  const friend = await User.findById(req.body.friendId);
  if(user && friend){
    //pull friend request from user
    await friend.friendRequests.pull(user._id);
    // await user.save(function(err) {
    //   if (!err) {
    //   }
    //   else {
    //     res.send({err:'Unable to save user'});
    //     console.log(err);
    //   }
    // });
    await friend.save(function(err) {
      if (!err) {
        res.send({suc: 'Friend request rejected'});
      }
      else {
        res.send({err:'Unable to save user'});
        console.log(err);
      }
    });
    
  }
  else {
    res.send({err:'User not found'});
  }
}

//remove friends
exports.removeFriend = async function(req, res, next) {
  const user = await User.findById(req.body.userId);
  const friend = await User.findById(req.body.friendId);
  if(user && friend){
    //remove friend from user's friends list
    await user.friends.pull(friend._id);
    //remove user from friend's friends list
    await friend.friends.pull(user._id);
    await user.save(function(err) {
      if (!err) {
      }
      else {
        res.send({err:'Unable to save user'});
        console.log(err);
      }
    });
    await friend.save(function(err) {
      if (!err) {
      }
      else {
        res.send({err:'Unable to save user'});
        console.log(err);
      }
    });
    res.send({suc: 'Friend removed'});
  }
  else {
    res.send({err:'User not found'});
  }
}


// POSTS

const postSchema = new Schema({
  userId: {type: Schema.Types.ObjectId, ref: 'user'},
  content: {type: String, required: true},
  privacy: {type: String, required: true, enum: ['public', 'friends']},
  //date of creation
},{autoCreate:true, timestamps: true});

const Post = db.model('post',postSchema);

// get all public post
exports.getAllPublicPosts = async function(req, res, next) {
  //get all posts with privacy = public and replace userId with first name and last name
  const posts = await Post.find({privacy: 'public'}).populate('userId', 'firstName lastName');
  // console.log(posts);
  res.send(posts);
}

// get user posts sorted by data in descending order and limit to 10 starting from postid provided
exports.getAllPublicPostsLimited = async function(req, res, next) {
  // get user posts sorted by data in descending order and limit to 10 starting from postid
  var posts;
  user = await User.findById(req.body.userId);
  console.log("GET POSTS");
  if(req.body.postId != ""){
    //get public post and friend post from array of friends in descending order and limit to 10 starting from postid
    posts = await Post.find({$or: [{privacy: 'public'}, {privacy: 'friends', userId: {$in: user.friends}}], _id: {$lt: req.body.postId}}).sort({createdAt: -1}).limit(10).populate('userId', 'firstName lastName');

    // posts = await Post.find({$or: [{privacy: 'public'}, {privacy: 'friends', userId: req.body.id}], _id: {$lt: req.body.postId}}).sort({_id: -1}).limit(10).populate('userId', 'firstName lastName');
    // posts = await Post.find({privacy: 'public', _id: {$lt: req.body.postId}}).sort({_id: -1}).limit(10).populate('userId', 'firstName lastName');
  }
  else {
    //get public post and friends post in descending order and limit to 10
    posts = await Post.find({$or: [{privacy: 'public'}, {privacy: 'friends', userId: {$in: user.friends}}, {privacy: 'friends', userId: req.body.userId} ]}).sort({createdAt: -1}).limit(10).populate('userId', 'firstName lastName');
    //posts = await Post.find({$or: [{privacy: 'public'}, {privacy: 'friends', userId: req.body.id}]}).sort({_id: -1}).limit(10).populate('userId', 'firstName lastName');
    // posts = await Post.find({privacy: 'public'}).sort({_id: -1}).limit(10).populate('userId', 'firstName lastName');
  }

  res.send(posts);
}

// get user posts
exports.getUserPosts = async function(req, res, next) {
  console.log(req.body.id);
  const posts = await Post.find({userId: req.body.id}).populate('userId', 'userId', 'firstName lastName');
  console.log(posts);
  res.send(posts);
}

// get user posts sorted by data in descending order and limit to 10 starting from postid provided
exports.getUserPostsLimited = async function(req, res, next) {
  console.log(req.body);
  
  var posts;
  if(req.body.next != ""){
    // get user posts sorted by data in descending order and limit to 10 starting from postid
    posts = await Post.find({userId: req.body.id, _id: {$lt: req.body.next}}).sort({_id: -1}).limit(10).populate('userId', 'firstName lastName');
  }
  else {
    posts = await Post.find({userId: req.body.id}).sort({_id: -1}).limit(10).populate('userId', 'firstName lastName');
  }

  res.send(posts);
}

// add post
exports.postAdd = async function(req, res, next) {
  
  var newPost = new Post({
    userId: req.body.userId,
    content: req.body.content,
    privacy: req.body.privacy
  });
  console.log(newPost);
  console.log("HERE SA POST ADD")

  //save and return post with userId replaced with username
  newPost.save(function(err) {
    if (!err) {
      newPost.populate('userId', 'firstName lastName', function(err, post) {
        res.send(post);
      });
    }
    else {
      res.send({err:'Unable to save post'});
      console.log(err);
    }
  });
}

//edit post
exports.postEdit = async function(req, res, next) {
  const post = await Post.findById(req.body.id);
  if(post){
    post.content = req.body.content;
    post.privacy = req.body.privacy;
    post.save(function(err) {
      if (!err) {
        post.populate('userId', 'firstName lastName', function(err, post) {
          res.send(post);
        });
      }
      else {
        res.send({err:'Unable to save post'});
        console.log(err);
      }
    });
  }
  else {
    res.send({err:'Post not found'});
  }
}

//delete post
exports.postDelete = async function(req, res, next) {
  const post = await Post.findByIdAndDelete(req.body._id);
  //error catch
  console.log('here')
  if(!post){
    res.send({err:'Post not found'});
  }
  else {
    res.send(post);
  }
}

// COMMMENTS

//create comment schema
const commentSchema = new Schema({
  userId: {type: Schema.Types.ObjectId, ref: 'user'},
  postId: {type: Schema.Types.ObjectId, ref: 'post'},
  comment: {type: String, required: true},
  //date of creation
},{autoCreate:true, timestamps: true});

const Comment = db.model('comment',commentSchema);

//add comment
exports.commentAdd = async function(req, res, next) {
  var newComment = new Comment({
    userId: req.body.userId,
    postId: req.body.postId,
    comment: req.body.comment
  });
  //save and return comment with userId replaced with username
  newComment.save(function(err) {
    if (!err) {
      newComment.populate('userId', 'firstName lastName', function(err, comment) {
        res.send(comment);
      });
    }
    else {
      res.send({err:'Unable to save comment'});
      console.log(err);
    }
  });
}

//get comments
exports.commentGet = async function(req, res, next) {
  const comments = await Comment.find({postId: req.body.postId}).populate('userId', 'firstName lastName');
  res.send(comments);
}

//delete comments
exports.commentDelete = async function(req, res, next) {
  console.log("HERE IN DELETE");
  const comment = await Comment.findByIdAndDelete(req.body.id);
  //error catch
  console.log(comment);
  if(!comment){
    res.send({err:'Comment not found'});
  }
  else {
    res.send(comment);
  }
}
const controller = require("./controller")

module.exports = (app) => {

  // Allow Cross Origin Resource Sharing
  app.use((req, res, next) => {
    res.setHeader('Access-Control-Allow-Origin', '*');
    res.setHeader('Access-Control-Allow-Credentials', 'true');
    res.setHeader('Access-Control-Allow-Methods', 'GET,HEAD,OPTIONS,POST,PUT,DELETE');
    res.setHeader('Access-Control-Allow-Headers', 'Access-Control-Allow-Headers, Origin,Accept, X-Requested-With, Content-Type, Access-Control-Request-Method, Access-Control-Request-Headers');
    next();
  })


  app.get("/", controller.homepage);

  app.post('/user/add', controller.userAdd);
  app.post('/user/login', controller.userLogin)
  app.get('/user/all', controller.getAllUsers);
  app.post('/user/search', controller.findUsers);
  app.post('/user/find', controller.findUserById);

  app.post('/user/update-pass', controller.updatePassword);
  app.post('/user/update', controller.updateUser);

  app.post('/user/send-friend-request', controller.sendFriendRequest);
  app.post('/user/remove-friend', controller.removeFriend);
  app.post('/user/accept-friend-request', controller.acceptFriendRequest);
  app.post('/user/reject-friend-request', controller.rejectFriendRequest);
  app.post('/user/get-friend-requests', controller.getFriendRequests);
  app.post('/user/get-friends', controller.getFriends);

  app.post('/post/add', controller.postAdd);
  app.get('/post/get-public-all', controller.getAllPublicPosts);
  app.post('/post/edit', controller.postEdit);
  app.delete('/post/delete', controller.postDelete);
  app.post('/post/get-user-posts', controller.getUserPosts);

  //limited queries
  app.post('/post/get-public-all-lim', controller.getAllPublicPostsLimited);
  app.post('/post/get-user-posts-lim', controller.getUserPostsLimited);

  //comments
  app.post('/comment/add', controller.commentAdd);
  app.delete('/comment/delete', controller.commentDelete);
  app.post('/comment/get', controller.commentGet);

}

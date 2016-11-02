// assets/javascrips/recourse.js

// Initiate angular app
angular
  .module("recourse", [
    "ui.router",
    "templates",
    "ngResource"
  ])

  // Congifure router function
  .config([
    "$stateProvider",
    RouterFunction
  ])

  // Declare factory for Token module
  .factory("TokenFactory", [
    "$resource",
    TokenFactoryFunction
  ])

  // Declare factory for Devise module
  .factory("DeviseFactory", [
    "$resource",
    DeviseFactoryFunction
  ])

  // Declare factory for Post module
  .factory("PostFactory", [
    "$resource",
    PostFactoryFunction
  ])

  // Declare factory for Favorites
  .factory("FavoriteFactory", [
    "$resource",
    FavoriteFactoryFunction
  ])

  // Declare main controller for Recourse App
  .controller("RecourseController", [
    "TokenFactory",
    "DeviseFactory",
    RecourseControllerFunction
  ])

  // Declare controller for Post index
  .controller("PostIndexController", [
    "PostFactory",
    "FavoriteFactory",
    PostIndexControllerFunction
  ])

  // Declare controller for Post show
  .controller("PostShowController", [
    "PostFactory",
    "$stateParams",
    "$state",
    PostShowControllerFunction
  ])



// User Factory Function
function TokenFactoryFunction($resource) {

  // Route to authentications controller for ngResource
  return $resource("/auth_user", {}, {
    signIn: {
      method: "POST"
    }
  })
}

// Devise Factory Function
function DeviseFactoryFunction($resource) {

  // Route to Devise controllers for ngResource
  return $resource("/users", {}, {
    signUp: {
      method: "POST",
      header: {
        "X-CSRF-Token": $('meta[name="csrf-token"]').attr('content')
      }
    }
  })
}

// Post Factory Function
function PostFactoryFunction($resource) {

  let authToken = ""
  if (localStorage.getItem('recourseUser')) {
    authToken = "Bearer " + JSON.parse(localStorage.getItem('recourseUser')).auth_token
  }

  // Route to API for ngResource
  return $resource("/api/posts/:id.json", {
    id: '@id'
  }, {
    create: {
      method: "POST",
      headers: { "Authorization": authToken }
    },
    update: {
      method: "PUT",
      headers: { "Authorization": authToken }
    }
  })
}

// Favorites Factory Function
function FavoriteFactoryFunction($resource) {

  let authToken = ""
  if (localStorage.getItem('recourseUser')) {
    authToken = "Bearer " + JSON.parse(localStorage.getItem('recourseUser')).auth_token
  }
  console.log(authToken);

  // Route to API for ngResource
  return $resource("/api/posts/:id/favorite.json", {
    id: '@id'
  }, {
    create: {
      method: "POST",
      headers: { "Authorization": authToken }
    },
    delete: {
      method: "DELETE",
      headers: { "Authorization": authToken }
    }
  })
}

// Recourse Main Controller Function
function RecourseControllerFunction(TokenFactory, DeviseFactory) {

  if (localStorage.getItem('recourseUser')) {
    this.currentUser = JSON.parse(localStorage.getItem('recourseUser')).user.email
  }

  // Sign Up method sends POST request to /users/sign_up (Devise)
  this.signUp = function(user) {
    console.log($('meta[name="csrf-token"]').attr('content'));
    let deviseUser = new DeviseFactory(user)
    console.log(deviseUser);
    deviseUser.$save().then( () => {
      this.signIn(user)
    })
  }

  // Sign In method sends POST request to /auth_user
  this.signIn = function(user) {
    let recourseUser = new TokenFactory({
      email: user.email,
      password: user.password
    })
    recourseUser.$save().then( () => {
      localStorage.setItem('recourseUser', JSON.stringify(recourseUser))
      this.currentUser = JSON.parse(localStorage.getItem('recourseUser')).user.email
    })
  }

  // Sign Up method removes JWT from localStorage
  this.signOut = function() {
    localStorage.removeItem('recourseUser')
    this.currentUser = ""
  }
}


// Index Post Controller Function
function PostIndexControllerFunction(PostFactory, FavoriteFactory) {

  // Update posts object against API
  this.posts = PostFactory.query()

  // Create method sends POST request to /api/posts
  this.create = function(post) {
    PostFactory.create({
      title: post.title,
      link: post.link
    }).$promise.then( () => {
      // After save, re-query the API (avoids page refresh)
      this.posts = PostFactory.query()
    })
  }

  // Add Favorite method sends POST request to /api/posts/:id/favorite
  this.add_favorite = function(post) {
    FavoriteFactory.create({
      id: post.id
    }).$promise.then( () => {
      this.posts = PostFactory.query()
    })
  }

  // Remove Favorite method sends DELETE request to /api/posts/:id/favorite
  this.remove_favorite = function(post) {
    FavoriteFactory.delete({
      id: post.id
    }).$promise.then( () => {
      this.posts = PostFactory.query()
    })
  }
}

// Show Post Controller
function PostShowControllerFunction(PostFactory, $stateParams, $state) {

  // Update post object against API
  this.post = PostFactory.get({ id: $stateParams.id })

  // Update method sends PUT request to /api/posts/:id
  this.update = function() {
    PostFactory.update({
      id: this.post.id,
      post: this.post
    }).$promise.then( () => {
      this.post = PostFactory.get({ id: $stateParams.id })
    })
  }

  this.delete = function() {
    this.post.$delete({id: $stateParams.id})
    $state.go("postIndex", {}, { reload: false })
  }
}



// Router Function
function RouterFunction($stateParams) {
  $stateParams
    .state("postIndex", {
      url: "/",
      templateUrl: "index.html",
      controller: "PostIndexController",
      controllerAs: "vm"
    })
    .state("postShow", {
      url: "/posts/:id",
      templateUrl: "show.html",
      controller: "PostShowController",
      controllerAs: "vm"
    })
}

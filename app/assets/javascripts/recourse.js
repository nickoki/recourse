// assets/javascrips/recourse.js

// Initiate angular app
angular
  .module("recourse", [
    "ui.router",
    "templates",
    "ngResource",
    "angularMoment"
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

  // Declare factory for Votes
  .factory("VoteFactory", [
    "$resource",
    VoteFactoryFunction
  ])

  // Declare main controller for Recourse App
  .controller("RecourseController", [
    "TokenFactory",
    "DeviseFactory",
    "$state",
    RecourseControllerFunction
  ])

  // Declare controller for Post index
  .controller("PostIndexController", [
    "PostFactory",
    "FavoriteFactory",
    "VoteFactory",
    PostIndexControllerFunction
  ])

  // Declare controller for Post show
  .controller("PostShowController", [
    "PostFactory",
    "FavoriteFactory",
    "VoteFactory",
    "$stateParams",
    "$state",
    PostShowControllerFunction
  ])

  // filter by current user's posts
  .filter('myPosts', function () {
    return function (posts, vm) {
      return posts.filter(function (post) {
        if (vm.filters.myPosts && vm.currentUser ) {
          return post.user_id == vm.currentUser.id
        } else {
          return true
        }
      });
    };
  })

  // filter by favorited posts
  .filter('myFavorites', function () {
    return function (posts, vm) {
      return posts.filter(function (post) {
        if (vm.filters.favorites) {
          return !!vm.check_favorites(post)
        } else {
          return true
        }
      });
    };
  });



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
    },
    delete: {
      method: "DELETE",
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

function VoteFactoryFunction($resource) {

  let authToken = ""
  if (localStorage.getItem('recourseUser')) {
    authToken = "Bearer " + JSON.parse(localStorage.getItem('recourseUser')).auth_token
  }

  // Route to API for ngResource
  return $resource("/api/posts/:id/vote.json", {
    id: '@id'
  }, {
    vote: {
      method: "POST",
      headers: { "Authorization": authToken }
    }
  })
}

// Recourse Main Controller Function
function RecourseControllerFunction(TokenFactory, DeviseFactory, $state) {

  // Set front-end currentUser
  if (localStorage.getItem('recourseUser')) {
    this.currentUser = JSON.parse(localStorage.getItem('recourseUser')).user
  }

  // Sign Up method sends POST request to /users/sign_up (Devise)
  this.signUp = function(user) {
    let deviseUser = new DeviseFactory(user)
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
      this.currentUser = JSON.parse(localStorage.getItem('recourseUser')).user
      // $state.go("postIndex", {}, { reload: true })
      location.reload() // jank af
    })
  }

  // Sign Up method removes JWT from localStorage
  this.signOut = function() {
    localStorage.removeItem('recourseUser')
    this.currentUser = ""
    location.reload()
  }
}


//  Post Index Controller Function
function PostIndexControllerFunction(PostFactory, FavoriteFactory, VoteFactory) {

  // Update posts object against API
  this.posts = PostFactory.query()

  this.filters = {
    favorites: false,
    myPosts: false
  }

  this.favoriteFilterFunction = function(post){
    if (this.filters.favorites) {
      return !!this.check_favorites(post)
    } else {
      return true
    }
  }

  this.myPostsFilterFunction = function(a, b, c, d) {
    if (vm.filters.myPosts && vm.currentUser ) {
      return post.user_id == vm.currentUser.id
    } else {
      return true
    }
  }

  // Set front-end currentUser
  if (localStorage.getItem('recourseUser')) {
    this.currentUser = JSON.parse(localStorage.getItem('recourseUser')).user
  }

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

  // Check favorites method checks if currentUser has favorited a post
  this.check_favorites = function(post) {
    return post.favorites.some( fav => {
      return this.currentUser ? fav.user_id == this.currentUser.id : false
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

  this.vote = function(post, type) {
    VoteFactory.vote({
      id: post.id,
      vote: {
        vote_type: type
      }
    }).$promise.then( () => {
      this.posts = PostFactory.query()
    })
  }


}

// Show Post Controller
function PostShowControllerFunction(PostFactory, FavoriteFactory, VoteFactory, $stateParams, $state) {

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

  // Delete method sends DELETE request to /api/posts/:id
  this.delete = function() {
    PostFactory.delete({
      id: this.post.id,
      post: this.post
    }).$promise.then( () => {
      $state.go("postIndex", {}, { reload: false })
    })
  }

  // Add Favorite method sends POST request to /api/posts/:id/favorite
  this.add_favorite = function() {
    FavoriteFactory.create({
      id: this.post.id
    }).$promise.then( () => {
      this.post = PostFactory.get({ id: $stateParams.id })
    })
  }

  // Remove Favorite method sends DELETE request to /api/posts/:id/favorite
  this.remove_favorite = function() {
    FavoriteFactory.delete({
      id: this.post.id
    }).$promise.then( () => {
      this.post = PostFactory.get({ id: $stateParams.id })
    })
  }

  this.vote = function(type) {
    VoteFactory.vote({
      id: this.post.id,
      vote: {
        vote_type: type
      }
    }).$promise.then( () => {
      this.post = PostFactory.get({ id: $stateParams.id })
    })
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

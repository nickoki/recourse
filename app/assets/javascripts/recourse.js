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

  // Declare factory for Post module
  .factory("PostFactory", [
    "$resource",
    PostFactoryFunction
  ])

  // Declare controller for Post index
  .controller("PostIndexController", [
    "PostFactory",
    PostIndexControllerFunction
  ])

  // Declare controller for Post show
  .controller("PostShowController", [
    "PostFactory",
    "$stateParams",
    "$state",
    PostShowControllerFunction
  ])



// Post Factory Function
function PostFactoryFunction($resource) {

  // Route to API for ngResource
  return $resource("/api/posts/:id.json", {}, {
    create: { method: "POST" },
    update: { method: "PUT" }
  })
}



// Index Post Controller Function
function PostIndexControllerFunction(PostFactory) {

  // Update posts object against API
  this.posts = PostFactory.query()

  // Create method sends POST request to /api/posts
  this.create = function(post) {
    var newPost = new PostFactory({
      title: post.title,
      link: post.link,
      user_id: 1 // hardcoded for now
    })
    newPost.$save().then( () => {
      // After save, re-query the API (avoids page refresh)
      this.posts = PostFactory.query()
    })
  }
}

// Show Post Controller Function
function PostShowControllerFunction(PostFactory, $stateParams, $state) {
  this.post = PostFactory.get({ id: $stateParams.id })
  this.update = function() {
    this.post.$update({id: $stateParams.id})
  }
  this.delete = function() {
    this.post.$delete({id: $stateParams.id})
    $state.go("postIndex", {}, {reload: false})
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

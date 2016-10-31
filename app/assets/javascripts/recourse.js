angular
  .module("recourse", [
    "ui.router",
    "templates",
    "ngResource"
  ])
  .config([
    "$stateProvider",
    RouterFunction
  ])
  .factory("PostFactory", [
    "$resource",
    PostFactoryFunction
  ])
  .controller("PostIndexController", [
    "PostFactory",
    PostIndexControllerFunction
  ])
  .controller("PostShowController", [
    "PostFactory",
    "$stateParams",
    PostShowControllerFunction
  ])

function PostFactoryFunction($resource) {
  return $resource("/api/posts/:id.json", {}, {
    update: { method: "PUT" }
  })
}

function PostIndexControllerFunction(PostFactory) {
  this.posts = PostFactory.query()
}

function PostShowControllerFunction(PostFactory,$stateParams) {
  this.post = PostFactory.get({ id: $stateParams.id })
}

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

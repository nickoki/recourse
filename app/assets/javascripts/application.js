// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require angular
//= require angular-rails-templates
//= require_tree ../templates
//= require_tree .
//= require bootstrap

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
  return $resource("http://localhost:3000/api/posts/:id.json", {}, {
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

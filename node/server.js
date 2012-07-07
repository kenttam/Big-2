var http = require("http");
var url = require("url");
var app = require('express');


function start(route, handle, deuces) {
  function onRequest(request, response) {
    var postData = "";
    var pathname = url.parse(request.url).pathname;
    console.log("Request for " + pathname + " received.");
    console.log(request);

    request.setEncoding("utf8");

    request.addListener("data", function(postDataChunk) {
      postData += postDataChunk;
      console.log("Received POST data chunk '"+
      postDataChunk + "'.");
    });

    request.addListener("end", function() {
      route(handle, pathname, response, postData, deuces);
      //console.log(request.session.user_id);
    });

    //request.session.user_id = "123";

  }

  app.createServer(onRequest).listen(8888);
  console.log("Server has started.");

}

exports.start = start;
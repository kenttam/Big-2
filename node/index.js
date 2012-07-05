var deuces = require("../deuces");
var server = require("./server");
var router = require("./router");
var requestHandlers = require("./requestHandlers");

var handle = {}
handle["/"] =  requestHandlers.start;
handle["/start"] = requestHandlers.start;
handle["/upload"] = requestHandlers.upload;
handle["/act"] = requestHandlers.act;
handle["/loadCards"] = requestHandlers.loadCards;
handle["/pass"] = requestHandlers.pass;
console.log(deuces);
server.start(router.route, handle, deuces);

import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

class AuthRouter {
  Handler get router {
    final route = Router();
//======== signup
    route.post('/signup', (Request req) {
      return Response(200,body: json.encode({"msg":"kjsf"}),headers: {"content-type":"application/json"});
    });
//======== login

    route.post('/login', (Request req) {
      return Response.ok('login');
    });

//======== reset password 
     route.post('/reset', (Request req) {
      return Response.ok('login');
    });

    final pipeline = Pipeline().addHandler(route);
    return pipeline;
  }
}

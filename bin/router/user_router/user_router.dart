import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

class UserRouter {
  Handler get router {
    final route = Router();
    route.get(
        '/home',
        (Request req) => Response(200,
            body: json.encode({"msg": "this is home page"}),
            headers: {"content-type": "application/json"}));
    route.get('/profile', (Request req) => Response.ok('profile'));
    route.get('/setting', (Request req) => Response.ok('setting'));

    final pipleLine = Pipeline()
        .addMiddleware((innerHandler) => (Request req) {
              print(req.url.path);
              if (req.url.path == 'profile') {
                return Response.forbidden('profile is forbidden');
              }
              return innerHandler(req);
            })
        .addHandler(route);
    return pipleLine;
  }
}

import 'dart:ffi';

import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import '../auth_router/auth_router.dart';
import '../user_router/user_router.dart';

class BaseRouter{
  Handler get router{
    final route = Router();
    route.mount('/auth', AuthRouter().router);
    route.mount('/user', UserRouter().router);
    final pipeline = Pipeline().addHandler(route);
    return pipeline;
  }
}
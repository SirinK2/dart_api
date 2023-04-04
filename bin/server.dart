import 'dart:convert';
import 'dart:io';

import 'package:content_length_validator/content_length_validator.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_helmet/shelf_helmet.dart';
import 'package:shelf_hotreload/shelf_hotreload.dart';
import 'package:shelf_rate_limiter/shelf_rate_limiter.dart';
import 'package:shelf_router/shelf_router.dart';

import 'router/base_router/base_router.dart';

void main(List<String> args) {
  withHotreload(
    () => createServer(),
    onReloaded: () => print('Reload!'),
    onHotReloadNotAvailable: () => print('No hot-reload :('),
    onHotReloadAvailable: () => print('Yay! Hot-reload :)'),
    onHotReloadLog: (log) => print('Reload Log: ${log.message}'),
    logLevel: Level.INFO,
  );
}

Future<HttpServer> createServer() async {
  final host = InternetAddress.anyIPv4;
  final port = int.parse(Platform.environment['port'] ?? '8080');

  final app = Router();
  app.mount('/', BaseRouter().router);
  app.all('/', (Request req) {
    return Response.ok('Api is running');
  });
  app.all('/<name|.*>', (Request req) {
    return Response.notFound('check your path url');
  });


  final memoryStorage = MemStorage();
  final rateLimiter = ShelfRateLimiter(
    storage: memoryStorage,
    duration: Duration(seconds: 60),
    maxRequests: 10,
  );

  final pipeline = Pipeline()
      .addMiddleware(helmet())
      .addMiddleware(logRequests())
      .addMiddleware(
        maxContentLengthValidator(
          maxContentLength: 500,
          errorResponse: Response(404, body: json.encode({"msg": "too big"}), headers: {"content-type": "application/json"})
        ),
      )
      .addMiddleware(rateLimiter.rateLimiter())
      .addMiddleware((innerHandler) => (Request req) {
            print(req.headersAll);
            print(req.method);
            print(req.url);
            // if(req.method=='POST'){
            //   return Response.forbidden('sorry you are try use post');
            // }
            return innerHandler(req);
          })
      .addHandler(app);

  final server = await serve(pipeline, host, port);
  print('server is running in http://${server.address.host}:${server.port}');
  return server;
}

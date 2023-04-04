import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:supabase/supabase.dart';
import '../../.env/const_file.dart';
import '../../service/supabase/auth/auth_supabase.dart';
import '../../service/supabase/database/supabase_database.dart';

class AuthRouter {
  Handler get router {
    final route = Router();

//======== signup

    route.post('/signup', (Request req) async {
      try {
        final body = json.decode(await req.readAsString());
        print(body);
        Map? user = await AuthSupabase.createAcount(
            email: body["email"], password: body["password"]);
        // if (user?["msg"] != null) {
        //   return Response(403,
        //       body: json.encode(user),
        //       headers: {"content-type": "application/json"});
        // }
        Map<String, dynamic> dataUser = {
          "name": body["name"],
          "id": user?["id"],
          "email": user?["email"]
        };
        await DatabaseSupabase.addNewUser(userMap: dataUser);
        return Response(202,
            body: json.encode(user),
            headers: {"content-type": "application/json"});
      } on AuthException catch (e) {
        throw FormatException(e.message);
      }
    });

//======= verfiy

    route.post('/verfiy/<token>', (Request req, String token) async {
      final body = json.decode(await req.readAsString());
      Map user =
          await AuthSupabase.verifyUser(email: body["email"], token: token);

      return Response(200,
          body: json.encode(user),
          headers: {"content-type": "application/json"});
    });

//======== login

    route.post('/login', (Request req) async {
      try {
        final body = json.decode(await req.readAsString());
        Map user = await AuthSupabase.loginUser(
            email: body["email"], password: body["password"]);
        return Response(200,
            body: json.encode(user),
            headers: {"content-type": "application/json"});
      } on FormatException catch (e) {
        return Response.forbidden(
          json.encode({"msg": e.message}),
          headers: {"content-type": "application/json"},
        );
      }
    });

//======== reset password

    route.post('/reset', (Request req) {
      return Response.ok('login');
    });

    final pipeline = Pipeline().addHandler(route);
    return pipeline;
  }
}

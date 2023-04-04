import 'package:supabase/supabase.dart';

import '../../../.env/const_file.dart';

class AuthSupabase {
  static final supabase = SupabaseClient(
    ConstFile.url,
    ConstFile.key,
  );

  static createAcount({required String email, required String password}) async {
    try {
      AuthResponse newUser =
          await supabase.auth.signUp(email: email, password: password);
      //  UserResponse newUser =
      // await supabase.auth.admin.createUser(AdminUserAttributes(email:email ,password:password ));
      Map<String, dynamic> customJson = {
        "id": newUser.user?.id,
        "email": newUser.user?.email,
        "last_sgin_in": newUser.user?.lastSignInAt,
      };

      return customJson;
    } on AuthException catch (e) {
      Map<String, dynamic> customJson = {
        "msg": e.message,
      };
      return customJson;
    }
  }

  static verifyUser({required String email, required String token}) async {
    AuthResponse newUser = await supabase.auth
        .verifyOTP(email: email, token: token, type: OtpType.signup);

    Map<String, dynamic> customJson = {
      "id": newUser.user?.id,
      "email": newUser.user?.email,
      "last_sgin_in": newUser.user?.lastSignInAt,
      "emailConfirmedAt": newUser.user?.emailConfirmedAt,
      "token": newUser.session?.accessToken
    };

    return customJson;
  }

  static loginUser({required String email, required String password}) async {
    try {
      AuthResponse newUser = await supabase.auth
          .signInWithPassword(email: email, password: password);
      Map<String, dynamic> customJson = {
        "id": newUser.user?.id,
        "email": newUser.user?.email,
        "last_sgin_in": newUser.user?.lastSignInAt,
        "token": newUser.session?.accessToken,
        "refreshToken": newUser.session?.refreshToken
      };

      return customJson;
    } on AuthException catch (e) {
      throw FormatException(e.message);
    }
  }
}

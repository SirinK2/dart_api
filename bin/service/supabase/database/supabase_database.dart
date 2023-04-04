import 'package:supabase/supabase.dart';

import '../../../.env/const_file.dart';

class DatabaseSupabase {
  static final supabase = SupabaseClient(
    ConstFile.url,
    ConstFile.key,
  );

  static addNewUser({required Map<String, dynamic> userMap}) async {
    try {
      await supabase.from("user").insert(userMap);
    } on PostgrestException catch (e) {
      throw FormatException(e.message);
    }
  }
}

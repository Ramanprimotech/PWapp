import 'package:http/http.dart' as http;
import '../../../pw_app.dart';

Future<bool> postUserId({String? apiUrl}) async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  try {
    final response = await http
        .post(
      Uri.parse('${Api.baseUrl}$apiUrl'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"user_id": sharedPreferences.getString("userID")}),
    )
        .timeout(const Duration(seconds: 10)); // Timeout after 10 seconds

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseBody = jsonDecode(response.body);
      if (responseBody["success"] == true) {
        debugPrint("Success: ${response.body}");
        return true;
      } else {
        debugPrint("Failed: ${response.body}");
        return false;
      }
    } else {
      debugPrint("Server Error: ${response.statusCode}, ${response.body}");
      return false;
    }
  } on SocketException {
    debugPrint("Network Error: No Internet Connection");
    return false;
  } on TimeoutException {
    debugPrint("Error: Request Timed Out");
    return false;
  } on FormatException {
    debugPrint("Error: Bad Response Format");
    return false;
  } catch (e) {
    debugPrint("Unexpected Error: $e");
    return false;
  }
}
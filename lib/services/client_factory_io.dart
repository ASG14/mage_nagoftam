import 'package:http/http.dart' as http;

http.Client createClientImpl() {
  return http.Client();
}

bool get isWebImpl => false;
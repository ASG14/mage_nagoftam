import 'client_factory_io.dart'
    if (dart.library.html) 'client_factory_web.dart';

import 'package:http/http.dart' as http;

http.Client createClient() {
  return createClientImpl();
}

bool get isWeb => isWebImpl;
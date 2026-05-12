import 'package:flutter_dotenv/flutter_dotenv.dart';

class Environment {

  static Future<void> initEnvironment () async{
    await dotenv.load(fileName: '.env');
  }

  static String baseUrl = dotenv.env['API_URL'] ?? "No hay url configurada";

}
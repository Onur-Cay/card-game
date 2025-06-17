class AppConfig {
  static const String ApiUrl = 'http://localhost:8000'; //Change these in prod
  static const String WsUrl = 'ws://localhost:8000/ws';

  static String get apiUrl => ApiUrl;

  static String get wsUrl => WsUrl;
}

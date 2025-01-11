class Env {
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://api.example.com/v1',
  );
  
  static const String imageBaseUrl = String.fromEnvironment(
    'IMAGE_BASE_URL',
    defaultValue: 'https://image.example.com',
  );

  static const String apiKey = String.fromEnvironment(
    'API_KEY',
    defaultValue: '',
  );
} 
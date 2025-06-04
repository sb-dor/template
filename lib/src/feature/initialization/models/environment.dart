import 'package:flutter/foundation.dart';

// is necessary if you are checking something for application (release) mode
enum Environment {
  dev._('DEV'),
  prod._('PROD');

  final String value;

  const Environment._(this.value);

  static Environment from(String? value) => switch (value) {
    "DEV" => Environment.dev,
    "PROD" => Environment.prod,
    _ => kReleaseMode ? Environment.prod : Environment.dev,
  };
}

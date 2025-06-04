### 📚 More on Flutter & Dart Architecture

If you're interested in learning more about Flutter and Dart architecture best practices, here are some valuable resources:

- [plugfox.dev](https://plugfox.dev/) – Articles and insights on scalable Flutter architecture and tooling  
- [hawkkiller on GitHub](https://github.com/hawkkiller) – Advanced Flutter projects and open-source libraries  
- [sizzle_starter](https://github.com/hawkkiller/sizzle_starter) – A solid starter template for clean Flutter architecture  
- [flutteris.com/blog](https://flutteris.com/blog) – Blog posts on practical Flutter development techniques  

These links offer great guidance on writing maintainable, scalable, and well-architected Flutter apps.



for running app in dev mode:

    flutter run --dart-define-from-file=env/dev.json

for running app in prod mode:

    flutter run --release --dart-define-from-file=env/prod.json


or you can add to your Android Studio or VS code this additional run args:

    --dart-define-from-file=env/prod.json


building releases:

Android Apk:

    flutter build apk --dart-define-from-file=env/prod.json

Android Bundle:

    flutter build appbundle --dart-define-from-file=env/prod.json

iOS:

    flutter build ios --dart-define-from-file=env/prod.json

iOS IPA:

    flutter build ipa --dart-define-from-file=env/prod.json

Windows:

    flutter build windows --dart-define-from-file=env/prod.json

Linux:

    flutter build linux --dart-define-from-file=env/prod.json

MacOS:

    flutter build macos --dart-define-from-file=env/prod.json
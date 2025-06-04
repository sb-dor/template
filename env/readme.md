for running app in dev mode:

    flutter run --dart-define-from-file=env/dev.json

for running app in prod mode:

    flutter run --dart-define-from-file=env/prod.json


or you can add to your Android Studio or VS code this additional run args:

    --dart-define-from-file=env/prod.json
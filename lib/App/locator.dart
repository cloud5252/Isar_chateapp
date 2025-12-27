import 'package:isar_chateapp/Services/Authentication.dart';
import 'package:isar_chateapp/Services/Isar_services/Isar_service.dart';
import 'package:stacked/stacked_annotations.dart';

@StackedApp(
  routes: [
    // MaterialRoute(page: SplashView, initial: true),
    // MaterialRoute(page: Intro4Page),
  ],
  dependencies: [
    LazySingleton(classType: Authentication),
    LazySingleton(classType: IsarService),
  ],
)
class AppSetup {}

import 'package:stacked/stacked_annotations.dart';

import '../Services/Authentication.dart';
import '../Services/Isar_services/Isar_service.dart';

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

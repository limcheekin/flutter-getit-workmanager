import 'package:get_it/get_it.dart';
import 'package:workmanager/workmanager.dart';

import 'simple_class.dart';

final getIt = GetIt.instance;

Future<void> init() async {
  getIt.registerLazySingleton<Simple>(() => Simple(10));
  _initWorkManager();
}

void _initWorkManager() async {
  await Workmanager.initialize(
    _callbackDispatcher,
    isInDebugMode: true,
  );

  await Workmanager.registerPeriodicTask(
    'simple', "getSimpleCounter",
    initialDelay: Duration(seconds: 10),
    frequency: Duration(
      minutes: 15,
    ), // minimum 15 mins
  );
}

void _callbackDispatcher() {
  Workmanager.executeTask((task, inputData) async {
    print('$task was executed. inputData = $inputData');
    try {
      print(getIt<Simple>().getCounter());
    } catch (e) {
      print(e);
    }
    return Future.value(true);
  });
}

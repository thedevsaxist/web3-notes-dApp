import 'package:get_it/get_it.dart';
import 'package:web3demo/app/provider/home_screen_provider.dart';

final sl = GetIt.instance;

void serviceLocator() {
  sl.registerLazySingleton<IHomeScreenProvider>(() => HomeScreenProvider());
}

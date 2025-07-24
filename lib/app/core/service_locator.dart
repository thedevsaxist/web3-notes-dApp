import 'package:get_it/get_it.dart';
import 'package:web3demo/app/provider/home_screen_provider.dart';
import 'package:web3demo/app/service/notes_service.dart';

final sl = GetIt.instance;

void serviceLocator() {
  sl.registerLazySingleton<IHomeScreenProvider>(() => HomeScreenProvider());
  sl.registerLazySingleton<INotesService>(() => NotesService());
}

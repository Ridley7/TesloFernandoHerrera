import 'package:shared_preferences/shared_preferences.dart';
import 'package:teslo/features/shared/infrastructure/services/key_value_storage_service.dart';

class KeyValueStorageServiceImplementation extends KeyValueStorageService{

  Future<SharedPreferences> getSharedPreferences() async{
    return await SharedPreferences.getInstance();
  }

  @override
  Future<T?> getValue<T>(String key) async {
    final SharedPreferences sharedPreferences = await getSharedPreferences();
    switch(T){
      case int:
        return sharedPreferences.getInt(key) as T;

      case String:
        return sharedPreferences.get(key) as T;

        default:
          throw UnimplementedError('GET not implemented for type ${ T.runtimeType }');
    }
  }

  @override
  Future<bool> removeKey(String key) async {
    final SharedPreferences sharedPreferences = await getSharedPreferences();
    return await sharedPreferences.remove(key);
  }

  @override
  Future<void> setKeyValue<T>(String key, T value) async {
    final SharedPreferences sharedPreferences = await getSharedPreferences();
    switch(T){
      case int:
        sharedPreferences.setInt(key, value as int);
        break;

      case String:
        sharedPreferences.setString(key, value as String);
        break;

      default:
        throw UnimplementedError('Set not implemented for type ${ T.runtimeType }');
    }
  }
  
}
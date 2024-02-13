//* ESTE SERVICIO RIGE TODAS LAS IMPLEMENTACIONES DEl package shared_preferences 
//* EN CASO DE QUE SE CAMBIE DE PAQUETE

abstract class KeyValueStorageService {

  Future<void> setKeyValue<T>(String key, T value);
  Future<T?> getValue<T>(String key);
  Future<bool> removeKey(String key);

}
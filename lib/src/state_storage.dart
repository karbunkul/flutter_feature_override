import 'dart:async';

abstract class StateStorage {
  FutureOr<bool?> read(String key);
  FutureOr<void> update(String key, bool value);
  FutureOr<void> remove(String key);
}

import 'package:dart_rest/dart_rest.dart';

class Cactus extends ManagedObject<_Cactus> implements _Cactus {}

class _Cactus {
  @primaryKey int id;

  @Column(unique: true)
  String name;
}
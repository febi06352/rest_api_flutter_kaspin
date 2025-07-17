import 'package:dchisel/dchisel.dart';

class Database {
  void config() {
    DChiselDB().configDB('postgre',
        host: '175.41.158.69',
        db: 'btix',
        port: 5432,
        username: 'postgres',
        password: '14091996Aa!');
  }
}

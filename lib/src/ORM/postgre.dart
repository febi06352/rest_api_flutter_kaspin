import 'package:dchisel/dchisel.dart';
import 'package:postgres/postgres.dart';

class Postgre {
  bool errorData = false;
  var errorMessage;

  Future<Response> getAll(PostgreSQLConnection connection, table) async {
    List<Map<String, dynamic>>? resultMap;
    var _data = <Map<String, dynamic>>[];

    await connection.mappedResultsQuery('SELECT * FROM $table').then((value1) {
      resultMap = value1;
    }).onError((error, stackTrace) {
      errorData = true;
      errorMessage = error.toString();
    });

    if (resultMap != null) {
      for (final row in resultMap!) {
        _data.add(encodeMap(row[table] ?? {'': ''}));
      }
    }

    // var _base = {
    //   'error': errorData,
    //   'data': _data,
    //   'message': errorMessage ?? 'Success'
    // };

    return errorData ? resForbidden(errorMessage) : resOk(_data);
  }

  Future<Response> getOption(PostgreSQLConnection connection, table,
      {column, where, like}) async {
    List<Map<String, dynamic>>? resultMap;
    var _data = <Map<String, dynamic>>[];
    var likes = like ? 'LIKE' : '=';
    print('SELECT $column FROM $table WHERE ${where[0]} $likes ${where[1]}');
    where != null
        ? await connection.mappedResultsQuery(
            'SELECT $column FROM $table WHERE ${where[0]} $likes @value',
            substitutionValues: {'value': where[1]}).then((value1) {
            resultMap = value1;
          }).onError((error, stackTrace) {
            errorData = true;
            errorMessage = error.toString();
            print(errorMessage);
          })
        : await connection
            .mappedResultsQuery('SELECT $column FROM $table')
            .then((value1) {
            resultMap = value1;
          }).onError((error, stackTrace) {
            errorData = true;
            errorMessage = error.toString();
          });

    if (resultMap != null) {
      for (final row in resultMap!) {
        _data.add(encodeMap(row[table] ?? {'': ''}));
      }
    }
    return errorData ? resForbidden(errorMessage) : resOk(_data);
  }

  Future<Response> create(PostgreSQLConnection connection, table,
      {required Map<String, dynamic>? data}) async {
    List<Map<String, dynamic>>? resultMap;
    var _data = <Map<String, dynamic>>[];
    var _dataMap = <String, dynamic>{};
    List keys = [];
    List keysData = [];

    data!.forEach((key, value) {
      var _key = key;
      keys.add(key);
      _key = key.replaceAll(key, '@$key');
      keysData.add(_key);
      _dataMap[_key] = value;
    });

    // print(
    //     'data sql : INSERT INTO $table (${keys.toString().replaceAll('[', '').replaceAll(']', '')}) VALUES (${keysData.toString().replaceAll('[', '').replaceAll(']', '')})');
    await connection
        .mappedResultsQuery(
            'INSERT INTO $table (${keys.toString().replaceAll('[', '').replaceAll(']', '')}) VALUES (${keysData.toString().replaceAll('[', '').replaceAll(']', '')})',
            substitutionValues: data)
        .then((value1) {
      resultMap = value1;
    }).onError((error, stackTrace) {
      print(error);
      errorData = true;
      errorMessage = error.toString();
    });

    if (resultMap != null) {
      for (final row in resultMap!) {
        _data.add(encodeMap(row[table] ?? {'': ''}));
      }
    }
    return errorData ? resForbidden(errorMessage) : resOk(_data);
  }

  Future<Response> deleteAll(PostgreSQLConnection connection, table) async {
    List<Map<String, dynamic>>? resultMap;
    var _data = <Map<String, dynamic>>[];

    await connection.mappedResultsQuery('DELETE FROM $table').then((value1) {
      resultMap = value1;
    }).onError((error, stackTrace) {
      errorData = true;
      errorMessage = error.toString();
    });

    if (resultMap != null) {
      for (final row in resultMap!) {
        _data.add(encodeMap(row[table] ?? {'': ''}));
      }
    }
    return errorData ? resForbidden(errorMessage) : resOk(_data);
  }

  Future<Response> deleteOption(PostgreSQLConnection connection, table,
      {required List? where}) async {
    List<Map<String, dynamic>>? resultMap;
    var _data = <Map<String, dynamic>>[];

    await connection.mappedResultsQuery(
        'DELETE FROM $table WHERE ${where![0]} = @value',
        substitutionValues: {'value': where[1]}).then((value1) {
      resultMap = value1;
    }).onError((error, stackTrace) {
      errorData = true;
      errorMessage = error.toString();
    });

    if (resultMap != null) {
      for (final row in resultMap!) {
        _data.add(encodeMap(row[table] ?? {'': ''}));
      }
    }
    return errorData ? resForbidden(errorMessage) : resOk(_data);
  }

  Future<Response> update(PostgreSQLConnection connection, table,
      {required Map<String, dynamic>? data, required List? where}) async {
    List<Map<String, dynamic>>? resultMap;
    var _data = <Map<String, dynamic>>[];
    var _dataMap = <String, dynamic>{};
    List keysData = [];

    data!.forEach((key, value) {
      var _key = key;
      var _value;
      if (value.runtimeType == String) {
        _value = '\'$value\'';
      } else {
        _value = value;
      }
      _key = key.replaceAll(key, '$key=$_value');
      _dataMap[_key] = value;
      keysData.add(_key);
    });

    var setData = keysData
        .toString()
        .replaceFirst('[', '')
        .substring(0, keysData.toString().length - 2);

    print('UPDATE $table SET $setData WHERE ${where![0]} = @value');

    await connection.mappedResultsQuery(
        'UPDATE $table SET $setData WHERE ${where[0]} = @value',
        substitutionValues: {'value': where[1]}).then((value1) {
      resultMap = value1;
    }).onError((error, stackTrace) {
      errorData = true;
      errorMessage = error.toString();
    });

    if (resultMap != null) {
      for (final row in resultMap!) {
        _data.add(encodeMap(row[table] ?? {'': ''}));
      }
    }
    return errorData ? resForbidden(errorMessage) : resOk(_data);
  }

  Future<Response> mappedQuery(PostgreSQLConnection connection,
      {required String query, Map<String, dynamic>? substitution}) async {
    List<Map<String, dynamic>>? resultMap;

    await connection
        .mappedResultsQuery(query, substitutionValues: substitution)
        .then((value1) {
      resultMap = value1;
    }).onError((error, stackTrace) {
      errorData = true;
      errorMessage = error.toString();
    });

    return errorData ? resForbidden(errorMessage) : resOk(resultMap);
  }
}

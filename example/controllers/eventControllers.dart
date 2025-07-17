import 'dart:convert';

import 'package:dchisel/dchisel.dart';
import 'package:dchisel/src/dchiselDB.dart';
import 'package:uuid/uuid.dart';

class EventsControllers {
  var connection = DChiselPgConnection();
  bool? errorData;
  String? errorMessage;

  Future<Response> getEvents(Request request) async {
    var events = await DChiselDB().getAll('events');
    return events;
  }

  Future<Response> insertEvents(Request request) async {
    var data = await request.body.asJson;
    var uuid = Uuid();
    var events = await DChiselDB().create('events', data: {
      'uuid': uuid.v4(),
      'event_name': data['event_name'],
      'description': data['description'],
      'organizer': data['organizer'],
      'location_adress': data['location_address'],
      'latitude': data['latitude'],
      'longitude': data['longitude'],
      'date_time_start': data['date_time_start'],
      'date_time_end': data['date_time_end'],
    });
    return events;
  }

  Future<Response> updateEvents(Request request, String uuid) async {
    var data = await request.body.asJson;
    var events =
        await DChiselDB().update('events', data: data, where: ['uuid', uuid]);
    return events;
  }

  Future<Response> getEvent(Request request, String uuid) async {
    var data = await DChiselDB().mappedQuery(
        query: 'SELECT * FROM events WHERE uuid = @value',
        substitution: {'value': uuid});
    return data;
  }
}

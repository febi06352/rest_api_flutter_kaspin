import 'package:dchisel/dchisel.dart';

import '../controllers/eventControllers.dart';
import '../controllers/usersControllers.dart';

class EventsRoutes {
  DRoute route(prefix, droute) {
    droute.get('/', (Request req) async => EventsControllers().getEvents(req),
        prefix: prefix);

    droute.post('/add',
        (Request request) async => EventsControllers().insertEvents(request),
        prefix: prefix);

    droute.put(
        '/update/<uuid>',
        (Request request, String uuid) async =>
            EventsControllers().updateEvents(request, uuid),
        prefix: prefix);

    droute.get(
        '/get/<uuid>',
        (Request request, String uuid) async =>
            EventsControllers().getEvent(request, uuid),
        prefix: prefix);

    return droute;
  }
}

var events = EventsRoutes();

import 'dart:developer';
import 'dart:io';

import "package:googleapis_auth/auth_io.dart";
import 'package:googleapis/calendar/v3.dart';
import 'package:url_launcher/url_launcher.dart';

class CalendarClient {
  static const _scopes = const [CalendarApi.CalendarScope];

  ///NOTE:
  ///all the details in the event here are passed statically.

  insert(title, startTime, endTime) {
    var _clientID /* = new ClientId("878169543212-ugngo0bm18hu3lh83nk76bidts9c4q2r.apps.googleusercontent.com", "")*/;
    if (Platform.isAndroid) {
      _clientID = new ClientId("878169543212-ugngo0bm18hu3lh83nk76bidts9c4q2r.apps.googleusercontent.com", "");
    } else if (Platform.isIOS) {
      _clientID = new ClientId("126777344627-ibdaobtrs4n62a0l7h19fs04h73pbqqf.apps.googleusercontent.com", "");
    }

    clientViaUserConsent(_clientID, _scopes, prompt).then((AuthClient client) {
      var calendar = CalendarApi(client);
      calendar.calendarList.list().then((value) => print("VAL________$value"));

      String calendarId = "primary";
      String eventId = 'helle';
      Event event = Event(); // Create object of event

      event.summary = title; // adding summary of event

      // creating objects of event attendees
      var eventAttendee = EventAttendee();
      var eventAttendee1 = EventAttendee();
      var eventAttendee2 = EventAttendee();

      eventAttendee1.displayName = 'Alan';
      eventAttendee1.email = 'alan@gmail.com';

      eventAttendee2.displayName = 'Alex';
      eventAttendee2.email = 'alex@gmail.com';

      eventAttendee.displayName = 'Jay Shah';
      eventAttendee.email = 'jshah200498@gmail.com';

// Adding the start date and end date of the event
      EventDateTime start = new EventDateTime();
      start.dateTime = startTime;
      start.timeZone = "GMT+05:00";
      // event.id = eventId;
      event.attendees = [eventAttendee, eventAttendee1, eventAttendee2];
      event.start = start;

      EventDateTime end = new EventDateTime();
      end.timeZone = "GMT+05:00";
      end.dateTime = endTime;
      event.end = end;
      try {
        calendar.events.insert(event, calendarId).then((value) {
          print("ADDEDDD_________________${value.status}");
          if (value.status == "confirmed") {
            log('Event added in google calendar');
          } else {
            log("Unable to add event in google calendar");
          }
        });
      } catch (e) {
        log('Error creating event $e');
      }

      ///below code is for updating the event info
      // try {
      //   calendar.events.update(event, calendarId, eventId).then((value) {
      //     print("ADDEDDD_________________${value.status}");
      //     if (value.status == "confirmed") {
      //       log('Event added in google calendar');
      //     } else {
      //       log("Unable to add event in google calendar");
      //     }
      //   });
      // } catch (e) {
      //   log('Error creating event $e');
      // }
    });
  }

  void prompt(String url) async {
    print("Please go to the following URL and grant access:");
    print("  => $url");
    print("");

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}

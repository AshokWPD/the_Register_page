import 'package:flutter/cupertino.dart';
import 'package:lerereeeen/profile/mob_profile.dart';
import 'home_containers/addstu/addstu.dart';
import 'login/mob_log.dart';

Map<String, WidgetBuilder> routes = {
  moblog.routeName: (context) => const moblog(),
  mobprof.routeName: (context) => const mobprof(),
  addstu.routename: (context) => const addstu(),
};
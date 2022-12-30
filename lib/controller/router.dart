import 'package:docs/pages/document_screen.dart';
import 'package:docs/pages/home_page.dart';
import 'package:docs/pages/login.dart';
import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';

final loggedOutRoute = RouteMap(
  routes: {
    '/': (route) => const MaterialPage(
          child: LoginScreen(),
        ),
  },
);

final loggedInRoute = RouteMap(
  routes: {
    '/': (route) => MaterialPage(
          child: HomePage(),
        ),
    '/document/:id': (route) => MaterialPage(
          child: DocumentPage(
            id: route.pathParameters['id'] ?? '',
          ),
        )
  },
);

import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:project_emp/presentation/views/app_scaffold.dart';
import 'package:project_emp/presentation/views/auth/login/login_screen.dart';
import 'package:project_emp/presentation/views/auth/signup/signup_screen.dart';
import 'package:project_emp/presentation/views/home/home.dart';
import 'package:project_emp/presentation/views/search/search.dart';
import 'package:project_emp/presentation/views/settings/settings.dart';
import 'package:project_emp/presentation/views/theme/theme_page.dart';
import 'package:project_emp/presentation/views/employee/add_employee.dart';
import 'package:project_emp/presentation/views/trash.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen(
      (dynamic _) => notifyListeners(),
    );
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

class AppRouter {
  AppRouter._();
  static final instance = AppRouter._();
  final _auth = FirebaseAuth.instance;

  late final router = GoRouter(
    refreshListenable: GoRouterRefreshStream(_auth.authStateChanges()),
    initialLocation: '/',
    redirectLimit: 10,
    redirect: (BuildContext context, GoRouterState state) {
      // final loggedIn = _auth.currentUser != null;
      // final goingToLogin = state.matchedLocation.startsWith('/login ');
      // final goingToWelcome = state.matchedLocation.startsWith('/welcome');

      // if (!loggedIn && !goingToLogin && !goingToWelcome) {
      //   return '/welcome?from=${state.matchedLocation}';
      // }
      // if (loggedIn && (goingToLogin || goingToWelcome)) return '/';
      // return null;
      final loggedIn = _auth.currentUser != null;
      final goingToLogin = state.matchedLocation.startsWith('/login');
      final goingToSignup = state.matchedLocation.startsWith('/signup');
      final goingToWelcome = state.matchedLocation.startsWith('/welcome');

      if (!loggedIn && !goingToLogin && !goingToSignup && !goingToWelcome) {
        return '/login?from=${Uri.encodeComponent(state.matchedLocation)}';
      }

      if (loggedIn && (goingToLogin || goingToSignup || goingToWelcome)) {
        return '/';
      }

      return null;
    },
    navigatorKey: _rootNavigatorKey,
    routes: [
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (BuildContext context, GoRouterState state, Widget child) {
          return AppScaffold(
            currentPath: state.uri.path,
            body: child,
            mobileNavs: 3,
          );
        },
        routes: [
          GoRoute(
            parentNavigatorKey: _shellNavigatorKey,
            path: '/',
            builder: (BuildContext context, GoRouterState state) {
              return Home();
            },
          ),
          GoRoute(
            parentNavigatorKey: _shellNavigatorKey,
            path: '/search',
            builder: (BuildContext context, GoRouterState state) {
              return SearchPage();
            },
          ),
          GoRoute(
            parentNavigatorKey: _shellNavigatorKey,
            path: '/add',
            builder: (BuildContext context, GoRouterState state) {
              return AddEmployee();
            },
          ),

          GoRoute(
            parentNavigatorKey: _shellNavigatorKey,
            path: '/theme',
            builder: (BuildContext context, GoRouterState state) {
              return ThemeSelectorPage();
            },
          ),
          GoRoute(
            parentNavigatorKey: _shellNavigatorKey,
            path: '/trash',
            builder: (BuildContext context, GoRouterState state) {
              return DeletedEmployeePage();
            },
          ),
          GoRoute(
            parentNavigatorKey: _shellNavigatorKey,
            path: '/settings',
            pageBuilder: (BuildContext context, GoRouterState state) {
              return CustomTransitionPage(
                key: state.pageKey,
                child: Settings(),
                transitionsBuilder: (
                  context,
                  animation,
                  secondaryAnimation,
                  child,
                ) {
                  const begin = Offset(1.0, 0.0); // Slide in from right
                  const end = Offset.zero;
                  const reverseBegin = Offset.zero;
                  const reverseEnd = Offset(-1.0, 0.0); // Slide out to left
                  const curve = Curves.easeInOut;

                  var tween = Tween(
                    begin: begin,
                    end: end,
                  ).chain(CurveTween(curve: curve));
                  var reverseTween = Tween(
                    begin: reverseBegin,
                    end: reverseEnd,
                  ).chain(CurveTween(curve: curve));

                  var offsetAnimation = animation.drive(tween);
                  var reverseOffsetAnimation = secondaryAnimation.drive(
                    reverseTween,
                  );

                  return SlideTransition(
                    position: offsetAnimation,
                    child: SlideTransition(
                      position: reverseOffsetAnimation,
                      child: child,
                    ),
                  );
                },
              );
            },
          ),

          GoRoute(
            parentNavigatorKey: _shellNavigatorKey,
            path: '/settings',
            builder: (BuildContext context, GoRouterState state) {
              return Settings();
            },
          ),
        ],
      ),

      // Signup
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/signup',
        name: 'signup',
        builder: (BuildContext context, GoRouterState state) {
          return SignUpScreen();
        },
      ),

      // Auth
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/login',
        builder: (BuildContext context, GoRouterState state) {
          return LoginScreen();
        },
      ),
    ],
  );
}

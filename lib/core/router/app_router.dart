import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:project_emp/presentation/views/app_scaffold.dart';
import 'package:project_emp/presentation/views/auth/login/login_screen.dart';
import 'package:project_emp/presentation/views/auth/signup/signup_screen.dart';
import 'package:project_emp/presentation/views/history/history.dart';
import 'package:project_emp/presentation/views/home/home.dart';
import 'package:project_emp/presentation/views/search/search.dart';
import 'package:project_emp/presentation/views/settings/settings.dart';
import 'package:project_emp/presentation/views/theme/theme_page.dart';
import 'package:project_emp/presentation/views/employee/add_employee.dart';
import 'package:project_emp/presentation/views/trash.dart';
import 'package:project_emp/presentation/views/welcome/welcome_screen.dart'; 

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
      final goingToLogin = state.matchedLocation.startsWith(
        '/login',
      ); // Fixed space issue
      final goingToSignup = state.matchedLocation.startsWith(
        '/signup',
      ); // Added signup check
      final goingToWelcome = state.matchedLocation.startsWith('/welcome');

      if (!loggedIn && !goingToLogin && !goingToSignup && !goingToWelcome) {
        return '/welcome?from=${Uri.encodeComponent(state.matchedLocation)}';
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
            // selectedIndex: index == -1 ? 0 s: index,
            currentPath: state.uri.path,
            body: child,
            mobileNavs: 3,
            // navList: navList,
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
              return AddTodo();
            },
          ),

          GoRoute(
            parentNavigatorKey: _shellNavigatorKey,
            path: '/history',
            builder: (BuildContext context, GoRouterState state) {
              return HistoryPage();
            },
          ),
          GoRoute(
            parentNavigatorKey: _shellNavigatorKey,
            path: '/trash',
            builder: (BuildContext context, GoRouterState state) {
              return TrashPage();
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
            path: '/settings',
            pageBuilder: (BuildContext context, GoRouterState state) {
              return CustomTransitionPage(
                key: state.pageKey,
                child: Settings(), // Your Settings screen
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

          // GoRoute(
          //   parentNavigatorKey: _shellNavigatorKey,
          //   path: '/settings',
          //   pageBuilder: (BuildContext context, GoRouterState state) {
          //     return CustomTransitionPage(
          //       key: state.pageKey,
          //       child: Settings(), // Your Settings screen
          //       transitionsBuilder: (
          //         context,
          //         animation,
          //         secondaryAnimation,
          //         child,
          //       ) {
          //         const begin = Offset(1.0, 0.0); // Slide in from the right
          //         const end = Offset.zero;
          //         const curve = Curves.easeInOut;

          //         var tween = Tween(
          //           begin: begin,
          //           end: end,
          //         ).chain(CurveTween(curve: curve));
          //         var offsetAnimation = animation.drive(tween);

          //         return SlideTransition(
          //           position: offsetAnimation,
          //           child: child,
          //         );
          //       },
          //     );
          //   },
          // ),
          GoRoute(
            parentNavigatorKey: _shellNavigatorKey,
            path: '/settings',
            builder: (BuildContext context, GoRouterState state) {
              return Settings();
            },
          ),
        ],
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/history',
        builder: (BuildContext context, GoRouterState state) {
          return HistoryPage();
        },
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
      // welcome
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/welcome',
        name: 'welcome',
        builder: (BuildContext context, GoRouterState state) {
          return WelcomeScreen();
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

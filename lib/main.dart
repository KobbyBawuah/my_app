import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_app/dashboard.dart';
import 'profile.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'my_widget.dart';

Future<void> main() async {
  await SentryFlutter.init(
    (options) {
      options.dsn = 'XXX';
      // Set tracesSampleRate to 1.0 to capture 100% of transactions for performance monitoring.
      // We recommend adjusting this value in production.
      options.tracesSampleRate = 1.0;
      options.profilesSampleRate = 1;
      options.autoAppStart = true;
      options.enableAutoSessionTracking = true;
      options.enableAutoPerformanceTracing = true;
      options.enableAppLifecycleBreadcrumbs = true;
      options.enableAutoNativeBreadcrumbs = true;
      options.enableBrightnessChangeBreadcrumbs = true;
      options.enableNativeCrashHandling = true;
      options.enableWatchdogTerminationTracking = true;
      options.enablePrintBreadcrumbs = true;
      options.attachStacktrace = true;
      options.enableTracing = true;
      options.debug = true;
    },
    appRunner: () => runApp(MyApp()),
  );
}

// void main() {
//   runApp( MyApp());
// }

class MyApp extends StatelessWidget {
  MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Go router Demo',
      routerConfig: _router,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
    );
  }
  final GoRouter _router = GoRouter(
    observers: [SentryNavigatorObserver()], // Add SentryNavigatorObserver here
    initialLocation: '/',
    routes: <RouteBase>[
      GoRoute(
        path: "/",
        name: 'home',
        builder: ((context, state) => const Dashboard()),
      ),
      GoRoute(
        path: "/profile",
        builder: ((context, state) => const Profile()),
      ),
      GoRoute(
        path: '/widget',
        name: 'widget',
        pageBuilder: (context, state) => const NoTransitionPage(
              child: MyWidget(),
              name: 'widgetPage',
              ),
              ),
  ]);
}



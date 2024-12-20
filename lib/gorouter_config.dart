import 'package:farmers_journal/presentation/components/update_journal.dart';
import 'package:farmers_journal/presentation/pages/page_create_journal.dart';
import 'package:go_router/go_router.dart';
import 'package:farmers_journal/presentation/pages/page_initial_setting.dart';
import 'package:farmers_journal/presentation/pages/page_main.dart';
import 'package:farmers_journal/presentation/pages/page_settings.dart';
import 'package:farmers_journal/presentation/pages/page_statistics.dart';

final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const PageInitialSetting(),
    ),
    GoRoute(
        path: '/create',
        builder: (context, state) => const PageCreateJournal(id: null)),
    GoRoute(
        path: '/update/:id',
        builder: (context, state) =>
            PageCreateJournal(id: state.pathParameters['id'])),
    GoRoute(
        path: '/main',
        builder: (context, state) => const PageMain(),
        routes: [
          GoRoute(
            path: '/statistics',
            builder: (context, state) => const PageStatistics(),
          ),
          GoRoute(
            path: '/settings',
            builder: (context, state) => const PageSettings(),
          ),
        ]),
  ],
);

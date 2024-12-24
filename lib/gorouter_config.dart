import 'package:farmers_journal/presentation/pages/page_journal/page_create_journal.dart';
import 'package:farmers_journal/presentation/pages/page_settings/page_place.dart';
import 'package:farmers_journal/presentation/pages/page_settings/page_plant.dart';
import 'package:go_router/go_router.dart';
import 'package:farmers_journal/presentation/pages/page_initial_setting/page_initial_setting.dart';
import 'package:farmers_journal/presentation/pages/page_main.dart';
import 'package:farmers_journal/presentation/pages/page_settings/page_settings.dart';
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
              path: '/settings',
              builder: (context, state) => const PageSettings(),
              routes: [
                GoRoute(
                  path: '/plant',
                  builder: (context, state) => const PagePlant(),
                ),
                GoRoute(
                  path: '/place',
                  builder: (context, state) => const PagePlace(),
                )
              ]),
        ]),
    GoRoute(
      path: '/statistics',
      builder: (context, state) => const PageStatistics(),
    ),
  ],
);

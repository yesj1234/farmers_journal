import 'package:farmers_journal/presentation/pages/page_account.dart';
import 'package:farmers_journal/presentation/pages/page_journal/page_create_journal.dart';
import 'package:farmers_journal/presentation/pages/page_login/auth_bridge.dart';

import 'package:farmers_journal/presentation/pages/page_login/page_signup.dart';

import 'package:farmers_journal/presentation/pages/page_settings/page_place.dart';
import 'package:farmers_journal/presentation/pages/page_settings/page_plant.dart';
import 'package:farmers_journal/presentation/pages/page_settings/page_profile.dart';
import 'package:farmers_journal/presentation/pages/page_settings/place_search.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:farmers_journal/presentation/pages/page_initial_setting/page_initial_setting.dart';
import 'package:farmers_journal/presentation/pages/page_main.dart';
import 'package:farmers_journal/presentation/pages/page_settings/page_settings.dart';
import 'package:farmers_journal/presentation/pages/page_statistics/page_statistics.dart';

final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const AuthBridge(),
      routes: [
        GoRoute(
          path: '/registration',
          builder: (context, state) => const PageSignup(),
        ),
        GoRoute(
          path: '/initialSetting',
          builder: (context, state) => const PageInitialSetting2(),
        ),
      ],
    ),
    GoRoute(
      path: '/create',
      builder: (context, state) => const PageCreateJournal(id: null),
    ),
    GoRoute(
      path: '/update/:id',
      builder: (context, state) =>
          PageCreateJournal(id: state.pathParameters['id']),
    ),
    GoRoute(
        path: '/main',
        builder: (context, state) => const PageMain(),
        routes: [
          GoRoute(
              path: '/settings',
              builder: (context, state) => const PageProfile(),
              routes: [
                GoRoute(
                    path: '/account',
                    builder: (context, state) => const PageAccount()),
                GoRoute(
                  path: '/edit_profile',
                  builder: (context, state) => const PageEditProfile(),
                ),
                GoRoute(
                  path: '/plant',
                  builder: (context, state) => const PagePlant(),
                ),
                GoRoute(
                  path: '/place',
                  builder: (context, state) =>
                      const PageTemp(actionText: '저장', actionIcon: Icons.save),
                )
              ]),
          GoRoute(
            path: '/statistics',
            builder: (context, state) => const PageStatistics(),
          ),
        ]),
  ],
);

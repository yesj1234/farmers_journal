import 'package:farmers_journal/presentation/pages/page_login/page_reset_password.dart';
import 'package:farmers_journal/presentation/pages/page_profile/page_setting/page_settings.dart';
import 'package:farmers_journal/presentation/pages/page_journal/page_create_journal.dart';
import 'package:farmers_journal/presentation/pages/page_login/auth_bridge.dart';
import 'package:farmers_journal/presentation/pages/page_login/page_signup.dart';
import 'package:farmers_journal/presentation/pages/page_profile/page_plant.dart';
import 'package:farmers_journal/presentation/pages/page_profile/page_edit_profile.dart'; //
import 'package:farmers_journal/presentation/pages/page_profile/place_search.dart';
import 'package:farmers_journal/presentation/pages/page_profile/page_setting/page_terms_and_policy.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:farmers_journal/presentation/pages/page_initial_setting/page_initial_setting.dart'
    hide PageInitialSetting2;
import 'package:farmers_journal/presentation/pages/page_initial_setting/page_initial_setting2.dart';
import 'package:farmers_journal/presentation/pages/page_main/page_main.dart';
import 'package:farmers_journal/presentation/pages/page_profile/page_profile.dart'; //
import 'package:farmers_journal/presentation/pages/page_statistics/page_statistics.dart';

final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const AuthBridge(),
      routes: [
        GoRoute(
          path: '/reset_password',
          builder: (context, state) => const PageResetPassword(),
        ),
        GoRoute(
          path: '/registration',
          builder: (context, state) => const PageSignup(),
        ),
        GoRoute(
          path: '/initial_setting',
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
            path: '/profile',
            builder: (context, state) => const PageProfile(),
            routes: [
              GoRoute(
                  path: '/setting',
                  builder: (context, state) => const PageSettings(),
                  routes: [
                    GoRoute(
                      path: '/terms_and_policy',
                      builder: (context, state) => const PageTermsAndPolicy(),
                    ),
                  ]),
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
                builder: (context, state) => const PagePlaceSearch(
                    actionText: '저장', actionIcon: Icons.save),
              )
            ]),
        GoRoute(
          path: '/statistics',
          builder: (context, state) => const PageStatistics(),
        ),
      ],
    ),
  ],
);

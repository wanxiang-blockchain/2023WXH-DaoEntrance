import 'package:auto_route/auto_route.dart';
import 'package:dtim/infra/pages/integrate/integrate.dart';
import 'package:dtim/infra/pages/org/create_org.dart';
import 'package:dtim/infra/pages/work/gov.dart';
import 'package:flutter/material.dart';

import 'package:dtim/infra/pages/chain/import_sr25519_key.dart';
import 'package:dtim/infra/pages/chain/sr25519_key.dart';
import 'package:dtim/infra/pages/main_pc.dart';
import 'package:dtim/infra/pages/select_org.dart';
import 'package:dtim/application/store/app/app.dart';
import 'package:dtim/infra/pages/work/work.dart';
import 'package:dtim/infra/pages/org/org.dart';
import 'package:dtim/infra/pages/preloader.dart';

part 'router.gr.dart';
const List<String> pcpages = ["im", "dao", "integrate"];
@AutoRouterConfig(replaceInRouteName: 'Screen,Route')
class AppRouter extends _$AppRouter implements AutoRouteGuard {
  AppCubit authService;

  AppRouter(this.authService);

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) async {
    if (authService.state.me != null ||
        resolver.routeName == Preloader.name ||
        resolver.routeName == Sr25519key.name ||
        resolver.routeName == SelectOrg.name ||
        resolver.routeName == ImportSr25519key.name) {
      resolver.next();
    } else {
      resolver.redirect(
        Preloader(onResult: (didLogin) {
          resolver.resolveNext(didLogin, reevaluateNext: false);
        }),
      );
    }
  }

  @override
  List<AutoRoute> get routes {
    return [
      AutoRoute(path: '/', page: Preloader.page),
      AutoRoute(path: '/pc/:t', page: Pc.page, children: [
        AutoRoute(path: 'im', page: OrgRoute.page),
        AutoRoute(path: 'gov', page: GovRoute.page, maintainState: false),
        AutoRoute(path: 'work', page: DaoRoute.page, maintainState: false),
        AutoRoute(path: 'integrate', page: IntegrateRoute.page, maintainState: false),
      ]),
      AutoRoute(path: '/sr25519key', page: Sr25519key.page),
      AutoRoute(path: '/importSr25519key', page: ImportSr25519key.page),
      AutoRoute(path: '/select_org', page: SelectOrg.page),
      AutoRoute(path: '/create_org', page: CreateOrg.page),
    ];
  }
}

// routers() {
//   return <GoRoute>[
//     GoRoute(
//       path: '/',
//       builder: (BuildContext context, GoRouterState state) {
//         return const PreloaderPage();
//       },
//     ),
//     GoRoute(
//       path: '/mobile',
//       builder: (BuildContext context, GoRouterState state) {
//         return const MobilePage();
//       },
//     ),
//     GoRoute(
//       path: '/pc/:app',
//       builder: (BuildContext context, GoRouterState state) {
//         return const PCPage();
//       },
//     ),
//     GoRoute(
//       path: '/sr25519key',
//       builder: (BuildContext context, GoRouterState state) {
//         return const Sr25519KeyPage();
//       },
//     ),
//     GoRoute(
//       path: '/importSr25519key',
//       builder: (BuildContext context, GoRouterState state) {
//         return const ImportSr25519KeyPage();
//       },
//     ),
//     GoRoute(
//       path: '/select_org',
//       builder: (BuildContext context, GoRouterState state) {
//         final auto = state.queryParams["auto"];
//         return SelectOrgPage(auto: auto ?? "");
//       },
//     ),
//     GoRoute(
//       path: '/search',
//       builder: (BuildContext context, GoRouterState state) {
//         return const SearchPage();
//       },
//     ),
//     GoRoute(
//       path: '/create_channel',
//       builder: (BuildContext context, GoRouterState state) {
//         return const CreateChannelPage();
//       },
//     ),
//     GoRoute(
//       path: '/create_private',
//       builder: (BuildContext context, GoRouterState state) {
//         return const CreatePrivatePage();
//       },
//     ),
//     GoRoute(
//       path: '/channel_setting/:id/:t',
//       builder: (BuildContext context, GoRouterState state) {
//         return ChannelSettingPage(
//           id: state.params['id'] ?? "",
//           t: state.params['t'] ?? "",
//         );
//       },
//     ),
//     GoRoute(
//       path: '/invitation/:id',
//       builder: (BuildContext context, GoRouterState state) {
//         return InvitationPage(id: state.params['id'] ?? "");
//       },
//     ),
//     GoRoute(
//       path: '/setting',
//       builder: (BuildContext context, GoRouterState state) {
//         return const SettingPage();
//       },
//     ),
//     GoRoute(
//       path: '/create_roadmap',
//       builder: (BuildContext context, GoRouterState state) {
//         return const CreateRoadMapPage();
//       },
//     ),
//     GoRoute(
//       path: '/join_dao',
//       builder: (BuildContext context, GoRouterState state) {
//         return const JoinWorkPage();
//       },
//     ),
//     GoRoute(
//       path: '/create_dao_project',
//       builder: (BuildContext context, GoRouterState state) {
//         return const CreateProjectPage();
//       },
//     ),
//     GoRoute(
//       path: '/referendum_vote/:id',
//       builder: (BuildContext context, GoRouterState state) {
//         return ReferendumVotePage(id: state.params['id'] ?? "");
//       },
//     ),
//     GoRoute(
//       path: '/create_task/:project_id',
//       builder: (BuildContext context, GoRouterState state) {
//         return CreateTaskPage(projectId: state.params['project_id'] ?? "");
//       },
//     ),
//     GoRoute(
//       path: '/join_task/:project_id/:id',
//       builder: (BuildContext context, GoRouterState state) {
//         return JoinTaskPage(id: state.params['id'] ?? "", projectId: state.params['project_id'] ?? "");
//       },
//     ),
//     GoRoute(
//       path: '/task_info/:project_id/:id',
//       builder: (BuildContext context, GoRouterState state) {
//         return TaskInfoPage(id: state.params['id'] ?? "", projectId: state.params['project_id'] ?? "");
//       },
//     ),
//     GoRoute(
//       path: '/make_review/:project_id/:id',
//       builder: (BuildContext context, GoRouterState state) {
//         return MakeReviewPage(id: state.params['id'] ?? "", projectId: state.params['project_id'] ?? "");
//       },
//     ),
//     GoRoute(
//       path: '/apply_project_funding/:project_id',
//       builder: (BuildContext context, GoRouterState state) {
//         return ApplyProjectFundingPage(projectId: state.params['project_id'] ?? "");
//       },
//     ),
//   ];
// }

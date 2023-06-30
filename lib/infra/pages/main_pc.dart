import 'dart:async';
import 'package:dtim/domain/utils/functions.dart';
import 'package:dtim/domain/utils/platform_infos.dart';
import 'package:dtim/domain/utils/screen/screen.dart';
import 'package:auto_route/auto_route.dart';
import 'package:dtim/infra/pages/select_org.dart';
import 'package:dtim/infra/router/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:dtim/infra/components/components.dart';
import 'package:dtim/infra/components/sider_bar.dart';
import 'package:dtim/application/store/im.dart';
import 'package:dtim/application/service/apis/apis.dart';
import 'package:dtim/domain/models/models.dart';
import 'package:dtim/application/store/theme.dart';

@RoutePage(name: "pc")
class PCPage extends StatefulWidget {
  final String t;
  const PCPage({Key? key, @pathParam required this.t}) : super(key: key);

  @override
  State<PCPage> createState() => _PCPageState();
}

class _PCPageState extends State<PCPage> {
  final StreamController<int> currentId = StreamController<int>();
  List<AccountOrg>? aorgs;
  late AppCubit im;
  double rightWidth = 200.w;
  String rightUrl = "";
  Uri? avatar;

  final mainPages = [
    const OrgRoute(),
    const GovRoute(),
    const DaoRoute(),
    const IntegrateRoute(),
  ];

  @override
  void initState() {
    super.initState();
    im = context.read<AppCubit>();
    currentId.add(pcpages.indexOf(widget.t));
    getData();
  }

  getData() async {
    final os = await (await AccountOrgApi.create()).listByAccount(im.me!.address);
    setState(() {
      aorgs = os;
    });
    if (im.currentState != null) {
      var u = await im.currentState!.client.getAvatarUrl(im.currentState!.client.userID ?? "");
      setState(() {
        avatar = u;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  onSelect(index) {
    currentId.add(index);
  }

  @override
  Widget build(BuildContext context) {
    final constTheme = Theme.of(context).extension<ExtColors>()!;
    return Scaffold(
      backgroundColor: constTheme.sidebarHeaderBg,
      body: AutoTabsRouter.pageView(
        routes: mainPages,
        scrollDirection: Axis.vertical,
        physics: const NeverScrollableScrollPhysics(),
        builder: (context, child, _) {
          if (im.currentState == null) {
            return Center(child: CircularProgressIndicator.adaptive(strokeWidth: 4.w));
          }
          final pageRouter = AutoTabsRouter.of(context);
          return Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              moveWindow(
                Container(
                  width: 65.w,
                  height: double.maxFinite,
                  decoration: BoxDecoration(
                    color: constTheme.sidebarHeaderBg,
                    border: Border(right: BorderSide(color: constTheme.sidebarHeaderBg.lighter(0.08), width: 1)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      if (PlatformInfos.isMacOS) SizedBox(height: 20.w),
                      SizedBox(height: 12.w),
                      // 用户
                      SizedBox(
                        width: 40.w,
                        height: 40.w,
                        child: MePop(
                          im.me!.address,
                          im.me!.name ?? "-",
                          mxContent: avatar,
                          true,
                          40.w,
                          bg: constTheme.sidebarText.withOpacity(0.1),
                          color: constTheme.sidebarText,
                        ),
                      ),
                      Container(
                        width: 6.w,
                        height: 4.w,
                        margin: EdgeInsets.only(top: 12.w, bottom: 10.w),
                        decoration:
                            BoxDecoration(color: constTheme.sidebarText, borderRadius: BorderRadius.circular(2.w)),
                      ),
                      Flexible(
                        child: StreamBuilder(
                          stream: currentId.stream,
                          builder: (BuildContext context, AsyncSnapshot<int> id) {
                            return Column(
                              children: [
                                SiderBarItem(
                                  "Chat",
                                  icon: AppIcons.chat,
                                  key: const Key("Chat"),
                                  selected: id.data == 0,
                                  onTap: () {
                                    pageRouter.setActiveIndex(0);
                                    onSelect(0);
                                  },
                                ),
                                SiderBarItem(
                                  "Gov",
                                  icon: AppIcons.sxgl,
                                  key: const Key("Gov"),
                                  selected: id.data == 1,
                                  onTap: () {
                                    pageRouter.setActiveIndex(1);
                                    onSelect(1);
                                  },
                                ),
                                // 任务管理
                                SiderBarItem(
                                  "Kanban",
                                  img: "https://wetee.app/icons/kanban.png",
                                  key: const Key("KANBAN"),
                                  selected: id.data == 2,
                                  onTap: () {
                                    pageRouter.setActiveIndex(2);
                                    onSelect(2);
                                  },
                                ),
                                // DAO管理
                                SiderBarItem(
                                  "Integrate",
                                  icon: AppIcons.shujujicheng,
                                  key: const Key("Integrate"),
                                  selected: id.data == 3,
                                  onTap: () {
                                    pageRouter.setActiveIndex(3);
                                    onSelect(3);
                                  },
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                      IconButton(
                        tooltip: "discover and join",
                        onPressed: () {
                          printDebug("discover and join");
                          context.router.pushNamed("/select_org?t=back");
                        },
                        icon: SizedBox(
                          width: 36.w,
                          height: 36.w,
                          child: Center(
                            child: Icon(
                              AppIcons.discoverfill,
                              size: 23.w,
                              color: constTheme.sidebarText,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: 6.w,
                        height: 4.w,
                        margin: EdgeInsets.only(top: 0.w, bottom: 5.w),
                        decoration: BoxDecoration(
                          color: constTheme.sidebarText,
                          borderRadius: BorderRadius.circular(2.w),
                        ),
                      ),
                      if (aorgs != null)
                        for (var i = 0; i < aorgs!.length; i++)
                          Tooltip(
                            message: orgs[i].name,
                            verticalOffset: -8.w,
                            margin: EdgeInsets.only(left: 50.w),
                            child: Container(
                              width: 40.w,
                              height: 40.w,
                              padding: EdgeInsets.all(2.w),
                              margin: EdgeInsets.fromLTRB(0, 10.w, 0, 0),
                              decoration: BoxDecoration(
                                color: constTheme.sidebarHeaderTextColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8.w),
                                border: Border.all(
                                  color: constTheme.sidebarTextActiveBorder.withOpacity(0.7),
                                  width: 2.w,
                                ),
                              ),
                              child: Container(
                                width: 36.w,
                                height: 36.w,
                                decoration: BoxDecoration(
                                  color: aorgs![i].orgColor != null
                                      ? hexToColor(aorgs![i].orgColor!)
                                      : constTheme.sidebarText.withOpacity(0.02),
                                  borderRadius: BorderRadius.circular(4.w),
                                ),
                                child: aorgs![i].orgAvater == null
                                    ? Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          if (aorgs![i].orgAvater == null)
                                            Text(
                                              aorgs![i].orgName ?? "",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: constTheme.sidebarHeaderTextColor.withOpacity(0.8),
                                                fontSize: 14.w,
                                              ),
                                            ),
                                        ],
                                      )
                                    : Center(
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(2.w),
                                          child: Image.network(
                                            fit: BoxFit.cover,
                                            aorgs![i].orgAvater!,
                                            width: 36.w,
                                            height: 36.w,
                                          ),
                                        ),
                                      ),
                              ),
                            ),
                          ),
                      SizedBox(height: 15.w),
                    ],
                  ),
                ),
              ),
              Flexible(child: child),
              // GestureDetector(
              //   child: MouseRegion(
              //     cursor: SystemMouseCursors.resizeColumn,
              //     child: SizedBox(
              //       width: 1.w,
              //       height: double.infinity,
              //       child: Container(color: constTheme.sidebarText.withOpacity(0.08)),
              //     ),
              //   ),
              //   onPanUpdate: (details) {
              //     setState(() {
              //       if (rightWidth - details.delta.dx < 180.w || rightWidth - details.delta.dx > 350.w) {
              //         return;
              //       }
              //       rightWidth = rightWidth - details.delta.dx;
              //     });
              //   },
              // ),
              // if (rightUrl != "") Container(width: rightWidth, height: double.maxFinite, color: Colors.red),
            ],
          );
        },
      ),
    );
  }
}

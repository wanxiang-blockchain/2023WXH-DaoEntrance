import 'package:dtim/domain/utils/screen/screen.dart';
import 'package:dtim/router.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:dtim/infra/components/dao/text.dart';
import 'package:dtim/infra/components/loading_dialog.dart';
import 'package:dtim/native_wraper.dart';
import 'package:dtim/application/store/work_ctx.dart';
import 'package:dtim/application/store/theme.dart';
import 'sub/referendum.dart';

class ReferendumPage extends StatefulWidget {
  const ReferendumPage({Key? key}) : super(key: key);

  @override
  State<ReferendumPage> createState() => _ReferendumPageState();
}

class _ReferendumPageState extends State<ReferendumPage> {
  late final WorkCTX dao;

  @override
  void initState() {
    super.initState();
    dao = context.read<WorkCTX>();
    getData();
  }

  getData() async {
    await dao.getVoteData();
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final constTheme = Theme.of(context).extension<ExtColors>()!;
    return Scaffold(
      key: const Key("ReferendumView"),
      backgroundColor: constTheme.centerChannelBg,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(left: 20.w, right: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20.w),
                Row(
                  children: [
                    Icon(
                      Icons.how_to_vote_rounded,
                      size: 30.w,
                      color: constTheme.centerChannelColor,
                    ),
                    SizedBox(width: 10.w),
                    PrimaryText(
                      text: 'Referendums',
                      size: 25.w,
                      fontWeight: FontWeight.w800,
                    ),
                    Expanded(child: Container()),
                    if (dao.votes.isNotEmpty)
                      InkWell(
                        onTap: () async {
                          if (!await workCtx.checkAfterTx()) return;
                          await waitFutureLoading(
                            context: globalCtx(),
                            future: () async {
                              await rustApi.daoGovUnlock(
                                  from: dao.user.address, client: dao.chainClient, daoId: dao.org.daoId);
                              await workCtx.daoRefresh();
                            },
                          );
                        },
                        child: Container(
                          height: 30.w,
                          padding: EdgeInsets.all(5.w),
                          decoration: BoxDecoration(
                            color: constTheme.buttonBg,
                            borderRadius: BorderRadius.circular(5.w),
                          ),
                          alignment: Alignment.center,
                          child: Row(
                            children: [
                              Icon(
                                Icons.undo_rounded,
                                size: 20.w,
                                color: constTheme.buttonColor,
                              ),
                              SizedBox(width: 5.w),
                              Text(
                                "unlock share",
                                style: TextStyle(
                                  fontSize: 14.w,
                                  color: constTheme.buttonColor,
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                  ],
                ),
                SizedBox(height: 8.w),
                PrimaryText(
                  text: "Using Referenda to Achieve Decentralized Voting",
                  size: 14.w,
                ),
                SizedBox(height: 5.w),
              ],
            ),
          ),
          SizedBox(height: 15.w),
          Divider(
            height: 1,
            color: constTheme.centerChannelDivider,
          ),
          SizedBox(height: 10.w),
          Expanded(
            child: Consumer<WorkCTX>(builder: (_, dao, child) {
              return Referendums(
                pending: dao.pending.where((r) => r.memberGroup.scope == 1).toList(),
                going: dao.going.where((r) => r.memberGroup.scope == 1).toList(),
              );
            }),
          ),
        ],
      ),
    );
  }
}

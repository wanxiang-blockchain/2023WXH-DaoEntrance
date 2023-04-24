import 'package:asyou_app/rust_wraper.io.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../components/components.dart';
import '../../../router.dart';
import '../../../store/dao_ctx.dart';
import '../../../utils/screen.dart';
import '../../../store/theme.dart';

class JoinTaskPage extends StatefulWidget {
  final Function? closeModel;
  final String id;
  final String projectId;
  const JoinTaskPage({Key? key, this.closeModel, required this.id, required this.projectId}) : super(key: key);

  @override
  State<JoinTaskPage> createState() => _CreateProjectPageState();
}

class _CreateProjectPageState extends State<JoinTaskPage> {
  bool publicGroup = false;
  final SubmitData _data = SubmitData(
    type: 0,
  );
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  void submitAction() async {
    if (_formKey.currentState == null || !_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();
    await waitFutureLoading(
      context: context,
      future: () async {
        if (_data.type == 0) {
          await rustApi.daoProjectJoinTask(
            from: daoCtx.user.address,
            client: daoCtx.chainClient,
            daoId: daoCtx.org.daoId,
            projectId: int.parse(widget.projectId),
            taskId: int.parse(widget.id),
          );
        } else {
          await rustApi.daoProjectJoinTaskReview(
            from: daoCtx.user.address,
            client: daoCtx.chainClient,
            daoId: daoCtx.org.daoId,
            projectId: int.parse(widget.projectId),
            taskId: int.parse(widget.id),
          );
        }
      },
    );

    //跳转到组织列表
    if (!mounted) return;
    BotToast.showText(text: '频道创建成功，现在返回主页面', duration: const Duration(seconds: 2));
    if (widget.closeModel != null) {
      widget.closeModel!.call();
      return;
    }
    rootNavigatorKey.currentContext?.pop();
  }

  @override
  Widget build(BuildContext context) {
    final constTheme = Theme.of(context).extension<ExtColors>()!;
    return Scaffold(
      backgroundColor: constTheme.centerChannelBg,
      appBar: widget.closeModel == null
          ? LocalAppBar(
              title: "Choose a role to join the task",
              onBack: () {
                if (widget.closeModel != null) {
                  widget.closeModel!.call();
                  return;
                }
                context.pop();
              },
            ) as PreferredSizeWidget
          : ModelBar(
              title: "Choose a role to join the task",
              onBack: () {
                if (widget.closeModel != null) {
                  widget.closeModel!.call();
                  return;
                }
                context.pop();
              },
            ),
      body: Padding(
        padding: EdgeInsets.only(left: 15.w, right: 15.w),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(height: 15.w),
              Row(children: [
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    _data.type = 0;
                    setState(() {});
                  },
                  child: renderType(
                    Appicon.zuzhiDataOrganization6,
                    "Assignee",
                    "Join the project and enjoy your work .",
                    _data.type == 0,
                  ),
                ),
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    _data.type = 1;
                    setState(() {});
                  },
                  child: renderType(
                    Appicon.xiangmu,
                    "Reviewer",
                    "Join the project, review the project progress.",
                    _data.type == 1,
                  ),
                ),
              ]),
              Expanded(child: Container()),
              InkWell(
                onTap: submitAction,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 10.w, horizontal: 30.w),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: constTheme.buttonBg,
                    borderRadius: BorderRadius.circular(5.w),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Center(
                          child: Text(
                            'Join Task',
                            style: TextStyle(
                              color: constTheme.buttonColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 19.w,
                            ),
                          ),
                        ),
                      ),
                      Icon(
                        Icons.navigate_next,
                        color: constTheme.buttonColor,
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(height: 30.w),
            ],
          ),
        ),
      ),
    );
  }

  renderType(icon, title, desc, select) {
    final constTheme = Theme.of(context).extension<ExtColors>()!;
    final titleStyle = TextStyle(
      fontSize: 14.w,
      color: constTheme.centerChannelColor,
      decorationColor: constTheme.centerChannelColor,
    );
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 13.w, left: 0.w),
          child: Icon(
            select ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
            color: select ? constTheme.buttonBg : constTheme.centerChannelColor,
            size: 20.w,
          ),
        ),
        Container(
          width: 220.w,
          padding: EdgeInsets.all(10.w),
          // margin: EdgeInsets.only(right: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, color: constTheme.centerChannelColor, size: 17.w),
                  SizedBox(width: 7.w),
                  Text(title, style: titleStyle.copyWith(fontSize: 17.w)),
                ],
              ),
              SizedBox(height: 5.w),
              Text(
                desc,
                style: titleStyle,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class SubmitData {
  int type;

  SubmitData({
    required this.type,
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../providers/signin/project_provider.dart';
import '../utils/colors.dart';

class NotificationPage extends StatefulWidget {
  NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final reg = Provider.of<ProjectProvider>(context, listen: false);

      await reg.fetchNotificationList(context: context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        // leading: SizedBox(),
        leading: InkWell(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_back),
        ),
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.transparent,
        title: Text(
          "Notifications",
          style: TextStyle(
            color: primaryClr,
            fontFamily: "Manrope",
            fontWeight: FontWeight.w500,
            fontSize: 18.sp,
          ),
        ),
        centerTitle: false,
      ),
      body: Consumer<ProjectProvider>(
        builder: (context, msg, _) {
          return ListView.separated(

            itemCount: msg.notificationModel?.notifications?.length ?? 0,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final notif = msg.notificationModel?.notifications?[index];

              return ListTile(
                // leading: CircleAvatar(
                //   backgroundColor: notif?.isRead == true
                //       ? Colors.grey
                //       : Colors.blue,
                //   child: const Icon(Icons.notifications, color: Colors.white),
                // ),
                title: Text(
                  notif?.title ?? "",
                  style: TextStyle(
                    fontWeight: notif?.isRead == true
                        ? FontWeight.normal
                        : FontWeight.bold,
                  ),
                ),
                subtitle: Text(notif?.message ?? ""),
                trailing: Text(
                  notif?.createdAt != null
                      ? DateFormat('hh:mm a').format(notif!.createdAt!)
                      : "",
                  style: const TextStyle(fontSize: 12),
                ),
                tileColor: notif?.isRead == true
                    ? Colors.white
                    : Colors.grey.withOpacity(0.05),
                onTap: () {
                  // handle click
                },
              );
            },
          );
        },
      ),
    );
  }
}

class AppNotification {
  final String title;
  final String message;
  final String time;
  final bool isRead;

  AppNotification({
    required this.title,
    required this.message,
    required this.time,
    this.isRead = false,
  });
}

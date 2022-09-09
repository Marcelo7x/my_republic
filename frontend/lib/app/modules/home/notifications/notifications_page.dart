import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:frontend/app/modules/home/home_store.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({Key? key}) : super(key: key);

  @override
  State<NotificationsPage> createState() => _NotificationsPageeState();
}

class _NotificationsPageeState extends State<NotificationsPage> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final HomeStore homeController = Modular.get<HomeStore>();

    return SafeArea(
      child: SizedBox(
        //header
        height: height * .9,
        width: width * 0.9,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.notifications_on_rounded),
                  Text(
                    "Notificações",
                    style: TextStyle(fontSize: 22),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: height * .8,
              width: width,
              child: ListView(
                children:
                    homeController.notifications.map((e) => e.widget).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

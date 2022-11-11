import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:frontend/app/modules/home/home_store.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({Key? key}) : super(key: key);

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
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
        child: Observer(builder: (context) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                //header
                height: height * 0.05,
                width: width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.notifications,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const Text(
                      "Notificações",
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: height * .7,
                width: width,
                child: Observer(builder: (context) {
                  return homeController.notifications.isNotEmpty
                      ? ListView(
                          children: homeController.notifications
                              .map((e) => e.getWidget(context))
                              .toList(),
                        )
                      : Container(
                          child: Center(
                            child: Text("Nenhuma notificação"),
                          ),
                        );
                }),
              ),
            ],
          );
        }),
      ),
    );
  }
}

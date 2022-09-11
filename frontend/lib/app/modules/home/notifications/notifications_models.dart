import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:frontend/app/modules/home/home_store.dart';
import 'package:frontend/domain/connection_manager.dart';

abstract class NotificationItem {
  final double height = 100;
  final double width = double.infinity;

  Widget getWidget(BuildContext context) {
    // TODO: implement widget
    throw UnimplementedError();
  }
}

class EntryRequest implements NotificationItem {
  final String title;
  final String message;
  final int userid;
  EntryRequest(
      {required this.title, required this.message, required this.userid});

  @override
  double get height => height;

  @override
  double get width => width;

  @override
  Widget getWidget(BuildContext context) => Card(
        child: ListTile(
          leading: const Icon(
            Icons.person,
            size: 56,
          ),
          title: Text(title),
          subtitle: Text(message),
          trailing: SizedBox(
              width: 90,
              child: Observer(builder: (context) {
                final homeController = Modular.get<HomeStore>();
                return !homeController.loading ||
                        homeController.useridSelected != userid
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: GestureDetector(
                                onTap: () async {
                                  final homeController =
                                      Modular.get<HomeStore>();

                                  homeController.setUseridSelected(userid);
                                  homeController.load(true);

                                  final cm = Modular.get<ConnectionManager>();
                                  await cm.acceptEntryRequest(userid);
                                  await homeController.reload();
                                  homeController.load(false);
                                  homeController.setUseridSelected(-1);
                                },
                                child: const Icon(Icons.check_circle_sharp,
                                    size: 36)),
                          ),
                          GestureDetector(
                            onTap: () async {
                              final homeController = Modular.get<HomeStore>();

                              homeController.setUseridSelected(userid);

                              homeController.load(true);

                              final cm = Modular.get<ConnectionManager>();
                              await cm.deleteEntryRequest(userid);
                              await homeController.reload();

                              homeController.load(false);
                              homeController.setUseridSelected(-1);
                            },
                            child: const Icon(
                              Icons.highlight_remove_rounded,
                              size: 36,
                            ),
                          ),
                        ],
                      )
                    : const SizedBox(
                        width: 40,
                        height: 40,
                        child: CircularProgressIndicator());
              })),
        ),
      );
}

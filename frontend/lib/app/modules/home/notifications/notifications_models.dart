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
  Widget getWidget(BuildContext context) => Container(
        margin: const EdgeInsets.only(top: 20),
        padding: const EdgeInsets.only(
          top: 10,
          bottom: 10,
        ),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              width: 1.0,
              color:
                  Theme.of(context).colorScheme.surfaceVariant.withAlpha(150),
            ),
          ),
        ),
        child: ListTile(
          leading: Container(
            height: 56,
            width: 56,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceVariant,
              borderRadius: BorderRadius.circular(100),
            ),
            child: const Icon(
              Icons.person,
              size: 30,
            ),
          ),
          title: Text(
            title.toUpperCase(),
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
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
                                final homeController = Modular.get<HomeStore>();

                                homeController.setUseridSelected(userid);
                                homeController.load(true);

                                final cm = Modular.get<ConnectionManager>();
                                await cm.acceptEntryRequest(userid);
                                await homeController.reload();
                                homeController.load(false);
                                homeController.setUseridSelected(-1);
                              },
                              child: Icon(
                                Icons.check_circle_sharp,
                                size: 36,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
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
                            child: Icon(
                              Icons.highlight_remove_rounded,
                              size: 36,
                              color: Theme.of(context).colorScheme.error,
                            ),
                          ),
                        ],
                      )
                    : const SizedBox(
                        width: 20,
                        height: 20,
                        child: Center(child: CircularProgressIndicator()));
              })),
        ),
      );
}

import 'package:flutter/material.dart';

abstract class NotificationItem {
  final double height = 100;
  final double width = double.infinity;

  Widget get widget {
    // TODO: implement widget
    throw UnimplementedError();
  }
}

class EntryRequest implements NotificationItem {
  final String title;
  final String message;
  EntryRequest({required this.title, required this.message});

  @override
  double get height => height;

  @override
  double get width => width;

  @override
  Widget get widget => Card(
        child: ListTile(
          leading: const Icon(
            Icons.person,
            size: 56,
          ),
          title: Text(title),
          subtitle: Text(message),
          trailing: SizedBox(
              width: 90,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: GestureDetector(
                        onTap: () {},
                        child: const Icon(Icons.check_circle_sharp, size: 36)),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: const Icon(
                      Icons.highlight_remove_rounded,
                      size: 36,
                    ),
                  )
                ],
              )),
        ),
      );
}

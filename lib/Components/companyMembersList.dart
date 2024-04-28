import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rsforms/Models/jobModel.dart';

class CompanyMemberList extends StatelessWidget {
  final List<RsUser> users;
  final String owneruserId;
  final String shareCode;

  final Function(String email) remove;
  const CompanyMemberList(
      {super.key, required this.users, required this.remove, required this.owneruserId, required this.shareCode});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: users.length + 1,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Material(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: index < users.length
                    ? ListTile(
                        onTap: () {
                          showCupertinoModalPopup(
                            context: context,
                            builder: (context) {
                              return CupertinoActionSheet(
                                title: Text("What action you want to take with ${users[index].email}"),
                                actions: [
                                  CupertinoActionSheetAction(
                                    onPressed: () async {
                                      Navigator.pop(context);
                                      showCupertinoDialog(
                                        context: context,
                                        builder: (context) {
                                          return CupertinoAlertDialog(
                                            title: Text(
                                              "Are you sure you want to remove ${users[index].email} from the company?",
                                            ),
                                            actions: [
                                              CupertinoDialogAction(
                                                  onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
                                              CupertinoDialogAction(
                                                onPressed: () {
                                                  remove(users[index].email);
                                                  Navigator.pop(context);
                                                },
                                                isDestructiveAction: true,
                                                child: const Text("Delete "),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    isDestructiveAction: true,
                                    child: const Text("Delete"),
                                  ),
                                ],
                                cancelButton: CupertinoActionSheetAction(
                                  child: const Text("Cancel"),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                ),
                              );
                            },
                          );
                        },
                        title: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(children: [
                            Text(
                              users[index].email,
                              style: const TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.w600),
                            ),
                            const Spacer(),
                            if (users[index].id == owneruserId)
                              Icon(
                                Icons.turned_in,
                                color: Colors.yellow[600],
                                size: 30,
                              ),
                          ]),
                        ))
                    : Padding(
                        padding: EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(left: 10),
                              child: Text(
                                "Share-code",
                                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.copy),
                                  onPressed: () {
                                    Clipboard.setData(ClipboardData(text: shareCode)).then((_) {
                                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                        content: Text(
                                          "Share-code copied to clipboard",
                                          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
                                        ),
                                        backgroundColor: Colors.white,
                                      ));
                                    });
                                  },
                                  iconSize: 28,
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                Text(
                                  shareCode,
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
              ),
            ),
          );
        });
  }
}

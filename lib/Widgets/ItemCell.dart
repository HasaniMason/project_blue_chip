import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import '../Custom Data/Item.dart';
import '../Custom Data/Users.dart';
import '../Screens/LogIn/SignInScreen.dart';
import 'AddToMenuModal.dart';

class ItemCell extends StatefulWidget {
  final Item item;
  final Users users;
  final bool datePicked;
  final List<DateTime> blackoutDates;

  const ItemCell(
      {super.key,
      required this.item,
      required this.users,
      required this.datePicked,
      required this.blackoutDates});

  @override
  State<ItemCell> createState() => _ItemCellState();
}

class _ItemCellState extends State<ItemCell> {
  String? url;

  setUp() async {
    if (widget.item.picLocation != null && widget.item.picLocation != 'null') {
      var ref =
          FirebaseStorage.instance.ref().child(widget.item.picLocation ?? "");

      print(widget.item.picLocation);
      try {
        await ref.getDownloadURL().then((value) => setState(() {
              url = value;

              //url = 'https://${url!}';
            }));
      } on FirebaseStorage catch (e) {
        print('Did not get URL: ${e}');
      }
    }
  }

  @override
  void initState() {
    super.initState();

    setUp();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: null,
        builder: (BuildContext context, AsyncSnapshot text) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(15)),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 95,
                      width: 90,
                      decoration: BoxDecoration(
                          // border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(20)),
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),

                          ///TODO null safety... provide 'no picture' picture
                          child: url != null
                              ? Image.network(
                                  url.toString(),
                                  fit: BoxFit.fill,
                                )
                              : const CircularProgressIndicator()),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.item.itemName,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 24),
                        ),
                        Row(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 8.0, right: 8),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.info_outline,
                                    color: Colors.grey,
                                    size: 17,
                                  ),
                                  Text(
                                    "Gluten Free",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall!
                                        .copyWith(color: Colors.grey),
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 8.0, right: 8),
                              child: Row(
                                children: [
                                  const Icon(Icons.category_outlined,
                                      color: Colors.grey, size: 17),
                                  Text(
                                    widget.item.category,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall!
                                        .copyWith(color: Colors.grey),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                        Container(
                          padding: EdgeInsets.zero,
                          width: 270,
                          height: 40,
                          child: Text(
                            widget.item.itemDescription,
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .copyWith(color: Colors.grey),
                            overflow: TextOverflow.fade,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("\$${widget.item.retail.toStringAsFixed(2)}",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall!
                                      .copyWith(
                                          color: Colors.grey,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18)),
                              widget.users.firstName != 'Guest'
                                  ? ElevatedButton(
                                      style: ButtonStyle(
                                          backgroundColor: MaterialStateProperty.all(
                                              Theme.of(context)
                                                  .colorScheme
                                                  .secondary),
                                          shape: MaterialStateProperty.all(
                                              RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(
                                                      7)))),
                                      onPressed: () {
                                        showModalBottomSheet(
                                            context: context,
                                            builder: (context) {
                                              return AddToMenuModal(
                                                item: widget.item,
                                                users: widget.users,
                                                datePicked: widget.datePicked,
                                                blackoutDates:
                                                    widget.blackoutDates,
                                              );
                                            });
                                      },
                                      child: Text(
                                        "Add to menu",
                                        style: Theme.of(context)
                                            .textTheme
                                            .displaySmall!
                                            .copyWith(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12),
                                      ))
                                  : ElevatedButton(
                                      style: ButtonStyle(
                                          backgroundColor: MaterialStateProperty.all(
                                              Theme.of(context)
                                                  .colorScheme
                                                  .secondary),
                                          shape: MaterialStateProperty.all(
                                              RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)))),
                                      onPressed: () {
                                        Navigator.pushAndRemoveUntil(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const SignInScreen()),
                                            (route) => false);
                                      },
                                      child: Text(
                                        "Sign in / Sign up",
                                        style: Theme.of(context)
                                            .textTheme
                                            .displaySmall!
                                            .copyWith(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12),
                                      )),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}

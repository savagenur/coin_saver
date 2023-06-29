import 'package:flutter/material.dart';

import '../../../../constants/constants.dart';

class MainTransactionPage extends StatefulWidget {
  const MainTransactionPage({super.key});

  @override
  State<MainTransactionPage> createState() => _MainTransactionPageState();
}

class _MainTransactionPageState extends State<MainTransactionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {},
                  child: Row(
                    children: [
                      Icon(Icons.money),
                      sizeHor(5),
                      Text(
                        "Total",
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                      Icon(Icons.arrow_drop_down_outlined)
                    ],
                  ),
                ),
                PopupMenuButton(
                  child: Row(
                    children: [
                      Text(
                        "By date",
                        style: TextStyle(decoration: TextDecoration.underline),
                      ),
                      Icon(Icons.arrow_drop_down)
                    ],
                  ),
                  initialValue: const PopupMenuItem(child: Text("By date")),
                  itemBuilder: (context) {
                    return [
                      const PopupMenuItem(child: Text("By date")),
                      const PopupMenuItem(child: Text("By amount")),
                    ];
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  children: [
                    ...List.generate(
                      20,
                      (index) => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "June 28, 2023",
                            style: TextStyle(
                              color: secondaryColor,
                            ),
                          ),
                          ListTile(
                            onTap: () {
                              Navigator.pushNamed(
                                  context, PageConst.transactionDetailPage);
                            },
                            contentPadding: EdgeInsets.zero,
                            leading: CircleAvatar(
                              child: Icon(Icons.bathtub_sharp),
                            ),
                            title: Text("Groceries"),
                            trailing: Text(
                              "c500000",
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ),
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: CircleAvatar(
                              child: Icon(Icons.bathtub_sharp),
                            ),
                            title: Text("Groceries"),
                            trailing: Text(
                              "c500000",
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ),
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: CircleAvatar(
                              child: Icon(Icons.bathtub_sharp),
                            ),
                            title: Text("Groceries"),
                            trailing: Text(
                              "c500000",
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ),
                          sizeVer(10)
                        ],
                      ),
                    ),
                    sizeVer(20),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, PageConst.addTransactionPage);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      centerTitle: true,
      toolbarHeight: 70,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Groceries",
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(color: Colors.white, fontWeight: FontWeight.normal),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 5),
            child: Text(
              "c500000",
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall!
                  .copyWith(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      actions: [
        IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
      ],
    );
  }
}

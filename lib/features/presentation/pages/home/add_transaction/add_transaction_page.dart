import 'package:coin_saver/constants.dart';
import 'package:flutter/material.dart';

import '../../../widgets/my_button_widget.dart';

class AddTransactionPage extends StatefulWidget {
  const AddTransactionPage({super.key});

  @override
  State<AddTransactionPage> createState() => AddTransactionPageState();
}

class AddTransactionPageState extends State<AddTransactionPage> {
  int _selectedDay = 0;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: _buildAppBar(),
        body: Padding(
          padding: EdgeInsets.all(10),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Spacer(
                      flex: 1,
                    ),
                    Expanded(
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * .3,
                        child: TextFormField(
                          maxLength: 10,
                          keyboardType: TextInputType.number,
                          maxLines: 1,
                          textAlign: TextAlign.center,
                          showCursor: false,
                          decoration: InputDecoration(hintText: "0"),
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge!
                              .copyWith(color: primaryColor),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          Text(
                            "USD",
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(color: primaryColor),
                          ),
                          IconButton(
                              onPressed: () {},
                              icon: Icon(Icons.calculate_outlined)),
                        ],
                      ),
                    ),
                  ],
                ),
                sizeVer(20),
                Text("Account:"),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    "Not selected",
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        fontWeight: FontWeight.bold, color: primaryColor),
                  ),
                ),
                Divider(),
                sizeVer(10),
                Text("Categories:"),
                sizeVer(10),
                _buildGridView(),
                Divider(),
                sizeVer(10),
                _buildSelectDay(context, _selectedDay),
                sizeVer(20),
                Text("Comment:"),
                sizeVer(10),
                TextFormField(
                  maxLength: 4000,
                  decoration: InputDecoration(
                    hintText: "Comment...",
                  ),
                ),
              ],
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: MediaQuery.of(context).viewInsets.bottom != 0
            ? null
            : MyButtonWidget(
                title: 'Add',
                width: MediaQuery.of(context).size.width*.5,
                borderRadius: BorderRadius.circular(30),
                paddingVertical: 15,
                onTap: () {
                  
                },
              ),
      ),
    );
  }

  Padding _buildSelectDay(BuildContext context, int selectedDay) {
    final List<Map> days = [
      {
        "today": "6/25",
      },
      {
        "yesterday": "6/26",
      },
      {
        "two days ago": "6/27",
      },
    ];
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              ...List.generate(
                  days.length,
                  (index) => GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedDay = index;
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: selectedDay == index
                                ? primaryColor
                                : Colors.white,
                          ),
                          padding: EdgeInsets.all(5),
                          margin: EdgeInsets.only(right: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                days[index].values.first,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(
                                        color: selectedDay == index
                                            ? Colors.white
                                            : null),
                              ),
                              Text(
                                days[index].keys.first,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(
                                        color: selectedDay == index
                                            ? Colors.white
                                            : Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      )),
            ],
          ),
          IconButton(onPressed: () {}, icon: Icon(Icons.calendar_month))
        ],
      ),
    );
  }

  GridView _buildGridView() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4, mainAxisSpacing: 5, crossAxisSpacing: 5),
      itemCount: 8,
      itemBuilder: (BuildContext context, int index) {
        return index == 7
            ? Column(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.grey[300],
                    radius: 25,
                    child: Icon(Icons.add),
                  ),
                  Text(
                    "More",
                    maxLines: 1,
                  ),
                ],
              )
            : Column(
                children: [
                  CircleAvatar(
                    radius: 30,
                    child: Icon(Icons.bus_alert),
                  ),
                  Text(
                    "Transactions",
                    style: Theme.of(context).textTheme.titleSmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              );
      },
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      toolbarHeight: 70,
      centerTitle: true,
      title: Text("Add Transactions"),
      bottom: TabBar(
        onTap: (value) {},
        padding: EdgeInsets.symmetric(horizontal: 20),
        indicatorPadding: EdgeInsets.only(bottom: 5),
        labelStyle: TextStyle(fontWeight: FontWeight.bold),
        tabs: [
          Tab(
            child: Text("EXPENSES"),
          ),
          Tab(child: Text("INCOME")),
        ],
      ),
    );
  }
}

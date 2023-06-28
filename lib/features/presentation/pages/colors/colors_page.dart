import 'package:coin_saver/constants/constants.dart';
import 'package:coin_saver/features/presentation/widgets/my_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../constants/colors.dart';

class ColorsPage extends StatelessWidget {
  const ColorsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Colors"),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 20,left: 20,),
            child: Row(
              children: [
                Text(
                  "Selected Color:",
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(fontWeight: FontWeight.normal),
                ),
                sizeHor(10),
                CircleAvatar(
                  backgroundColor: Colors.green,
                ),
              ],
            ),
          ),
          Divider(),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: GridView.builder(
                        shrinkWrap: true,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 5,
                          crossAxisSpacing: 20,
                          mainAxisSpacing: 20,
                        ),
                        itemCount: colors.length,
                        itemBuilder: (BuildContext context, int index) {
                          return CircleAvatar(
                            backgroundColor: colors[index],
                          );
                        },
                      ),
            ),
          ),
          Divider(),
          MyButtonWidget(title: "Add Color",borderRadius: BorderRadius.circular(20),width: MediaQuery.of(context).size.width*.8 ,onTap: () {
            
          },paddingVertical: 15 ,)
        ],
      ),
    );
  }
}

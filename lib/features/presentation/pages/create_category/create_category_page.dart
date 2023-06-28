import 'package:coin_saver/constants/category_icons.dart';
import 'package:coin_saver/constants/colors.dart';
import 'package:coin_saver/constants/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../widgets/my_button_widget.dart';

class CreateCategoryPage extends StatefulWidget {
  const CreateCategoryPage({super.key});

  @override
  State<CreateCategoryPage> createState() => CreateCategoryPageState();
}

class CreateCategoryPageState extends State<CreateCategoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Category"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Flexible(
                    child: CircleAvatar(
                      backgroundColor: secondaryColor,
                      child: Icon(
                        Icons.question_mark_sharp,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  sizeHor(10),
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(hintText: "Category Name"),
                    ),
                  ),
                ],
              ),
              sizeVer(10),
              _buildIsIncomeRadio(context),
              sizeVer(10),
              Text(
                "Planned outlay",
                style: TextStyle(color: Colors.grey.shade600),
              ),
              sizeVer(10),
              _buildPlannedOutlay(context),
              sizeVer(20),
              Text(
                "Icons",
                style: TextStyle(color: Colors.grey.shade600),
              ),
              sizeVer(10),
              _buildGridView(context),
              sizeVer(10),
              Text(
                "Color",
                style: TextStyle(color: Colors.grey.shade600),
              ),
              sizeVer(10),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: _buildColor()),
              sizeVer(20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  
                  MyButtonWidget(
                    title: 'Add',
                    width: MediaQuery.of(context).size.width * .5,
                    borderRadius: BorderRadius.circular(30),
                    paddingVertical: 15,
                    onTap: () {},
                  ),
                ],
              )

            ],
          ),
        ),
      ),
    );
  }

  Row _buildColor() {
    return Row(
              children: [
                ...List.generate(
                  mainColors.length,
                  (index) => Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: CircleAvatar(
                      backgroundColor: mainColors[index],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    
                  },
                  child: Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: CircleAvatar(
                      backgroundColor: secondaryColor,
                      child: Icon(Icons.add,color: Colors.white,),
                    ),
                  ),
                )
              ],
            );
  }

  GridView _buildGridView(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 2,
      mainAxisSpacing: 2,
      crossAxisCount: 4,
      children: <Widget>[
        ...List.generate(mainIcons.length, (index) {
          return Container(
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            child: CircleAvatar(
              radius: 30,
              backgroundColor: secondaryColor,
              child: Icon(
                mainIcons[index],
                color: Colors.white,
              ),
            ),
          );
        }),
        GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, PageConst.catalogIconsPage);
          },
          child: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            child: CircleAvatar(
              radius: 25,
              backgroundColor: Colors.amber,
              child: Icon(
                Icons.more_horiz,
                color: Colors.white,
              ),
            ),
          ),
        )
      ],
    );
  }

  Row _buildPlannedOutlay(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: SizedBox(
            width: MediaQuery.of(context).size.width * .3,
            child: TextField(
              decoration: InputDecoration(hintText: "Not selected"),
            ),
          ),
        ),
        sizeHor(10),
        Expanded(
            child: Text(
          "KGS per month",
          style: TextStyle(fontWeight: FontWeight.w500),
        ))
      ],
    );
  }

  Row _buildIsIncomeRadio(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: InkWell(
            onTap: () {},
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Radio(
                  value: true,
                  groupValue: true,
                  onChanged: (value) {},
                ),
                Text(
                  "Expenses",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: InkWell(
            onTap: () {},
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Radio(
                  value: true,
                  groupValue: true,
                  onChanged: (value) {},
                ),
                Text(
                  "Income",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

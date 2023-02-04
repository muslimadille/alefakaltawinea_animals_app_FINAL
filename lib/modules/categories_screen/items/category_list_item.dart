import 'package:alefakaltawinea_animals_app/modules/categories_screen/provider/categories_provider_model.dart';
import 'package:alefakaltawinea_animals_app/modules/serviceProviders/list_screen/service_providers_list_screen.dart';
import 'package:alefakaltawinea_animals_app/utils/my_utils/baseDimentions.dart';
import 'package:alefakaltawinea_animals_app/utils/my_utils/baseTextStyle.dart';
import 'package:alefakaltawinea_animals_app/utils/my_utils/myColors.dart';
import 'package:alefakaltawinea_animals_app/utils/my_utils/myUtils.dart';
import 'package:alefakaltawinea_animals_app/utils/my_utils/resources.dart';
import 'package:alefakaltawinea_animals_app/utils/my_widgets/transition_image.dart';
import 'package:flutter/material.dart';

import '../../../main.dart';

class CategoryListItem extends StatefulWidget {
  OnItemClickListener? onItemClickListener;
  String title;
  String image;

  CategoryListItem(
      {required this.title,required this.image,this.onItemClickListener});

  @override
  _CategoryListItemState createState() => _CategoryListItemState();
}

class _CategoryListItemState extends State<CategoryListItem> {
  _CategoryListItemState();

  GlobalKey _keyRed = GlobalKey();
  double height = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) async {});
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onItemClickListener,
      child: _newIem(),
    );
  }


  Widget _newIem() {
    return Container(
      margin: EdgeInsets.all(D.default_10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(D.default_10),
            color: C.BASE_BLUE,
            boxShadow:[BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                offset:Offset(1,1),
                blurRadius:1,
                spreadRadius: 1
            )]
        ),
      child: Column(children: [
      Expanded(
          child: TransitionImage(
        widget.image,
        width: double.infinity,
        fit: BoxFit.contain,
      )),
        Container(
          height: D.default_1,
          color: C.BASE_ORANGE,
          margin: EdgeInsets.only(top:D.default_5),
        ),
      Container(
        height: D.default_35,
        child: Center(
          child: Text(widget.title,
              style: S.h1(color: Colors.white)),
        ),)],),);
  }
}

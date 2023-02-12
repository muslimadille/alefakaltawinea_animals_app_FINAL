import 'package:alefakaltawinea_animals_app/utils/my_utils/baseDimentions.dart';
import 'package:alefakaltawinea_animals_app/utils/my_utils/myColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingProgress extends StatelessWidget {
  const LoadingProgress({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(.20),
      width: double.infinity,
      height: double.infinity,
      child:Center(child: Container(
        width: D.default_200,
        height: D.default_100,
        padding: EdgeInsets.all(D.default_10),
        decoration:  BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.all(Radius.circular(D.default_5)),
        ),
        child: const SpinKitCircle(
          color: C.BASE_BLUE,
        ),),) ,
    );
  }
}

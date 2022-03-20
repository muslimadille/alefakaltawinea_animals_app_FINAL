import 'package:alefakaltawinea_animals_app/modules/adoption/provider/adoption_provider_model.dart';
import 'package:alefakaltawinea_animals_app/modules/baseScreen/baseScreen.dart';
import 'package:alefakaltawinea_animals_app/modules/profile/no_profile_screen.dart';
import 'package:alefakaltawinea_animals_app/utils/my_utils/baseDimentions.dart';
import 'package:alefakaltawinea_animals_app/utils/my_utils/baseTextStyle.dart';
import 'package:alefakaltawinea_animals_app/utils/my_utils/constants.dart';
import 'package:alefakaltawinea_animals_app/utils/my_utils/myColors.dart';
import 'package:alefakaltawinea_animals_app/utils/my_utils/myUtils.dart';
import 'package:alefakaltawinea_animals_app/utils/my_utils/resources.dart';
import 'package:alefakaltawinea_animals_app/utils/my_widgets/action_bar_widget.dart';
import 'package:alefakaltawinea_animals_app/utils/my_widgets/laoding_view.dart';
import 'package:alefakaltawinea_animals_app/utils/my_widgets/transition_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'add_adoption_screen.dart';
import 'animal_details_screen.dart';
import 'my_adoption_screen.dart';

class AdoptionScreen extends StatefulWidget {
  const AdoptionScreen({Key? key}) : super(key: key);

  @override
  _AdoptionScreenState createState() => _AdoptionScreenState();
}

class _AdoptionScreenState extends State<AdoptionScreen> {
  AdoptionProviderModel? adoptionProviderModel;
  int selectedTab=0;
  @override
  void initState() {
    super.initState();
    adoptionProviderModel=Provider.of<AdoptionProviderModel>(context,listen: false);
    adoptionProviderModel!.getCategoriesList();

  }
  @override
  Widget build(BuildContext context) {
    adoptionProviderModel=Provider.of<AdoptionProviderModel>(context,listen: true);
    return BaseScreen(
      showSettings: false,
      showBottomBar: true,
      tag: "AdoptionScreen",
      body: Column(
        children: [
          ActionBarWidget(tr("adoption"), context,backgroundColor: Colors.white,textColor: C.ADAPTION_COLOR,enableShadow: false,),
          Expanded(
              child:Container(
                color: Colors.white,
                child: Column(
                children: [
                  _categoryList(),
                  Row(children: [
                    Expanded(child: _addBtn(),),
                    Expanded(child: _myOffersBtn(),),
                  ],),
                  adoptionProviderModel!.isLoading?Expanded(child: LoadingProgress()): Expanded(flex: 1,child: _animalsList())
                ],
              ),))
        ],
      ),
    );
  }

  Widget _addBtn() {
    return InkWell(
      onTap: () {
        if(Constants.currentUser!=null){
          MyUtils.navigate(context, AddAdoptionScreen());
        }else{
          MyUtils.navigate(context, NoProfileScreen());
        }
      },
      child: Container(
          margin: EdgeInsets.only(left:D.default_10,right:D.default_10),
          padding: EdgeInsets.only(top:D.default_10,bottom:D.default_10,left:D.default_20,right:D.default_20),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(D.default_15),
              color: C.ADAPTION_COLOR,
              ),
          child: Center(
            child: Text(
              tr("add_adoption"),
              style: S.h4(color: Colors.white),
              textAlign: TextAlign.center,
            ),
          )),
    );
  }
  Widget _myOffersBtn() {
    return InkWell(
      onTap: () {
        if(Constants.currentUser!=null){
          MyUtils.navigate(context, MyAdoptionScreen());
        }else{
          MyUtils.navigate(context, NoProfileScreen());
        }
      },
      child: Container(
          margin: EdgeInsets.only(left:D.default_10,right:D.default_10),
          padding: EdgeInsets.only(top:D.default_10,bottom:D.default_10,left:D.default_20,right:D.default_20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(D.default_15),
            color: C.ADAPTION_COLOR,
          ),
          child: Center(
            child: Text(
              tr("my_adoption"),
              style: S.h4(color: Colors.white),
              textAlign: TextAlign.center,
            ),
          )),
    );
  }




  Widget _categoryList() {
    return Container(
      margin: EdgeInsets.only(left:D.default_10,right:D.default_10),
      height: D.default_90,
      width: double.infinity,
      child: ListView.builder(
          itemCount: adoptionProviderModel!.categoriesList.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return Container(
                margin: EdgeInsets.all(D.default_10),
                child: InkWell(
                  onTap: (){
                    adoptionProviderModel!.setSelectedCategoryIndex(index);
                    adoptionProviderModel!.getAnimals(adoptionProviderModel!.categoriesList[index].id!);
                  },
                  child: TransitionImage(
                  adoptionProviderModel!.categoriesList[index].photo!,
                  radius: D.default_200,
                  width: D.default_70,
                  height: D.default_70,
                  strokeColor: adoptionProviderModel!.selectedCategoryIndex==index?C.ADAPTION_COLOR:Colors.grey,
                  backgroundColor: adoptionProviderModel!.selectedCategoryIndex==index?C.ADAPTION_COLOR:Colors.white,
                  fit: BoxFit.fitWidth,
                  padding: EdgeInsets.all(D.default_5),
                ),));
          }),
    );
  }

  Widget _animalsList() {
    return adoptionProviderModel!.animalPagerListModel!=null&&adoptionProviderModel!.animalPagerListModel!.data!.isNotEmpty?Container(
      padding: EdgeInsets.all(D.default_10),
      child: CustomScrollView(slivers: [
      SliverGrid(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: D.default_10,
            mainAxisSpacing: D.default_10,
            childAspectRatio: 0.9,
          ),
          delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
              return _animalsListItem(index);
            },
            childCount: adoptionProviderModel!.animalPagerListModel!.data!.length,
            semanticIndexOffset: 1,
          )),
    ]),):_noData();
  }
Widget _noData(){
    return Center(child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TransitionImage(Res.OFFER_ICON,
          width: D.default_80,
          height: D.default_80,
        ),
        SizedBox(height: D.default_20,),
        Text("لا توجد حيوانات متاحة حاليا في هذا القسم",style: S.h3(color: C.BASE_BLUE),)
      ],),);
}
  Widget _animalsListItem(int index) {
    return InkWell(
      onTap: () {
        if(Constants.currentUser!=null){
          MyUtils.navigate(context, AnimalDetailsScreen(index));
        }else{
          MyUtils.navigate(context, NoProfileScreen());
        }
      },
      child:Container(
      width: D.default_80,
      height: D.default_100,
      margin: EdgeInsets.all(D.default_5),
      padding: EdgeInsets.all(D.default_2),

      child: Column(
        children: [
          Expanded(
              child: Center(child: TransitionImage(
                adoptionProviderModel!.animalPagerListModel!.data![index].photo!,
                radius: D.default_300,
                fit: BoxFit.cover,
                width: D.default_90,
                height: D.default_90,
              ),)),
          Container(
            child: Center(
              child: Text(
                adoptionProviderModel!.animalPagerListModel!.data![index].type!,
                style: S.h3(color: C.BASE_BLUE),
              ),
            ),
          ),
          Text(
            "المزيد..",
            style: S.h6(color: Colors.grey),
          )

        ],
      ),
    ));
  }

  List<adoptionCategory> categories = [
    adoptionCategory(),
    adoptionCategory(),
    adoptionCategory(),
    adoptionCategory(),
    adoptionCategory(),
    adoptionCategory(),
    adoptionCategory()
  ];
}

class adoptionCategory {
  String name = "test";
  String image = Res.IC_FAV_GREY;
}

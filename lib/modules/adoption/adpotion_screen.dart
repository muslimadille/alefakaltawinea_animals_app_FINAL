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
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import 'add_adoption_screen.dart';
import 'adoption_register_pop.dart';
import 'animal_details_screen.dart';
import 'my_adoption_screen.dart';

class AdoptionScreen extends StatefulWidget {
  const AdoptionScreen({Key? key}) : super(key: key);

  @override
  _AdoptionScreenState createState() => _AdoptionScreenState();
}

class _AdoptionScreenState extends State<AdoptionScreen> {
  AdoptionProviderModel? adoptionProviderModel;
  int _currentLoadedPage=1;
  ScrollController? controller;
  @override
  void initState() {
    super.initState();
    controller = ScrollController()..addListener(_scrollListener);
    adoptionProviderModel=Provider.of<AdoptionProviderModel>(context,listen: false);
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      adoptionProviderModel!.getCategoriesList();
    });


  }
  @override
  void dispose() async{
    await adoptionProviderModel!.setShowRegister(false);
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    adoptionProviderModel=Provider.of<AdoptionProviderModel>(context,listen: true);
    return BaseScreen(
      showSettings: false,
      showBottomBar: true,
      tag: "AdoptionScreen",
      body: Stack(
        fit:StackFit.expand,
        children: [
          Column(
            children: [
              ActionBarWidget(tr(""), context,backgroundColor: Colors.white,textColor: C.BASE_BLUE,enableShadow: false,),
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
                        adoptionProviderModel!.isLoading&&adoptionProviderModel!.animalPagerListModel==null?Expanded(child: LoadingProgress()):
                        adoptionProviderModel!.animalPagerListModel==null?Container():Expanded(flex: 1,child: Stack(children: [
                          _animalsList(),
                          (adoptionProviderModel!.isLoading&&(adoptionProviderModel!.animalPagerListModel!.data??[]).isNotEmpty)?Container(
                            height: MediaQuery.of(context).size.height,
                            width: MediaQuery.of(context).size.width,
                          ):Container()
                        ],)),
                        adoptionProviderModel!.animalPagerListModel==null?Container():
                        (adoptionProviderModel!.isLoading&&(adoptionProviderModel!.animalPagerListModel!.data??[]).isNotEmpty)?Container(height: D.default_60,width: D.default_250,child: Center(child: SpinKitCircle(
                          color: C.ADAPTION_COLOR,
                        ),),):Container()
                      ],
                    ),))
            ],
          ),
          Constants.currentUser==null&&adoptionProviderModel!.shoewRegister?RegisterationPop():Container()
        ],)
    );
  }

  Widget _addBtn() {
    return InkWell(
      onTap: () {
        if(Constants.currentUser!=null){
          MyUtils.navigate(context, AddAdoptionScreen());
        }else{
          adoptionProviderModel!.setShowRegister(true);
        }
      },
      child: Container(
          margin: EdgeInsets.only(left:D.default_20,right:D.default_20),
          padding: EdgeInsets.only(top:D.default_10,bottom:D.default_10,left:D.default_20,right:D.default_20),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(D.default_15),
              color: C.ADAPTION_COLOR,
              ),
          child: Center(
            child: Text(
              tr("add_adoption"),
              style: S.h2(color: Colors.white),
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
          adoptionProviderModel!.setShowRegister(true);
        }
      },
      child: Container(
          margin: EdgeInsets.only(left:D.default_20,right:D.default_20),
          padding: EdgeInsets.only(top:D.default_10,bottom:D.default_10,left:D.default_20,right:D.default_20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(D.default_15),
            color: C.ADAPTION_COLOR,
          ),
          child: Center(
            child: Text(
              tr("my_adoption"),
              style: S.h2(color: Colors.white),
              textAlign: TextAlign.center,
            ),
          )),
    );
  }




  Widget _categoryList() {
    return Container(
      margin: EdgeInsets.only(left:D.default_10,right:D.default_10),
      height: D.default_80,
      width: double.infinity,
      child: ListView.builder(
          itemCount: adoptionProviderModel!.categoriesList.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return Container(
                margin: EdgeInsets.all(D.default_10),
                child: InkWell(
                  onTap: (){
                    _currentLoadedPage=1;
                    adoptionProviderModel!.setSelectedCategoryIndex(index);
                    adoptionProviderModel!.getAnimals(adoptionProviderModel!.categoriesList[index].id!,1);
                  },
                  child:
                  TransitionImage(
                  adoptionProviderModel!.categoriesList[index].photo!,
                  radius: D.default_200,
                  width: D.default_60,
                  height: D.default_60,
                  strokeColor: adoptionProviderModel!.selectedCategoryIndex==index?C.ADAPTION_COLOR:Colors.grey[400],
                  backgroundColor: adoptionProviderModel!.selectedCategoryIndex==index?C.ADAPTION_COLOR:Colors.grey[400],
                  fit: BoxFit.fitWidth,
                  padding: EdgeInsets.all(D.default_5),
                ),));
          }),
    );
  }

  Widget _animalsList() {
    return adoptionProviderModel!.animalPagerListModel!.data!.isNotEmpty?Container(
      padding: EdgeInsets.all(D.default_10),
      child: CustomScrollView(
        controller: controller,
          slivers: [
      SliverGrid(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: D.default_5,
            mainAxisSpacing: D.default_5,
            childAspectRatio: 1,
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
        Text(tr("no_animals"),style: S.h3(color: C.BASE_BLUE),)
      ],),);
}
  Widget _animalsListItem(int index) {
    return InkWell(
      onTap: () {
        if(Constants.currentUser!=null){
          MyUtils.navigate(context, AnimalDetailsScreen(index));
        }else{
          adoptionProviderModel!.setShowRegister(true);
        }
      },
      child:Container(
      margin: EdgeInsets.all(D.default_5),
      padding: EdgeInsets.all(D.default_2),

      child: Column(
        children: [
          Expanded(
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(D.default_150),
                    color: Colors.white,
                    boxShadow:[BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        offset:Offset(1,1),
                        blurRadius:2,
                        spreadRadius: 2
                    )]
                ),
                child: TransitionImage(
                adoptionProviderModel!.animalPagerListModel!.data![index].photo!.isNotEmpty?adoptionProviderModel!.animalPagerListModel!.data![index].photo!:Res.DEFAULT_IMAGE,
                radius: D.default_200,
                fit: BoxFit.cover,
                width: D.default_150,
                height: D.default_150,

              ),)),
          Container(
            child: Center(
              child: Text(
                adoptionProviderModel!.animalPagerListModel!.data![index].name!,
                style: S.h1(color: C.BASE_BLUE),
              ),
            ),
          ),
          Text(
            tr("more"),
            style: S.h4(color: Colors.grey),
          )

        ],
      ),
    ));
  }
  void _scrollListener() {
    print(controller!.position.extentAfter);
    if (controller!.position.extentAfter <1) {
      _currentLoadedPage=_currentLoadedPage+1;
      adoptionProviderModel!.getAnimals(adoptionProviderModel!.categoriesList[adoptionProviderModel!.selectedCategoryIndex??0].id!,_currentLoadedPage);
    }
  }
}


class adoptionCategory {
  String name = "test";
  String image = Res.IC_FAV_GREY;
}

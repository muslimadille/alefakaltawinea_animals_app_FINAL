import 'package:alefakaltawinea_animals_app/utils/my_widgets/animal_cart_widget.dart';
import 'package:alefakaltawinea_animals_app/utils/my_widgets/delete_card_popup.dart';
import 'package:alefakaltawinea_animals_app/utils/my_widgets/edite_card_popup.dart';
import 'package:alefakaltawinea_animals_app/utils/my_widgets/laoding_view.dart';
import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/Material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import '../../utils/my_utils/baseDimentions.dart';
import '../../utils/my_utils/baseTextStyle.dart';
import '../../utils/my_utils/constants.dart';
import '../../utils/my_utils/myColors.dart';
import '../../utils/my_utils/myUtils.dart';
import '../../utils/my_widgets/action_bar_widget.dart';
import '../../utils/my_widgets/transition_image.dart';
import '../baseScreen/baseScreen.dart';
import '../cart/add_cart_screen.dart';
import '../cart/provider/cart_provider.dart';
import '../homeTabsScreen/provider/bottom_bar_provider_model.dart';

class MyCardsScreen extends StatefulWidget {
  const MyCardsScreen({Key? key}) : super(key: key);

  @override
  State<MyCardsScreen> createState() => _MyCardsScreenState();
}

class _MyCardsScreenState extends State<MyCardsScreen> {
  CartProvider? cartProvider;
  @override
  void initState() {
    super.initState();
    cartProvider = Provider.of<CartProvider>(context, listen: false);
    cartProvider!.getMyCart();
  }

  @override
  Widget build(BuildContext context) {
    cartProvider = Provider.of<CartProvider>(context, listen: true);
    return BaseScreen(
        showSettings: false,
        showBottomBar: true,
        tag: "ProfileScreen",
        body:Column(
      children: [
        ActionBarWidget(
          tr("my_carts"),
          context,
          backgroundColor: Colors.white,
          textColor: C.BASE_BLUE,
          enableShadow: false,
        ),
        Expanded(
          child:
          cartProvider!.isLoading?LoadingProgress():cartProvider!.myCarts.isNotEmpty ? _myCartsScreen() : _noCarts(),
        )
      ],
    ));
  }

  Widget _myCartsScreen() {
    return Column(
      children: [
        Expanded(
          child: Container(
            child: ListView.builder(
              itemBuilder: (context, index) {
                return AnimalCartWidget(cart: cartProvider!.myCarts[index],enableEdite: true,
                  onDelete: (){
                    MyUtils.basePopup(context, body: DeleteCradPopupScreen(content:tr("delete_card_text"),onOkPressed: (){
                      cartProvider!.deleteCard(cartProvider!.myCarts[index].id??0);
                      Navigator.pop(context);
                    },));
                  },
                  onEdite: (){
                    MyUtils.basePopup(context, body: EditeCartScreen(myCart:cartProvider!.myCarts[index],));
                  },);
              },
              itemCount: cartProvider!.myCarts.length,
            ),
          ),
        ),
        _addCartBtn()
      ],
    );
  }



  Widget _noCarts() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            tr("dont_have_cart_title"),
            style: S.h1(color: C.BASE_BLUE),
          ),
          Text(
            tr("dont_have_cart_subtitle"),
            style: S.h2(color: Colors.grey),
          ),
          SizedBox(
            height: D.default_40,
          ),
          _addCartBtn(),
        ],
      ),
    );
  }

  Widget _addCartBtn() {
    return Center(
      child: InkWell(
        onTap: () async {
          if (Constants.APPLE_PAY_STATE) {
            MyUtils.navigate(context, AddCartScreen());
          } else {
            await Fluttertoast.showToast(
                msg: tr("Your request has been successfully received"));
          }
        },
        child: Container(
          width: D.default_250,
          margin: EdgeInsets.all(D.default_30),
          padding: EdgeInsets.only(
              left: D.default_10,
              right: D.default_10,
              top: D.default_5,
              bottom: D.default_5),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(D.default_15),
              color: C.BASE_BLUE,
              boxShadow: [
                BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    offset: Offset(1, 1),
                    blurRadius: 1,
                    spreadRadius: 1)
              ]),
          child: Text(
            tr("add_cart"),
            style: S.h1(color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

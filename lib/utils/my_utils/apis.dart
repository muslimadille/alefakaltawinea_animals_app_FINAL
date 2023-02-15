class Apis{
  static String TOKEN_VALUE="";

  static const REQ_SUCCESS = "success";
  static const CODE_SUCCESS = '200';
  static const CODE_SHOW_MESSAGE = '400';
  static const CODE_ACTIVE_USER = '403';
  static const CODE_ERROR = '500';
  static const REQ_NOT_ALLOWED = "NotAllowed";
  static const REQ_DATA_RETURNED = "DataReturn";
  static const REQ_EMPTY_DATA = "EmptyData";
  static const REQ_FAILED = "failed";
  static const ExCEPTION = "Exception";

  static String BASE_URL="https://alefak.com/api/v1";
  static String GET_CATEGORIES_LIST="${BASE_URL}/categories";
  static String GET_SERVICE_PROVIDERS_LIST="${BASE_URL}/shops";
  static String GET_SERVICE_PROVIDER="${BASE_URL}/get-shop";
  static String GET_ADS_SLIDER="${BASE_URL}/ads";
  static String GET_REGIONS="${BASE_URL}/regions";
  static String LOGIN="${BASE_URL}/login";
  static String LOGOUT="${BASE_URL}/logout";
  static String REGISTER="${BASE_URL}/register";
  static String ACTIVE_ACCOUNT="${BASE_URL}/activate";
  static String GET_AUTH_CODE_TO_SET_PASSWORD="${BASE_URL}/get-code";
  static String FORGET_PASSWORD="${BASE_URL}/set-new-password";//used after GET_AUTH_CODE
  static String UPDATE_PROFILE="${BASE_URL}/update-profile";//used after GET_AUTH_CODE
  static String CHANGE_PASSWORD="${BASE_URL}/change-password";//used after GET_AUTH_CODE
  static String DELETE_ACCOUNT="${BASE_URL}/delete-account";//used after GET_AUTH_CODE
  static String CONTACT_US="${BASE_URL}/contact-us";
  static String REGISTER_SHOP="${BASE_URL}/register-shop";







  ///......... adoption...............................
  static String GET_ADOPTION_CATEGORIES="${BASE_URL}/sub-categories";
  static String GET_ADOPTION_ANIMALS="${BASE_URL}/animals";//?category_id=1
  static String ADD_ADOPTION_ANIMALS="${BASE_URL}/add-animal";
  static String GET_MY_ANIMALS="${BASE_URL}/my-animals";
  static String EDIT_ANIMAL="${BASE_URL}/update-animal/";
  static String DELETE_ANIMAL="${BASE_URL}/delete-animal/";




  ///....................fav.....................
  static String ADD_FAV="${BASE_URL}/add-fav";
  static String GET_FAV="${BASE_URL}/favs";
  ///................notification.............
  static String GET_NOTIFICATIONS="${BASE_URL}/new-notifications";
  ///.................static info......................

  static String GET_APP_INFO="${BASE_URL}/static_info";
  ///.............. CARTS..................................
  static String UPLOAD_CART_IMAGE="${BASE_URL}/upload-photo";
  static String ADD_CART="${BASE_URL}/add-card";
  static String USER_CART="${BASE_URL}/my-cards";
  static String USE_OFFER="${BASE_URL}/use-offer";
  static String SCAN_CODE="${BASE_URL}/scan-code";
  static String CHECK_COBON="${BASE_URL}/check-cobon";
  static String EDITE_CARD="${BASE_URL}/edit-card";
  static String DELETE_CARD="${BASE_URL}/delete-card";


}
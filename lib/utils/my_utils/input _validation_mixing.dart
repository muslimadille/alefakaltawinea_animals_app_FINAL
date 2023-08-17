
mixin InputValidationMixin {
  bool isFieldNotEmpty(String field) => field.isNotEmpty;
  bool isPhoneValide(String value)=>RegExp(r'(^(5)(5|0|3|6|4|9|1|8|7|2)([0-9]{7})$)').hasMatch(value);
  bool isPasswordValide(String value)=>value.length>=8;
  bool isTowFieldsMached(String value,String conf)=>value==conf;
  bool isEmailValide(String value)=>RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9-]+\.[a-zA-Z]+").hasMatch(value);


}
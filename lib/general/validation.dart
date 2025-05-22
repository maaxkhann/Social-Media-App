import 'package:social_media/utilities/pops.dart';

bool validateRegister(
  String image,
  String name,
  String email,
  String phoneNo,
  String position,
  String password,
  String confirmPassword,
) {
  if (image.isEmpty) {
    Pops.showError('please select profile image');
    return false;
  } else if (email.isEmpty) {
    Pops.showError('please fill email');
    return false;
  } else if (phoneNo.isEmpty) {
    Pops.showError('please fill phone number');
    return false;
  } else if (position.isEmpty) {
    Pops.showError('please fill position');
    return false;
  } else if (password.isEmpty) {
    Pops.showError('please fill password');
    return false;
  } else if (password != confirmPassword) {
    Pops.showError('Password not matched');
    return false;
  }
  return true;
}

bool validateLogin(String email, String password) {
  if (email.isEmpty) {
    Pops.showError('please fill email');
    return false;
  } else if (password.isEmpty) {
    Pops.showError('please fill password');
    return false;
  }
  return true;
}

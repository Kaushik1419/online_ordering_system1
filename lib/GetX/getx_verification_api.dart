import 'package:get/get.dart';

class VerificationController extends GetxController{
  RxString digitInputValue = "".obs;
  RxBool isLoading = true.obs;

  late String id = Get.arguments('userId');
  oook(){
    print(id);
  }
}
import 'package:get/get.dart';
import 'package:scanner/controllers/database_controller.dart';
import 'package:scanner/widgets/search_widget/search_controller.dart';
import 'controllers/home_controller.dart';

class HomeBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HomeController());
    Get.lazyPut(() => DataBaseController());
    Get.lazyPut(() => SearchController());
  }
}

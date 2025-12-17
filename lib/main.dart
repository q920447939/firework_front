import 'package:firework_front/config/server_config.dart';
import 'package:firework_front/core/widget/custom_safe_area/CustomSafeArea.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'core/theme/app_theme.dart';
import 'routes/app_routes.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

void main() async {
  await Hive.initFlutter();
  WidgetsFlutterBinding.ensureInitialized();
  // Add this line
  await ScreenUtil.ensureScreenSize();
  await EasyLocalization.ensureInitialized();
  await dotenv.load();
  //强制竖屏
  await SystemChrome.setPreferredOrientations(<DeviceOrientation>[
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then(
    (_) => runApp(
      CustomerSafeArea(
        child: AspectRatio(aspectRatio: 16 / 9, child: MyApp()),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final initSmartDialog = FlutterSmartDialog.init();
    double width = ServerConfig().width.toDouble();
    double height = ServerConfig().height.toDouble();
    //填入设计稿中设备的屏幕尺寸,单位dp
    return ScreenUtilInit(
      designSize: Size(width, height),
      builder: (context, child) {
        // 设置文案代理,国际化需要在MaterialApp初始化完成之后才生效,而且需要每次更新context
        /* TDTheme.setResourceBuilder((context) => delegate..updateContext(context),
          needAlwaysBuild: true);*/
        return MediaQuery(
          data: MediaQuery.of(
            context,
          ).copyWith(textScaler: TextScaler.linear(1.0)),
          child: GetMaterialApp.router(
            title: ServerConfig().appName,
            theme: AppTheme.lightTheme,
            routeInformationParser: AppRoutes.router.routeInformationParser,
            routerDelegate: AppRoutes.router.routerDelegate,
            routeInformationProvider: AppRoutes.router.routeInformationProvider,
            debugShowCheckedModeBanner: false,
            builder: initSmartDialog,
          ),
        );
      },
    );
  }
}

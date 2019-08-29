import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:fun_android/config/ui_adapter_config.dart';
import 'package:fun_android/config/storage_manager.dart';

import 'config/provider_manager.dart';
import 'config/router_config.dart';
import 'generated/i18n.dart';
import 'view_model/locale_model.dart';
import 'view_model/theme_model.dart';

main() async {
  Provider.debugCheckInvalidValueType = null;

  /// Flutter的master分支中,在使用'MethodChannel'之前
  /// 需要确保[WidgetsFlutterBinding]的初始化
  var widgetsBinding = InnerWidgetsFlutterBinding.ensureInitialized();

  /// 一些必备首选项的初始化
  await StorageManager.init();
  widgetsBinding
    ..attachRootWidget(App())
    ..scheduleWarmUpFrame();
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ///OKToast
    return OKToast(
        child: MultiProvider(
            providers: providers,
            child: Consumer2<ThemeModel, LocaleModel>(
                builder: (context, themeModel, localeModel, child) {
                  ///配置刷新
              return RefreshConfiguration(
                hideFooterWhenNotFull: true, //列表数据不满一页,不触发加载更多
                child: MaterialApp(
                  debugShowCheckedModeBanner: false,
                  theme: themeModel.themeData,
                  darkTheme: themeModel.darkTheme,
                  locale: localeModel.locale,
                  localizationsDelegates: const [
                    S.delegate,
                    GlobalCupertinoLocalizations.delegate,
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate
                  ],
                  supportedLocales: S.delegate.supportedLocales,
                  ///路由
                  onGenerateRoute: Router.generateRoute,
                  ///初始化路由
                  initialRoute: RouteName.splash,
                ),
              );
            })));
  }
}

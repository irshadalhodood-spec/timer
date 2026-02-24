import 'package:flutter/cupertino.dart';
import 'package:lottie/lottie.dart';

import '../../core/values/app_assets.dart';

class CustomLoading extends StatelessWidget {
  const CustomLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Lottie.asset(
          ThemeAssets.loading,
          height: 290,
          fit: BoxFit.scaleDown,
        );
  }
}
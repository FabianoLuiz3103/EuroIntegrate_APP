import 'package:eurointegrate_app/components/consts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

Widget progressSkin(double tamanho){
  return Center(
    child: SpinKitThreeBounce(
                    size: tamanho,
                    color: azulEuro,
                  ),
  );
}



Widget progressSkinIni(double tamanho){
  return Center(
    child: SpinKitThreeBounce(
                    size: tamanho,
                    color: Colors.white,
                  ),
  );
}
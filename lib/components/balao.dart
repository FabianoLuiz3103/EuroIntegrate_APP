import 'package:eurointegrate_app/components/consts.dart';
import 'package:flutter/material.dart';

class BalloonPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = azulEuro
      ..style = PaintingStyle.fill;

    final path = Path();

    // Desenha o balão (corpo retangular com cantos arredondados)
    path.addRRect(RRect.fromRectAndRadius(
      Rect.fromLTWH(1, 1, size.width, size.height - 20),
      Radius.circular(30),
    ));

    // Desenha a antena (triângulo apontando para baixo e para a direita)
    path.moveTo(size.width - 30, size.height - 20); // Ponto inicial
    path.lineTo(size.width - 20, size.height - 30); // Ponto superior direito do triângulo
    path.lineTo(size.width - 2, size.height - 15);  // Ponto inferior do triângulo
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

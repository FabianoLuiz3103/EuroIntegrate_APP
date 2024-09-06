import 'package:flutter/material.dart';

class CardGraficos extends StatelessWidget {
  const CardGraficos({
    super.key,
    this.title = '',
    this.subtitle = ''
  });
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 8, 18, 8),
      child: Container(
        width: MediaQuery.of(context).size.height * 0.95,
        height: MediaQuery.of(context).size.height * 0.15,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3), 
              spreadRadius: 5, 
              blurRadius: 10, 
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child:  Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Text(
                title,
                style: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 14),
              ),
            ),
            const SizedBox(height: 20),
             Center(child: Text(subtitle)),
          ],
        ),
      ),
    );
  }
}
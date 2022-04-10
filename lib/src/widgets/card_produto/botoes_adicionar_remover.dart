import 'package:flutter/material.dart';

class BotoesAdicionarRemoverProduto extends StatelessWidget {
  final VoidCallback onRemoverPressed;
  final VoidCallback onAdicionarPressed;

  const BotoesAdicionarRemoverProduto(
      {Key? key,
      required this.onRemoverPressed,
      required this.onAdicionarPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      runSpacing: 0,
      spacing: 0,
      children: <Widget>[
        IconButton(
          onPressed: onRemoverPressed,
          icon: Icon(
            Icons.remove_circle_outlined,
            color: Color.fromRGBO(220, 38, 38, 1),
            size: 25,
          ),
        ),
        SizedBox(
            child: SizedBox(
                width: 45,
                child: TextField(
                  textAlign: TextAlign.center,
                ))),
        IconButton(
          onPressed: onAdicionarPressed,
          icon: Icon(
            Icons.add_circle_outlined,
            color: Colors.green,
            size: 25,
          ),
        ),
      ],
    );
  }
}

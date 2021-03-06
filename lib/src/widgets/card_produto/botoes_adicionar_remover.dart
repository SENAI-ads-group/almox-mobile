import 'package:flutter/material.dart';

class BotoesAdicionarRemoverProduto extends StatelessWidget {
  final VoidCallback onRemoverPressed;
  final VoidCallback onAdicionarPressed;
  final TextField? quantidadeTextField;
  final bool enabled;

  const BotoesAdicionarRemoverProduto({
    Key? key,
    required this.onRemoverPressed,
    required this.onAdicionarPressed,
    this.quantidadeTextField,
    this.enabled = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      runSpacing: 0,
      spacing: 0,
      children: <Widget>[
        if (enabled)
          IconButton(
            onPressed: onRemoverPressed,
            icon: Icon(
              Icons.remove_circle_outlined,
              color: Color.fromRGBO(220, 38, 38, 1),
              size: 25,
            ),
          ),
        SizedBox(child: SizedBox(width: 65, child: quantidadeTextField)),
        if (enabled)
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

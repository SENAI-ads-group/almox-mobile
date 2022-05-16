import 'package:almox_mobile/src/model/requisicao_model.dart';
import 'package:almox_mobile/src/model/status_requisicao.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CardRequisicao extends StatelessWidget {
  final RequisicaoModel requisicao;

  const CardRequisicao({Key? key, required this.requisicao}) : super(key: key);

  Widget? _iconeStatus() {
    switch (requisicao.status) {
      case StatusRequisicao.AGUARDANDO_ATENDIMENTO:
        return _IconeStatusRequisicao(
          backgroundColor: Colors.grey.shade500.withOpacity(0.2),
          iconData: Icons.more_time,
          color: Colors.grey.shade700,
        );
      case StatusRequisicao.EM_ATENDIMENTO:
        return _IconeStatusRequisicao(
          backgroundColor: Colors.orangeAccent.withOpacity(0.2),
          iconData: Icons.timelapse_rounded,
          color: Colors.orangeAccent,
        );
      case StatusRequisicao.ENTREGUE:
        return _IconeStatusRequisicao(
          backgroundColor: Color.fromRGBO(200, 230, 201, 1),
          iconData: Icons.check,
          color: Color.fromRGBO(37, 96, 41, 1),
        );
      case StatusRequisicao.CANCELADA:
        return _IconeStatusRequisicao(
          backgroundColor: Colors.red.withOpacity(0.2),
          iconData: Icons.block,
          color: Colors.red,
        );
      default:
        return null;
    }
  }

  bool _podeCancelarRequisicao() => requisicao.status != StatusRequisicao.CANCELADA && requisicao.status != StatusRequisicao.ENTREGUE;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(15)),
        side: BorderSide(color: Color.fromRGBO(226, 229, 234, 1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                onTap: () => Navigator.of(context).pushNamed('/atenderRequisicao', arguments: requisicao),
                leading: _iconeStatus(),
                title: Text(
                  requisicao.departamento.descricao,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(DateFormat("dd 'de' MMMM 'de' y").format(requisicao.dataRequisicao)),
                    Text(requisicao.almoxarife.pessoa.nome),
                  ],
                ),
              ),
            ),
          ),
          if (_podeCancelarRequisicao())
            InkWell(
              onTap: () {},
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        height: 40,
                        width: 40,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.2),
                            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15), topRight: Radius.circular(15)),
                          ),
                          child: Padding(
                              padding: EdgeInsets.all(4),
                              child: Icon(
                                Icons.block_outlined,
                                size: 25,
                                color: Colors.red,
                              )),
                        ),
                      )
                    ],
                  )
                ],
              ),
            )
        ],
      ),
    );
  }
}

class _IconeStatusRequisicao extends StatelessWidget {
  final Color backgroundColor;
  final Color color;
  final IconData iconData;

  const _IconeStatusRequisicao({
    Key? key,
    required this.backgroundColor,
    required this.color,
    required this.iconData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Icon(
        iconData,
        color: color,
        size: 30,
      ),
    );
  }
}

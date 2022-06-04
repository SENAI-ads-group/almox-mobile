import 'package:almox_mobile/src/model/requisicao_model.dart';
import 'package:almox_mobile/src/model/status_requisicao.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../model/operador_model.dart';

class CardRequisicao extends StatelessWidget {
  final RequisicaoModel requisicao;
  final GestureTapCallback? onTap;
  final OperadorModel? operadorLogado;

  const CardRequisicao({
    Key? key,
    required this.requisicao,
    this.onTap,
    this.operadorLogado,
  }) : super(key: key);

  Widget? IconeStatus() {
    switch (requisicao.status) {
      case StatusRequisicao.AGUARDANDO_ATENDIMENTO:
        return IconeStatusRequisicao(
          backgroundColor: Colors.grey.shade500.withOpacity(0.2),
          iconData: Icons.more_time,
          color: Colors.grey.shade700,
        );
      case StatusRequisicao.EM_ATENDIMENTO:
        return IconeStatusRequisicao(
          backgroundColor: Colors.orangeAccent.withOpacity(0.2),
          iconData: Icons.timelapse_rounded,
          color: Colors.orangeAccent,
        );
      case StatusRequisicao.ENTREGUE:
        return IconeStatusRequisicao(
          backgroundColor: Color.fromRGBO(200, 230, 201, 1),
          iconData: Icons.check,
          color: Color.fromRGBO(37, 96, 41, 1),
        );
      case StatusRequisicao.CANCELADA:
        return IconeStatusRequisicao(
          backgroundColor: Colors.red.withOpacity(0.2),
          iconData: Icons.block,
          color: Colors.red,
        );
      case StatusRequisicao.AGUARDANDO_RECEBIMENTO:
        return IconeStatusRequisicao(
          backgroundColor: Colors.yellow.shade600.withOpacity(0.2),
          iconData: Icons.timer_outlined,
          color: Colors.yellow.shade600,
        );
      default:
        return null;
    }
  }

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
                onTap: onTap,
                leading: IconeStatus(),
                title: Text(
                  requisicao.departamento.descricao,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(DateFormat("dd 'de' MMMM 'de' y")
                        .format(requisicao.dataRequisicao)),
                    if (operadorLogado == null)
                      Text(
                        '${requisicao.requisitante.pessoa.nome} -> ${requisicao.almoxarife.pessoa.nome}',
                      )
                    else
                      operadorLogado!.id == requisicao.almoxarife.id
                          ? Text(
                              'Requisitante: ${requisicao.requisitante.pessoa.nome}',
                            )
                          : Text(
                              'Almoxarife: ${requisicao.almoxarife.pessoa.nome}',
                            )
                  ],
                ),
              ),
            ),
          ),
          if (operadorLogado != null)
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
                            color:
                                operadorLogado!.id == requisicao.almoxarife.id
                                    ? Colors.pinkAccent.withOpacity(0.2)
                                    : Colors.blue.withOpacity(0.2),
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(15),
                                topRight: Radius.circular(15)),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(4),
                            child:
                                operadorLogado!.id == requisicao.almoxarife.id
                                    ? Icon(
                                        Icons.call_received_outlined,
                                        size: 20,
                                        color: Colors.pinkAccent,
                                      )
                                    : Icon(
                                        Icons.call_made_outlined,
                                        size: 20,
                                        color: Colors.blue.shade700,
                                      ),
                          ),
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

class IconeStatusRequisicao extends StatelessWidget {
  final Color backgroundColor;
  final Color color;
  final IconData iconData;

  const IconeStatusRequisicao({
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

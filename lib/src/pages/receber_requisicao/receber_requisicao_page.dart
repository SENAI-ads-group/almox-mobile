import 'dart:io';

import 'package:almox_mobile/src/almox_app_theme.dart';
import 'package:almox_mobile/src/bloc/receber_requisicao/receber_requisicao_cubit.dart';
import 'package:almox_mobile/src/bloc/receber_requisicao/receber_requisicao_state.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class ReceberRequisicaoPage extends StatelessWidget {
  const ReceberRequisicaoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ReceberRequisicaoCubit(),
      child: const ReceberRequisicaoView(),
    );
  }
}

class ReceberRequisicaoView extends StatefulWidget {
  const ReceberRequisicaoView({Key? key}) : super(key: key);

  @override
  State<ReceberRequisicaoView> createState() => _ReceberRequisicaoViewState();
}

class _ReceberRequisicaoViewState extends State<ReceberRequisicaoView> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  final _textFormFieldController = TextEditingController();

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ReceberRequisicaoCubit, ReceberRequisicaoState>(
      listenWhen: (previous, current) =>
          previous.erro != current.erro ||
          previous.requisicaoConfirmada != current.requisicaoConfirmada,
      listener: (context, state) {
        if (state.requisicaoConfirmada) {
          ScaffoldMessenger.of(context)
            ..removeCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text('Reebimento Confirmado'),
                    Icon(Icons.check)
                  ],
                ),
                backgroundColor: Colors.green,
              ),
            );
          Navigator.of(context).pop();
        }
        if (state.erro) {
          ScaffoldMessenger.of(context)
            ..removeCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [Text('Códidgo inválido'), Icon(Icons.error)],
                ),
                backgroundColor: Colors.red,
              ),
            );
        }
      },
      child: BlocBuilder<ReceberRequisicaoCubit, ReceberRequisicaoState>(
          builder: (context, state) {
        final receberRequisicaoCubit = context.read<ReceberRequisicaoCubit>();

        return Scaffold(
          backgroundColor: AlmoxAppTheme.background,
          appBar: AppBar(
            title: Text('Receber Requisição'),
          ),
          body: Stack(
            children: [
              Column(
                children: <Widget>[
                  if (TipoLeitura.camera == state.tipoLeitura)
                    Expanded(
                      flex: 4,
                      child: QRView(
                        key: qrKey,
                        onQRViewCreated: (QRViewController controller) {
                          this.controller = controller;
                          controller.resumeCamera();
                          controller.scannedDataStream.listen((scanData) {
                            if (scanData.code != state.codigo) {
                              receberRequisicaoCubit.setCodigo(
                                  codigo: scanData.code, confirmar: false);
                            }
                          });
                        },
                      ),
                    )
                  else
                    Padding(
                      padding: EdgeInsets.all(20),
                      child: Card(
                        child: Form(
                          child: Padding(
                            padding: EdgeInsets.all(20),
                            child: Column(
                              children: [
                                TextField(
                                  controller: _textFormFieldController,
                                  onSubmitted: (value) {
                                    receberRequisicaoCubit.setCodigo(
                                      codigo: value,
                                    );
                                  },
                                  decoration: const InputDecoration(
                                    labelText: "Código de Confirmação",
                                    border: OutlineInputBorder(),
                                    labelStyle: TextStyle(
                                      color: Colors.black38,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 50),
                                SizedBox(
                                  height: 40,
                                  width: 300,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      receberRequisicaoCubit.setCodigo(
                                        codigo: _textFormFieldController.text,
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      shadowColor: Colors.transparent,
                                    ),
                                    child: Text(
                                      'Confirmar',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 10),
                                SizedBox(
                                  height: 40,
                                  width: 300,
                                  child: ElevatedButton(
                                    onPressed: state.carregando
                                        ? null
                                        : () {
                                            receberRequisicaoCubit.tipoLeitura =
                                                TipoLeitura.camera;
                                            controller!.resumeCamera();
                                          },
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.grey.shade700,
                                    ),
                                    child: Text(
                                      'Ler QR Code',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  if (TipoLeitura.camera == state.tipoLeitura)
                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: EdgeInsets.only(top: 20),
                        child: Column(
                          children: [
                            Center(
                              child: (state.codigo != null)
                                  ? Text(
                                      '${state.codigo}',
                                      style: TextStyle(fontSize: 18),
                                    )
                                  : Text(
                                      'Aguardando leitura de QR Code...',
                                      style: TextStyle(fontSize: 18),
                                    ),
                            ),
                            SizedBox(height: 20),
                            SizedBox(
                              height: 40,
                              width: 200,
                              child: ElevatedButton(
                                onPressed: state.codigo != null
                                    ? () {
                                        receberRequisicaoCubit.setCodigo(
                                            codigo: state.codigo!);
                                      }
                                    : () {
                                        controller!.pauseCamera();
                                        receberRequisicaoCubit.tipoLeitura =
                                            TipoLeitura.input;
                                      },
                                style: ElevatedButton.styleFrom(
                                  primary: state.codigo != null
                                      ? Theme.of(context).primaryColor
                                      : Colors.grey.shade700,
                                ),
                                child: Text(
                                  state.codigo != null
                                      ? 'Confirmar'
                                      : 'Digitar manualmente',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            SizedBox(
                              height: 40,
                              width: 200,
                              child: ElevatedButton(
                                onPressed: state.carregando
                                    ? null
                                    : Navigator.of(context).pop,
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.red,
                                  shadowColor: Colors.transparent,
                                ),
                                child: Text(
                                  'Cancelar',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                ],
              ),
              if (state.carregando)
                Container(
                  alignment: AlignmentDirectional.center,
                  decoration: BoxDecoration(
                    color: Colors.white70,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(10.0)),
                    width: 300.0,
                    height: 200.0,
                    alignment: AlignmentDirectional.center,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Center(
                          child: SizedBox(
                            height: 50.0,
                            width: 50.0,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              value: null,
                              strokeWidth: 7.0,
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 25.0),
                          child: Center(
                            child: Text(
                              "carregando... aguarde...",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        );
      }),
    );
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}

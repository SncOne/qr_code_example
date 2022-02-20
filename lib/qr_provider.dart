import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final qrProvider = ChangeNotifierProvider(
  (_) => QrCodeProvider(),
);

class QrCodeProvider extends ChangeNotifier {
  QrCodeProvider() : super();

  final box = Hive.box('');

  String? qrData;

  List createdQrs = [];
  List scannedQrs = [];

  void getQrs() {
    createdQrs = box.get('createdQrList') ?? [];
    scannedQrs = box.get('scannedQrList') ?? [];
  }

  Future<void> createQr(String data) async {
    List tempList = box.get('createdQrList') ?? [];
    box.put('createdQrList', [...tempList, data]);
    createdQrs.add(data);
  }

  Future<void> scanQr(String data) async {
    List tempList = box.get('scannedQrList') ?? [];
    box.put('scannedQrList', [...tempList, data]);
    scannedQrs.add(data);
  }
}

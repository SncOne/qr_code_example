import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'qr_provider.dart';

class HomePage extends HookConsumerWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final index = useState(0);
    final tabController = useTabController(initialLength: 2);
    final qrdata = useTextEditingController();
    tabController.addListener(() => index.value = tabController.index);
    final qrData = ref.watch(qrProvider.notifier);
    useEffect(() {
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        qrData.getQrs();
      });
      return () {};
    }, []);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Spacer(),
              index.value == 1
                  ? CupertinoButton(
                      child: const Text('Create Qr'),
                      onPressed: () => showDialog(
                        context: context,
                        builder: (context) {
                          return Dialog(
                            elevation: 0,
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Text('Your Qr Data'),
                                  const SizedBox(height: 20),
                                  TextField(
                                      controller: qrdata, autofocus: true),
                                  const SizedBox(height: 20),
                                  CupertinoButton(
                                    child: const Text('Create Qr'),
                                    onPressed: () {
                                      qrData.qrData = qrdata.text;
                                      Navigator.pushNamed(context, '/CreateQr');
                                    },
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    )
                  : CupertinoButton(
                      child: const Text('Scan Qr'),
                      onPressed: () => Navigator.pushNamed(context, '/ScanQr'),
                    )
            ],
          ),
          bottom: TabBar(
            controller: tabController,
            isScrollable: true,
            indicatorWeight: 4,
            indicatorSize: TabBarIndicatorSize.label,
            indicatorColor: Colors.blue,
            unselectedLabelColor: Colors.grey,
            labelColor: Colors.black87,
            tabs: const [
              Tab(text: 'Scans'),
              Tab(text: 'Createds'),
            ],
          ),
        ),
        body: TabBarView(
          controller: tabController,
          children: [
            qrData.scannedQrs.isEmpty
                ? const Center(
                    child: Text("There isn't any scanned Qr's yet."),
                  )
                : ListView.builder(
                    itemCount: qrData.scannedQrs.length,
                    itemBuilder: (_, i) => GestureDetector(
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              QrImage(
                                data: qrData.scannedQrs[i],
                                size: 75,
                                backgroundColor: Colors.white,
                                version: QrVersions.auto,
                              ),
                              Text(qrData.scannedQrs[i]),
                            ],
                          ),
                        ),
                      ),
                      onTap: () {
                        qrData.qrData = qrData.scannedQrs[i];
                        Navigator.pushNamed(context, '/CreateQr');
                      },
                    ),
                  ),
            qrData.createdQrs.isEmpty
                ? const Center(
                    child: Text("There isn't any created Qr's yet."),
                  )
                : ListView.builder(
                    itemCount: qrData.createdQrs.length,
                    itemBuilder: (_, i) => GestureDetector(
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              QrImage(
                                data: qrData.createdQrs[i],
                                size: 75,
                                backgroundColor: Colors.white,
                                version: QrVersions.auto,
                              ),
                              Text(qrData.createdQrs[i]),
                            ],
                          ),
                        ),
                      ),
                      onTap: () {
                        qrData.qrData = qrData.createdQrs[i];
                        Navigator.pushNamed(context, '/CreateQr');
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}

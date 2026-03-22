import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:habit_boost/core/sync/sync_service.dart';
import 'package:habit_boost/core/utils/app_logger.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class ConnectivityListener {
  ConnectivityListener(this._connectivity, this._syncService);

  final Connectivity _connectivity;
  final SyncService _syncService;

  StreamSubscription<List<ConnectivityResult>>? _subscription;
  bool _wasOffline = false;

  void start() {
    _subscription = _connectivity.onConnectivityChanged.listen((results) {
      final isOffline = results.contains(ConnectivityResult.none);
      if (_wasOffline && !isOffline) {
        log.i('Connectivity restored — flushing sync queue');
        _syncService.flushQueue();
      }
      _wasOffline = isOffline;
    });
  }

  void stop() {
    _subscription?.cancel();
    _subscription = null;
  }
}

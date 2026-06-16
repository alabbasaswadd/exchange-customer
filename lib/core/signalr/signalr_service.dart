import 'package:signalr_netcore/signalr_client.dart';

class SignalRService {
  HubConnection? _connection;

  static const String _baseUrl =
      'https://shamcash.runasp.net/currency-exchange-api';

  Future<void> connect(String token, String role) async {
    try {
      final hubUrl = _hubUrlForRole(role);
      if (hubUrl == null) {
        print('SignalR: unknown role "$role", skipping connection');
        return;
      }

      _connection = HubConnectionBuilder()
          .withUrl(
            hubUrl,
            options: HttpConnectionOptions(
              transport: HttpTransportType.WebSockets,
              accessTokenFactory: () async => token,
            ),
          )
          .withAutomaticReconnect()
          .build();

      _connection!.onreconnecting(({Exception? error}) {
        print('SignalR reconnecting: $error');
      });

      _connection!.onreconnected(({String? connectionId}) {
        print('SignalR reconnected: connectionId=$connectionId');
      });

      _registerHandlers(role);

      await _connection!.start();
      print('SignalR connected: $hubUrl');
    } catch (e) {
      print('SignalR connection error: $e');
    }
  }

  Future<void> disconnect() async {
    if (_connection != null) {
      await _connection!.stop();
      _connection = null;
    }
    print('SignalR disconnected');
  }

  String? _hubUrlForRole(String role) {
    switch (role) {
      case '0':
        return '$_baseUrl/hubs/customer';
      case '1':
        return '$_baseUrl/hubs/cashier';
      case '2':
        return '$_baseUrl/hubs/notifications';
      default:
        return null;
    }
  }

  void _registerHandlers(String role) {
    switch (role) {
      case '0':
        _on('ExchangeRequestCreated');
        _on('ExchangeRequestApproved');
        _on('ExchangeRequestRejected');
        _on('WalletBalanceUpdated');
        break;
      case '1':
        _on('NewExchangeRequest');
        _on('ExchangeRequestAssigned');
        _on('ExchangeRequestCompleted');
        break;
      case '2':
        _on('SystemNotification');
        _on('UserCreated');
        _on('ExchangeRequestAudited');
        _on('ReceiveNotification');
        break;
    }
  }

  void _on(String event) {
    _connection!.on(event, (List<Object?>? args) {
      print('SignalR [$event]: ${args?.isNotEmpty == true ? args![0] : null}');
    });
  }
}

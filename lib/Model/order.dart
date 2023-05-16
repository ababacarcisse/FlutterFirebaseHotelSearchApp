import 'package:google_maps_flutter/google_maps_flutter.dart';

class Command {
  final String taxiID;
  final String customerID;
  final String clientName;
  final String TaxiName;
  final DateTime timestamp;
  final String destination;
  String status;
  String commandID;
  Command(
      {required this.taxiID,
      required this.customerID,
      required this.timestamp,
      required this.clientName,
      required this.commandID,
      required this.destination,
      this.status = 'en attente', // ini
      required this.TaxiName});

  Map<String, dynamic> toMap() {
    return {
      'taxiID': taxiID,
      'customerID': customerID,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}

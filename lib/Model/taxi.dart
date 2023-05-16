import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter_platform_interface/src/types/location.dart';

class Taxi {
  String? taxiID, taxiName, taxiUrlImg, taxiUserID, taxiUserName;
  LatLng initialPosition;
  Timestamp? taxiTimestamp;
  Taxi(
      {required this.taxiID,
      required this.taxiName,
      required this.taxiUrlImg,
      required this.taxiUserID,
      required this.taxiUserName,
      required this.taxiTimestamp,
      required this.initialPosition});
}

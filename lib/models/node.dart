import 'dart:ui' show Offset;
import 'package:uuid/uuid.dart';

class Node {
  String id = Uuid().v4();
  Offset position;

  Node(this.position);
}
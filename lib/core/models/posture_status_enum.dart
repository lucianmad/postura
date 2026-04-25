import 'package:flutter/material.dart';

enum PostureStatus {
  ok(Colors.green, 'Posture OK'),
  fhp(Colors.red, 'FHP'),
  slouching(Colors.red, 'Slouching'),
  asymmetricShoulders(Colors.red, 'Asymmetric Shoulders'),
  headTilted(Colors.red, 'Head Tilted'),
  headTurned(Colors.yellow, 'Head Turned'),
  lookingDown(Colors.yellow, 'Looking Down'),
  uncalibrated(Colors.grey, 'Uncalibrated'),
  searching(Colors.grey, 'Searching'),
  idle(Colors.grey, 'Idle'),
  unknown(Colors.black, 'Unknown');

  const PostureStatus(this.color, this.status);
  final Color color;
  final String status;

  static PostureStatus fromString(String rawStatus) {
    return _statusMap[rawStatus.trim()] ?? unknown;
  }

  static const _statusMap = {
    'Posture OK': ok,
    'FHP': fhp,
    'SLOUCHING': slouching,
    'ASYMMETRIC SHOULDERS': asymmetricShoulders,
    'HEAD TILTED': headTilted,
    'HEAD TURNED': headTurned,
    'LOOKING DOWN': lookingDown,
    'UNCALIBRATED': uncalibrated,
    'SEARCHING': searching,
    'IDLE': idle,
  };
}

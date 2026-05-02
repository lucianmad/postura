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

  const PostureStatus(this.color, this.displayName);
  final Color color;
  final String displayName;

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

  PostureCategory get category {
    switch (this) {
      case PostureStatus.ok:
        return PostureCategory.good;
      case PostureStatus.fhp:
      case PostureStatus.slouching:
      case PostureStatus.asymmetricShoulders:
      case PostureStatus.headTilted:
        return PostureCategory.bad;
      case PostureStatus.headTurned:
      case PostureStatus.lookingDown:
        return PostureCategory.informational;
      case PostureStatus.uncalibrated:
      case PostureStatus.searching:
      case PostureStatus.idle:
      case PostureStatus.unknown:
        return PostureCategory.neutral;
    }
  }
}

enum PostureCategory { good, bad, informational, neutral }

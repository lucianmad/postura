import 'package:flutter/material.dart';
import 'package:postura/core/theme/app_theme.dart';

enum PostureStatus {
  ok(AppColors.good, 'Posture OK'),
  fhp(AppColors.bad, 'FHP'),
  slouching(AppColors.bad, 'Slouching'),
  asymmetricShoulders(AppColors.bad, 'Asymmetric Shoulders'),
  headTilted(AppColors.bad, 'Head Tilted'),
  headTurned(AppColors.info, 'Head Turned'),
  lookingDown(AppColors.info, 'Looking Down'),
  uncalibrated(AppColors.neutral, 'Uncalibrated'),
  searching(AppColors.neutral, 'Searching'),
  idle(AppColors.neutral, 'Idle'),
  unknown(AppColors.background, 'Unknown');

  const PostureStatus(this.color, this.displayName);
  final Color color;
  final String displayName;

  static PostureStatus fromString(String rawStatus) {
    final trimmed = rawStatus.trim();
    final fromMap = _statusMap[trimmed];
    if (fromMap != null) return fromMap;

    final result = PostureStatus.values.firstWhere(
      (s) => s.name.toLowerCase() == trimmed.toLowerCase(),
      orElse: () => unknown,
    );
    return result;
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

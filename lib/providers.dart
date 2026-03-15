import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:postura/core/models/posture_state.dart';

final postureStateProvider = StreamProvider<PostureState>((ref) {
  final postureStream = FirebaseDatabase.instance
      .ref('devices/pi_desk_001/current_state')
      .onValue
      .map((event) {
        final map =
            (event.snapshot.value ?? {'status': 'SEARCHING', 'timestamp': 0})
                as Map<Object?, Object?>;
        final castedMap = map.cast<String, dynamic>();
        return PostureState.fromMap(castedMap);
      });

  return postureStream;
});

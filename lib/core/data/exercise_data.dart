import 'package:postura/core/models/exercise.dart';
import 'package:postura/core/models/posture_status_enum.dart';

const Map<PostureStatus, List<Exercise>> exerciseData = {
  PostureStatus.fhp: [
    Exercise(
      name: 'Chin Tucks',
      description:
          'Place 2 fingers at the bottom of your chin.\n\n'
          'Gently tuck your chin in and retract your head backwards, '
          'keeping your fingers in contact with your chin throughout.\n\n'
          'Hold the end position for 3 to 5 seconds, then relax.\n\n'
          'Aim for 2 to 3 sets of 10 repetitions.',
    ),
    Exercise(
      name: 'One Arm Pec Stretch',
      description:
          'Stand close to a wall and stretch one arm behind you with the palm flat on the wall.\n\n'
          'Pull in your stomach without arching your back.\n\n'
          'Lean forward and slightly away from the extended arm until you feel a stretch in your chest.\n\n'
          'Hold for 30 seconds, then repeat on the other side.',
    ),
  ],
  PostureStatus.slouching: [
    Exercise(
      name: 'Doorway Stretch',
      description:
          'Stand inside a doorway and bend your right arm at a 90-degree angle, '
          'placing your forearm against the doorframe at shoulder height.\n\n'
          'Rotate your chest to the left until you feel a stretch in your chest and front shoulder.\n\n'
          'Hold for 30 seconds, then repeat with the opposite arm.',
    ),
    Exercise(
      name: 'Thoracic Extension',
      description:
          'Sit upright in your chair and clasp your hands behind your head.\n\n'
          'Gently arch your upper back over the back of the chair, opening your chest toward the ceiling.\n\n'
          'Hold for 10 seconds, then return to the upright position.\n\n'
          'Repeat 5 times.',
    ),
  ],
  PostureStatus.asymmetricShoulders: [
    Exercise(
      name: 'Lateral Neck Stretch',
      description:
          'Sit or stand with your head and neck in a straight line.\n\n'
          'Tilt your head toward one shoulder until you feel a stretch on the opposite side.\n\n'
          'Optionally use your hand to gently increase the stretch.\n\n'
          'Hold for 30 seconds, then repeat on the other side.',
    ),
    Exercise(
      name: 'Shoulder Blade Squeezes',
      description:
          'Stand or sit upright with your arms alongside your body.\n\n'
          'Squeeze your shoulder blades together and downward.\n\n'
          'Hold for a few seconds, then release slowly.\n\n'
          'Do 2 to 3 sets of 10 repetitions.',
    ),
  ],
  PostureStatus.headTilted: [
    Exercise(
      name: 'Lateral Neck Stretch',
      description:
          'Sit upright and relax your shoulders.\n\n'
          'Tilt your ear toward your shoulder until you feel a stretch on the opposite side of your neck.\n\n'
          'Hold for 20 seconds, then return to centre.\n\n'
          'Repeat on the other side.',
    ),
    Exercise(
      name: 'Upper Trapezius Stretch',
      description:
          'Sit upright and drop one shoulder downward.\n\n'
          'Tilt your head toward the opposite side until you feel a stretch along the top of your shoulder.\n\n'
          'Hold for 20 seconds, then repeat on the other side.',
    ),
  ],
  PostureStatus.headTurned: [
    Exercise(
      name: 'Neck Rotation',
      description:
          'Sit or stand upright with your shoulders relaxed.\n\n'
          'Slowly turn your head to one side as far as is comfortable.\n\n'
          'Hold for 2 seconds, then return to centre and repeat on the other side.\n\n'
          'Do 10 repetitions on each side.',
    ),
    Exercise(
      name: 'SCM Stretch',
      description:
          'Sit upright and turn your head away from the tight side.\n\n'
          'Look slightly upward until you feel a stretch along the front and side of your neck.\n\n'
          'Hold for 20 seconds, then repeat on the other side.',
    ),
  ],
  PostureStatus.lookingDown: [
    Exercise(
      name: 'Chin Tuck with Extension',
      description:
          'Sit upright and gently tuck your chin toward your chest.\n\n'
          'Then slowly look up toward the ceiling, keeping your shoulders relaxed.\n\n'
          'Hold for 5 seconds at the top, then return slowly.\n\n'
          'Do 10 repetitions.',
    ),
    Exercise(
      name: 'Neck Extension Stretch',
      description:
          'Sit upright with your shoulders relaxed.\n\n'
          'Slowly tilt your head backward, looking up at the ceiling.\n\n'
          'Hold for 10 seconds, then return slowly to the starting position.\n\n'
          'Do 5 repetitions.',
    ),
  ],
};

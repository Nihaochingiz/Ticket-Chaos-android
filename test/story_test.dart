import 'package:flutter_test/flutter_test.dart';
import 'package:ticket_hell/main.dart';

void main() {
  test('story contains several endings', () {
    expect(
      scenes.values.where((scene) => scene.ending).length,
      greaterThanOrEqualTo(5),
    );
  });

  test('every choice points to an existing scene', () {
    for (final scene in scenes.values) {
      for (final choice in scene.choices) {
        expect(
          scenes.containsKey(choice.next),
          isTrue,
          reason: '${scene.id} -> ${choice.next}',
        );
      }
    }
  });
}

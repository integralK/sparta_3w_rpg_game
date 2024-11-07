// test 패키지와 Character 클래스를 import 합니다.
import 'package:test/test.dart';
import 'package:sparta_3w_rpg_game/character.dart';
import 'package:sparta_3w_rpg_game/monster.dart';

void main() {
  // 그룹으로 테스트를 정리할 수 있다.
  group('Character 클래스 테스트', () {
    test('캐릭터 생성 테스트', () {
      // Character 객체를 생성하고 초기 값을 확인합니다.
      final character = Character('Hero', 100, 20, 10);

      // 캐릭터 이름, 체력, 공격력, 방어력이 올바른지 테스트합니다.
      expect(character.name, 'Hero');
      expect(character.health, 100);
      expect(character.attack, 20);
      expect(character.defense, 10);
    });

    test('공격 메서드 테스트', () {
      // Character와 가상의 Monster 객체 생성
      final character = Character('Hero', 100, 20, 10);
      final monster = Monster('Goblin', 50, 15);

      // 캐릭터가 몬스터를 공격하는 기능 테스트
      character.attackMonster(monster);

      // 공격 후 몬스터의 체력이 감소했는지 확인
      expect(monster.health, lessThan(50));
    });

    test('방어 메서드 테스트', () {
      final character = Character('Hero', 100, 20, 10);

      // 방어 메서드 호출 전후의 체력 확인
      int initialHealth = character.health;
      character.defend(5);

      // 방어 후 체력이 증가했는지 확인
      expect(character.health, greaterThan(initialHealth));
    });
  });
}

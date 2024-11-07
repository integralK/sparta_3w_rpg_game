import 'dart:io'; // 'dart:io' 라이브러리를 사용하여 파일 입출력 및 사용자 입력 처리
import 'package:sparta_3w_rpg_game/game.dart'; // 'Game' 클래스 (게임 로직 담당)
import 'package:sparta_3w_rpg_game/character.dart'; // 'Character' 클래스 (캐릭터 속성 및 행동)
import 'package:sparta_3w_rpg_game/monster.dart';

void main() {
  // 사용자로부터 캐릭터 이름 입력 받기
  stdout.write("캐릭터의 이름을 입력하세요: ");
  String name = stdin.readLineSync() ?? "";

  Character character = loadCharacter(name); // 캐릭터 스탯 파일을 읽고 캐릭터 생성
  List<Monster> monsters = loadMonsters(); // 몬스터 리스트 생성
  Game game = Game(character, monsters); // 게임 객체 생성

  // 게임 시작
  game.startGame();
}

// 캐릭터 스탯 파일에서 읽어오기 메서드
Character loadCharacter(String name) {
  try {
    final file = File('data/characters.txt');
    final contents = file.readAsStringSync();
    final stats = contents.split(',');

    if (stats.length != 3) throw FormatException('Invalid character data');

    int health = int.parse(stats[0]); // 첫 번째 값은 체력
    int attack = int.parse(stats[1]); // 두 번째 값은 공격력
    int defense = int.parse(stats[2]); // 세 번째 값은 방어력

    return Character(name, health, attack,
        defense); // 불러온 데이터를 기반으로 Character 객체 생성 (character 객체반환)
  } catch (e) {
    print('캐릭터 데이터를 불러오는 데 실패했습니다: $e\n');
    exit(1); // 오류 발생 시 프로그램 종료
  }
}

// 파일에서 몬스터 스탯 불러오기 메서드
List<Monster> loadMonsters() {
  List<Monster> monsters = [];

  try {
    final file = File('data/monsters.txt');
    final contents = file.readAsLinesSync();

    for (var line in contents) {
      // 각 줄마다 데이터를 읽어서 처리한다.
      if (line.trim().isEmpty) continue; // 빈 줄은 건너뜀

      final stats = line.split(','); // CSV 형식으로 구분된 데이터를 분리한다.
      if (stats.length != 3) throw FormatException('Invalid character data');

      String name = stats[0]; // 첫 번째 값은 이름
      int health = int.parse(stats[1]); // 두 번째 값은 체력
      int maxAttack = int.parse(stats[2]); // 세 번째 값은 최대 공격력

      monsters.add(Monster(
          name, health, maxAttack)); // 읽어온 데이터를 기반으로 Monster 객체 생성 후 리스트에 추가
    }

    return monsters; // 몬스터 리스트 반환
  } catch (e) {
    print('몬스터 데이터를 불러오는 데 실패했습니다: $e\n');
    exit(1); // 오류 발생 시 프로그램 종료
  }
}

import 'dart:io'; // 'dart:io' 라이브러리를 사용하여 파일 입출력 및 사용자 입력 처리
import 'package:sparta_3w_rpg_game/game.dart'; // 'Game' 클래스 (게임 로직 담당)
import 'package:sparta_3w_rpg_game/character.dart'; // 'Character' 클래스 (캐릭터 속성 및 행동)
import 'package:sparta_3w_rpg_game/monster.dart';

void main() {
  String name = getValidCharacterName(); // 사용자로부터 유효한 캐릭터 이름을 입력받기

  Character character = loadCharacter(name); // 캐릭터 스탯 파일을 읽고 캐릭터 생성
  List<Monster> monsters = loadMonsters(); // 몬스터 리스트 생성
  Game game = Game(character, monsters); // 게임 객체 생성

  // 게임 시작
  game.startGame();
}

// 유효한 캐릭터 이름을 입력받는 함수
String getValidCharacterName() {
  // 사용자가 유효한 이름을 입력할 때까지 반복해서 입력을 받는다.
  RegExp nameRegExp = RegExp(r'^[a-zA-Z가-힣]+$'); // 한글, 영문 대소문자만 허용하는 정규표현식
  String name;

  while (true) {
    stdout.write("캐릭터의 이름을 입력하세요: ");
    name = stdin.readLineSync() ?? "";

    if (name.isEmpty) {
      print("이름은 빈 문자열일 수 없습니다. 다시 입력해주세요.");
    } else if (!nameRegExp.hasMatch(name)) {
      print("이름에는 한글 또는 영문 대소문자만 사용할 수 있습니다. 다시 입력해주세요.");
    } else {
      break; // 조건을 모두 만족하면 루프를 빠져나옴
    }
  }

  return name;
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

    return Character(name, health, attack, defense);
    // 불러온 데이터를 기반으로 Character 객체 생성 (character 객체반환)
  } catch (e) {
    print('캐릭터 데이터를 불러오는 데 실패했습니다: $e\n'); // 기본 캐릭터 생성하여 반환
    // exit(1); 오류 발생 시 프로그램 종료
    return Character(name, 100, 10, 5); // 기본 체력, 공격력, 방어력 값
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
    print('몬스터 데이터를 불러오는 데 실패했습니다: $e\n'); // 빈 리스트 반환하여 프로그램이 종료되지 않도록 함
    //  exit(1); 오류 발생 시 프로그램 종료
    return monsters;
  }
}

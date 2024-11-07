import 'dart:io'; // 'dart:io'는 콘솔 입출력, 파일 입출력 등을 처리하는 라이브러리
import 'dart:math'; // 'dart:math'는 랜덤 값 생성 등을 위해 필요한 라이브러리
import 'character.dart'; // 'Character' 클래스가 정의된 파일을 임포트
import 'monster.dart'; // 'Monster' 클래스가 정의된 파일을 임포트

class Game {
  // 게임에 관련된 주요 속성들을 정의
  Character character; // 게임 내에서 플레이어 역할을 할 캐릭터 객체
  List<Monster> monsters = []; // 게임에서 싸울 몬스터들의 리스트 (빈 리스트로 초기화)
  int defeatedMonsters = 0; // 물리친 몬스터의 개수 (게임 종료 조건에 사용)
  /* 초기값을 = 0으로 설정한 이유는 게임 시작 시에는 아직 물리친 몬스터가 없기 때문. 
     defeatedMonsters 변수는 게임이 진행되며 플레이어가 몬스터를 처치할 때마다 하나씩 증가하고, 
     최종적으로 모든 몬스터를 물리쳤을 때의 수를 추적하는 역할을 한다.*/

  // 생성자: 게임을 시작할 때 캐릭터와 몬스터 리스트를 초기화
  Game(this.character, this.monsters);
  /* Game 클래스의 생성자(Constructor)는 캐릭터와 몬스터 리스트를 받아서 초기화한다.
     이 생성자는 게임이 시작될 때 호출되며, 캐릭터와 몬스터들이 준비된 상태로 게임이 시작된다. */

  // 게임을 시작하는 메서드
  void startGame() {
    print("게임을 시작합니다!");
    character.showStatus();
    print("\n");

    // while 루프는 캐릭터의 체력이 0보다 크고, 아직 물리치지 않은 몬스터가 있을 때 반복
    while (character.health > 0 && defeatedMonsters < monsters.length) {
      print("새로운 몬스터가 나타났습니다!\n");
      Monster monster = getRandomMonster(); // 랜덤으로 몬스터 선택
      monster.showStatus();
      print("\n");

      battle(monster); // 선택된 몬스터와 전투 진행

      if (character.health <= 0) {
        // 캐릭터의 체력이 0 이하가 되면 게임종료
        print("${character.name}이(가) 패배했습니다.\n");
        saveResult("패배"); // 패배 결과를 파일에 저장
        break; // while 루프 종료 (게임 종료)
      }
      if (defeatedMonsters == monsters.length) {
        // 설정한 물리친 몬스터 개수만큼 몬스터를 물리치면 게임에서 승리
        print("모든 몬스터를 물리쳤습니다! 승리!\n");
        saveResult("승리"); // 승리 결과를 파일에 저장
        break; // while 루프 종료 (게임 종료)
      } else {
        while (true) {
          stdout.write(
              "다음 몬스터와 대결하시겠습니까? (y/n): "); // 몬스터를 물리칠 때마다 다음 몬스터와 대결할 건지 선택
          String? choice = stdin.readLineSync(); // 사용자 입력 받기
          if (choice == "y") {
            break;
          } else if (choice == "n") {
            print("게임을 종료합니다.\n");
            break;
          } else {
            print("잘못된 입력입니다.\n");
            continue;
          }
        }
      }
    }

    print("게임이 종료되었습니다.\n");

    if (monsters.isNotEmpty && character.health > 0) saveResult("중단됨");
    // 만약 캐릭터가 살아있고, 모든 몬스터를 물리치지 못했으면 "중단됨" 결과 저장

    exit(0); // 프로그램 종료
  }

  // 전투 메서드: 캐릭터와 선택된 몬스터 간의 전투를 처리한다.
  void battle(Monster monster) {
    while (monster.health > 0 && character.health > 0) {
      // 전투는 캐릭터나 몬스터 중 하나의 체력이 0 이하가 될 때까지 계속된다
      character.showStatus(); // 매 턴마다 캐릭터 상태 출력
      monster.showStatus(); // 매 턴마다 몬스터 상태 출력

      stdout.write("행동을 선택하세요: 공격하기(1), 방어하기(2): ");
      String? action = stdin.readLineSync(); // 사용자로부터 행동 입력 받기

      if (action == "1") {
        // 공격을 선택한 경우
        character.attackMonster(monster); // 캐릭터가 몬스터를 공격
        if (monster.health > 0) {
          monster.attackCharacter(character); // 몬스터가 반격
        }
      } else if (action == "2") {
        // 방어를 선택한 경우
        monster.attackCharacter(character); // 몬스터의 공격
        character.defend(monster.maxAttack); // 캐릭터의 방어 및 체력 회복
      } else {
        print("잘못 입력하셨습니다. 다시 입력해 주세요.\n");
        continue; // 잘못된 입력이 들어오면 루프 재시작
      }

      // 전투 종료 조건 체크
      if (character.health <= 0) {
        print("${character.name}이(가) 전투에서 패배했습니다.\n");
        break;
      } else if (monster.health <= 0) {
        defeatedMonsters++;
        monsters.remove(monster); // 물리친 몬스터를 리스트에서 제거
        print("${monster.name}을(를) 물리쳤습니다!\n");
        break;
      }
    }
  }

  // 랜덤으로 몬스터 선택하는 메서드
  Monster getRandomMonster() {
    Random random = Random();
    return monsters[random.nextInt(monsters.length)];
    /* Random().nextInt(n)은 n 미만의 랜덤 정수를 반환한다.
       여기서는 남은 몬스터 리스트 중 랜덤하게 하나를 선택한다. */
  }

  // 결과 저장 메서드: 게임 결과(승리/패배)를 파일에 저장한다.
  void saveResult(String result) {
    stdout.write("결과를 저장하시겠습니까? (y/n): ");
    String? choice = stdin.readLineSync();

    if (choice?.toLowerCase() == "y") {
      // 사용자가 y 또는 Y 를 입력하면 결과 저장
      final file = File('data/result.txt');
      file.writeAsStringSync(
          "캐릭터 이름: ${character.name} 남은 체력: ${character.health} 게임 결과: $result\n");
      print("결과가 저장되었습니다.\n");
    }
  }
}

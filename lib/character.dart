import 'monster.dart';

class Character {
  // 캐릭터의 속성 정의
  String name; // 캐릭터 이름
  int health; // 체력
  int attack; // 공격력
  int defense; // 방어력

  // 생성자: 캐릭터의 이름, 체력, 공격력, 방어력을 초기화
  Character(this.name, this.health, this.attack, this.defense);

  // 몬스터를 공격하는 메서드
  void attackMonster(Monster monster) {
    // print('$name이(가) ${monster.name}을(를) 공격합니다!\n'); 라고 입력할 수도 있다.
    int damage = attack - monster.defense; // 캐릭터의 공격력에서 몬스터의 방어력만큼을 뺀 데미지 계산
    if (damage < 0) damage = 0; // 데미지는 최소 0이 되도록 보정
    monster.health -= damage; // 데미지만큼 몬스터의 체력을 감소
    print('$name이(가) ${monster.name}에게 $damage 만큼의 피해를 입혔습니다.\n');
  }

  // 방어 메서드: 방어 시 체력을 회복하는 기능
  void defend(int damage) {
    int recoveredHealth = damage ~/ 2; // 받은 데미지의 절반만큼 체력 회복
    health += recoveredHealth;
    print('$name이(가) 방어하여 $recoveredHealth 만큼 체력을 회복했습니다.\n');
  }

  // 캐릭터 상태 출력 메서드
  void showStatus() {
    print('$name 체력: $health, 공격력: $attack, 방어력: $defense\n');
  }
}

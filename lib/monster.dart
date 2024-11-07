import 'dart:math'; // 랜덤 공격력 생성을 위해 필요
import 'character.dart';

class Monster {
  // 몬스터의 속성 정의
  String name;
  int health;
  int maxAttack;
  int defense = 0; // 몬스터는 방어력이 0으로 고정

  // 생성자: 몬스터의 초기 속성을 설정
  Monster(this.name, this.health, this.maxAttack);

  // 랜덤으로 몬스터의 공격력을 설정
  int get attack => max(5,
      Random().nextInt(maxAttack + 1)); // getter방식은 여러 곳에서 동일한 로직을 재사용해야 할 때 유용
  /* max(a, b) 함수는 a와 b 중 더 큰 값을 반환한다. 여기서는 랜덤으로 생성한 공격력 값이 5보다 작으면 5로 설정하고, 
     5 이상이면 랜덤 값을 그대로 사용하게 된다. 이로 인해 몬스터의 공격력은 최소 5 이상이 되며, 최대값은 maxAttack이 된다. */
  /* Random()은 난수를 생성하는 클래스이다. nextInt(n) 메서드는 0부터 n-1까지의 정수 중 하나를 무작위로 반환한다.
     maxAttack + 1을 넣은 이유는 maxAttack을 포함하는 범위에서 랜덤 값을 생성하기 위해서. 
    예를 들어, maxAttack이 20이라면, 0부터 20까지 랜덤한 값이 나올 수 있게 된다. */

  // 몬스터가 캐릭터를 공격하는 메서드
  void attackCharacter(Character character) {
    int damage = attack - character.defense;
    if (damage < 0) damage = 0; // 최소 데미지는 0 이상
    character.health -= damage; // 캐릭터에게 데미지를 입힘
    if (character.health < 0) character.health = 0; // 체력이 음수가 되지 않도록 처리
  }

  // 몬스터 상태 출력 메서드
  void showStatus() {
    print('$name 체력: $health, 최대 공격력: $maxAttack\n');
  }
}

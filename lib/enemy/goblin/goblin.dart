import 'package:bonfire/bonfire.dart';
import 'package:flutter/material.dart';
import 'goblin_sprite_sheet.dart';

class Goblin extends SimpleEnemy with ObjectCollision {
  final Vector2 initPosition;
  double attack = 25;
  double mapTileSize = 0;

  Goblin(this.initPosition, this.mapTileSize)
      : super(
          animation: GoblinSpriteSheet.goblinAnimations(),
          position: initPosition,
          size: Vector2.all(mapTileSize * 0.8),
          speed: mapTileSize / 0.35,
          life: 120,
        ) {
    setupCollision(
      CollisionConfig(
        collisions: [
          CollisionArea.rectangle(
            size: Vector2(
              valueByTileSize(7),
              valueByTileSize(7),
            ),
            align: Vector2(valueByTileSize(3), valueByTileSize(4)),
          ),
        ],
      ),
    );
  }

  double valueByTileSize(double value) {
    return value * (mapTileSize / 16);
  }

  @override
  void render(Canvas canvas) {
    drawDefaultLifeBar(
      canvas,
      borderRadius: BorderRadius.circular(2),
    );
    super.render(canvas);
  }

  @override
  void update(double dt) {
    super.update(dt);

    seeAndMoveToPlayer(
      closePlayer: (player) {
        execAttack();
      },
      radiusVision: mapTileSize * 4,
    );
  }

  @override
  void die() {
    gameRef.add(
      AnimatedObjectOnce(
        animation: SpriteAnimation.load(
          'goblin/smoke_explosin.png',
          SpriteAnimationData.sequenced(
            amount: 6,
            stepTime: 0.1,
            textureSize: Vector2(16, 16),
          ),
        ),
        position: position,
        size: Vector2(32, 32),
      ),
    );
    removeFromParent();
    super.die();
  }

  void execAttack() {
    simpleAttackMelee(
      size: Vector2.all(mapTileSize * 0.62),
      damage: attack,
      interval: 800,
      animationRight: GoblinSpriteSheet.enemyAttackEffectRight(),
      execute: () {},
    );
  }

  @override
  void receiveDamage(AttackFromEnum attacker, double damage, dynamic id) {
    showDamage(
      damage,
      config: TextStyle(
        fontSize: valueByTileSize(5),
        color: Colors.white,
        fontFamily: 'Normal',
      ),
    );
    super.receiveDamage(attacker, damage, id);
  }
}

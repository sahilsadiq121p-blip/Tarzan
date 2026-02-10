import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';

void main() {
  runApp(GameWidget(game: CarGame()));
}

class CarGame extends FlameGame with HasKeyboardHandlerComponents {
  late PlayerCar player;
  final Random random = Random();

  @override
  Future<void> onLoad() async {
    camera.viewport = FixedResolutionViewport(resolution: Vector2(360, 640));

    add(Background());

    player = PlayerCar();
    add(player);

    add(EnemySpawner());
  }
}

//////////////// BACKGROUND //////////////////

class Background extends RectangleComponent {
  Background()
      : super(
          size: Vector2(360, 640),
          paint: Paint()..color = const Color(0xFF222222),
        );
}

//////////////// PLAYER CAR //////////////////

class PlayerCar extends RectangleComponent with KeyboardHandler {
  double speed = 250;

  PlayerCar()
      : super(
          size: Vector2(60, 100),
          position: Vector2(150, 500),
          paint: Paint()..color = Colors.blue,
        );

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    if (keysPressed.contains(LogicalKeyboardKey.arrowLeft)) {
      position.x -= 20;
    }
    if (keysPressed.contains(LogicalKeyboardKey.arrowRight)) {
      position.x += 20;
    }

    position.x = position.x.clamp(0, 300);

    return true;
  }
}

//////////////// ENEMY //////////////////

class EnemyCar extends RectangleComponent {
  EnemyCar(double x)
      : super(
          size: Vector2(60, 100),
          position: Vector2(x, -100),
          paint: Paint()..color = Colors.red,
        );

  @override
  void update(double dt) {
    position.y += 200 * dt;

    if (position.y > 700) {
      removeFromParent();
    }
  }
}

//////////////// SPAWNER //////////////////

class EnemySpawner extends Component with HasGameRef<CarGame> {
  double timer = 0;
  final Random random = Random();

  @override
  void update(double dt) {
    timer += dt;

    if (timer > 1.2) {
      timer = 0;

      double x = random.nextDouble() * 300;
      gameRef.add(EnemyCar(x));
    }
  }
}

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:math';

void main() {
  runApp(GameApp());
}

class GameApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      home: GameScreen(),
    );
  }
}

class GameScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GameWidget(
      game: TapGame(),
    );
  }
}

class ResultScreen extends StatelessWidget {
  final int score;

  const ResultScreen({required this.score});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Great work, you got $score points!",
                style: TextStyle(fontSize: 48)),
            Padding(
              padding: EdgeInsets.all(16),
            ),
            ElevatedButton(
              child: Text(
                "Play Again",
                style: TextStyle(fontSize: 24),
              ),
              onPressed: () => Get.offAll(() => GameScreen()),
            ),
          ],
        ),
      ),
    );
  }
}

class TapGame extends FlameGame {
  final gravity = Vector2(0, 100);
  var timeLeft = 30.0;
  var totalTaps = 0;
  bool isGameOver = false;

  TapGame() {
    addAll([
      TapBox(position: Vector2(100, 200)),
      TapCircle(position: Vector2(200, 300)),
      TapTriangle(position: Vector2(200, 100)),
    ]);
  }

  @override
  void update(double dt) {
    super.update(dt);
    timeLeft -= dt;

    if (timeLeft <= 0 && !isGameOver) {
      isGameOver = true;
      Get.offAll(() => ResultScreen(score: totalTaps));
    }
  }

  void incrementTapCount() {
    totalTaps++;
  }
}

class TapBox extends RectangleComponent with HasGameRef<TapGame>, TapCallbacks {
  var velocity = Vector2(0, 0);
  final random = Random();
  double timeSinceLastMove = 0.0;

  TapBox({required Vector2 position})
      : super(
          position: position,
          size: Vector2(50, 50),
        );

  @override
  void update(double dt) {
    super.update(dt);

    velocity += gameRef.gravity * dt;
    position += velocity * dt;

    if (position.y > gameRef.size.y) {
      position.y = 0;
      velocity.y = 0;
    }

    timeSinceLastMove += dt;
    if (timeSinceLastMove > 1.0) {
      moveToRandomPosition();
      timeSinceLastMove = 0.0;
    }
  }

  @override
  void onTapDown(TapDownEvent event) {
    gameRef.incrementTapCount();
    position.y += 10; 
  }

  void moveToRandomPosition() {
    position.x = random.nextDouble() * (gameRef.size.x - size.x);
    position.y = random.nextDouble() * (gameRef.size.y - size.y);
  }
}

class TapCircle extends CircleComponent with HasGameRef<TapGame>, TapCallbacks {
  var velocity = Vector2(0, 0);
  final random = Random();
  double timeSinceLastMove = 0.0;

  TapCircle({required Vector2 position})
      : super(
          position: position,
          radius: 25,
        );

  @override
  void update(double dt) {
    super.update(dt);

    velocity += gameRef.gravity * dt;
    position += velocity * dt;

    if (position.y > gameRef.size.y) {
      position.y = 0;
      velocity.y = 0;
    }

    timeSinceLastMove += dt;
    if (timeSinceLastMove > 1.0) {
      moveToRandomPosition();
      timeSinceLastMove = 0.0;
    }
  }

  @override
  void onTapDown(TapDownEvent event) {
    gameRef.incrementTapCount();
    position.x -= 10;
  }

  void moveToRandomPosition() {
    position.x = random.nextDouble() * (gameRef.size.x - radius * 2);
    position.y = random.nextDouble() * (gameRef.size.y - radius * 2);
  }
}

class TapTriangle extends PolygonComponent
    with HasGameRef<TapGame>, TapCallbacks {
  var velocity = Vector2(0, 0);
  final random = Random();
  double timeSinceLastMove = 0.0;

  TapTriangle({required Vector2 position})
      : super([
          Vector2(0, -25),
          Vector2(25, 25),
          Vector2(-25, 25),
        ]) {
    this.position = position;
  }

  @override
  void update(double dt) {
    super.update(dt);

    velocity += gameRef.gravity * dt;
    position += velocity * dt;

    if (position.y > gameRef.size.y) {
      position.y = 0;
      velocity.y = 0;
    }

    timeSinceLastMove += dt;
    if (timeSinceLastMove > 1.0) {
      moveToRandomPosition();
      timeSinceLastMove = 0.0;
    }
  }

  @override
  void onTapDown(TapDownEvent event) {
    gameRef.incrementTapCount();
    position.x += 10;
  }

  void moveToRandomPosition() {
    position.x = random.nextDouble() * (gameRef.size.x - 50);
    position.y = random.nextDouble() * (gameRef.size.y - 50);
  }
}

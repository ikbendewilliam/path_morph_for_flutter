import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_path_morph/flutter_path_morph.dart';

Path buildClosedBlobPath() {
  final path = Path();
  path.moveTo(0, 50);
  path.quadraticBezierTo(0, 0, 50, 0);
  path.quadraticBezierTo(100, 0, 100, 50);
  path.quadraticBezierTo(100, 100, 50, 100);
  path.quadraticBezierTo(0, 100, 0, 50);
  path.close();
  return path;
}

Path buildClosedSquarePath() {
  final path = Path();
  path.moveTo(200, 200);
  path.lineTo(300, 200);
  path.lineTo(300, 300);
  path.lineTo(200, 300);
  path.close();
  return path;
}

void main() {
  test('closed-path optimization no longer wipes points1 (regression test for clear/addAll cascade bug)', () {
    final path1 = buildClosedBlobPath();
    final path2 = buildClosedSquarePath();

    final data = PathMorphUtils.samplePaths(path1, path2);
    expect(data.points1IsClosed, true);
    expect(data.points2IsClosed, true);
    expect(data.points1, isNotEmpty, reason: 'points1 must survive the shift/reverse optimization');
    expect(data.points1.length, data.points2.length);

    final controller = AnimationController(vsync: const TestVSync(), duration: const Duration(milliseconds: 900));
    final animations = PathMorphUtils.generateAnimations(controller, data);
    expect(animations.length, data.points1.length);
    expect(animations, isNotEmpty, reason: 'generateAnimations must produce an animation per point');
  });
}

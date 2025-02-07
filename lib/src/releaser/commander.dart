// Created by: Christo Pananjickal, Created at: 06-02-2025 08:26 pm

import 'dart:io';

import '../vlogger/vlogger.dart';

class Commander {
  static Vlogger vlogger = Vlogger();

  static void say(String text, {VClr color = VClr.say}) => vlogger.log(text, color: color.color);

  static void command(String text, {VClr color = VClr.command}) => say(text, color: color);

  static void doing(String text) => say(text, color: VClr.action);

  static String ask(String question, {VClr color = VClr.question}) {
    vlogger.log(question, color: color.color);
    return (stdin.readLineSync() ?? '').trim();
  }

  static bool askYN(String question, {VClr color = VClr.question}) {
    vlogger.log('$question(y/n)', color: color.color);
    String? input = (stdin.readLineSync() ?? '').trim();
    if (input == 'y' || input == 'Y') return true;
    if (input == 'n' || input == 'N') return false;
    vlogger.log('Invalid input', color: VlogColors.red);

    return askYN(question, color: color);
  }

  static bool askYNSub(String question) => askYN('    $question', color: VClr.subQuestion);
}

enum VClr {
  question(color: VlogColors.magenta),
  subQuestion(color: VlogColors.green),
  say(color: VlogColors.yellow),
  command(color: VlogColors.red),
  action(color: VlogColors.grey),
  ;

  const VClr({required this.color});
  final VlogColors color;
}

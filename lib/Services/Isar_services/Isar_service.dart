import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import '../../models/expances.dart';

class IsarService {
  static late Isar isar;

  static Future<void> init() async {
    final dir = await getApplicationDocumentsDirectory();

    isar = await Isar.open(
      [
        UserModelSchema,
        MessagesSchema,
      ],
      directory: dir.path,
    );
  }

  static Future<List<UserModel>> getUser() async {
    return await isar.userModels.where().findAll();
  }

  static Stream<List<UserModel>> watchUsers() {
    return isar.userModels.where().watch(fireImmediately: true);
  }

  Future<bool> deleteUser(int id) async {
    return await isar.writeTxn(() async {
      return await isar.userModels.delete(id);
    });
  }

  Future<void> updateUser(UserModel user) async {
    await isar.writeTxn(() async {
      await isar.userModels.put(user);
    });
  }

  Future<void> addUser(context, UserModel user) async {
    await isar.writeTxn(() async {
      await isar.userModels.put(user);
    });
  }

  Widget deleteExpancesButton(BuildContext context, int id) {
    return MaterialButton(
      onPressed: () async {
        await deleteUser(id);
        Navigator.pop(context);
      },
      child: const Text('Delete'),
    );
  }
}

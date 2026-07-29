import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:q_slope_calculator/src/data/models/q_slope.dart';
import 'package:q_slope_calculator/src/logic/cubit/q_slope_list/q_slope_list_cubit.dart';

void main() {
  SharedPreferences.setMockInitialValues({});

  group('QSlopeListCubit', () {
    final mockQSlope = QSlope(
      id: 'test_id',
      locationId: 'LocA',
      lithology: 'Granite',
    );

    setUp(() async {
      final pref = await SharedPreferences.getInstance();
      await pref.clear();
    });

    test('initial state is QSlopeListLoading', () {
      final cubit = QSlopeListCubit();
      expect(cubit.state, isA<QSlopeListLoading>());
      cubit.close();
    });

    blocTest<QSlopeListCubit, QSlopeListState>(
      'loadQSlopeList emits QSlopeListEmpty when list is empty',
      build: () {
        return QSlopeListCubit();
      },
      act: (cubit) => cubit.loadQSlopeList(),
      expect: () => [isA<QSlopeListLoading>(), isA<QSlopeListEmpty>()],
    );

    blocTest<QSlopeListCubit, QSlopeListState>(
      'loadQSlopeList emits QSlopeListLoaded when list has items',
      setUp: () async {
        final pref = await SharedPreferences.getInstance();
        await pref.setStringList('Q_SLOPES', [mockQSlope.toJson()]);
      },
      build: () {
        return QSlopeListCubit();
      },
      act: (cubit) => cubit.loadQSlopeList(),
      expect:
          () => [
            isA<QSlopeListLoading>(),
            isA<QSlopeListLoaded>().having(
              (state) => state.qSlopeList.length,
              'length',
              1,
            ),
          ],
    );

    blocTest<QSlopeListCubit, QSlopeListState>(
      'saveQSlopeToList saves slope and reloads list',
      build: () {
        return QSlopeListCubit();
      },
      act: (cubit) => cubit.saveQSlopeToList(mockQSlope),
      expect:
          () => [
            isA<QSlopeListLoading>(),
            isA<QSlopeListLoaded>().having(
              (state) => state.qSlopeList.length,
              'length',
              1,
            ),
          ],
    );

    blocTest<QSlopeListCubit, QSlopeListState>(
      'clearQSlopeList clears all slopes and reloads empty list',
      setUp: () async {
        final pref = await SharedPreferences.getInstance();
        await pref.setStringList('Q_SLOPES', [mockQSlope.toJson()]);
      },
      build: () {
        return QSlopeListCubit();
      },
      act: (cubit) => cubit.clearQSlopeList(),
      expect: () => [isA<QSlopeListLoading>(), isA<QSlopeListEmpty>()],
    );

    blocTest<QSlopeListCubit, QSlopeListState>(
      'deleteQSlopeFromList deletes specific slope and reloads',
      setUp: () async {
        final pref = await SharedPreferences.getInstance();
        await pref.setStringList('Q_SLOPES', [mockQSlope.toJson()]);
      },
      build: () {
        return QSlopeListCubit();
      },
      act: (cubit) => cubit.deleteQSlopeFromList('test_id'),
      expect: () => [isA<QSlopeListLoading>(), isA<QSlopeListEmpty>()],
    );
  });
}

import 'dart:async';
import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:maze_king/packages/maze_game/maze_generator_algorithm.dart';
import 'package:maze_king/repositories/game/game_repository.dart';
import 'package:maze_king/utils/app_remaining_time_calculator.dart';
import 'package:maze_king/utils/enums/contest_enums.dart';
import 'package:maze_king/utils/enums/timer_enums.dart';
import 'package:maze_king/views/contest_details/contest_details_controller.dart';
import '../../data/models/game/game_details_model.dart';
import '../../exports.dart';
import '../../packages/maze_game/maze_game_functions.dart';
import '../../utils/timer_calculations.dart';
import 'widgets/game_timeout_bottom_sheet/game_timeout_bottom_sheet.dart';
// import 'package:vibration/vibration.dart';

class MazeGameController extends GetxController with GetTickerProviderStateMixin {
  /// Animations
  late AnimationController controller;
  late Animation<Offset> animation;
  final AudioPlayer _audioPlayer = AudioPlayer();

  Rx<GameDetailsModel> contestDetailsModel = GameDetailsModel().obs;

  RxBool canPop = false.obs;
  RxBool canShowExitDialog = true.obs;
  Function() whenCompleteFunction = () {};

  /// Loader
  RxBool isLoading = false.obs;
  RxBool isGameFinished = false.obs;

  ///
  RxBool isFreePracticeMode = false.obs;
  RxBool isNavFromCuntDownScreen = false.obs;

  ///
  RxBool isWinner = false.obs;
  RxBool isGameStarted = false.obs;

  /// ------------------------------------   timer   -----------------------------------------

  int baseGameTimer = 60;

  Timer? gameFinishTimer;
  RxInt gameTimeInSeconds = 60.obs;
  RxInt totalRemainingSeconds = 60.obs;
  RxString totalRemainingTimeStr = "".obs;

  List<String> testingMobileNumbers = [
    "+917777990666",
    "+918469879296",
    "+918264612844",
    "+917709284779"
  ];

  double calculateRemainingTimePercentage() {
    const totalDuration = 10 * 60; // Assume 10 minutes is the total duration in seconds
    final remainingTime = parseTimeToSeconds(totalRemainingTimeStr.value); // Convert remaining time string to seconds

    return remainingTime / totalDuration; // A value between 0.0 and 1.0
  }

  int parseTimeToSeconds(String timeStr) {
    try {
      List<String> parts = timeStr.split(':');

      if (parts.length == 2) {
        int minutes = int.parse(parts[0]);
        int seconds = int.parse(parts[1]);
        return (minutes * 60) + seconds;
      } else {
        // Return 0 or handle the case where the format is incorrect
        throw const FormatException("Invalid time format");
      }
    } catch (e) {

      return 0; // Return 0 if parsing fails
    }
  }

  void startTimer() {
    cancelGameTimer();
    const oneSec = Duration(seconds: 1);

    ///

    updateTimer({bool doDecrement = true, int decrementSeconds = 1}) {
      if (isFreePracticeMode.isFalse) {
        if (contestDetailsModel.value.liveRemainingMilliSeconds != null) {
          ///
          ///

          totalRemainingTimeStr.value = AppRemainingTimeCalculator.getByRemainingDuration(
            contestDetailsModel.value.endTime ?? DateTime.now(),
            remainingTime: Duration(seconds: totalRemainingSeconds.value),
            whenComplete: () {
              if (doDecrement && !isValZero(contestDetailsModel.value.liveRemainingMilliSeconds ?? 0)) {
                contestDetailsModel.value.liveRemainingMilliSeconds = (contestDetailsModel.value.liveRemainingMilliSeconds! - (decrementSeconds * 1000));
              }
            },
          );
        } else {
          totalRemainingTimeStr.value = AppRemainingTimeCalculator.defaultCalculation(contestDetailsModel.value.endTime ?? DateTime.now());
        }
        if (doDecrement && totalRemainingSeconds > 0) totalRemainingSeconds.value -= 1;
      } else {
        /// Practice Game
        ///
        totalRemainingTimeStr.value = AppRemainingTimeCalculator.getByRemainingDuration(
          contestDetailsModel.value.endTime ?? DateTime.now(),
          remainingTime: Duration(seconds: totalRemainingSeconds.value),
          whenComplete: () {
            if (doDecrement && totalRemainingSeconds > 0) totalRemainingSeconds.value -= 1;
          },
        );
      }
    }

    ///

    if (isFreePracticeMode.isFalse) {
      if (contestDetailsModel.value.endTime != null) {
        if (contestDetailsModel.value.liveRemainingMilliSeconds != null) {
          Duration gameRemainingDuration = Duration(milliseconds: contestDetailsModel.value.liveRemainingMilliSeconds ?? baseGameTimer);
          totalRemainingSeconds.value = gameRemainingDuration.inSeconds;
          // updateTimer(doDecrement: false);
        } else {
          int timeDiffInSec = contestDetailsModel.value.endTime!.difference(DateTime.now()).inSeconds;

          gameTimeInSeconds.value = timeDiffInSec > 0 ? timeDiffInSec : 0;
          totalRemainingSeconds.value = gameTimeInSeconds.value;
        }
      } else {
        gameTimeInSeconds.value = baseGameTimer;
        totalRemainingSeconds.value = baseGameTimer;
      }
    } else {
      gameTimeInSeconds.value = baseGameTimer;
      totalRemainingSeconds.value = baseGameTimer;
    }

    /// TODO
    /// Check Timer
    updateTimer();
    gameFinishTimer = Timer.periodic(
      oneSec,
      (Timer timer) {
        updateTimer();
        if (totalRemainingTimeStr.value == "0s" || totalRemainingTimeStr.value == "00s") {
          /// TODO
          /// TIME-OUT
          printYellow("TIME-OUT");

          finishGameActivity();
        }
      },
    );
  }

  void cancelGameTimer() {
    gameFinishTimer?.cancel();
  }

  /// ------------------------   game start countdown date time   -------------------------------
  ///
  int? gameStartCountDownRemainingMilliseconds;
  DateTime? gameStartCountDownDateTime;
  Timer? gameStartCountDownTimer;
  RxString remainingTimeToStartGameStr = "".obs;

  void updateStartGameTimer({bool doDecrement = true, int decrementSeconds = 1}) {
    printOkStatus(remainingTimeToStartGameStr.value);
    if (gameStartCountDownRemainingMilliseconds != null) {
      remainingTimeToStartGameStr.value = AppRemainingTimeCalculator.getByRemainingDuration(
        contestDetailsModel.value.startTime ?? DateTime.now(),
        remainingTime: Duration(milliseconds: gameStartCountDownRemainingMilliseconds ?? 0),
        whenComplete: () {
          if (doDecrement && !isValZero(gameStartCountDownRemainingMilliseconds ?? 0)) {
            gameStartCountDownRemainingMilliseconds = (gameStartCountDownRemainingMilliseconds! - (decrementSeconds * 1000));
          }
        },
      );
    } else {
      remainingTimeToStartGameStr.value = AppRemainingTimeCalculator.defaultCalculation(gameStartCountDownDateTime ?? DateTime.now());
    }
  }

  void startGameStartTimer() {
    const oneSec = Duration(seconds: 1);

    /// TODO
    /// Check Timer
    updateStartGameTimer(doDecrement: false);
    gameStartCountDownTimer = Timer.periodic(
      oneSec,
      (Timer timer) {
        updateStartGameTimer();
        if (!(remainingTimeToStartGameStr.value.contains("h") || remainingTimeToStartGameStr.value.contains("m"))) {
          if (remainingTimeToStartGameStr.value.contains("s") ? (int.parse(remainingTimeToStartGameStr.value.replaceAll("s", "")) <= 10) : false) {
            /// TODO
            /// TIME-OUT
            printYellow("GAME STARTS IN FEW SECONDS");
            UiUtils.toast("Your Game Starts In Few Seconds");
            cancelGameStartTimer();
            Get.back();
          }
        }
      },
    );
  }

  void cancelGameStartTimer() {
    gameStartCountDownTimer?.cancel();
  }

  /// ------------------------------- Finish Game Activity ----------------------------------

  Future<void> finishGameActivity() async {
    if (isLoading.isFalse) {
      printOkStatus("=== finishGameActivity ====");
      cancelGameTimer();
      isGameFinished.value = true;
      if (Get.isDialogOpen ?? false) Get.back();
      canShowExitDialog.value = false;
      printOkStatus("W: ${onTrackBallProgressPercentage().toStringAsFixed(3)}%|| T: ${totalBallProgressPercentage().toStringAsFixed(3)}%");

      if (isFreePracticeMode.isFalse) {
        /// FINISH GAME API
        await GameRepository.finishGameAPI(
          loader: isLoading,
          contestId: contestDetailsModel.value.id ?? "",
          recurringId: contestDetailsModel.value.recurringId ?? "",
          winningStatus: isWinner.value ? WinningStatus.won : WinningStatus.lose,
          onTrackPercentage: isWinner.value ? "100" : onTrackBallProgressPercentage().toStringAsFixed(5),
          totalPercentage: (isWinner.value && totalBallProgressPercentage().isLowerThan(100)) ? "100" : totalBallProgressPercentage().toStringAsFixed(5),

          /// reverse time # remainingTime
          takenTimeInMicroseconds: (contestDetailsModel.value.liveRemainingMilliSeconds != null && isValZero(contestDetailsModel.value.liveRemainingMilliSeconds))
              ? 0
              : TimerCalculations.calculateTimeDifference(
                  DateTime.now(),
                  DateTime.now().add(Duration(milliseconds: contestDetailsModel.value.liveRemainingMilliSeconds ?? 0)),
                  timeUnit: TimeUnit.microseconds,
                ),
        );

        /// disable play and go button in contest details screen if it is already in route
        if (isRegistered<ContestDetailsController>()) {
          ContestDetailsController contestDetailsCon = Get.find<ContestDetailsController>();
          contestDetailsCon.updateContestTypeEnumByStringType('completed');
        }

        canPop.value = true;

        if (Get.currentRoute == AppRoutes.gameViewScreen && !(Get.isBottomSheetOpen ?? false)) {
          showModalBottomSheet(
              context: Get.context!,
              isScrollControlled: true,
              isDismissible: false,
              enableDrag: false,
              builder: (context) {
                return const GameTimeOutBottomSheet();
              }).whenComplete(() {
            printYellow("WHEN_COMPLETE");
            canPop.value = true;
            whenCompleteFunction();
            Get.back();
          });
        }
        // isGameFinished.value = false;
      } else {
        /// PRACTICE MODE
        // Get.back();
      }
    }
  }

  /// ---------------------------------------------------------------------------------------

  void initDataSetter() {
    isLoading.value = true;

    // /// start timer
    // startTimer();

    /// maze true false data
    mazeTrueFalseData.value = contestDetailsModel.value.cells ?? [];
    if (!isValEmpty(contestDetailsModel.value.winningPath)) {
      idealWinningPath = contestDetailsModel.value.winningPath!.map((e) => Point(e.first, e.last)).toList();
    }

    /// TODO
    /// [rows] and [columns] should be same and odd value
    rows.value = contestDetailsModel.value.row ?? 0;
    columns.value = contestDetailsModel.value.column ?? 0;

    tileSize = (Get.size.width / columns.value);
    placeBallInitialPosition(initialBallPosition: contestDetailsModel.value.start ?? []);

    /// add initial data
    totalTraversedPath.add(initialBallPosition);
    totalTraversedPathOnWinningTrack.add(initialBallPosition);

    /// find longest path
    // List<Point<int>> longestPath = MazeGameFunctions().findLongestPath(mazeTrueFalseData);
    // Point<int> initialPosition = longestPath.first;
    // Point<int> destinationPosition = longestPath.last;
    // initialBallPosition = initialPosition;
    ballDestination = Point(contestDetailsModel.value.end?.first ?? 0, contestDetailsModel.value.end?.last ?? 0);

    /// find winning path
    // idealWinningPath = MazeGameFunctions().getWinningPath(mazeData: mazeTrueFalseData, startBallPosition: initialBallPosition, destinationBallPosition: ballDestination);
    placeBallDestination(destination: contestDetailsModel.value.end ?? []);

    /// Animations
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    controller.addListener(() {
      update();
    });

    animation = Tween<Offset>(begin: Offset((ballPosition.value.y + 0.5) * tileSize, (ballPosition.value.x + 0.5) * tileSize), end: Offset((ballPosition.value.y + 0.5) * tileSize, (ballPosition.value.x + 0.5) * tileSize)).animate(controller);

    controller.forward();

    isLoading.value = false;

    /// start timer
    startTimer();
  }

  void updateGameStatus({required bool win}) {
    isWinner.value = win;
    isWinner.refresh();
  }

  num onTrackBallProgressPercentage() {
    return (totalTraversedPathOnWinningTrack.length / idealWinningPath.length) * 100;
  }

  num totalBallProgressPercentage() {
    return (totalTraversedPath.length / idealWinningPath.length) * 100;
  }

  /// [maze] true & false
  /// true is wall and false is empty space
  RxList<List<bool>> mazeTrueFalseData = <List<bool>>[
    // [true, true, true, true, true, true, true, true, true, true, true, true, true, true, true],
    // [true, false, false, false, false, false, true, false, false, false, true, false, false, false, true],
    // [true, true, true, false, true, true, true, false, true, true, true, false, true, true, true],
    // [true, false, false, false, true, false, true, false, false, false, false, false, true, false, true],
    // [true, false, true, false, true, false, true, false, true, true, true, true, true, false, true],
    // [true, false, true, false, false, false, true, false, false, false, false, false, false, false, true],
    // [true, false, true, true, true, true, true, true, true, true, true, true, true, false, true],
    // [true, false, false, false, false, false, true, false, true, false, true, false, false, false, true],
    // [true, true, true, true, true, false, true, false, true, false, true, false, true, true, true],
    // [true, false, false, false, false, false, true, false, true, false, true, false, true, false, true],
    // [true, false, true, true, true, true, true, false, true, false, true, false, true, false, true],
    // [true, false, true, false, false, false, false, false, false, false, false, false, false, false, true],
    // [true, false, true, true, true, false, true, false, true, false, true, true, true, false, true],
    // [true, false, false, false, false, false, true, false, true, false, true, false, false, false, true],
    // [true, true, true, true, true, true, true, true, true, true, true, true, true, true, true],
  ].obs;

  @override
  void onInit() {
    super.onInit();
    // UiUtils.toast(" ---- onInit ---- ");

    /// init
    isWinner.value = false;
    isGameStarted.value = true;

    if (Get.arguments != null) {
      if (Get.arguments['gameDetailsModel'].runtimeType == GameDetailsModel) {
        contestDetailsModel.value = Get.arguments['gameDetailsModel'];
        printYellow(contestDetailsModel.value.cells);
        whenCompleteFunction = Get.arguments["whenCompleteFunction"] ?? () {};
        initDataSetter();
      }

      if (Get.arguments['isFreePracticeMode'] == true) {
        /// PRACTICE MODE
        isFreePracticeMode.value = true;
        isLoading.value = true;
      }

      if (Get.arguments['isNavFromCuntDownScreen'].runtimeType == bool) {
        /// IS NAVIGATE FROM COUNTDOWN SCREEN
        isNavFromCuntDownScreen.value = Get.arguments['isNavFromCuntDownScreen'] ?? false;
      }

      if (Get.arguments['gameStartCountDownRemainingMilliseconds'].runtimeType == int) {
        /// GAME START COUNTDOWN TIMER
        gameStartCountDownRemainingMilliseconds = Get.arguments['gameStartCountDownRemainingMilliseconds'];

        startGameStartTimer();
      } else if (Get.arguments['gameStartDateTimeForCountDown'].runtimeType == DateTime) {
        /// GAME START COUNTDOWN TIMER
        gameStartCountDownDateTime = Get.arguments['gameStartDateTimeForCountDown'];

        startGameStartTimer();
      }
    }
  }

  @override
  void onReady() {
    super.onReady();
    // UiUtils.toast(" ---- onReady ---- P:${isFreePracticeMode.value}");
    if (isFreePracticeMode.isFalse) {
      startGameAPI();
    } else {
      generatePracticeMazeView();
    }
  }

  Future<void> generatePracticeMazeView() async {
    isWinner.value = false;
    isGameStarted.value = true;
    isGameFinished.value = false;
    isFreePracticeMode.value = true;

    isLoading.value = true;

    /// PRACTICE GAME MAZE SIZE API

    int mazeSize = await GameRepository.getFreePracticeGameSizeAPI() ?? 15;

    int newRow = mazeSize;
    int newCol = newRow;
    List<List<bool>> cells = MazeGenerator.generate(rows: newRow, cols: newCol);
    List<Point<int>> longestPath = MazeGameFunctions.findLongestPath(cells);

    idealWinningPath = MazeGameFunctions.getWinningPath(mazeData: cells, startBallPosition: longestPath.first, destinationBallPosition: longestPath.last);

    totalTraversedPathOnWinningTrack.value = [];

    contestDetailsModel.value = GameDetailsModel(row: newRow, column: newCol, cells: cells, start: [longestPath[0].x, longestPath[0].y], end: [longestPath[1].x, longestPath[1].y]);
    initDataSetter();
  }

  Future<void> startGameAPI() async {
    /// START GAME API
    bool success = await GameRepository.startGameAPI(contestId: contestDetailsModel.value.id ?? "", recurringId: contestDetailsModel.value.recurringId ?? "") ?? false;
    if (success) {
      // initDataSetter();
    } else {
      canPop.value = true;
      canShowExitDialog.value = false;
      Get.back();
    }
  }

  @override
  void onClose() {
    /// dispose ball's animation
    disposeBallAnimation();

    cancelGameTimer();
    cancelGameStartTimer();
  }

  void disposeBallAnimation() {
    printOkStatus("disposeBallAnimation");
    controller.dispose();
  }

  /// ---------------------------------------------------------------------------------------------------------

  /// number of blocks for the both Rows & Columns must be odd number
  /// for ex:9, 15

  RxInt rows = 0.obs;
  RxInt columns = 0.obs;

  late double tileSize;

  Rx<Point<int>> ballPosition = const Point(1, 1).obs;
  Rx<Point<int>> newBallAnimationPosition = const Point(1, 1).obs;
  late Point<int> ballDestination;

  /// source to destination ideal winning path, this path is the ideal path where ball can traverse to reach its destination
  List<Point<int>> idealWinningPath = [];

  /// path is contains value of source to current ball positions
  RxList<Point<int>> currentPath = <Point<int>>[].obs;

  /// totalTraversedPath is contains value of total traversed positions, it contains right and wrong path both
  RxList<Point<int>> totalTraversedPath = <Point<int>>[].obs;

  /// totalTraversedPathOnWinningTrack is contains value of on winning-track completed positions
  RxList<Point<int>> totalTraversedPathOnWinningTrack = <Point<int>>[].obs;

  Point<int> initialBallPosition = const Point(1, 1);

  void placeBallInitialPosition({required List<int> initialBallPosition}) {
    if (initialBallPosition.isNotEmpty) {
      ballPosition.value = Point(initialBallPosition.first, initialBallPosition.last); // Starting position for simplicity
      currentPath.value = [ballPosition.value];
    }
  }

  void placeBallDestination({required List<int> destination}) {
    if (destination.isNotEmpty) {
      ballDestination = Point(destination.first, destination.last);
    } // Destination position for simplicity
  }

  bool checkGivenPointIsOnWinningTrack(Point<int> point) {
    /// call this function when you want to your ball is on winning track or not

    return idealWinningPath.where((e) => e == point).toList().isNotEmpty;
  }

  void addPointToCompletedWinningTrack(Point<int> point) {
    /// call this function when you want to add ball's current position to completed path by ball on the winning track
    if (checkGivenPointIsOnWinningTrack(point)) {
      totalTraversedPathOnWinningTrack.add(point);
    }
  }

  void removePointToCompletedWinningTrack(Point<int> point) {
    try {
      /// call this function when you want to remove ball's current position from completed path by ball on the winning track
      // printYellow(totalTraversedPathOnWinningTrack);
      if (checkGivenPointIsOnWinningTrack(totalTraversedPath[totalTraversedPath.length - 1])) {
        // totalTraversedPathOnWinningTrack.remove(point);
        totalTraversedPathOnWinningTrack.removeLast();
      }
    } catch (e) {
      printErrors(type: "removePointToCompletedWinningTrack", errText: "$e");
    }
  }

  bool _isInRange(int row, int col) {
    return row > 0 && row < rows.value && col > 0 && col < columns.value;
  }

  bool isMoveValid(Point<int> newPosition) {
    /// check the move is valid or not, it means it will check that willing new ball position is empty path or wall, if new position for current move is empty path then it will return true, it means its a valid move.
    bool isInRange = _isInRange(newPosition.x, newPosition.y);
    bool isTraversablePath = !mazeTrueFalseData[newPosition.x][newPosition.y];
    // printOkStatus("isInRange:$isInRange | isPath:$isTraversablePath");
    bool result = isInRange && isTraversablePath;

    return result;
  }

  void moveBallStepByStep(Point<int> direction) {
    // printOkStatus("direction: $direction || ballPosition: $ballPosition");
    Point<int> newPosition = ballPosition.value + direction;
    printYellow("ballPosition:$ballPosition | newPosition: $newPosition");
    if (isMoveValid(newPosition)) {
      ballPosition.value = newPosition;
      if (currentPath.any((element) => element == newPosition)) {
        printOkStatus("Exists !!");
        // TODO
        // if (newPosition != initialBallPosition) path.remove(newPosition);
        /*if (newPosition != initialBallPosition) */
        currentPath.removeLast();
      } else {
        currentPath.add(newPosition);
      }

      printOkStatus("$currentPath");
    } else {
      printYellow("Invalid Move");
    }
  }

  Timer? ballMovementTimer;

  bool multiPathConditionChecker(SwipeDirection swipeDirection) {
    /// check the other path possibility around the ball, if we found any multi-path possibility where user can choose to move as per its choice

    bool isFacesMultiplePath = (swipeDirection.name == SwipeDirection.left.name || swipeDirection.name == SwipeDirection.right.name)
        ?

        /// when auto horizontal scrolling running that time it will detect up and down vertical boxes for empty path where it makes possibilities to move ball in possible directions
        (!mazeTrueFalseData[(ballPosition.value + const Point(1, 0)).x][ballPosition.value.y]) || (!mazeTrueFalseData[(ballPosition.value + const Point(-1, 0)).x][ballPosition.value.y])
        :

        /// when auto vertical scrolling running that time it will detect left and right horizontal boxes for empty path where it makes possibilities to move ball in possible directions

        (!mazeTrueFalseData[ballPosition.value.x][(ballPosition.value + const Point(0, 1)).y]) || (!mazeTrueFalseData[ballPosition.value.x][(ballPosition.value + const Point(0, -1)).y]);

    return isFacesMultiplePath;
  }

  bool multiPathConditionCheckerByPosition(SwipeDirection swipeDirection, Point<int> givenBallPosition) {
    // printYellow("> ${swipeDirection.name} | $givenBallPosition");
    /// check the other path possibility around the ball, if we found any multi-path possibility where user can choose to move as per its choice

    bool isFacesMultiplePath = (swipeDirection.name == SwipeDirection.left.name || swipeDirection.name == SwipeDirection.right.name)
        ?

        /// when auto horizontal scrolling running that time it will detect up and down vertical boxes for empty path where it makes possibilities to move ball in possible directions
        (!mazeTrueFalseData[(givenBallPosition + const Point(1, 0)).x][givenBallPosition.y]) || (!mazeTrueFalseData[(givenBallPosition + const Point(-1, 0)).x][givenBallPosition.y])
        :

        /// when auto vertical scrolling running that time it will detect left and right horizontal boxes for empty path where it makes possibilities to move ball in possible directions

        (!mazeTrueFalseData[givenBallPosition.x][(givenBallPosition + const Point(0, 1)).y]) || (!mazeTrueFalseData[givenBallPosition.x][(givenBallPosition + const Point(0, -1)).y]);

    return isFacesMultiplePath;
  }

  SwipeDirection getSwipeDirectionByPointClass(Point<int> point) {
    return point == const Point(0, 1)
        ? SwipeDirection.right
        : point == const Point(0, -1)
            ? SwipeDirection.left
            : point == const Point(1, 0)
                ? SwipeDirection.down
                : point == const Point(-1, 0)
                    ? SwipeDirection.up
                    : SwipeDirection.none;
  }

  Point<int> possiblePathFinderWhenBallStuck({required bool isFreshMovement, required SwipeDirection swipeDirection, required Point<int> directionPoint}) {
    /// call this function when ball stuck at wall while moving
    ///

    Point<int> leftMovePoint = const Point(0, -1);
    Point<int> rightMovePoint = const Point(0, 1);
    Point<int> upMovePoint = const Point(-1, 0);
    Point<int> downMovePoint = const Point(1, 0);

    Point<int> leftMoveNewPoint() {
      return ballPosition.value + leftMovePoint;
    }

    Point<int> rightMoveNewPoint() {
      return ballPosition.value + rightMovePoint;
    }

    Point<int> upMoveNewPoint() {
      return ballPosition.value + upMovePoint;
    }

    Point<int> downMoveNewPoint() {
      return ballPosition.value + downMovePoint;
    }

    Point<int> newScrollDirection = const Point(0, 0);

    bool isWallOnLeft = mazeTrueFalseData[leftMoveNewPoint().x][leftMoveNewPoint().y];
    bool isWallOnRight = mazeTrueFalseData[rightMoveNewPoint().x][rightMoveNewPoint().y];
    bool isWallOnUp = mazeTrueFalseData[upMoveNewPoint().x][upMoveNewPoint().y];
    bool isWallOnDown = mazeTrueFalseData[downMoveNewPoint().x][downMoveNewPoint().y];

    checkNewDirectionAccordingSwipe(SwipeDirection swipeDirection, bool isFreshMove) {
      if (!isWallOnLeft && swipeDirection.name != SwipeDirection.right.name) {
        if (isFreshMove ? true : !multiPathConditionChecker(swipeDirection)) {
          // printOkStatus("#readyToMoveLeftSide");
          newScrollDirection = leftMovePoint;
        }
      }
      if (!isWallOnRight && swipeDirection.name != SwipeDirection.left.name) {
        if (isFreshMove ? true : !multiPathConditionChecker(swipeDirection)) {
          // printOkStatus("#readyToMoveRightSide");
          newScrollDirection = rightMovePoint;
        }
      }
      if (!isWallOnUp && swipeDirection.name != SwipeDirection.down.name) {
        if (isFreshMove ? true : !multiPathConditionChecker(swipeDirection)) {
          // printOkStatus("#readyToMoveUpSide");
          newScrollDirection = upMovePoint;
        }
      }
      if (!isWallOnDown && swipeDirection.name != SwipeDirection.up.name) {
        if (isFreshMove ? true : !multiPathConditionChecker(swipeDirection)) {
          // printOkStatus("#readyToMoveDownSide");
          newScrollDirection = downMovePoint;
        }
      }

      return newScrollDirection;
    }

    List a = [isWallOnLeft, isWallOnRight, isWallOnUp, isWallOnDown];
    bool multiPathDetected = a.where((element) => element == false).length > 2;

    return multiPathDetected ? const Point(0, 0) : checkNewDirectionAccordingSwipe(swipeDirection, isFreshMovement);
  }

  bool checkBallIsStuck(Point<int> ballPosition) {
    Point<int> leftMovePoint = const Point(0, -1);
    Point<int> rightMovePoint = const Point(0, 1);
    Point<int> upMovePoint = const Point(-1, 0);
    Point<int> downMovePoint = const Point(1, 0);

    Point<int> leftMoveNewPoint() {
      return ballPosition + leftMovePoint;
    }

    Point<int> rightMoveNewPoint() {
      return ballPosition + rightMovePoint;
    }

    Point<int> upMoveNewPoint() {
      return ballPosition + upMovePoint;
    }

    Point<int> downMoveNewPoint() {
      return ballPosition + downMovePoint;
    }

    bool isWallOnLeft = mazeTrueFalseData[leftMoveNewPoint().x][leftMoveNewPoint().y];
    bool isWallOnRight = mazeTrueFalseData[rightMoveNewPoint().x][rightMoveNewPoint().y];
    bool isWallOnUp = mazeTrueFalseData[upMoveNewPoint().x][upMoveNewPoint().y];
    bool isWallOnDown = mazeTrueFalseData[downMoveNewPoint().x][downMoveNewPoint().y];

    List a = [isWallOnLeft, isWallOnRight, isWallOnUp, isWallOnDown];
    bool notMoveFurther = a.where((element) => element == false).length == 1;
    // printOkStatus("checkBallIsStuck: $notMoveFurther");
    return notMoveFurther;
  }

  ///
  void moveBallFrequentlyByGestureInOneDirection(Point<int> direction, Function() afterOneIterationFunction) {
    /// STUCK-STUCK
    /// this function is for when user swipe in one direction that time ball will move forward until it find other multi-paths or it reaches to the end of that direction where ball can not move further, after that you have to interact with finger swipe to move ball in other direction

    SwipeDirection swipeDirection = getSwipeDirectionByPointClass(direction);

    /// [isFreshMove ]'s value will be true when user move ball by finger-swipe for that one box where the ball is located
    bool isFreshMove = true;

    /// timer
    ballMovementTimer?.cancel();
    if (/*!(timer?.isActive ?? false)*/ true) {
      ballMovementTimer = Timer.periodic(
        const Duration(milliseconds: 10),
        (internalTimer) {
          if (internalTimer.tick != 1) isFreshMove = false;
          // printYellow("TICK:${internalTimer.tick}");
          Point<int> newPosition = ballPosition.value + direction;
          // printYellow("ballPosition:$ballPosition | newPosition: $newPosition");
          if (isMoveValid(newPosition)) {
            if (isFreshMove ? true : !multiPathConditionChecker(swipeDirection)) {
              ballPosition.value = newPosition;
              if (currentPath.any((element) => element == newPosition)) {
                // printOkStatus("Exists !!");
                currentPath.removeLast();
              } else {
                currentPath.add(newPosition);
              }
              afterOneIterationFunction();

              // printOkStatus("$currentPath");
            } else {
              ballMovementTimer?.cancel();
            }
          } else {
            ballMovementTimer?.cancel();
            printYellow("Invalid Move");
          }
        },
      );
    }
    /*else {
      printYellow("Yellow");
    }*/
  }

  void moveBallFrequentlyUntilFindMultiPathPossibility({required Point<int> direction, required Function() afterOneIterationFunction, bool isFreshMovement = true}) {
    /// AUTOMATED
    /// this function is for when user swipe in one direction that time ball will move forward until it find other multi-paths or it reaches to the end of the maze where ball can not move further,
    // Point<int> direction= swipeDirection.name==SwipeDirection.left?;
    // printOkStatus("$isFreshMovement");
    // printOkStatus("direction: $direction || ballPosition: $ballPosition");
    SwipeDirection swipeDirection = getSwipeDirectionByPointClass(direction);

    /// [isFreshMove ]'s value will be true when user move ball by finger-swipe for that one box where the ball is located
    bool isFreshMove = isFreshMovement;

    /// timer
    ballMovementTimer?.cancel();

    if (swipeDirection.name != SwipeDirection.none.name || direction != const Point(0, 0)) {
      ballMovementTimer = Timer.periodic(
        const Duration(milliseconds: 100),
        (internalTimer) {
          if (internalTimer.tick != 1) isFreshMove = false;
          // printYellow("TICK:${internalTimer.tick}");
          Point<int> newPosition = ballPosition.value + direction;
          // printYellow("ballPosition:$ballPosition | newPosition: $newPosition");
          if (isMoveValid(newPosition)) {
            updateGameStatus(win: false);

            if (isFreshMove ? true : !multiPathConditionChecker(swipeDirection)) {
              ballPosition.value = newPosition;

              /// Animations
              // updateBallPositionByAnimation(newPosition.x, newPosition.y);

              ///

              if (currentPath.any((element) => element == newPosition)) {
                isFreshMove = false;
                // printOkStatus("Exists !!");
                currentPath.removeLast();

                /// remove data from completed path on winning track

                removePointToCompletedWinningTrack(ballPosition.value);
              } else {
                currentPath.add(newPosition);

                /// add data to completed path on winning track
                addPointToCompletedWinningTrack(ballPosition.value);
              }

              /// one iteration
              afterOneIterationFunction();
              totalTraversedPath.add(ballPosition.value);
              // totalTraversedPathOnWinningTrack.add(ballPosition);
              // printOkStatus("$path");
            } else {
              ballMovementTimer?.cancel();
              printErrors(type: "Multi-Path:", errText: " TRUE");
            }
          } else {
            ballMovementTimer?.cancel();

            /// check where the next we have to trigger so ball can move in other direction
            /// this code executes when ball moving in one direction and after few moves if it not getting move in this direction due to unavailability of the empty path where ball can travel
            ///
            /// STEPS:
            /// 1. Find up and down empty path when ball is traversing horizontally AND find left and right empty path when ball is traversing vertically
            /// 2. Start traversal of the ball in possible direction
            ///
            // printYellow("Invalid Move");
            // printYellow("==>${possiblePathFinderWhenBallStuck(swipeDirection: swipeDirection, directionPoint: direction, isFreshMovement: true)}");

            /// CODE:

            if ((isFreshMove ? true : multiPathConditionChecker(swipeDirection)) && !checkBallIsStuck(ballPosition.value) && ballDestination != ballPosition.value) {
              moveBallFrequentlyUntilFindMultiPathPossibility(
                direction: possiblePathFinderWhenBallStuck(swipeDirection: swipeDirection, directionPoint: direction, isFreshMovement: true),
                afterOneIterationFunction: afterOneIterationFunction,
                // isFreshMovement: true,
              );
            } else if (ballDestination == ballPosition.value) {
              printOkStatus("===========> WINNER <===========");
              updateGameStatus(win: true);
            } else {}
          }
        },
      );
    } else {
      printYellow("Yellow");
    }
  }

  /// TODO
  /// Animations Functions
  void updateBallPositionByAnimation(SwipeDirection swipeDirection, Point<int> direction, Point<int> oldPosition, Point<int> newPosition) {
    // printYellow("$newPosition |   ${controller.status}");

    void addCompletedFlow() {
      List<Point<int>> newCurrentPath = MazeGameFunctions.getWinningPath(mazeData: mazeTrueFalseData, startBallPosition: initialBallPosition, destinationBallPosition: ballPosition.value);
      if (newCurrentPath.length + 1 == currentPath.length || newCurrentPath.length - 1 == currentPath.length) {
        currentPath.value = MazeGameFunctions.getWinningPath(mazeData: mazeTrueFalseData, startBallPosition: initialBallPosition, destinationBallPosition: ballPosition.value);
      }
    }

    // printOkStatus("==>$oldPosition | $newPosition | ${oldPosition.distanceTo(newPosition)}");

    /// Animations
    ///
    double distance = oldPosition.distanceTo(newPosition);
    int dynamicSpeed = ((tileSize * 5) * distance).toInt();
    int speedInMilliseconds = /*dynamicSpeed > 100 ? 100 :*/ dynamicSpeed;
    printYellow("SPEED: $speedInMilliseconds");
    controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: speedInMilliseconds),
    );

    animation = Tween<Offset>(begin: Offset((oldPosition.y + 0.5) * tileSize, (oldPosition.x + 0.5) * tileSize), end: Offset((newPosition.y + 0.5) * tileSize, (newPosition.x + 0.5) * tileSize)).animate(controller);

    animation.addListener(() {
      // printOkStatus(animation.status.name.toUpperCase());
      // Access the current value of the animation
      Offset currentPosition = animation.value;

      // Convert it to Point<int>
      Point<int> currentPoint = Point<int>(currentPosition.dy ~/ tileSize, currentPosition.dx ~/ tileSize);

      ballPosition.value = currentPoint;
      updateGameStatus(win: false);

      /// =========<<<   add/remove completed points on wining track or off track
      if (currentPath.last != ballPosition.value) {
        if (currentPath.any((element) => element == ballPosition.value)) {
          // printOkStatus("Exists !!");
          currentPath.removeLast();

          /// remove data from completed path on winning track
          removePointToCompletedWinningTrack(ballPosition.value);
        } else {
          currentPath.add(ballPosition.value);

          /// add data to completed path on winning track
          addPointToCompletedWinningTrack(ballPosition.value);
        }

        /// one iteration
        totalTraversedPath.add(ballPosition.value);

        /// TEMP CODE
        currentPath.value = MazeGameFunctions.getWinningPath(mazeData: mazeTrueFalseData, startBallPosition: initialBallPosition, destinationBallPosition: ballPosition.value);
      } else {}

      /// >>>=========

      /// #############################################    AUTO TRAVERSAL CODE    ######################################################

      if (ballPosition.value == newBallAnimationPosition.value && animation.status == AnimationStatus.completed) {
        // printYellow("STUCK: $ballPosition | MP:${multiPathConditionCheckerByPosition(swipeDirection, ballPosition.value)} | N-STK:${!checkBallIsStuck(ballPosition.value)}");

        // updateBallPositionByAnimation(ballPosition, newPosition)

        if (animation.status == AnimationStatus.completed && !checkBallIsStuck(newPosition) && ballDestination != ballPosition.value) {
          // printYellow("INVALID ==>");
          Point<int> possiblePath = possiblePathFinderWhenBallStuck(isFreshMovement: true, swipeDirection: swipeDirection, directionPoint: direction);

          /// AUTO TRAVERSE MOVEMENT
          moveBallFrequentlyUsingAnimation(direction: possiblePath, /*isFreshMovement: true,*/ afterOneIterationFunction: () {});
        } else if (ballDestination == ballPosition.value) {
          printOkStatus("===========> WINNER <===========");
          updateGameStatus(win: true);
          finishGameActivity();
        } else {}

        // addCompletedFlow();
      } else {
        addCompletedFlow();
        // printOkStatus("NOT-STUCK: $ballPosition");
      }

      ///
    });

    controller
      ..addListener(() {
        update();
      })
      ..forward().whenComplete(() => /*printOkStatus("$newPosition |   ${controller.status}")*/ null);
    newBallAnimationPosition.value = newPosition;

    update();
  }

  void _playSound() async {
    HapticFeedback.lightImpact();

    // Load your sounds file from assets or a URL
    await _audioPlayer.play(UrlSource('https://cdn.uppbeat.io/audio-files/06ae18f31ba6d2a5dd6b6f941ae28d0a/69ec45faa09452b4339b9dc1e3631174/01e58062411244f96ec1bced7e7fc229/STREAMING-whoosh-swift-cut-jam-fx-1-00-00.mp3'));
    // await _audioPlayer.play(AssetSource('sounds/swipe.mp3')); // Ensure you have a sounds file in the correct path
  }

  void moveBallFrequentlyUsingAnimation({required Point<int> direction, required Function() afterOneIterationFunction, bool isFreshMovement = true}) {
    /// AUTOMATED
    /// this function is for when user swipe in one direction that time ball will move forward until it find other multi-paths or it reaches to the end of the maze where ball can not move further,
    SwipeDirection swipeDirection = getSwipeDirectionByPointClass(direction);

    /// [ isFreshMove ]'s value will be true when user move ball by finger-swipe for that one box where the ball is located
    // bool isFreshMove = isFreshMovement;

    printOkStatus("${swipeDirection.name}  |  B: ${ballPosition.value}");
    Point<int> oldPosition = ballPosition.value;
    Point<int> newPosition = ballPosition.value + direction;

    /// TEMP
    if (swipeDirection.name == SwipeDirection.none.name) {
      currentPath.value = MazeGameFunctions.getWinningPath(mazeData: mazeTrueFalseData, startBallPosition: initialBallPosition, destinationBallPosition: ballPosition.value);
    }

    while (isMoveValid(newPosition) ? !multiPathConditionCheckerByPosition(swipeDirection, newPosition) : false) {
      // isFreshMove = false;
      HapticFeedback.lightImpact();
      _playSound();

      newPosition = newPosition + direction;

      if (isMoveValid(newPosition)) {
        printYellow("VALID B:${ballPosition.value}");

        ballPosition.value = newPosition;

        updateBallPositionByAnimation(swipeDirection, direction, oldPosition, newPosition);
      } else if (true) {
        printYellow("invalid MOVE ### B:${ballPosition.value}");
        // currentPath.value = MazeGameFunctions.getWinningPath(mazeData: mazeTrueFalseData, startBallPosition: initialBallPosition, destinationBallPosition: ballPosition.value);

        // if (ballPosition.value == initialBallPosition) {
        //   totalTraversedPathOnWinningTrack.value = [ballPosition.value];
        //   printOkStatus("${totalTraversedPathOnWinningTrack} & ${idealWinningPath}");
        // }
        // printOkStatus("${totalTraversedPathOnWinningTrack} & ${idealWinningPath}");
        // printYellow("${currentPath}");
      }
    }
  }
}

enum SwipeDirection { left, up, right, down, none }

class Node {
  final Point<int> position;
  final int g; // cost from start to current node
  final int h; // heuristic cost (estimated cost from current node to goal)
  final int f; // total cost (g + h)
  final Node? parent;

  Node(this.position, this.g, this.h, this.parent) : f = g + h;

  @override
  String toString() {
    return 'Node{position: $position, g: $g, h: $h, f: $f}';
  }
}

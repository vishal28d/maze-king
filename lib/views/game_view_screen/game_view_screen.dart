import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:maze_king/views/game_view_screen/circular_countdown%20_timer.dart';

import '../../exports.dart';
import '../../packages/custom_pop_scope/custom_will_pop.dart';
import '../../res/widgets/app_bar.dart';
import '../../res/widgets/app_dialog.dart';
import 'game_controller.dart';

class MazeGameViewScreen extends StatefulWidget {
  const MazeGameViewScreen({super.key});

  @override
  State<MazeGameViewScreen> createState() => _MazeGameViewScreenState();
}

class _MazeGameViewScreenState extends State<MazeGameViewScreen>
    with WidgetsBindingObserver {
  MazeGameController con = Get.put(MazeGameController());
  final GlobalKey<CircularCountdownTimerState> _timerKey = GlobalKey<CircularCountdownTimerState>();

  @override
  void initState() {
    super.initState();
    // Listen to changes in game state and stop timer if the game is finished
    con.isGameFinished.listen((isFinished) {
      if (isFinished) {
        _timerKey.currentState?.stopTimer();
      }
    });
  }

  void willPopBackDialog() {
    try {
      if (Get.currentRoute == AppRoutes.gameViewScreen) {
        AppDialogs.dashboardCommonDialog(
          Get.context!,
          dialogTitle: 'Are you sure want to EXIT?',
          buttonTitle: "EXIT",
          barrierDismissible: RxBool(true),
          showButton: RxBool(true),
          descriptionChild: const Padding(
            padding: EdgeInsets.symmetric(horizontal: defaultPadding),
            child:
            Text("You will be not able to play this game once you exit!"),
          ),
          buttonOnTap: () async {
            if (await getConnectivityResult()) {
              Get.back();
              con.finishGameActivity();
            }
          },
        );
      }
    } catch (e) {
      printOkStatus("-");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // printOkStatus("${con.currentPath}");
      // printOkStatus(con.remainingTimeToStartGameStr.value);

      return ConditionalWillPopScope(
        // canPop: con.isFreePracticeMode.isFalse ? con.canPop.value : true,
        // onPopInvoked: (val) {
        //   printYellow("onPopInvoked: $val");
        //   if (con.isFreePracticeMode.isFalse && con.canShowExitDialog.value && val) {
        //     willPopBackDialog();
        //   }
        // },
        onWillPop: () {
          printYellow("onPopInvoked");
          if (con.isFreePracticeMode.isFalse) {
            if (con.canPop.value) {
              return Future.value(con.canPop.value);
            } else {
              willPopBackDialog();
              return Future.value(con.canPop.value);
            }
          } else {
            /// Practice
            return Future.value(con.canPop.value);
          }
        },
        shouldAddCallback:
        Platform.isIOS /*? con.isFreePracticeMode.isFalse : true*/,
        child: GestureDetector(
          onHorizontalDragEnd: con.isGameFinished.isFalse
              ? (details) {
            if (con.animation.status == AnimationStatus.completed) {
              if ((details.primaryVelocity ?? 0) > 0) {
                // Swiped right
                // printOkStatus("Swiped right!");
                // mazeGame.moveBallFrequentlyByGesture(const Point(0, 1));
                con.moveBallFrequentlyUsingAnimation(
                    direction: const Point(0, 1),
                    afterOneIterationFunction: () {
                      setState(() {});
                    });
              } else if ((details.primaryVelocity ?? 0) < 0) {
                // Swiped left
                // printOkStatus("Swiped left!");
                // mazeGame.moveBallFrequentlyByGesture(const Point(0, -1));
                con.moveBallFrequentlyUsingAnimation(
                    direction: const Point(0, -1),
                    afterOneIterationFunction: () {
                      setState(() {});
                    });
              }
            }
          }
              : null,
          onVerticalDragEnd: con.isGameFinished.isFalse
              ? (details) {
            if (con.animation.status == AnimationStatus.completed) {
              if ((details.primaryVelocity ?? 0) > 0) {
                // Swiped down
                // printOkStatus("Swiped down!");
                // mazeGame.moveBallFrequentlyByGesture(const Point(1, 0));
                con.moveBallFrequentlyUsingAnimation(
                    direction: const Point(1, 0),
                    afterOneIterationFunction: () {
                      setState(() {});
                    });
              } else if ((details.primaryVelocity ?? 0) < 0) {
                // Swiped up
                // printOkStatus("Swiped up!");
                // mazeGame.moveBallFrequentlyByGesture(const Point(-1, 0));
                con.moveBallFrequentlyUsingAnimation(
                    direction: const Point(-1, 0),
                    afterOneIterationFunction: () {
                      setState(() {});
                    });
                // mazeGame.
              }
            }
          }
              : null,

        child: Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: Container(
            color: Colors.transparent,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                /// ----------- APP-BAR -------------

                // MyAppBar(
                //   title: con.totalRemainingTimeStr.value,
                //   isLargeTitle: true,
                //   subTitle: "Time Left",
                //   centerTitle: true,
                //   showBackIcon: true,
                //   isOrangeBg: con.isFreePracticeMode.value,
                //   myAppBarSize: MyAppBarSize.medium,
                //   backgroundColor: Colors.transparent,
                //   onTapOfBackButton: () {
                //     if (con.isFreePracticeMode.isFalse) {
                //       willPopBackDialog();
                //     } else {
                //       con.canPop.value = true;
                //       Get.back();
                //     }
                //   },
                // ),
                MyAppBar(
                  // title: 'Title Here',
                  // subTitle: 'Subtitle Here',
                  showBackIcon: true,
                  isOrangeBg: con.isFreePracticeMode.value,
                  myAppBarSize: MyAppBarSize.medium,
                  backgroundColor: Colors.transparent,
                  onTapOfBackButton: () {
                    if (con.isFreePracticeMode.isFalse) {
                      willPopBackDialog();
                    } else {
                      con.canPop.value = true;
                      Get.back();
                    }
                  },
                  bottomWidget: CircularCountdownTimer(
                    key: _timerKey,
                    seconds: 60, // set your countdown time
                    subtitle: 'Time Left',
                    size: 50, // adjust size as needed
                  ),
                ),

                const Spacer(),

                /// ----------- GAME VIEW -------------
                ...([
                  con.isGameFinished.isFalse
                      ? con.isLoading.isFalse
                      ? Container(
                    color: AppColors.gameBackground,
                    alignment: Alignment.center,
                    child: con.isLoading.isFalse
                        ? Center(
                      child: GetBuilder<MazeGameController>(
                          builder: (logic) {
                            return Column(
                              children: [
                                // if (kDebugMode) Text("WP: ${con.onTrackBallProgressPercentage().round()} | TP: ${con.totalBallProgressPercentage().round()} | BP: ${con.ballPosition.value} | CPLI: ${con.currentPath.last}"),
                                /// MAZE VIEW
                                CustomPaint(
                                  size: Size(
                                      Get.size.width,
                                      Get.size.height -
                                          (con.tileSize *
                                              con.rows.value)),
                                  willChange: true,
                                  painter: MazePainter(
                                      tileSize: con.tileSize,
                                      strokeWidth: con.tileSize / 3,
                                      strokeSpacing:
                                      con.tileSize / 2,
                                      offsetAnimation:
                                      con.animation),
                                ),
                              ],
                            );
                          }),
                    )
                        : UiUtils.appCircularProgressIndicator(
                        color: Colors.black),
                  )
                      : UiUtils.appCircularProgressIndicator()
                      : con.isFreePracticeMode.isFalse
                      ? Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: defaultPadding * 2,
                        vertical: (defaultPadding * 5).h),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        UiUtils.appCircularProgressIndicator(),
                        defaultPadding.verticalSpace,
                        Text(
                          // "You game has been finished. Please wait few seconds",
                          "You game has been finished. Please wait 3 minutes for result",
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall
                              ?.copyWith(
                            color:
                            AppColors.subTextColor(context),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  )
                      : Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: defaultPadding * 2),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          con.isWinner.value
                              ? AppAssets.winnerIllustrationPNG
                              : AppAssets.gameOverIllustrationPNG,
                          width: Get.width / 1.8,
                        ),
                        Text(
                          "${con.isWinner.value ? 'Impressive! ' : ''}Your success rate in the practice maze indicates a ${(con.onTrackBallProgressPercentage().isEqual(100) || con.onTrackBallProgressPercentage().isGreaterThan(100) || con.isWinner.value) ? '100' : con.initialBallPosition == con.ballPosition.value ? '0' : con.onTrackBallProgressPercentage().round()}% chance of winning the contest. Join now!",
                          // "🎉 Congratulations on completing the practice maze game! 🎉",
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(
                            // color: AppColors.subTextColor(context),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        if (con.isNavFromCuntDownScreen.isFalse)
                          AppButton(
                              padding: const EdgeInsets.symmetric(
                                  vertical: defaultPadding)
                                  .copyWith(top: defaultPadding * 2),
                              title: "Join Contest",
                              onPressed: () {

                                Get.back();
                              }),
                        GestureDetector(
                          onTap: () {
                            _timerKey.currentState!.resetTimer();
                            con.generatePracticeMazeView();
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: defaultPadding,
                                vertical: con.isNavFromCuntDownScreen
                                    .isFalse
                                    ? 0
                                    : defaultPadding * 2),
                            child: Text(
                              "Play Again!",
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                color: Theme.of(context)
                                    .colorScheme
                                    .tertiary,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ]),
                if (con.isGameFinished.isTrue)
                  const Spacer(
                    flex: 2,
                  ),
                if (con.isGameFinished.isFalse)
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton.outlined(
                        onPressed: () {
                          if (con.animation.status ==
                              AnimationStatus.completed) {
                            con.moveBallFrequentlyUsingAnimation(
                                direction: const Point(-1, 0),
                                afterOneIterationFunction: () {
                                  setState(() {});
                                });
                          }
                        },
                        icon: Icon(
                          Icons.keyboard_arrow_up,
                          color: AppColors.black,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton.outlined(
                            onPressed: () {
                              if (con.animation.status ==
                                  AnimationStatus.completed) {
                                con.moveBallFrequentlyUsingAnimation(
                                    direction: const Point(0, -1),
                                    afterOneIterationFunction: () {
                                      setState(() {});
                                    });
                              }
                            },
                            icon: Icon(
                              Icons.keyboard_arrow_left,
                              color: AppColors.black,
                            ),
                          ),
                          const SizedBox(
                            width: 50,
                          ),
                          IconButton.outlined(
                            onPressed: () {
                              if (con.animation.status ==
                                  AnimationStatus.completed) {
                                con.moveBallFrequentlyUsingAnimation(
                                    direction: const Point(0, 1),
                                    afterOneIterationFunction: () {
                                      setState(() {});
                                    });
                              }
                            },
                            icon: Icon(
                              Icons.keyboard_arrow_right,
                              color: AppColors.black,
                            ),
                          ),
                        ],
                      ),
                      IconButton.outlined(
                        onPressed: () {
                          if (con.animation.status ==
                              AnimationStatus.completed) {
                            con.moveBallFrequentlyUsingAnimation(
                                direction: const Point(1, 0),
                                afterOneIterationFunction: () {
                                  setState(() {});
                                });
                          }
                        },
                        icon: Icon(
                          Icons.keyboard_arrow_down,
                          color: AppColors.black,
                        ),
                      ),
                    ],
                  ),

                SizedBox(
                  height: Get.height * .05,
                )
              ],
            ),
          ),
        ),
        ),
      );
    });
  }
}

/// ***********************************************************************************
///                                 MAZE VIEW BUILDER
/// ***********************************************************************************

class MazePainter extends CustomPainter {
  final double tileSize;
  final double strokeWidth;
  final double strokeSpacing;

  // final double ballNewX;
  // final double ballNewY;

  final Animation<Offset> offsetAnimation;

  // BallPainter(this.offsetAnimation) : super(repaint: offsetAnimation);

  MazePainter(
      {required this.tileSize,
        required this.strokeWidth,
        required this.strokeSpacing,
        required this.offsetAnimation /* required this.ballNewX, required this.ballNewY*/
      });

  MazeGameController gameCon = Get.find<MazeGameController>();

  bool checkLeftPointIsWall(int currentRow, int currentColumn) {
    if (currentColumn != 0) {
      return gameCon.mazeTrueFalseData[currentRow][currentColumn - 1];
    } else {
      return false;
    }
  }

  bool checkRightPointIsWall(int currentRow, int currentColumn) {
    if (currentColumn != gameCon.mazeTrueFalseData[0].length - 1) {
      return gameCon.mazeTrueFalseData[currentRow][currentColumn + 1];
    } else {
      return false;
    }
  }

  bool checkUpPointIsWall(int currentRow, int currentColumn) {
    if (currentRow != 0) {
      return gameCon.mazeTrueFalseData[currentRow - 1][currentColumn];
    } else {
      return false;
    }
  }

  bool checkDownPointIsWall(int currentRow, int currentColumn) {
    if (currentRow != gameCon.mazeTrueFalseData.length - 1) {
      return gameCon.mazeTrueFalseData[currentRow + 1][currentColumn];
    } else {
      return false;
    }
  }

  List<Point<int>> getCurrentPath(
      Point<int> initialPosition, Point<int> currentPosition) {
    List<Point<int>> path = [];

    int currentRow = initialPosition.x;
    int currentCol = initialPosition.y;

    while (currentRow != currentPosition.x || currentCol != currentPosition.y) {
      if (currentRow < currentPosition.x) {
        currentRow++;
      } else if (currentRow > currentPosition.x) {
        currentRow--;
      } else if (currentCol < currentPosition.y) {
        currentCol++;
      } else if (currentCol > currentPosition.y) {
        currentCol--;
      }

      path.add(Point(currentRow, currentCol));
    }

    return path;
  }

  @override
  void paint(Canvas canvas, Size size) {
    // offsetToPoint();
    final paint = Paint()
      ..color = Colors.transparent
      ..style = PaintingStyle.fill;

    for (int i = 0; i < gameCon.rows.value; i++) {
      for (int j = 0; j < gameCon.columns.value; j++) {
        if (gameCon.mazeTrueFalseData[i][j]) {
          /// Square Wall
          paint
            ..color = Colors.transparent
            ..style = PaintingStyle.fill;
          canvas.drawRect(
            Rect.fromPoints(
              Offset(j * tileSize, i * tileSize),
              Offset((j + 1) * tileSize, (i + 1) * tileSize),
            ),
            paint,
          );
        } else {
          /// Traversable Path
          paint
            ..color = AppColors.gameTraversablePath
            ..style = PaintingStyle.fill;
          canvas.drawRect(
            Rect.fromPoints(
              Offset(j * tileSize, i * tileSize),
              Offset((j + 1) * tileSize, (i + 1) * tileSize),
            ),
            paint,
          );
        }
      }
    }

    /// #################################################################    Wall Painter    #####################################################################
    paint
      ..color = AppColors.gameWall
    // ..strokeWidth = tileSize * 0.1
      ..style = PaintingStyle.stroke;

    wallPainter(canvas, paint);

    /// ##################################################       Draw Ball's Initial & Destination Position       ################################################

    /// Initial
    paint
      ..color = AppColors.gameBall
      ..style = PaintingStyle.fill;
    canvas.drawCircle(
      /*Offset(
        (gameCon.ballPosition.y + 0.5) * tileSize,
        (gameCon.ballPosition.x + 0.5) * tileSize,
      ),*/

      offsetAnimation.value,
      tileSize / 1.6,
      paint,
    );

    /// Destination
    paint
      ..color = AppColors.red.withOpacity(
          0.5) /*AppColors.gameDestination*/ // Set the fill color to transparent
      ..strokeWidth = tileSize * 0.1 // Set the border width
      ..style = PaintingStyle.fill; // Set the painting style to stroke

    canvas.drawCircle(
      Offset(
        (gameCon.ballDestination.y + 0.5) * tileSize,
        (gameCon.ballDestination.x + 0.5) * tileSize,
      ),
      tileSize / 1.6,
      paint,
    );

    paint
      ..color = AppColors.red.withOpacity(
          .99) /*AppColors.gameDestination*/ // Set the fill color to transparent
      ..strokeWidth = tileSize * 0.1 // Set the border width
      ..style = PaintingStyle.stroke; // Set the painting style to stroke

    canvas.drawCircle(
      Offset(
        (gameCon.ballDestination.y + 0.5) * tileSize,
        (gameCon.ballDestination.x + 0.5) * tileSize,
      ),
      tileSize / 1.6,
      paint,
    );

    /// #######################################################         Draw Current-Completed Path         ########################################################

    paint
      ..strokeWidth = strokeWidth * 0.5
      ..strokeCap = StrokeCap.square
      ..color = AppColors.gameCompletedPath;

    // List<Point<int>> path = MazeGameFunctions().getWinningPath(mazeData: gameCon.mazeTrueFalseData, startBallPosition: gameCon.initialBallPosition, destinationBallPosition: gameCon.ballPosition.value);

    for (int i = 0; i < gameCon.currentPath.length - 1; i++) {
      final start = Offset(
        (gameCon.currentPath[i].y + 0.5) * tileSize,
        (gameCon.currentPath[i].x + 0.5) * tileSize,
      );
      final end = Offset(
        (gameCon.currentPath[i + 1].y + 0.5) * tileSize,
        (gameCon.currentPath[i + 1].x + 0.5) * tileSize,
      );
      canvas.drawLine(start, end, paint);
    }

    /// ########################################################          Draw Winning Path          ########################################################
    // printOkStatus(LocalStorage.userMobile.value);
    if (gameCon.testingMobileNumbers.contains(LocalStorage.userMobile.value)) {
      paint.color = AppColors.gameWinningPath;
      paint.style = PaintingStyle.fill;

      // paint.strokeMiterLimit = tileSize;
      for (int i = 0; i < gameCon.idealWinningPath.length; i++) {
        canvas.drawRect(
          Rect.fromPoints(
              Offset(gameCon.idealWinningPath[i].y * tileSize,
                  gameCon.idealWinningPath[i].x * tileSize),
              Offset(
                (gameCon.idealWinningPath[i].y + 1) * tileSize,
                (gameCon.idealWinningPath[i].x + 1) * tileSize,
              )),
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

  void wallPainter(canvas, paint) {
    for (int i = 0; i < gameCon.rows.value; i++) {
      for (int j = 0; j < gameCon.columns.value; j++) {
        if (gameCon.mazeTrueFalseData[i][j]) {
          paint
            ..style = PaintingStyle.fill
            ..strokeWidth = strokeWidth;

          /// -------------------------------------------------- One PATH -------------------------------------------------------------------
          if ((!checkLeftPointIsWall(i, j) &&
              !checkUpPointIsWall(i, j) &&
              !checkRightPointIsWall(i, j) &&
              checkDownPointIsWall(i, j))) {
            /// vertical line, empty space on top
            canvas.drawLine(
              Offset(j * tileSize + strokeSpacing, i * tileSize + strokeWidth),
              Offset((j + 1) * tileSize - strokeSpacing, (i + 1) * tileSize),
              paint,
            );
          } else if ((!checkLeftPointIsWall(i, j) &&
              checkUpPointIsWall(i, j) &&
              !checkRightPointIsWall(i, j) &&
              !checkDownPointIsWall(i, j))) {
            /// vertical line, empty space on bottom
            canvas.drawLine(
              Offset(j * tileSize + strokeSpacing, i * tileSize),
              Offset((j + 1) * tileSize - strokeSpacing,
                  (i + 1) * tileSize - strokeWidth),
              paint,
            );
          } else if ((!checkLeftPointIsWall(
              i, j) /*&& checkUpPointIsWall(i, j)*/ &&
              !checkRightPointIsWall(i, j) /*&& checkDownPointIsWall(i, j)*/)) {
            /// vertical line
            canvas.drawLine(
              Offset(j * tileSize + strokeSpacing, i * tileSize),
              Offset((j + 1) * tileSize - strokeSpacing, (i + 1) * tileSize),
              paint,
            );
          }

          if (checkLeftPointIsWall(i, j) &&
              !checkUpPointIsWall(i, j) &&
              checkRightPointIsWall(i, j) &&
              !checkDownPointIsWall(i, j)) {
            /// horizontal line
            canvas.drawLine(
              Offset(j * tileSize, i * tileSize + strokeSpacing),
              Offset((j + 1) * tileSize, (i + 1) * tileSize - strokeSpacing),
              paint,
            );
          } else if (!checkLeftPointIsWall(i, j) &&
              !checkUpPointIsWall(i, j) &&
              checkRightPointIsWall(i, j) &&
              !checkDownPointIsWall(i, j)) {
            /// horizontal line, empty space on left
            canvas.drawLine(
              Offset(j * tileSize + strokeWidth, i * tileSize + strokeSpacing),
              Offset((j + 1) * tileSize, (i + 1) * tileSize - strokeSpacing),
              paint,
            );
          } else if (checkLeftPointIsWall(i, j) &&
              !checkUpPointIsWall(i, j) &&
              !checkRightPointIsWall(i, j) &&
              !checkDownPointIsWall(i, j)) {
            /// horizontal line, empty space on right
            canvas.drawLine(
              Offset(j * tileSize, i * tileSize + strokeSpacing),
              Offset((j + 1) * tileSize - strokeWidth,
                  (i + 1) * tileSize - strokeSpacing),
              paint,
            );
          }

          /// -------------------------------------------------- 2 PATH -------------------------------------------------------------------
          /// -----             -----                |                         |
          /// |                     |                |                         |
          /// |                     |                ---------         ---------

          if (!checkLeftPointIsWall(i, j) &&
              !checkUpPointIsWall(i, j) &&
              checkRightPointIsWall(i, j) &&
              checkDownPointIsWall(i, j)) {
            /// top left corner
            canvas.drawLine(
              Offset(j * tileSize + strokeWidth, i * tileSize + strokeSpacing),
              Offset((j + 1) * tileSize, (i + 1) * tileSize - strokeSpacing),
              paint,
            );

            canvas.drawLine(
              Offset(
                  j * tileSize + strokeSpacing, i * tileSize + strokeSpacing),
              Offset((j + 1) * tileSize - strokeSpacing, (i + 1) * tileSize),
              paint,
            );
          }

          if (checkLeftPointIsWall(i, j) &&
              !checkUpPointIsWall(i, j) &&
              !checkRightPointIsWall(i, j) &&
              checkDownPointIsWall(i, j)) {
            /// top right corner
            canvas.drawLine(
              Offset(j * tileSize, i * tileSize + strokeSpacing),
              Offset((j + 1) * tileSize - strokeWidth,
                  (i + 1) * tileSize - strokeSpacing),
              paint,
            );

            canvas.drawLine(
              Offset(
                  j * tileSize + strokeSpacing, i * tileSize + strokeSpacing),
              Offset((j + 1) * tileSize - strokeSpacing, (i + 1) * tileSize),
              paint,
            );
          }

          if (!checkLeftPointIsWall(i, j) &&
              checkUpPointIsWall(i, j) &&
              checkRightPointIsWall(i, j) &&
              !checkDownPointIsWall(i, j)) {
            /// bottom left corner

            canvas.drawLine(
              Offset(
                  j * tileSize + strokeSpacing, i * tileSize + strokeSpacing),
              Offset((j + 1) * tileSize, (i + 1) * tileSize - strokeSpacing),
              paint,
            );

            canvas.drawLine(
              Offset(j * tileSize + strokeSpacing, i * tileSize),
              Offset((j + 1) * tileSize - strokeSpacing,
                  (i + 1) * tileSize - strokeWidth),
              paint,
            );
          }

          if (checkLeftPointIsWall(i, j) &&
              checkUpPointIsWall(i, j) &&
              !checkRightPointIsWall(i, j) &&
              !checkDownPointIsWall(i, j)) {
            /// bottom right corner
            canvas.drawLine(
              Offset(j * tileSize, i * tileSize + strokeSpacing),
              Offset((j + 1) * tileSize - strokeSpacing,
                  (i + 1) * tileSize - strokeSpacing),
              paint,
            );

            canvas.drawLine(
              Offset(j * tileSize + strokeSpacing, i * tileSize),
              Offset((j + 1) * tileSize - strokeSpacing,
                  (i + 1) * tileSize - strokeWidth),
              paint,
            );
          }

          /// -------------------------------------------------- 3 PATH -------------------------------------------------------------------

          if (!checkLeftPointIsWall(i, j) &&
              checkUpPointIsWall(i, j) &&
              checkRightPointIsWall(i, j) &&
              checkDownPointIsWall(i, j)) {
            /// top, bottom, right combined line
            /// |
            /// |-------
            /// |
            canvas.drawLine(
              Offset(
                  j * tileSize + strokeSpacing, i * tileSize + strokeSpacing),
              Offset((j + 1) * tileSize, (i + 1) * tileSize - strokeSpacing),
              paint,
            );

            canvas.drawLine(
              Offset(j * tileSize + strokeSpacing, i * tileSize),
              Offset((j + 1) * tileSize - strokeSpacing,
                  (i + 1) * tileSize /*- strokeWidth*/),
              paint,
            );
            // canvas.drawLine(
            //   Offset(j * tileSize + strokeSpacing, i * tileSize),
            //   Offset((j + 1) * tileSize - strokeSpacing, (i + 1) * tileSize),
            //   paint,
            // );
          }

          if (checkLeftPointIsWall(i, j) &&
              checkUpPointIsWall(i, j) &&
              !checkRightPointIsWall(i, j) &&
              checkDownPointIsWall(i, j)) {
            /// left, top, bottom combined line
            ///          |
            ///   -------|
            ///          |
            canvas.drawLine(
              Offset(j * tileSize, i * tileSize + strokeSpacing),
              Offset((j + 1) * tileSize - strokeSpacing,
                  (i + 1) * tileSize - strokeSpacing),
              paint,
            );

            canvas.drawLine(
              Offset(j * tileSize + strokeSpacing, i * tileSize),
              Offset((j + 1) * tileSize - strokeSpacing, (i + 1) * tileSize),
              paint,
            );
            // canvas.drawLine(
            //   Offset(j * tileSize + strokeSpacing, i * tileSize),
            //   Offset((j + 1) * tileSize - strokeSpacing, (i + 1) * tileSize),
            //   paint,
            // );
          }

          if (checkLeftPointIsWall(i, j) &&
              checkUpPointIsWall(i, j) &&
              checkRightPointIsWall(i, j) &&
              !checkDownPointIsWall(i, j)) {
            /// left, top, right combined line
            ///         |
            ///         |
            ///  ----------------

            canvas.drawLine(
              Offset(j * (tileSize), (i * tileSize) + strokeSpacing),
              Offset((j + 1) * tileSize, ((i + 1) * tileSize) - strokeSpacing),
              paint,
            );

            canvas.drawLine(
              Offset(j * (tileSize) + strokeSpacing, (i * tileSize)),
              Offset((j + 1) * tileSize - strokeSpacing,
                  ((i + 1) * tileSize - strokeSpacing)),
              paint,
            );
          }

          if (checkLeftPointIsWall(i, j) &&
              !checkUpPointIsWall(i, j) &&
              checkRightPointIsWall(i, j) &&
              checkDownPointIsWall(i, j)) {
            /// left, right, bottom combined line
            ///  ----------------
            ///         |
            ///         |

            canvas.drawLine(
              Offset(j * (tileSize), (i * tileSize) + strokeSpacing),
              Offset((j + 1) * tileSize, ((i + 1) * tileSize) - strokeSpacing),
              paint,
            );

            canvas.drawLine(
              Offset(j * (tileSize) + strokeSpacing,
                  (i * tileSize) + strokeSpacing),
              Offset((j + 1) * tileSize - strokeSpacing,
                  ((i + 1) * tileSize + strokeSpacing)),
              paint,
            );
          }

          if (checkLeftPointIsWall(i, j) &&
              checkUpPointIsWall(i, j) &&
              checkRightPointIsWall(i, j) &&
              checkDownPointIsWall(i, j)) {
            /// left, right, bottom combined line
            ///         |
            ///         |
            ///  ----------------
            ///         |
            ///         |

            canvas.drawLine(
              Offset(j * tileSize + strokeSpacing, i * tileSize),
              Offset((j + 1) * tileSize - strokeSpacing, (i + 1) * tileSize),
              paint,
            );

            canvas.drawLine(
              Offset(j * (tileSize), (i * tileSize) + strokeSpacing),
              Offset((j + 1) * tileSize, ((i + 1) * tileSize) - strokeSpacing),
              paint,
            );
          }
        }
      }
    }
  }
}

enum SwipeDirection { left, up, right, down, none }
import 'package:flutter/material.dart';
import 'dart:async';

class TicTacToeGame extends StatefulWidget {
  final String initialPlayer;

  TicTacToeGame({required this.initialPlayer});

  @override
  _TicTacToeGameState createState() => _TicTacToeGameState();
}

class _TicTacToeGameState extends State<TicTacToeGame> with TickerProviderStateMixin {
  List<String> board = List.filled(9, '');
  bool isPlayer1Turn = true;
  int remainingTime = 5;
  Timer? timer;
  int player1Score = 0;
  int player2Score = 0;
  String? winner;
  bool gameOver = false;

  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    isPlayer1Turn = widget.initialPlayer == 'X';
    startTimer();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );
  }

  void startTimer() {
    timer?.cancel(); // Cancel any existing timer
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (remainingTime > 0) {
          remainingTime--;
        } else {
          switchTurn();
        }
      });
    });
  }

  void switchTurn() {
    isPlayer1Turn = !isPlayer1Turn;
    remainingTime = 5;
  }

  void onTileTap(int index) {
    if (board[index] == '' && !gameOver) {
      setState(() {
        board[index] = isPlayer1Turn ? 'X' : 'O';
        _animationController.forward(from: 0.0);
        checkWinner();
        if (!gameOver) {
          switchTurn();
        }
      });
    }
  }

  void checkWinner() {
    final winningCombinations = [
      [0, 1, 2], [3, 4, 5], [6, 7, 8], // Rows
      [0, 3, 6], [1, 4, 7], [2, 5, 8], // Columns
      [0, 4, 8], [2, 4, 6] // Diagonals
    ];

    for (var combination in winningCombinations) {
      if (board[combination[0]] != '' &&
          board[combination[0]] == board[combination[1]] &&
          board[combination[1]] == board[combination[2]]) {
        setState(() {
          winner = board[combination[0]];
          gameOver = true;
          updateScore();
        });
        timer?.cancel(); // Stop the timer when game is over
        return;
      }
    }

    if (!board.contains('') && winner == null) {
      setState(() {
        gameOver = true;
        winner = 'Draw';
      });
      timer?.cancel(); // Stop the timer when game is over
    }
  }

  void updateScore() {
    if (winner == 'X') {
      player1Score++;
    } else if (winner == 'O') {
      player2Score++;
    }
  }

  void restartGame() {
    setState(() {
      board = List.filled(9, '');
      isPlayer1Turn = widget.initialPlayer == 'X';
      remainingTime = 5;
      winner = null;
      gameOver = false;
    });
    startTimer(); // Restart the timer
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.blue,
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '0:0${remainingTime}',
                  style: TextStyle(fontSize: 24, color: Colors.white),
                ),
                Text(
                  gameOver ? 'Game Over' : '${isPlayer1Turn ? "Player 1" : "Player 2"}\'s Turn',
                  style: TextStyle(fontSize: 24, color: Colors.white),
                ),
                SizedBox(height: 20),
                AspectRatio(
                  aspectRatio: 1,
                  child: Container(
                    margin: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                      ),
                      itemCount: 9,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () => onTileTap(index),
                          child: AnimatedBuilder(
                            animation: _animation,
                            builder: (context, child) {
                              return Transform.scale(
                                scale: board[index] == '' ? 1.0 : _animation.value,
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.black),
                                  ),
                                  child: Center(
                                    child: Text(
                                      board[index],
                                      style: TextStyle(fontSize: 48),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Player 1 (X): $player1Score | Player 2 (O): $player2Score',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
                if (gameOver)
                  Column(
                    children: [
                      SizedBox(height: 20),
                      Text(
                        winner == 'Draw' ? 'It\'s a Draw!' : 'Winner: ${winner == 'X' ? 'Player 1' : 'Player 2'}',
                        style: TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: restartGame,
                        child: Text('Restart Game'),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: Colors.blue),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    _animationController.dispose();
    super.dispose();
  }
}
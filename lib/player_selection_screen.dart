import 'package:flutter/material.dart';
import 'tic_tac_toe_game.dart';

class PlayerSelectionScreen extends StatelessWidget {
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
                  'TIC-TAC-TOE',
                  style: TextStyle(fontSize: 32, color: Colors.white, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                Text(
                  'Pick who goes first?',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildPlayerButton(context, 'X', Colors.red),
                    SizedBox(width: 20),
                    _buildPlayerButton(context, 'O', Colors.green),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPlayerButton(BuildContext context, String player, Color color) {
    return GestureDetector(
      onTap: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => TicTacToeGame(initialPlayer: player)),
        );
      },
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            player,
            style: TextStyle(fontSize: 48, color: color),
          ),
        ),
      ),
    );
  }
}
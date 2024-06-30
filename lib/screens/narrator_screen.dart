import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:mafia1/constants.dart';
import 'package:mafia1/models/user_role.dart';
import 'package:mafia1/screens/select_role_screen.dart';

class NarratorScreen extends StatefulWidget {
  final List<UserRole> userRoles;

  const NarratorScreen({super.key, required this.userRoles});

  @override
  // ignore: library_private_types_in_public_api
  _NarratorScreenState createState() => _NarratorScreenState();
}

class _NarratorScreenState extends State<NarratorScreen> {
  bool _showRoles = false;
  Duration _timerDuration = Duration.zero;
  late final Stopwatch _stopwatch;
  late final Ticker _ticker;
  bool _isRunning = false;
  late List<bool> _playerStatus;

  @override
  void initState() {
    super.initState();
    _stopwatch = Stopwatch();
    _ticker = Ticker((duration) {
      if (_stopwatch.isRunning) {
        setState(() {
          _timerDuration = _stopwatch.elapsed;
        });
      }
    })..start();
    _playerStatus = List<bool>.filled(widget.userRoles.length, true);
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  void _toggleRoles() {
    setState(() {
      _showRoles = !_showRoles;
    });
  }

  void _toggleTimer() {
    setState(() {
      if (_isRunning) {
        _stopwatch.reset();
        _stopwatch.stop();
        _timerDuration = Duration.zero; // Reset the timer duration
      } else {
        _stopwatch.start();
      }
      _isRunning = !_isRunning; // Toggle the running state
    });
  }

  void _togglePlayerStatus(int index) {
    setState(() {
      _playerStatus[index] = !_playerStatus[index];
    });
  }

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        Get.off(() => const SelectRoleScreen());
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: kYellowColor,
          title: Text('صفحه راوی', style: kTextStyle),
          actions: [
            IconButton(
              icon: Icon(
                _showRoles ? Icons.visibility : Icons.visibility_off,
                color: Colors.black,
              ),
              onPressed: _toggleRoles,
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: widget.userRoles.length,
                  itemBuilder: (context, index) {
                    final userRole = widget.userRoles[index];
                    return GestureDetector(
                      onTap: () => _togglePlayerStatus(index),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                          side: BorderSide(
                            color: kYellowColor,
                            width: 2,
                          ),
                        ),
                        color: _playerStatus[index] ? kYellowColor : Colors.transparent,
                        child: ListTile(
                          leading: Text(
                            userRole.user.name,
                            style: kTextStyle.copyWith(
                              color: _playerStatus[index] ? Colors.black : kYellowColor,
                              fontSize: 20,
                              decoration: _playerStatus[index]
                                  ? TextDecoration.none
                                  : TextDecoration.lineThrough,
                            ),
                          ),
                          trailing: _showRoles
                              ? Text(
                                  userRole.role.roleName,
                                  style: kTextStyle.copyWith(
                                    color: _playerStatus[index] ? Colors.black : kYellowColor,
                                    fontSize: 20,
                                    decoration: _playerStatus[index]
                                        ? TextDecoration.none
                                        : TextDecoration.lineThrough,
                                  ),
                                )
                              : null,
                        ),
                      ),
                    );
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: kYellowColor,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: InkWell(
                  onTap: _toggleTimer,
                  child: _isRunning
                      ? Text(
                          _formatDuration(_timerDuration),
                          style: kTextStyle.copyWith(color: Colors.black, fontSize: 25),
                        )
                      : const Icon(Icons.hourglass_empty, color: Colors.black, size: 30),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }
}

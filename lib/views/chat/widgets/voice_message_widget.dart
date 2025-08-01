import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:social_media/constants/app_colors.dart';
import 'package:social_media/constants/app_text.dart';
import 'package:social_media/extensions/sized_box.dart';

class VoiceMessageWidget extends StatefulWidget {
  final String url;
  const VoiceMessageWidget({super.key, required this.url});

  @override
  State<VoiceMessageWidget> createState() => _VoiceMessageWidgetState();
}

class _VoiceMessageWidgetState extends State<VoiceMessageWidget> {
  late AudioPlayer _player;
  bool isPlaying = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();

    // Listen to player state to update play/pause button
    _player.playerStateStream.listen((state) {
      final playing = state.playing;
      final processingState = state.processingState;

      if (processingState == ProcessingState.completed) {
        // Audio finished playing
        if (mounted) {
          setState(() {
            isPlaying = false;
            _position = Duration.zero;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            isPlaying = playing;
          });
        }
      }
    });

    // Listen to position changes
    _player.positionStream.listen((pos) {
      if (mounted) {
        setState(() {
          _position = pos;
        });
      }
    });

    // Listen to duration changes
    _player.durationStream.listen((dur) {
      if (dur != null && mounted) {
        setState(() {
          _duration = dur;
        });
      }
    });

    // Set the audio source
    _setAudioSource();
  }

  Future<void> _setAudioSource() async {
    try {
      await _player.setUrl(widget.url);
    } catch (e) {
      // Handle load error
      debugPrint('Error loading audio source: $e');
    }
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  void togglePlay() async {
    if (isPlaying) {
      await _player.pause();
    } else {
      // If audio is completed, seek to start first
      final duration = _duration;
      final position = _position;
      if (position >= duration) {
        await _player.seek(Duration.zero);
      }
      await _player.play();
    }
  }

  String formatDuration(Duration d) {
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    double progressValue = 0;
    if (_duration.inMilliseconds > 0) {
      progressValue = _position.inMilliseconds / _duration.inMilliseconds;
      if (progressValue > 1) progressValue = 1;
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          visualDensity: VisualDensity.compact,
          color: AppColors.primaryColor,
          icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
          onPressed: togglePlay,
        ),
        SizedBox(
          width: 100,
          child: LinearProgressIndicator(
            value: progressValue,
            backgroundColor: AppColors.lightGrey,
            //   color: Colors.blueAccent,
            //  minHeight: 4,
          ),
        ),
        8.spaceX,
        CustomText(
          title: formatDuration(_position),
          size: 12,
          color: AppColors.black.withValues(alpha: 0.5),
        ),
      ],
    );
  }
}

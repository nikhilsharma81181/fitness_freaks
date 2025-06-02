import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fitness_freaks_flutter/core/constants/app_colors.dart';

class ChatMessage {
  final String content;
  final bool isUser;
  final DateTime timestamp;
  final List<WorkoutSuggestion>? workouts;
  final bool showStartWorkout;

  ChatMessage({
    required this.content,
    required this.isUser,
    required this.timestamp,
    this.workouts,
    this.showStartWorkout = false,
  });

  // Factory constructor for regular messages
  factory ChatMessage.regular({
    required String content,
    required bool isUser,
  }) {
    return ChatMessage(
      content: content,
      isUser: isUser,
      timestamp: DateTime.now(),
    );
  }

  // Factory constructor for messages with workout recommendations
  factory ChatMessage.withWorkouts({
    required String content,
    required List<WorkoutSuggestion> workouts,
  }) {
    return ChatMessage(
      content: content,
      isUser: false,
      timestamp: DateTime.now(),
      workouts: workouts,
    );
  }

  // Factory constructor for messages with start workout option
  factory ChatMessage.withStartWorkout({
    required String content,
    required WorkoutSuggestion workout,
  }) {
    return ChatMessage(
      content: content,
      isUser: false,
      timestamp: DateTime.now(),
      workouts: [workout],
      showStartWorkout: true,
    );
  }
}

class WorkoutSuggestion {
  final String name;
  final String type;
  final String duration;
  final String difficulty;
  final String description;

  WorkoutSuggestion({
    required this.name,
    required this.type,
    required this.duration,
    required this.difficulty,
    required this.description,
  });
}

class ChatView extends StatefulWidget {
  const ChatView({Key? key}) : super(key: key);

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> with TickerProviderStateMixin {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];
  bool _isAnimatingNewMessage = false;

  @override
  void initState() {
    super.initState();
    // Initialize with sample messages to match the provided UI
    _messages.addAll([
      ChatMessage.regular(
        content:
            "Hello! I'm your FitnessFreaks AI coach. How can I help you today?",
        isUser: false,
      ),
      ChatMessage.regular(
        content:
            "I need a workout for tomorrow morning. Something quick but effective.",
        isUser: true,
      ),
      ChatMessage.withWorkouts(
        content:
            "I've got some great options for a quick and effective morning workout. Here are a few recommendations based on your profile:",
        workouts: [
          WorkoutSuggestion(
            name: "Morning Energy Boost",
            type: "HIIT",
            duration: "20 min",
            difficulty: "Medium",
            description:
                "Quick cardio and bodyweight exercises to energize your day",
          ),
          WorkoutSuggestion(
            name: "Quick Core Crusher",
            type: "Strength",
            duration: "15 min",
            difficulty: "Medium",
            description:
                "Focused abdominal workout that will fire up your core",
          ),
        ],
      ),
      ChatMessage.regular(
        content: "The Morning Energy Boost looks perfect!",
        isUser: true,
      ),
      ChatMessage.withStartWorkout(
        content:
            "Great choice! The Morning Energy Boost is a fantastic way to start your day. Would you like to schedule this workout or start it now?",
        workout: WorkoutSuggestion(
          name: "Morning Energy Boost",
          type: "HIIT",
          duration: "20 min",
          difficulty: "Medium",
          description:
              "Quick cardio and bodyweight exercises to energize your day",
        ),
      ),
    ]);

    // Scroll to bottom after frame is rendered
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _sendMessage(String text) {
    if (text.trim().isEmpty) return;

    setState(() {
      // Add user message
      _messages.add(ChatMessage.regular(content: text, isUser: true));
      _isAnimatingNewMessage = true;
    });

    // Clear text field
    _messageController.clear();

    // Scroll to bottom
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });

    // Reset animation flag after a short delay
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() {
          _isAnimatingNewMessage = false;
        });
      }
    });

    // In a real app, you would call your AI service here
    // For demo, we'll just add a mock response after a delay
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _messages.add(
            ChatMessage.regular(
              content:
                  "Thanks for your message! I'm your AI fitness coach and I'm here to help you achieve your fitness goals.",
              isUser: false,
            ),
          );
        });

        // Scroll to bottom after adding AI response
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _scrollToBottom();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Custom background for chat (optional overlay)
        _buildBackground(),

        // Main content
        SafeArea(
          child: Column(
            children: [
              // Header
              _buildHeader(),

              // Messages
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  itemCount: _messages.length,
                  itemBuilder: (context, index) {
                    final message = _messages[index];
                    final bool isLastMessage = index == _messages.length - 1;

                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeOutBack,
                      transform: Matrix4.identity()
                        ..scale(isLastMessage && _isAnimatingNewMessage
                            ? 0.96
                            : 1.0),
                      margin: const EdgeInsets.only(bottom: 16),
                      child: MessageBubble(message: message),
                    );
                  },
                ),
              ),

              // Message input
              _buildMessageInput(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBackground() {
    return Stack(
      children: [
        // Additional radial gradient overlay for chat-specific styling
        Positioned(
          bottom: 0,
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.3,
            decoration: BoxDecoration(
              gradient: RadialGradient(
                colors: [
                  AppColors.chatGradient2.withOpacity(0.1),
                  Colors.transparent,
                ],
                center: Alignment.bottomCenter,
                radius: 1.2,
              ),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
              child: Container(color: Colors.transparent),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Title and subtitle
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Coach Chat',
                style: GoogleFonts.inter(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Connect with your guide',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  color: Colors.white.withOpacity(0.7),
                ),
              ),
            ],
          ),

          // Options button
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.1),
            ),
            child: Center(
              child: Icon(
                CupertinoIcons.ellipsis,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Colors.white.withOpacity(0.1),
            width: 0.5,
          ),
        ),
        color: Colors.black.withOpacity(0.3),
      ),
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                // Text field
                Expanded(
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.1),
                        width: 0.5,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                        child: TextField(
                          controller: _messageController,
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 17,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Message your fitness coach...',
                            hintStyle: GoogleFonts.inter(
                              color: Colors.white.withOpacity(0.5),
                              fontSize: 15,
                            ),
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 16),
                            border: InputBorder.none,
                          ),
                          onSubmitted: _sendMessage,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                // Send button
                GestureDetector(
                  onTap: () => _sendMessage(_messageController.text),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          AppColors.chatGradient1,
                          AppColors.chatGradient2,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.chatGradient1.withOpacity(0.5),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Icon(
                        CupertinoIcons.arrow_up,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MessageBubble extends StatelessWidget {
  final ChatMessage message;

  const MessageBubble({
    Key? key,
    required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
          message.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (message.isUser) const Spacer(),

        // Limit bubble width based on screen size
        ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.75,
          ),
          child: Column(
            crossAxisAlignment: message.isUser
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            children: [
              // Message bubble
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    colors: message.isUser
                        ? [
                            AppColors.chatGradient1.withOpacity(0.8),
                            AppColors.chatGradient2.withOpacity(0.7),
                          ]
                        : [
                            Colors.black.withOpacity(0.5),
                            Colors.black.withOpacity(0.3),
                          ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  border: Border.all(
                    color: message.isUser
                        ? Colors.white.withOpacity(0.15)
                        : Colors.white.withOpacity(0.1),
                    width: 0.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: message.isUser
                          ? AppColors.chatGradient1.withOpacity(0.3)
                          : Colors.black.withOpacity(0.2),
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Message text
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Text(
                        message.content,
                        style: GoogleFonts.inter(
                          fontSize: 15,
                          color: Colors.white,
                        ),
                      ),
                    ),

                    // Workout suggestions if available
                    if (message.workouts != null &&
                        message.workouts!.isNotEmpty)
                      Column(
                        children: message.workouts!
                            .map((workout) => WorkoutCard(
                                  workout: workout,
                                  showStartButton: message.showStartWorkout,
                                ))
                            .toList(),
                      ),
                  ],
                ),
              ),

              // Timestamp
              Padding(
                padding: const EdgeInsets.only(top: 4, left: 8, right: 8),
                child: Text(
                  _formatTime(message.timestamp),
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: Colors.white.withOpacity(0.5),
                  ),
                ),
              ),
            ],
          ),
        ),

        if (!message.isUser) const Spacer(),
      ],
    );
  }

  String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour;
    final minute = dateTime.minute;
    final period = hour >= 12 ? 'PM' : 'AM';
    final formattedHour = hour > 12
        ? hour - 12
        : hour == 0
            ? 12
            : hour;
    final formattedMinute = minute.toString().padLeft(2, '0');
    return '$formattedHour:$formattedMinute $period';
  }
}

class WorkoutCard extends StatelessWidget {
  final WorkoutSuggestion workout;
  final bool showStartButton;

  const WorkoutCard({
    Key? key,
    required this.workout,
    this.showStartButton = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.black.withOpacity(0.2),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 0.5,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Workout type, duration and difficulty
                Row(
                  children: [
                    // Type badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: _getTypeColor(workout.type),
                      ),
                      child: Text(
                        workout.type,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ),

                    const Spacer(),

                    // Duration badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.black.withOpacity(0.3),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            CupertinoIcons.clock_fill,
                            size: 10,
                            color: Colors.white.withOpacity(0.8),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            workout.duration,
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: Colors.white.withOpacity(0.8),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 8),

                    // Difficulty badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.black.withOpacity(0.3),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            CupertinoIcons.flame_fill,
                            size: 10,
                            color: _getDifficultyColor(workout.difficulty),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            workout.difficulty,
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: _getDifficultyColor(workout.difficulty),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Workout name
                Text(
                  workout.name,
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 4),

                // Workout description
                Text(
                  workout.description,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.8),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                // Start workout button
                if (showStartButton) ...[
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: () {
                      // Implement start workout functionality
                    },
                    child: Container(
                      width: double.infinity,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        gradient: LinearGradient(
                          colors: [
                            AppColors.chatGradient1,
                            AppColors.chatGradient2,
                          ],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.chatGradient1.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            CupertinoIcons.play_fill,
                            color: Colors.white,
                            size: 14,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Start Workout',
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getTypeColor(String type) {
    switch (type) {
      case 'Strength':
        return Colors.blue;
      case 'Cardio':
        return const Color.fromRGBO(243, 77, 90, 1);
      case 'Flexibility':
        return const Color.fromRGBO(0, 230, 179, 1);
      case 'HIIT':
        return const Color.fromRGBO(140, 89, 242, 1);
      default:
        return const Color.fromRGBO(38, 217, 140, 1);
    }
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty) {
      case 'Easy':
        return const Color.fromRGBO(38, 217, 140, 1);
      case 'Medium':
        return const Color.fromRGBO(255, 204, 0, 1);
      case 'Hard':
        return const Color.fromRGBO(243, 77, 90, 1);
      default:
        return Colors.white.withOpacity(0.8);
    }
  }
}

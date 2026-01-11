import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:bmi/modules/login/login_animation_controller.dart';

class ProgressScreen extends StatefulWidget {
  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen>
    with TickerProviderStateMixin {
  late Stream<QuerySnapshot> userStream;
  late AnimationController _scaleController;

  @override
  void initState() {
    super.initState();
    User? user = FirebaseAuth.instance.currentUser;
    userStream = FirebaseFirestore.instance
        .collection('profiles')
        .where('uid', isEqualTo: user!.uid)
        .snapshots();

    _scaleController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.water_drop),
        title: Text(
  'Your Characters',
  style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1),
),

        elevation: 0,
        actions: [
          PopupMenuButton(
            icon: Icon(Icons.home),
              onSelected: (val) {
                if (val == 1) Navigator.pushNamed(context, 'home');
              },
              itemBuilder: (context) => [
                    PopupMenuItem(
                      child: Text('Home'),
                      value: 1,
                    ),
                  ]),
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              signOut(context);
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: userStream,
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
            final docData = snapshot.data!.docs[0].data() as Map<String, dynamic>;
            int completedDays = (docData['streak'] ?? 0);
            return charactersGrid(completedDays);

          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }


  Future<void> signOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pushNamedAndRemoveUntil(context, 'login', (route) => false);
    } catch (e) {
      print('Error signing out: $e');
    }
  }
  Widget charactersGrid(int completedDays) {
  final characters = List.generate(
    9,
    (index) => 'assets/lottie/char_${index + 1}.json',
  );

  return Padding(
    padding: const EdgeInsets.all(20),
    child: GridView.builder(
      itemCount: characters.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 0.85,
      ),
      itemBuilder: (context, index) {
        final isUnlocked = index < completedDays;

        return GestureDetector(
          onTap: (){
            if(isUnlocked){
              final player = AudioPlayer();
              player.play(AssetSource('sounds/sound_${index+1}.mp3'));
            }
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8,
                  offset: Offset(0, 6),
                )
              ],
            ),
            child: Column(
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      Center(
                        child: Opacity(
                          opacity: isUnlocked ? 1 : 0.3,
                          child: Lottie.asset(
                            characters[index],
                            repeat: isUnlocked,
                          ),
                        ),
                      ),
                      if (!isUnlocked)
                        const Positioned(
                          top: 12,
                          right: 12,
                          child: Icon(
                            Icons.lock,
                            color: Colors.grey,
                            size: 26,
                          ),
                        ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: isUnlocked ? Colors.blue[50] : Colors.grey[100],
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(22),
                      bottomRight: Radius.circular(22),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      characterNames[index],
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isUnlocked ? Colors.blue[700] : Colors.grey[500],
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ),
  );
}



}

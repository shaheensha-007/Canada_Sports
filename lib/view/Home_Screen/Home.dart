import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../Model/gamelobby_Model.dart';
import '../../contoller/Gamelobby_Controller/Gamelobby_controller.dart';
import '../../widgets/AppTheme.dart';

class Home_Screen extends StatefulWidget {
  const Home_Screen({super.key});

  @override
  State<Home_Screen> createState() => _Home_ScreenState();
}

class _Home_ScreenState extends State<Home_Screen> {
  final GamelobbyController controller = Get.put(GamelobbyController());
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Detect when user scrolls to the bottom
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
        controller.fetchGames(isLoadMore: true);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppTheme.deepPurple, AppTheme.primaryPurple, AppTheme.lightPurple],
          ),
        ),
        child: SafeArea(
          child: RefreshIndicator(
            onRefresh: () => controller.fetchGames(),
            child: CustomScrollView(
              controller: _scrollController,
              slivers: [
                // 1. STATIC HEADER SECTION
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        _buildTopBar(),
                        const SizedBox(height: 30),
                        _buildGreeting(),
                        const SizedBox(height: 25),
                      ],
                    ),
                  ),
                ),

                // 2. THE GAME GRID
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  sliver: Obx(() {
                    if (controller.isLoading.value && controller.gameList.isEmpty) {
                      return const SliverFillRemaining(
                        child: Center(child: CircularProgressIndicator(color: Colors.white)),
                      );
                    }

                    if (controller.gameList.isEmpty) {
                      return const SliverToBoxAdapter(
                        child: Center(child: Text("No Games Found", style: TextStyle(color: Colors.white))),
                      );
                    }

                    return SliverGrid(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 15,
                        mainAxisSpacing: 15,
                        childAspectRatio: 0.8,
                      ),
                      delegate: SliverChildBuilderDelegate(
                            (context, index) => _buildGameCard(controller.gameList[index]),
                        childCount: controller.gameList.length,
                      ),
                    );
                  }),
                ),

                // 3. PAGINATION LOADER (Bottom)
                SliverToBoxAdapter(
                  child: Obx(() {
                    return controller.isMoreLoading.value
                        ? const Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Center(child: CircularProgressIndicator(color: Colors.greenAccent)),
                    )
                        : const SizedBox(height: 80);
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- UI COMPONENTS ---

  Widget _buildTopBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildTopIcon(Icons.grid_view_rounded),
        Text(
          "GAME LOBBY",
          style: GoogleFonts.orbitron(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 2,
          ),
        ),
        const CircleAvatar(
          radius: 20,
          backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=jumman'),
        ),
      ],
    );
  }

  Widget _buildGreeting() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Hey Jumman 👋",
          style: GoogleFonts.poppins(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        const SizedBox(height: 8),
        const Text(
          "Select your favorite game and start winning.",
          style: TextStyle(color: Colors.white70, fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildGameCard(GamelobbyModel game) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
              child: Image.network(
                game.urlThumb ?? "",
                width: double.infinity,
                fit: BoxFit.cover,
                // IMAGE VIEW RESOLUTION:
                loadingBuilder: (context, child, loading) {
                  if (loading == null) return child;
                  return const Center(child: CircularProgressIndicator(strokeWidth: 2));
                },
                errorBuilder: (context, error, stackTrace) =>
                const Center(child: Icon(Icons.broken_image, color: Colors.white54)),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  game.name ?? "Game",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
                Text(
                  game.product ?? "Casino",
                  style: const TextStyle(color: Colors.greenAccent, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopIcon(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(color: Colors.white10, shape: BoxShape.circle),
      child: Icon(icon, color: Colors.white),
    );
  }
}
import 'package:flutter/material.dart';

class HotHome extends StatefulWidget {
  final ScrollController scrollController;
  const HotHome({
    super.key,
    required this.scrollController,
  });

  @override
  State<HotHome> createState() => _HotHomeState();
}

class _HotHomeState extends State<HotHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(right: 12, left: 12),
        child: Column(
          children: [
            Expanded(
              child: GridView.count(
                controller: widget.scrollController,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                crossAxisCount: 2,
                childAspectRatio: 180 / 216,
                children: List.generate(
                    11,
                    (index) => Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.blueAccent,
                          ),
                        )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

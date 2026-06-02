import 'package:flutter/material.dart';

class CarouselItem {
  final String title;
  final String content;
  final TextDirection textDir;

  CarouselItem({
    required this.title,
    required this.content,
    // this.textDir = TextDirection.ltr,
    required this.textDir,
  });
}

class TextCarousel extends StatefulWidget {
  final List<CarouselItem> items;

  const TextCarousel({super.key, required this.items});

  @override
  State<TextCarousel> createState() => _TextCarouselState();
}

class _TextCarouselState extends State<TextCarousel>
    with SingleTickerProviderStateMixin<TextCarousel> {
  late final PageController pageController;
  late final TabController tabController;

  int currentPage = 0;

  @override
  void initState() {
    super.initState();
    pageController = PageController();
    tabController = TabController(length: widget.items.length, vsync: this);
  }

  @override
  void dispose() {
    pageController.dispose();
    tabController.dispose();
    super.dispose();
  }

  void _goToNextPage() {
    if (currentPage < widget.items.length - 1) {
      pageController.animateToPage(
        currentPage + 1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _goToPreviousPage() {
    if (currentPage > 0) {
      pageController.animateToPage(
        currentPage - 1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: double.infinity,
        // height: 250,
        color: Colors.white,
        child: Column(
          children: [
            Expanded(
              child: Row(
                children: [
                  IconButton(
                    onPressed: currentPage > 0 ? _goToPreviousPage : null,
                    icon: const Icon(Icons.chevron_left),
                    iconSize: 32,
                    color: Colors.deepPurple,
                  ),
                  Expanded(
                    child: PageView.builder(
                      controller: pageController,
                      itemCount: widget.items.length,
                      onPageChanged: (index) {
                        setState(() {
                          currentPage = index;
                          tabController.animateTo(index);
                        });
                      },
                      itemBuilder: (context, index) {
                        final item = widget.items[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                item.title,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.deepPurple,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                textDirection: item.textDir,
                                item.content,
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(
                                      color: Colors.black87,
                                      height: 1.5,
                                    ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  IconButton(
                    onPressed: currentPage < widget.items.length - 1
                        ? _goToNextPage
                        : null,
                    icon: const Icon(Icons.chevron_right),
                    iconSize: 32,
                    color: Colors.deepPurple,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            TabPageSelector(
              controller: tabController,
              color: Colors.grey.shade300,
              selectedColor: Colors.deepPurple,
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}

// const Color darkBlue = Color.fromARGB(255, 18, 32, 47);

// class TextCarousal extends StatefulWidget {
//   const TextCarousal({super.key});

//   @override
//   State<TextCarousal> createState() => _TextCarousalState();
// }

// class _TextCarousalState extends State<TextCarousal>
//     with SingleTickerProviderStateMixin<TextCarousal> {
//   final PageController pageController = PageController();
//   late TabController tabController;

//   static const textList = [
//     'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
//     'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
//     'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
//   ];

//   @override
//   void initState() {
//     tabController = TabController(length: textList.length, vsync: this);
//     pageController.addListener(_updateTabController);
//     super.initState();
//   }

//   @override
//   void dispose() {
//     pageController.removeListener(_updateTabController);
//     super.dispose();
//   }

//   void _updateTabController() {
//     tabController.index = pageController.page!.toInt();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Container(
//         width: double.infinity,
//         height: 220,
//         color: Colors.white,
//         child: Column(
//           children: [
//             SizedBox(
//               height: 160,
//               width: 250,
//               child: PageView.builder(
//                 controller: pageController,
//                 itemCount: textList.length,
//                 itemBuilder: (context, index) => Center(
//                   child: Text(
//                     textList[index],
//                     textAlign: TextAlign.center,
//                     style: Theme.of(
//                       context,
//                     ).textTheme.bodyMedium!.copyWith(color: Colors.black),
//                   ),
//                 ),
//               ),
//             ),
//             TabPageSelector(controller: tabController),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class CustomTextSelector extends StatefulWidget {
//   final List<String> items;
//   final Function(String) onSelectionChanged;

//   const CustomTextSelector({
//     super.key,
//     required this.items,
//     required this.onSelectionChanged,
//   });

//   @override
//   State<CustomTextSelector> createState() => _CustomTextSelectorState();
// }

// class _CustomTextSelectorState extends State<CustomTextSelector> {
//   int _currentIndex = 0;

//   void _next() {
//     setState(() {
//       _currentIndex = (_currentIndex + 1) % widget.items.length;
//       widget.onSelectionChanged(widget.items[_currentIndex]);
//     });
//   }

//   void _previous() {
//     setState(() {
//       _currentIndex =
//           (_currentIndex - 1 + widget.items.length) % widget.items.length;
//       widget.onSelectionChanged(widget.items[_currentIndex]);
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         IconButton(
//           icon: const Icon(
//             Icons.chevron_left,
//             size: 30,
//             color: Colors.deepPurple,
//           ),
//           onPressed: _previous,
//         ),
//         Container(
//           padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//           child: Text(
//             widget.items[_currentIndex],
//             style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//           ),
//         ),
//         IconButton(
//           icon: const Icon(
//             Icons.chevron_right,
//             size: 30,
//             color: Colors.deepPurple,
//           ),
//           onPressed: _next,
//         ),
//       ],
//     );
//   }
// }

import 'package:discover/components/gradient_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:discover/model/item_model.dart';
import 'package:discover/services/api_service.dart';

class DiscoveryPage extends StatefulWidget {
  @override
  _DiscoveryPageState createState() => _DiscoveryPageState();
}

class _DiscoveryPageState extends State<DiscoveryPage> {
  final ApiService apiService = ApiService();
  List<ItemModel> items = [];
  int page = 1;
  int limit = 10;
  bool isLoading = false;
  bool hasMoreData = true;

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    loadItems();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      loadItems();
    }
  }

  Future<void> loadItems() async {
    if (isLoading || !hasMoreData) return;

    setState(() {
      isLoading = true;
    });

    try {
      final List<ItemModel> newItems = await apiService.fetchData(page, limit);
      if (newItems.isEmpty) {
        setState(() {
          hasMoreData = false;
        });
      } else {
        setState(() {
          items.addAll(newItems);
          page++;
        });
      }
    } catch (e) {
      print('Error fetching data: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error loading data. Please try again.'),
        ),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _refresh() async {
    setState(() {
      page = 1;
      items.clear();
      hasMoreData = true;
    });

    await loadItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GradientAppBar(
        gradientBegin: Color.fromARGB(255, 249, 74, 74),
        gradientEnd: const Color.fromARGB(255, 249, 126, 126),
        title: "Discoverrr",
      ),

      body: RefreshIndicator(
        onRefresh: _refresh,
        child: ListView.builder(
          itemCount: items.length + (isLoading ? 1 : 0),
          itemBuilder: (BuildContext context, int index) {
            if (index == items.length) {
              return (isLoading)
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(child: CircularProgressIndicator()),
                    )
                  : SizedBox.shrink();
            } else {
              ItemModel item = items[index];
              return Card(
                child: ListTile(
                  title: Text(item.title),
                  subtitle: Text(item.description),
                  leading: item.imageUrl.isNotEmpty
                      ? Image.network(
                          item.imageUrl,
                          width: 50,
                          height: 50,
                        )
                      : SizedBox.shrink(),
                ),
              );
            }
          },
          controller: _scrollController,
        ),
      ),
    );
  }
}

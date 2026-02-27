import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

const Color kPrimaryBlue = Color(0xFF1E3A8A); // Bleu plus foncé
const Color kDarkBlue = Color(0xFF0F172A);    // Bleu très foncé
const String kCartStorageKey = 'cart_product_ids';
const String kConnectedStorageKey = 'connected_user';

void main() {
  runApp(const MyApp());
}

class Product {
  const Product({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.description,
  });

  final String id;
  final String name;
  final String imageUrl;
  final String price;
  final String description;
}

const List<Product> kProducts = [
  Product(
    id: 'p1',
    name: 'Savon Karité Ekzòt',
    imageUrl: 'https://images.unsplash.com/photo-1589890787815-8f6f1e740f5e?w=500&fit=crop',
    price: '75 HTG',
    description: 'Savon rich ak karité pou idratasyon pwofon ak po sèk.',
  ),
  Product(
    id: 'p2',
    name: 'Savon Sitwon Joli',
    imageUrl: 'https://images.unsplash.com/photo-1587563871167-2b0fdef6b94e?w=500&fit=crop',
    price: '60 HTG',
    description: 'Sant sitwon fre ak pwopriyete netwayaj natirèl pisan.',
  ),
  Product(
    id: 'p3',
    name: 'Savon Aloès Vèt',
    imageUrl: 'https://images.unsplash.com/photo-1600585154340-be6161a56a0c?w=500&fit=crop',
    price: '65 HTG',
    description: 'Aloès vera pou apaze po ensite ak pwoteje kont lanati.',
  ),
  Product(
    id: 'p4',
    name: 'Savon Lavann Rélaks',
    imageUrl: 'https://images.unsplash.com/photo-1542601906990-b4d3fb778b09?w=500&fit=crop',
    price: '85 HTG',
    description: 'Lavann pou detann misk ak kalme lespri apre yon jou long.',
  ),
  Product(
    id: 'p5',
    name: 'Savon Mant Freche',
    imageUrl: 'https://images.unsplash.com/photo-1584430163504-6d66e6bfd922?w=500&fit=crop',
    price: '70 HTG',
    description: 'Mant pou yon sans freche ak revigòre po a chak maten.',
  ),
  Product(
    id: 'p6',
    name: 'Savon Woz Delika',
    imageUrl: 'https://images.unsplash.com/photo-1574169208507-84376144848b?w=500&fit=crop',
    price: '90 HTG',
    description: 'Ekstrè woz ak lwil esansyèl pou yon po dous ak parfim.',
  ),
];


Future<Set<String>> _readCartIds() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final List<String> ids = prefs.getStringList(kCartStorageKey) ?? <String>[];
  return ids.toSet();
}

Future<void> _writeCartIds(Set<String> ids) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setStringList(kCartStorageKey, ids.toList());
}

Future<List<Product>> _readCartProducts() async {
  final Set<String> ids = await _readCartIds();
  return kProducts.where((Product item) => ids.contains(item.id)).toList();
}

Future<void> buyProduct(BuildContext context, Product product) async {
  final Set<String> ids = await _readCartIds();
  final bool isNew = ids.add(product.id);
  await _writeCartIds(ids);

  if (!context.mounted) {
    return;
  }

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        isNew
            ? '${product.name} ajoute nan panyen.'
            : '${product.name} deja nan panyen.',
      ),
      duration: const Duration(seconds: 2),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'EBoutikoo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: kPrimaryBlue),
        scaffoldBackgroundColor: const Color(0xFFF8FAFC),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Product> previewItems = kProducts;

    return Scaffold(
      drawer: const AppSideMenu(currentIndex: 0),
      drawerEdgeDragWidth: 96,
      appBar: AppBar(
        leading: const AppMenuButton(),
        backgroundColor: kPrimaryBlue,
        foregroundColor: Colors.white,
        title: const Text('EBoutikoo'),
        actions: [
          IconButton(
            tooltip: 'Panye',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(builder: (_) => const CartPage()),
              );
            },
            icon: const Icon(Icons.shopping_cart_checkout),
          ),
          TextButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Fonksyon peye a pa disponib.')),
              );
            },
            icon: const Icon(Icons.payment, color: Colors.white, size: 18),
            label: const Text('PEYE', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            _CategoryBox(
              label: 'Kategori Savon Natirèl',
              icon: Icons.eco,
              onTap: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute<void>(
                    builder: (_) => const ProductListPage(),
                  ),
                );
              },
            ),
            const SizedBox(height: 10),
            _CategoryBox(
              label: 'Tout Pwodwi yo',
              icon: Icons.category_outlined,
              onTap: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute<void>(
                    builder: (_) => const ProductListPage(),
                  ),
                );
              },
            ),
            const SizedBox(height: 12),
            Expanded(
              child: GridView.builder(
                itemCount: previewItems.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.63,
                ),
                itemBuilder: (BuildContext context, int index) {
                  final Product product = previewItems[index];
                  return _HomeProductCard(product: product);
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const AppBottomNav(currentIndex: 0),
    );
  }
}

class _CategoryBox extends StatelessWidget {
  const _CategoryBox({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Container(
          height: 74,
          width: double.infinity,
          decoration: BoxDecoration(
            color: kDarkBlue,
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Row(
            children: [
              Icon(icon, color: Colors.white),
              const Spacer(),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HomeProductCard extends StatelessWidget {
  const _HomeProductCard({required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: InkWell(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => DetailPage(product: product),
                  ),
                );
              },
              child: SizedBox.expand(
                child: NetworkProductImage(url: product.imageUrl),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 6, 8, 2),
            child: Text(
              product.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              'Savon kreyòl',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 11),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 0, 4, 2),
            child: Row(
              children: [
                IconButton(
                  onPressed: () => buyProduct(context, product),
                  icon: const Icon(Icons.shopping_cart),
                  color: Colors.black,
                  iconSize: 20,
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.favorite),
                  color: kDarkBlue,
                  iconSize: 20,
                ),
                const Spacer(),
                IconButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => DetailPage(product: product),
                      ),
                    );
                  },
                  icon: const Icon(Icons.open_in_new),
                  iconSize: 18,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DetailPage extends StatelessWidget {
  const DetailPage({super.key, required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppSideMenu(currentIndex: -1),
      drawerEdgeDragWidth: 96,
      appBar: AppBar(
        leading: const AppMenuButton(),
        backgroundColor: kPrimaryBlue,
        foregroundColor: Colors.white,
        title: const Text('DETAY'),
        actions: [
          TextButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Fonksyon sa pa disponib.')),
              );
            },
            icon: const Icon(Icons.payment, color: Colors.white, size: 18),
            label: const Text('PEYE', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: AspectRatio(
              aspectRatio: 16 / 11,
              child: NetworkProductImage(url: product.imageUrl),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            product.name,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            product.price,
            style: TextStyle(
              fontSize: 16,
              color: Colors.green.shade700,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            product.description,
            style: const TextStyle(fontSize: 15, height: 1.5),
          ),
          const SizedBox(height: 10),
          const Text('Savon kreyòl se yon bon chwa pou swen po chak jou.'),
        ],
      ),
      floatingActionButton: FloatingActionButton.small(
        backgroundColor: const Color(0xFFF0BC18),
        foregroundColor: Colors.black,
        onPressed: () => buyProduct(context, product),
        child: const Icon(Icons.add_shopping_cart),
      ),
      bottomNavigationBar: const AppBottomNav(currentIndex: 2),
    );
  }
}

class ProductListPage extends StatelessWidget {
  const ProductListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: kPrimaryBlue,
        foregroundColor: Colors.white,
        title: const Text('Lis Pwodwi'),
        actions: [
          IconButton(
            tooltip: 'Panye',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(builder: (_) => const CartPage()),
              );
            },
            icon: const Icon(Icons.shopping_cart),
          ),
          TextButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Fonksyon paye a pa disponib.')),
              );
            },
            icon: const Icon(Icons.credit_card, color: Colors.white, size: 18),
            label: const Text('PEYE', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: GridView.builder(
          itemCount: kProducts.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.67,
          ),
          itemBuilder: (BuildContext context, int index) {
            final Product product = kProducts[index];
            return Card(
              elevation: 2,
              clipBehavior: Clip.antiAlias,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(12),
                      ),
                      child: NetworkProductImage(url: product.imageUrl),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 6, 8, 2),
                    child: Text(
                      product.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      'Savon kreyòl',
                      style: TextStyle(fontSize: 11),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(4, 0, 4, 2),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () => buyProduct(context, product),
                          icon: const Icon(Icons.shopping_cart),
                          iconSize: 20,
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.favorite),
                          color: kDarkBlue,
                          iconSize: 20,
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute<void>(
                                builder: (_) => DetailPage(product: product),
                              ),
                            );
                          },
                          icon: const Icon(Icons.open_in_new),
                          iconSize: 18,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: const AppBottomNav(currentIndex: 2),
    );
  }
}

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  bool _loading = true;
  List<Product> _items = <Product>[];

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  Future<void> _loadItems() async {
    final List<Product> products = await _readCartProducts();
    if (!mounted) {
      return;
    }
    setState(() {
      _items = products;
      _loading = false;
    });
  }

  Future<void> _removeItem(String id) async {
    final Set<String> ids = await _readCartIds();
    ids.remove(id);
    await _writeCartIds(ids);
    await _loadItems();
  }

  Future<void> _clearAll() async {
    await _writeCartIds(<String>{});
    await _loadItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppSideMenu(currentIndex: 1),
      drawerEdgeDragWidth: 96,
      appBar: AppBar(
        leading: const AppMenuButton(),
        backgroundColor: kPrimaryBlue,
        foregroundColor: Colors.white,
        title: Text('Panye (${_items.length})'),
        actions: [
          if (_items.isNotEmpty)
            IconButton(
              tooltip: 'Efase tout',
              onPressed: _clearAll,
              icon: const Icon(Icons.delete_sweep),
            ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _items.isEmpty
              ? const Center(
                  child: Text(
                    'Panyen ou vid pou kounye a.',
                    style: TextStyle(fontSize: 16),
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.all(12),
                  itemCount: _items.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (BuildContext context, int index) {
                    final Product product = _items[index];
                    return Card(
                      child: ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: SizedBox(
                            width: 62,
                            height: 62,
                            child: NetworkProductImage(url: product.imageUrl),
                          ),
                        ),
                        title: Text(product.name),
                        subtitle: Text(product.price),
                        trailing: IconButton(
                          onPressed: () => _removeItem(product.id),
                          icon: const Icon(Icons.delete, color: Colors.red),
                        ),
                      ),
                    );
                  },
                ),
      bottomNavigationBar: const AppBottomNav(currentIndex: 1),
    );
  }
}

class NetworkProductImage extends StatelessWidget {
  const NetworkProductImage({super.key, required this.url});

  final String url;

  @override
  Widget build(BuildContext context) {
    return Image.network(
      url,
      fit: BoxFit.cover,
      loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? p) {
        if (p == null) {
          return child;
        }
        final int? total = p.expectedTotalBytes;
        final double? value =
            total != null ? p.cumulativeBytesLoaded / total : null;
        return Center(
          child: CircularProgressIndicator(value: value),
        );
      },
      errorBuilder: (BuildContext context, Object error, StackTrace? stack) {
        return Container(
          color: const Color(0xFFDBE2F9),
          child: const Center(
            child: Icon(Icons.broken_image, color: kDarkBlue, size: 34),
          ),
        );
      },
    );
  }
}

class AppMenuButton extends StatelessWidget {
  const AppMenuButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (BuildContext ctx) {
        return IconButton(
          tooltip: 'Meni',
          onPressed: () => Scaffold.of(ctx).openDrawer(),
          iconSize: 28,
          icon: const Icon(Icons.menu_rounded, color: Colors.white),
        );
      },
    );
  }
}

class AppSideMenu extends StatefulWidget {
  const AppSideMenu({super.key, required this.currentIndex});

  final int currentIndex;

  @override
  State<AppSideMenu> createState() => _AppSideMenuState();
}

class _AppSideMenuState extends State<AppSideMenu> {
  bool _connected = false;

  @override
  void initState() {
    super.initState();
    _loadConnectedState();
  }

  Future<void> _loadConnectedState() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool value = prefs.getBool(kConnectedStorageKey) ?? false;
    if (!mounted) {
      return;
    }
    setState(() {
      _connected = value;
    });
  }

  Future<void> _setConnected(bool value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(kConnectedStorageKey, value);
    if (!mounted) {
      return;
    }
    setState(() {
      _connected = value;
    });
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(value ? 'Ou konekte kounye a.' : 'Ou dekonekte kounye a.'),
      ),
    );
  }

  void _goToProductList() {
    Navigator.of(context).pop();
    if (widget.currentIndex == 2) {
      return;
    }
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(builder: (_) => const ProductListPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(16, 52, 16, 18),
            color: kPrimaryBlue,
            child: const Text(
              'EBoutikoo',
              style: TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ListTile(
            leading: Icon(
              _connected ? Icons.verified_user : Icons.login,
              color: kDarkBlue,
            ),
            title: const Text('Konekte'),
            onTap: () => _setConnected(true),
          ),
          ListTile(
            leading: const Icon(Icons.grid_view_rounded, color: kDarkBlue),
            title: const Text('Lis pwodwi'),
            onTap: _goToProductList,
          ),
          ListTile(
            leading: const Icon(Icons.logout, color: kDarkBlue),
            title: const Text('Dekonekte'),
            onTap: () => _setConnected(false),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                _connected ? 'Estatis: Konekte' : 'Estatis: Dekonekte',
                style: const TextStyle(
                  color: Colors.black54,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AppBottomNav extends StatelessWidget {
  const AppBottomNav({super.key, required this.currentIndex});

  final int currentIndex;

  void _onTap(BuildContext context, int index) {
    if (index == currentIndex) {
      return;
    }

    Widget page;
    if (index == 0) {
      page = const HomePage();
    } else if (index == 1) {
      page = const CartPage();
    } else {
      page = const ProductListPage();
    }

    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(builder: (_) => page),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      selectedItemColor: kPrimaryBlue,
      onTap: (int index) => _onTap(context, index),
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_rounded),
          label: 'Lakay',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_cart_rounded),
          label: 'Panye',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.grid_view_rounded),
          label: 'Pwodwi',
        ),
      ],
    );
  }
}

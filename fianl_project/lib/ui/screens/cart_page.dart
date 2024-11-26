import 'package:fianl_project/constants.dart';
import 'package:fianl_project/models/plants.dart';
import 'package:fianl_project/ui/screens/widgets/plant_widget.dart';
import 'package:flutter/material.dart';

class CartPage extends StatefulWidget {
  final List<Plant> addedToCartPlants;
  const CartPage({Key? key, required this.addedToCartPlants}) : super(key: key);

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  // Map to track the quantity of each plant in the cart
  late Map<int, int> quantities;

  @override
  void initState() {
    super.initState();
    // Initialize the quantities map
    quantities = {for (int i = 0; i < widget.addedToCartPlants.length; i++) i: 1};
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: widget.addedToCartPlants.isEmpty
          ? Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 80,
                    child: Image.asset('assets/images/add-cart.png'),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Your Cart is Empty',
                    style: TextStyle(
                      color: Constants.primaryColor,
                      fontWeight: FontWeight.w300,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            )
          : Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 30),
              height: size.height,
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: widget.addedToCartPlants.length,
                      scrollDirection: Axis.vertical,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        return Stack(
                          children: [
                            // PlantWidget to display plant details
                            PlantWidget(
                              index: index,
                              plantList: widget.addedToCartPlants,
                            ),
                            // Positioned counter for quantity
                            Positioned(
                              right: 15,
                              top: -5,
                              
                              child: Column(
                                children: [
                                  IconButton(
                                    iconSize: 15,
                                    icon: const Icon(Icons.remove),
                                    onPressed: () {
                                      setState(() {
                                        if (quantities[index]! > 1) {
                                          quantities[index] = quantities[index]! - 1;
                                        }
                                      });
                                    },
                                  ),
                                  // Safely access quantities[index], and if null, fallback to 1
                                  Text(
                                    quantities[index]?.toString() ?? '1',
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                  IconButton(
                                     iconSize: 15,
                                    icon: const Icon(Icons.add),
                                    onPressed: () {
                                      setState(() {
                                        quantities[index] = (quantities[index] ?? 0) + 1;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                            // Positioned delete button
                            Positioned(
                              right: -10,
                              top: 34,
                              child: IconButton(
                                icon: Icon(
                                  Icons.delete,
                                  color: const Color.fromARGB(255, 8, 105, 92),
                                ),
                                onPressed: () {
                                  setState(() {
                                    widget.addedToCartPlants.removeAt(index);
                                    quantities.remove(index);
                                  });
                                },
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  Column(
                    children: [
                      const Divider(
                        thickness: 1.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            'Totals',
                            style: TextStyle(
                              fontSize: 23,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          Text(
                            r'$' +
                                widget.addedToCartPlants
                                    .asMap()
                                    .entries
                                    .fold<double>(
                                      0,
                                      (total, entry) => total +
                                          (entry.value.price *
                                              (quantities[entry.key] ?? 1)), // Default to 1 if null
                                    )
                                    .toStringAsFixed(2),
                            style: TextStyle(
                              fontSize: 24.0,
                              color: Constants.primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}

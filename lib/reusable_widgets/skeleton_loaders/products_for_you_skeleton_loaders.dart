import 'package:flutter/material.dart';

class ProductTileSkeleton extends StatefulWidget {
	const ProductTileSkeleton({Key? key}) : super(key: key);

	@override
	State<ProductTileSkeleton> createState() => _ProductTileSkeletonState();
}

class _ProductTileSkeletonState extends State<ProductTileSkeleton> with SingleTickerProviderStateMixin {
	late AnimationController _controller;

	@override
	void initState() {
		super.initState();
		_controller = AnimationController(
			vsync: this,
			duration: const Duration(milliseconds: 1200),
		)..repeat();
	}

	@override
	void dispose() {
		_controller.dispose();
		super.dispose();
	}

	@override
	Widget build(BuildContext context) {
		return Card(
			shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
			child: Column(
				crossAxisAlignment: CrossAxisAlignment.stretch,
				children: [
					// Skeleton photo
					Expanded(
						flex: 3,
						child: ClipRRect(
							borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
							child: AnimatedBuilder(
								animation: _controller,
								builder: (context, child) {
									return ShaderMask(
										shaderCallback: (rect) {
											return LinearGradient(
												begin: Alignment.centerLeft,
												end: Alignment.centerRight,
												colors: [
													Colors.grey.shade300,
													Colors.grey.shade100,
													Colors.grey.shade300,
												],
												stops: [
													(_controller.value - 0.2).clamp(0.0, 1.0),
													_controller.value.clamp(0.0, 1.0),
													(_controller.value + 0.2).clamp(0.0, 1.0),
												],
											).createShader(rect);
										},
										child: Container(
											color: Colors.grey.shade300,
										),
									);
								},
							),
						),
					),
					// Skeleton details
					Expanded(
						flex: 2,
						child: Padding(
							padding: const EdgeInsets.all(8.0),
							child: Column(
								crossAxisAlignment: CrossAxisAlignment.start,
								mainAxisAlignment: MainAxisAlignment.spaceBetween,
								children: [
									Container(
										height: 16,
										width: double.infinity,
										decoration: BoxDecoration(
											color: Colors.grey.shade300,
											borderRadius: BorderRadius.circular(4),
										),
									),
									const SizedBox(height: 4),
									Container(
										height: 16,
										width: 60,
										decoration: BoxDecoration(
											color: Colors.grey.shade200,
											borderRadius: BorderRadius.circular(4),
										),
									),
									const SizedBox(height: 4),
									Container(
										height: 14,
										width: 40,
										decoration: BoxDecoration(
											color: Colors.grey.shade200,
											borderRadius: BorderRadius.circular(4),
										),
									),
								],
							),
						),
					),
				],
			),
		);
	}
}

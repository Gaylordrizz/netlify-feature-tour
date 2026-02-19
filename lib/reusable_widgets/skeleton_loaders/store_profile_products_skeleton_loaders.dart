import 'package:flutter/material.dart';

class StoreProfileProductSkeleton extends StatefulWidget {
	const StoreProfileProductSkeleton({Key? key}) : super(key: key);

	@override
	State<StoreProfileProductSkeleton> createState() => _StoreProfileProductSkeletonState();
}

class _StoreProfileProductSkeletonState extends State<StoreProfileProductSkeleton> with SingleTickerProviderStateMixin {
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
		return Transform.scale(
			scale: 0.77,
			child: Column(
				crossAxisAlignment: CrossAxisAlignment.stretch,
				children: [
					Expanded(
						child: ClipRRect(
							borderRadius: BorderRadius.circular(8),
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
											decoration: BoxDecoration(
												color: Colors.grey.shade300,
												borderRadius: BorderRadius.circular(8),
											),
										),
									);
								},
							),
						),
					),
					const SizedBox(height: 8),
					Text(
						'', // No text, just a skeleton bar below
						style: const TextStyle(
							fontSize: 14,
							fontWeight: FontWeight.w500,
						),
						maxLines: 2,
						overflow: TextOverflow.ellipsis,
						textAlign: TextAlign.center,
					),
					Padding(
						padding: const EdgeInsets.symmetric(horizontal: 24.0),
						child: Container(
							height: 16,
							width: double.infinity,
							decoration: BoxDecoration(
								color: Colors.grey.shade300,
								borderRadius: BorderRadius.circular(4),
							),
						),
					),
					const SizedBox(height: 12),
				],
			),
		);
	}
}

import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:flutter/scheduler.dart';

class CustomTooltip extends StatefulWidget {
  const CustomTooltip({
    required this.child,
    required this.message,
    this.maxWidth = 240,
    this.mouseOffset = const Offset(8, 8),
  });

  final Widget child;
  final String message;
  final double maxWidth;
  final Offset mouseOffset;

  @override
  State<CustomTooltip> createState() => _CustomTooltipState();
}

class _CustomTooltipState extends State<CustomTooltip> {
  OverlayPortalController controller = OverlayPortalController();

  Offset? mousePosition;
  final _key = GlobalKey();
  Size? size;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (event) {
        controller.show();
        setState(() {
          mousePosition = event.position;
        });
      },
      onExit: (event) {
        controller.hide();
        setState(() {
          mousePosition = event.position;
        });
      },
      onHover: (event) {
        setState(() {
          mousePosition = event.position;
        });
      },
      child: OverlayPortal.targetsRootOverlay(
        controller: controller,
        overlayChildBuilder: (BuildContext context) {
          return Positioned.fill(child: LayoutBuilder(builder: (context, constraints) {
            SchedulerBinding.instance.addPostFrameCallback((_) {
              size ??= (_key.currentContext?.findRenderObject() as RenderBox?)?.size;
            });

            final width = constraints.maxWidth;
            final height = constraints.maxHeight;

            return SizedBox(
              width: width,
              height: height,
              child: Stack(
                children: [
                  Positioned(
                    top: math.min((mousePosition?.dy ?? 0) + widget.mouseOffset.dy, height - (size?.height ?? 0)),
                    left: math.min(
                        (mousePosition?.dx ?? 0) + widget.mouseOffset.dx, width - (size?.width ?? widget.maxWidth)),
                    child: Container(
                      key: _key,
                      constraints: BoxConstraints(maxWidth: widget.maxWidth),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            offset: const Offset(0, 4),
                            blurRadius: 12,
                            color: Colors.black.withAlpha((255 * 0.15).toInt()),
                          )
                        ],
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16,
                      ),
                      child: Text(widget.message),
                    ),
                  )
                ],
              ),
            );
          }));
        },
        child: widget.child,
      ),
    );
  }
}

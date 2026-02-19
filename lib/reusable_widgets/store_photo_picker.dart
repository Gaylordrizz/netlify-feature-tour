import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class StorePhotoPicker extends StatefulWidget {
  final String label;
  final double aspectRatio; // e.g., 1.0 for square, 2.0 for banner
  final Uint8List? initialBytes;
  final void Function(Uint8List? bytes)? onChanged;
  final String? requirementsText;
  final double width;
  final double height;
  final TextStyle? labelStyle;

  const StorePhotoPicker({
    super.key,
    required this.label,
    required this.aspectRatio,
    this.initialBytes,
    this.onChanged,
    this.requirementsText,
    this.width = 140,
    this.height = 140,
    this.labelStyle,
  });

  @override
  State<StorePhotoPicker> createState() => _StorePhotoPickerState();
}

class _StorePhotoPickerState extends State<StorePhotoPicker> {
  Uint8List? _imageBytes;
  String? _warning;

  @override
  void initState() {
    super.initState();
    _imageBytes = widget.initialBytes;
  }

  Future<void> _pickImage() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.image, withData: true);
    if (result != null && result.files.isNotEmpty) {
      final file = result.files.single;
      if (file.bytes != null) {
        final decoded = await decodeImageFromList(file.bytes!);
        bool aspectOk = widget.aspectRatio == 0.0 ||
            (widget.aspectRatio == 1.0 && decoded.width == decoded.height) ||
            (widget.aspectRatio > 1.0 && decoded.width > decoded.height);
        setState(() {
          _imageBytes = file.bytes;
          _warning = aspectOk ? null : 'Warning: Image does not meet recommended aspect ratio.';
        });
        if (widget.onChanged != null) widget.onChanged!(file.bytes);

        // Save photo to Supabase user_photos table
        try {
          final user = Supabase.instance.client.auth.currentUser;
          if (user != null) {
            final filePath = file.name;
            final description = widget.label;
            final isPublic = false;
            final createdAt = DateTime.now().toIso8601String();
            await Supabase.instance.client.from('user_photos').insert({
              'user_id': user.id,
              'file_path': filePath,
              'description': description,
              'is_public': isPublic,
              'created_at': createdAt,
            });
          }
        } catch (e) {
          debugPrint('Failed to save photo to Supabase: $e');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.requirementsText != null)
          Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.yellow.shade100,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.amber, width: 1.5),
            ),
            child: Text(widget.requirementsText!, style: const TextStyle(fontSize: 13, color: Colors.black)),
          ),
        Text(
          widget.label,
          style: widget.labelStyle ?? const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: _pickImage,
          child: SizedBox(
            width: widget.width,
            height: widget.height,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _imageBytes != null && _imageBytes!.isNotEmpty ? Colors.green : Colors.grey.shade400,
                      width: 2,
                    ),
                  ),
                ),
                if (_imageBytes != null && _imageBytes!.isNotEmpty)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.memory(
                      _imageBytes!,
                      fit: BoxFit.cover,
                      width: widget.width,
                      height: widget.height,
                    ),
                  ),
                if (_imageBytes == null || _imageBytes!.isEmpty)
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add_photo_alternate, size: 40, color: Colors.grey.shade600),
                        const SizedBox(height: 8),
                        Text('Click to upload', style: TextStyle(color: Colors.grey.shade600)),
                      ],
                    ),
                  ),
                if (_imageBytes != null && _imageBytes!.isNotEmpty)
                  Positioned(
                    bottom: 8,
                    right: 8,
                    child: Icon(Icons.check_circle, color: Colors.green, size: 32),
                  ),
                if (_imageBytes != null && _imageBytes!.isNotEmpty)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.grey,
                        shape: BoxShape.circle,
                      ),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _imageBytes = null;
                            _warning = null;
                          });
                          if (widget.onChanged != null) widget.onChanged!(null);
                        },
                        child: const Icon(Icons.close, color: Colors.white, size: 16),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
        if (_warning != null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(_warning!, style: const TextStyle(color: Colors.orange, fontSize: 12)),
          ),
      ],
    );
  }
}

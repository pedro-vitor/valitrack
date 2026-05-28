import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspaths;

class InputImageWithPreview extends StatefulWidget {
  final Function(File) onSelectedImage;
  const InputImageWithPreview({
    super.key,
    required this.onSelectedImage,
  });

  @override
  State<InputImageWithPreview> createState() => _InputImageWithPreviewState();
}

class _InputImageWithPreviewState extends State<InputImageWithPreview> {
  File? _storedImage;

  Future<void> _takePicture() async {
    final ImagePicker picker = ImagePicker();
    XFile imageFile = await picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 600,
    ) as XFile;

    if (await imageFile.length() <= 0) {
      return;
    }
    setState(() => _storedImage = File(imageFile.path));

    // pega a pasta onde o sistema permite que salvemos os dados da aplicação.
    final appDir = await syspaths.getApplicationDocumentsDirectory();

    /// Como o caminho do arquivo pode ser algo grande, pegamos somente
    /// o nome dele.
    String fileName = path.basename(_storedImage!.path);

    /// agora e so fazer uma cópia da imagem do cash da camera para o diretorio
    /// do projeto.
    final savedImage = await _storedImage!.copy(
      '${appDir.path}/$fileName',
    );

    widget.onSelectedImage(savedImage);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: _takePicture,
          child: Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(5)),
                border: Border.all(
                  width: 1,
                  color: const Color.fromARGB(255, 88, 88, 88),
                )),
            alignment: Alignment.center,
            child: _storedImage != null
                ? Image.file(
                    _storedImage!,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  )
                : const Icon(
                    Icons.camera_alt_rounded,
                    size: 60,
                    color: Color.fromARGB(255, 88, 88, 88),
                  ),
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';

class ProjectFilesPage extends StatelessWidget {
  const ProjectFilesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        backgroundColor: const Color(0xffF4F4F4),

        body: Column(
          children: [
            const SizedBox(height: 8),
            _storageCard(),
            const SizedBox(height: 12),
            _searchBar(),
            const SizedBox(height: 8),
            Expanded(child: _filesList()),
          ],
        ),
      ),
    );
  }
}

Widget _storageCard() {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 16),
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Project Files",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 4),
        const Text("2.5 GB / 10 GB", style: TextStyle(fontSize: 12)),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: 0.25,
          backgroundColor: Colors.grey.shade300,
          color: Colors.red,
        ),
        const SizedBox(height: 12),
        _fileActions(),
      ],
    ),
  );
}

Widget _fileActions() {
  final actions = ["Create Folder", "General", "Contracts", "Invoices"];

  return GridView.builder(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 4,
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      childAspectRatio: 1,
    ),
    itemCount: actions.length,
    itemBuilder: (_, i) => Column(
      children: [
        CircleAvatar(
          radius: 22,
          backgroundColor: Colors.grey.shade100,
          child: const Icon(Icons.folder_copy_outlined, size: 20),
        ),
        const SizedBox(height: 4),
        Text(actions[i], style: const TextStyle(fontSize: 11)),
      ],
    ),
  );
}

Widget _filesList() {
  return ListView.separated(
    padding: const EdgeInsets.all(16),
    itemCount: 3,
    separatorBuilder: (_, __) => const SizedBox(height: 8),
    itemBuilder: (_, index) => _fileTile(),
  );
}

Widget _fileTile() {
  return Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
    ),
    child: Row(
      children: [
        const Icon(Icons.file_copy_outlined, color: Colors.red),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                "invoice_003.pdf",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 2),
              Text(
                "2.3 MB • Uploaded Steve Harrington",
                style: TextStyle(fontSize: 11, color: Colors.grey),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(6),
          ),
          child: const Text("Materials", style: TextStyle(fontSize: 10)),
        ),
        const SizedBox(width: 6),
        const Icon(Icons.more_vert, size: 18),
      ],
    ),
  );
}

Widget _searchBar() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: TextField(
      decoration: InputDecoration(
        hintText: "Search file",
        prefixIcon: const Icon(Icons.search),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
    ),
  );
}

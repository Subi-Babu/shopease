import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youbuilt/screen/projects/widgets/wallet.dart';
import 'package:youbuilt/screen/sign_up.dart';
import 'package:youbuilt/utils/colors.dart';
import '../../../custom_widgets/custom_button.dart';
import '../../../providers/signin/project_provider.dart';
import '../../../utils/toast_util.dart';

class ProjectFilesPage extends StatefulWidget {
  final String? pid;
  ProjectFilesPage({super.key, required this.pid});

  @override
  State<ProjectFilesPage> createState() => _ProjectFilesPageState();
}

class _ProjectFilesPageState extends State<ProjectFilesPage> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final reg = Provider.of<ProjectProvider>(context, listen: false);
      reg.selectedFolderName = "General";
      await reg.fetchFolderList(context: context, id: widget.pid ?? "");
      await reg.fetchProjectListsFile(
        context: context,
        pid: widget.pid ?? "",
        pfid: "",
      );
    });

    super.initState();
  }

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
            _fileActions(context, widget.pid ?? ""),
            _searchBar(),
            const SizedBox(height: 8),
            Consumer<ProjectProvider>(
              builder: (context, provider, _) {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${provider.selectedFolderName ?? "General"}",
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontFamily: "Manrope",
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(width: 15),
                      InkWell(
                        onTap: () {
                          _showUploadFileDialog(context, widget.pid ?? "");
                        },
                        child: Container(
                          width: 180.h,
                          height: 45.h,
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: primaryClr,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.add, color: Colors.white, size: 18),
                              SizedBox(width: 5),
                              Text(
                                "Upload File",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: "Manrope",
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            Expanded(child: _filesList()),
          ],
        ),
      ),
    );
  }

  Widget _storageCard() {
    return Consumer<ProjectProvider>(
      builder: (context, provider, _) {
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
              Row(
                children: [
                  Image.asset(
                    "assets/heroicons_folder.png",
                    height: 20,
                    width: 20,
                  ),
                  SizedBox(width: 8),
                  const Text(
                    "Project Files",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontFamily: "Manrope",
                      fontSize: 16,
                      color: primaryClr,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Text(
                    provider.projectFileListModel?.totalSize ?? "",
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: "Manrope",
                      fontWeight: FontWeight.w500,
                      color: primaryClr,
                    ),
                  ),
                  const Text(
                    "/ 10 GB",
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: "Manrope",
                      fontWeight: FontWeight.w500,
                      color: Color(0xff737373),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: 0.25,
                backgroundColor: Color(0xffF4F4F4),
                color: primaryClr,
                minHeight: 5,
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  Widget _fileActions(BuildContext context, String pid) {
    return Consumer<ProjectProvider>(
      builder: (context, provider, _) {
        return Container(
          height: 85,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              // Create Folder button
              InkWell(
                borderRadius: BorderRadius.circular(8),
                onTap: () => _showCreateFolderDialog(context, pid),
                child: _actionItem(
                  title: "Create Folder",
                  icon: Image.asset(
                    "assets/Group 1171275251.png",
                    height: 25,
                    width: 30,
                  ),
                  hasBox: true,
                ),
              ),
              const SizedBox(width: 24),
              // General folder (static)
              InkWell(
                borderRadius: BorderRadius.circular(8),
                onTap: () async {
                  // Set selected folder to General
                  provider.setSelectedFolderForList(id: "", name: "General");

                  // Fetch general folder files (pfid = "")
                  await provider.fetchProjectListsFile(
                    context: context,
                    pid: pid,
                    pfid: "",
                  );
                },
                child: _actionItem(
                  title: "General",
                  icon: Image.asset("assets/docc.png", height: 20, width: 25),
                  hasBox: true,
                ),
              ),
              // API folders
              if (provider.folderModel?.projectFolders != null &&
                  provider.folderModel!.projectFolders!.isNotEmpty)
                ...provider.folderModel!.projectFolders!.map((folder) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 24),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(8),
                      onTap: () async {
                        // Set selected folder
                        provider.setSelectedFolderForList(
                          id: "${folder.value}",
                          name: "${folder.label}",
                        );

                        // Fetch folder files
                        await provider.fetchProjectListsFile(
                          context: context,
                          pid: pid,
                          pfid: folder.value.toString(),
                        );

                        print(
                          "Folder tapped: ${folder.label}, ID: ${folder.value}",
                        );
                        print("Folder tapped: ${provider.selectedFolderName}");
                      },
                      child: _actionItem(
                        title: folder.label ?? "Folder",
                        icon: Image.asset(
                          "assets/docc.png",
                          height: 20,
                          width: 25,
                        ),
                        hasBox: true,
                      ),
                    ),
                  );
                }).toList(),
            ],
          ),
        );
      },
    );
  }

  void _showUploadFileDialog(BuildContext context, String projectId) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Consumer<ProjectProvider>(
              builder: (context, project, _) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    /// Title
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Upload File",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontFamily: "Manrope",
                            fontSize: 18,
                            color: primaryClr,
                          ),
                        ),
                        InkWell(
                          onTap: () => Navigator.pop(context),
                          child: const Icon(Icons.close, color: Colors.grey),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    uploadFileBox(
                      title: project.fileFile == null
                          ? "Upload file"
                          : project.fileFile!.path.split('/').last,
                      onTap: () {
                        project.pickFileSection();
                      },
                    ),
                    const SizedBox(height: 10),
                    CustomTextField(
                      hintText: "File Name",
                      fillColor: Colors.white,
                      controller: project.nameFileCntrl,
                    ),
                    const SizedBox(height: 10),
                    Container(
                      height: 45.h,
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xffC1C1C1)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          isExpanded: true,
                          value: project.selectedFolderId,
                          hint: const Text("Select Folder"),
                          icon: const Icon(Icons.keyboard_arrow_down),
                          items: [
                            /// Default General Folder
                            const DropdownMenuItem(
                              value: "general",
                              child: Text("General"),
                            ),

                            /// API Folders
                            if (project.folderModel?.projectFolders != null)
                              ...project.folderModel!.projectFolders!.map((
                                folder,
                              ) {
                                return DropdownMenuItem(
                                  value: folder.value.toString(), // Folder ID
                                  child: Text(folder.label ?? "Folder"),
                                );
                              }).toList(),
                          ],
                          onChanged: (value) {
                            project.setSelectedFolder(value);
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: 10),

                    /// Upload Button
                    CustomButton(
                      text: project.expense == true
                          ? "Uploading..."
                          : "Upload File",
                      onPress: project.expense == true
                          ? null
                          : () {
                              project.addFile(
                                context: context,
                                name: project.nameFileCntrl.text ?? "",
                                projectFolderId:
                                    project.selectedFolderId.toString() ?? "",
                                file: project.fileFile,
                                projectId: projectId,
                              );
                              project.nameFileCntrl.clear();
                              project.selectedFolderId = null;
                              project.fileFile = null;

                              print("Upload file API call");
                            },
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget _actionItem({
    required String title,
    required Widget icon,
    required bool hasBox,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        hasBox
            ? Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xffE0E0E0)),
                ),
                child: icon,
              )
            : icon,
        const SizedBox(height: 3),
        SizedBox(
          width: 50,
          child: Text(
            title,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 12,
              fontFamily: "Manrope",
              color: primaryClr,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _filesList() {
    return Consumer<ProjectProvider>(
      builder: (context, file, _) {
        return file.projectFileListModel?.projectFileList?.length == 0
            ? Center(child: Text("No data"))
            : file.Loading == true
            ? const Center(
                child: SizedBox(
                  height: 30,
                  width: 30,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: primaryClr,
                  ),
                ),
              )
            : ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount:
                    file.projectFileListModel?.projectFileList?.length ?? 0,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (_, index) {
                  final sizeInBytes =
                      file.projectFileListModel?.projectFileList?[index].size ??
                      0;

                  final sizeInMB = sizeInBytes / (1024 * 1024);

                  return InkWell(
                    onTap: () {
                      final fileUrl = file
                          .projectFileListModel
                          ?.projectFileList?[index]
                          .location; // 👈 Make sure API gives this

                      if (fileUrl != null && fileUrl.isNotEmpty) {
                        _openFile(fileUrl);
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          Image.asset(
                            "assets/akar-icons_file.png",
                            height: 20,
                            width: 20,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  file
                                          .projectFileListModel
                                          ?.projectFileList?[index]
                                          .fileName ??
                                      "",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                    color: primaryClr,
                                    fontFamily: "Manrope",
                                  ),
                                ),
                                SizedBox(height: 2),
                                Text(
                                  "${sizeInMB.toStringAsFixed(2)} MB",
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: "Manrope",
                                    color: Color(0xff737373),
                                  ),
                                ),
                                SizedBox(height: 2),
                                Text(
                                  "Uploaded : ${file.projectFileListModel?.projectFileList?[index].userName ?? ""}",
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: "Manrope",
                                    color: primaryClr,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text(
                              "Materials",
                              style: TextStyle(fontSize: 10),
                            ),
                          ),
                          const SizedBox(width: 6),
                          const Icon(Icons.more_vert, size: 18),
                        ],
                      ),
                    ),
                  );
                },
              );
      },
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

  void _showCreateFolderDialog(BuildContext context, String projectId) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Consumer<ProjectProvider>(
              builder: (context, project, _) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Title
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Folder Creation",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: primaryClr,
                          ),
                        ),
                        InkWell(
                          onTap: () => Navigator.pop(context),
                          child: const Icon(Icons.close),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Folder name
                    CustomTextField(
                      hintText: "Folder Name",
                      controller: project.nameCntrl,
                    ),
                    const SizedBox(height: 16),
                    // Create button
                    CustomButton(
                      text: project.loading2 == true
                          ? "Creating..."
                          : "Create Folder",
                      onPress: project.loading2 == true
                          ? null
                          : () {
                              if (project.nameCntrl.text.trim().isEmpty) {
                                ToastUtil.show("Enter folder name");
                                return;
                              }
                              project.addProjectFolder(
                                context: context,
                                title: project.nameCntrl.text.trim(),
                                pid: projectId,
                              );
                              project.nameCntrl.clear();
                            },
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }
}

Future<void> _openFile(String url) async {
  final Uri uri = Uri.parse(url);
  try {
    final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!launched) {
      debugPrint("Could not launch $url");
    }
  } catch (e) {
    debugPrint("Error launching $url: $e");
  }
}

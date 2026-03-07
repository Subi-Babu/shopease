import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:youbuilt/screen/sign_up.dart';
import 'package:youbuilt/utils/colors.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import '../../custom_widgets/custom_button.dart';
import '../../providers/signin/project_provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../utils/constants.dart';

class AddressPage extends StatefulWidget {
  const AddressPage({super.key});

  @override
  State<AddressPage> createState() => _AddressPageState();
}

class _AddressPageState extends State<AddressPage> {
  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final reg = Provider.of<ProjectProvider>(context, listen: false);
      await reg.fetchAddressList(context: context);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: const BackButton(color: Colors.black),
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.transparent,
        title: Text(
          "Address",
          style: TextStyle(
            color: primaryClr,
            fontFamily: "Manrope",
            fontWeight: FontWeight.w500,
            fontSize: 18.sp,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Consumer<ProjectProvider>(
          builder: (context, address, _) {
            return Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(20),
                          ),
                        ),
                        builder: (context) => const AddAddressSheet(),
                      );
                    },
                    icon: const Icon(Icons.add, color: Colors.black),
                    label: Text(
                      "Add Address",
                      style: TextStyle(
                        color: primaryClr,
                        fontFamily: "Manrope",
                        fontWeight: FontWeight.w600,
                        fontSize: 16.sp,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: primaryClr),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Saved Address",
                    style: TextStyle(
                      color: primaryClr,
                      fontFamily: "Manrope",
                      fontWeight: FontWeight.w500,
                      fontSize: 18.sp,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child:
                      address.addressListModel == null ||
                          address.addressListModel!.data == null ||
                          address.addressListModel!.data!.isEmpty
                      ? const Center(child: Text("No Address Found"))
                      : ListView.separated(
                          itemCount:
                              address.addressListModel!.data!.length ?? 0,
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final item = address.addressListModel!.data![index];
                            return _addressCard(
                              title: item.addressTitle ?? "",
                              name: item.name ?? "",
                              address: item.address ?? "",
                              index: index,
                              isSelected: item.isDefault ?? false,
                              onChanged: () async {
                                await address.updateAddress(
                                  context: context,
                                  adddresId: item?.id.toString() ?? "",
                                );
                              },
                            );
                          },
                        ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _addressCard({
    required int index,
    required bool isSelected,
    required VoidCallback onChanged,
    required String title,
    required String name,
    required String address,
  }) {
    return InkWell(
      onTap: onChanged,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? primaryClr : const Color(0xffD1D5DB),
            width: isSelected ? 1.5 : 1,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Checkbox(
              value: isSelected,
              activeColor: primaryClr,
              onChanged: (_) => onChanged(),
            ),
            const SizedBox(width: 8),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: const Color(0xff8A8A8A),
                      fontFamily: "Manrope",
                      fontWeight: FontWeight.w700,
                      fontSize: 16.sp,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    name,
                    style: TextStyle(
                      color: const Color(0xff131313),
                      fontFamily: "Manrope",
                      fontWeight: FontWeight.w500,
                      fontSize: 16.sp,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    address,
                    style: TextStyle(
                      color: primaryClr,
                      fontFamily: "Manrope",
                      fontWeight: FontWeight.w500,
                      fontSize: 14.sp,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            isSelected == false
                ? SizedBox()
                : Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.green),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      "Default",
                      style: TextStyle(
                        color: Colors.green,
                        fontFamily: "Manrope",
                        fontWeight: FontWeight.w700,
                        fontSize: 14.sp,
                      ),
                    ),
                  ),
            const SizedBox(width: 10),

            const Icon(Icons.more_vert, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Location Search Dialog
// ─────────────────────────────────────────────────────────────

class LocationSearchDialog extends StatefulWidget {
  final Function(LatLng latLng, String address) onLocationSelected;

  const LocationSearchDialog({super.key, required this.onLocationSelected});

  @override
  State<LocationSearchDialog> createState() => _LocationSearchDialogState();
}

class _LocationSearchDialogState extends State<LocationSearchDialog> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _searchResults = [];
  bool _isSearching = false;

  Future<void> _searchLocation(String query) async {
    if (query.trim().isEmpty) {
      setState(() => _searchResults = []);
      return;
    }
    setState(() => _isSearching = true);
    try {
      final locations = await locationFromAddress(query);
      final List<Map<String, dynamic>> results = [];
      for (final loc in locations.take(5)) {
        final placemarks = await placemarkFromCoordinates(
          loc.latitude,
          loc.longitude,
        );
        if (placemarks.isNotEmpty) {
          final p = placemarks.first;
          final displayName = [
            p.name,
            p.street,
            p.subLocality,
            p.locality,
            p.administrativeArea,
            p.country,
          ].where((s) => s != null && s.isNotEmpty).join(', ');
          results.add({
            'latLng': LatLng(loc.latitude, loc.longitude),
            'address': displayName,
            'subtitle':
                '${p.locality ?? ''}, ${p.administrativeArea ?? ''}, ${p.country ?? ''}',
          });
        }
      }
      setState(() => _searchResults = results);
    } catch (e) {
      setState(() => _searchResults = []);
      debugPrint("Search error: $e");
    }
    setState(() => _isSearching = false);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Search Location",
                  style: TextStyle(
                    fontFamily: "Manrope",
                    fontWeight: FontWeight.w600,
                    fontSize: 16.sp,
                    color: primaryClr,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close, size: 20),
                ),
              ],
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _searchController,
              autofocus: true,
              decoration: InputDecoration(
                hintText: "Search for a place or address...",
                hintStyle: TextStyle(
                  fontFamily: "Manrope",
                  fontSize: 13.sp,
                  color: Colors.grey,
                ),
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                suffixIcon: _isSearching
                    ? const Padding(
                        padding: EdgeInsets.all(12.0),
                        child: SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.red,
                          ),
                        ),
                      )
                    : _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: Colors.grey),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _searchResults = []);
                        },
                      )
                    : null,
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 8,
                ),
              ),
              onChanged: (val) {
                setState(() {});
                Future.delayed(const Duration(milliseconds: 600), () {
                  if (_searchController.text == val) {
                    _searchLocation(val);
                  }
                });
              },
            ),
            const SizedBox(height: 8),
            if (_searchResults.isEmpty && !_isSearching)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  children: [
                    Icon(
                      Icons.location_searching,
                      size: 40,
                      color: Colors.grey.shade300,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _searchController.text.isEmpty
                          ? "Type to search for a location"
                          : "No results found",
                      style: TextStyle(
                        fontFamily: "Manrope",
                        fontSize: 13.sp,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              )
            else
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.35,
                ),
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: _searchResults.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final result = _searchResults[index];
                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 4,
                        horizontal: 4,
                      ),
                      leading: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.location_pin,
                          color: Colors.red,
                          size: 20,
                        ),
                      ),
                      title: Text(
                        result['address'],
                        style: TextStyle(
                          fontFamily: "Manrope",
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: result['subtitle'].isNotEmpty
                          ? Text(
                              result['subtitle'],
                              style: TextStyle(
                                fontFamily: "Manrope",
                                fontSize: 11.sp,
                                color: Colors.grey,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            )
                          : null,
                      onTap: () {
                        Navigator.pop(context);
                        widget.onLocationSelected(
                          result['latLng'],
                          result['address'],
                        );
                      },
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Add Address Sheet
// ─────────────────────────────────────────────────────────────

class AddAddressSheet extends StatefulWidget {
  const AddAddressSheet({super.key});

  @override
  State<AddAddressSheet> createState() => _AddAddressSheetState();
}

class _AddAddressSheetState extends State<AddAddressSheet> {
  GoogleMapController? _mapController;
  LatLng _selectedLatLng = const LatLng(20.5937, 78.9629);
  bool _isLoadingLocation = false;
  String _locationLabel = "Tap map or use current location";

  // ✅ Local controllers owned by this widget — always in sync
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _pincodeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  @override
  void dispose() {
    _addressController.dispose();
    _pincodeController.dispose();
    super.dispose();
  }

  Future<void> _getCurrentLocation() async {
    setState(() => _isLoadingLocation = true);
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.deniedForever) {
        setState(() => _isLoadingLocation = false);
        return;
      }
      final Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      final LatLng latLng = LatLng(position.latitude, position.longitude);
      await _updateLocationFromLatLng(latLng);
      _mapController?.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: latLng, zoom: 16),
        ),
      );
    } catch (e) {
      debugPrint("Location error: $e");
    }
    setState(() => _isLoadingLocation = false);
  }

  Future<void> _updateLocationFromLatLng(LatLng latLng) async {
    // Guard: don't use context after widget is disposed
    if (!mounted) return;

    setState(() => _selectedLatLng = latLng);

    try {
      final placemarks = await placemarkFromCoordinates(
        latLng.latitude,
        latLng.longitude,
      );

      // Guard again after the await
      if (!mounted) return;

      if (placemarks.isNotEmpty) {
        final p = placemarks.first;
        final pincode = p.postalCode ?? '';
        final address =
            "${p.street ?? ''}, ${p.subLocality ?? ''}, ${p.locality ?? ''}, $pincode"
                .replaceAll(RegExp(r',\s*,'), ',') // clean double commas
                .trim();

        setState(() => _locationLabel = address);

        // ✅ Set local controllers directly — no Consumer/context needed
        // _addressController.text = address;
        // _pincodeController.text = pincode;

        // ✅ Also sync to provider so other screens can read it
        // context.read<ProjectProvider>().addressCntrl.text = address;
        // context.read<ProjectProvider>().pincodeAddressController.text = pincode;
      }
    } catch (e) {
      if (!mounted) return;
      debugPrint("Reverse geocode error: $e");
      setState(
        () => _locationLabel =
            "Lat: ${latLng.latitude.toStringAsFixed(5)}, Lng: ${latLng.longitude.toStringAsFixed(5)}",
      );
    }
  }

  void _openLocationSearch() {
    showDialog(
      context: context,
      builder: (ctx) => LocationSearchDialog(
        onLocationSelected: (LatLng latLng, String address) {
          _updateLocationFromLatLng(latLng);
          _mapController?.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(target: latLng, zoom: 16),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        child: Consumer<ProjectProvider>(
          builder: (context, provider, _) {
            return Container(
              color: Colors.white,
              padding: EdgeInsets.only(left: 16, right: 16, top: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  /// Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Add New Address",
                        style: TextStyle(
                          color: primaryClr,
                          fontFamily: "Manrope",
                          fontWeight: FontWeight.w600,
                          fontSize: 18.sp,
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  /// Current location + Search location row
                  Row(
                    children: [
                      GestureDetector(
                        onTap: _getCurrentLocation,
                        child: Row(
                          children: [
                            _isLoadingLocation
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.red,
                                    ),
                                  )
                                : const Icon(
                                    Icons.my_location,
                                    color: Colors.red,
                                  ),
                            const SizedBox(width: 6),
                            Text(
                              _isLoadingLocation
                                  ? "Fetching..."
                                  : "Current Location",
                              style: TextStyle(
                                color: Colors.red,
                                fontFamily: "Manrope",
                                fontWeight: FontWeight.w600,
                                fontSize: 13.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Container(
                        width: 1,
                        height: 18,
                        color: Colors.grey.shade300,
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // ✅ Use local controllers so they update immediately
                  CustomTextField(
                    hintText: "Address",
                    fillColor: Colors.white,
                    controller: provider.addressCntrl,
                  ),
                  const SizedBox(height: 12),
                  CustomTextField(
                    hintText: "Pin Code",
                    fillColor: Colors.white,
                    controller: provider.pincodeAddressController,
                  ),
                  const SizedBox(height: 12),
                  CustomTextField(
                    hintText: "Address Title",
                    fillColor: Colors.white,
                    controller: provider.titleAddressController,
                  ),
                  const SizedBox(height: 12),
                  CustomTextField(
                    hintText: "Enter Name (Optional)",
                    fillColor: Colors.white,
                    controller: provider.nameddressController,
                  ),
                  const SizedBox(height: 12),
                  CustomTextField(
                    hintText: "Enter Number (Optional)",
                    fillColor: Colors.white,
                    controller: provider.phoneddressController,
                  ),
                  const SizedBox(height: 12),

                  /// Location search field (tappable, opens search dialog)
                  GestureDetector(
                    onTap: _openLocationSearch,
                    child: AbsorbPointer(
                      child: TextField(
                        readOnly: true,
                        decoration: InputDecoration(
                          hintText: "Search & pick a location",
                          hintStyle: TextStyle(
                            fontFamily: "Manrope",
                            fontSize: 13.sp,
                            color: Colors.grey,
                          ),
                          prefixIcon: const Icon(
                            Icons.search,
                            color: Colors.grey,
                          ),
                          filled: true,
                          fillColor: Colors.grey.shade50,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 14,
                            horizontal: 12,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    "Choose Location",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),

                  Text(
                    "📍 Lat: ${_selectedLatLng.latitude.toStringAsFixed(6)}, Lng: ${_selectedLatLng.longitude.toStringAsFixed(6)}",
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.grey.shade600,
                      fontFamily: "Manrope",
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _locationLabel,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.grey.shade700,
                      fontFamily: "Manrope",
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),

                  /// Google Map with pin picker
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: SizedBox(
                      height: 220,
                      width: double.infinity,
                      child: Stack(
                        children: [
                          GoogleMap(
                            initialCameraPosition: CameraPosition(
                              target: _selectedLatLng,
                              zoom: 14,
                            ),
                            onMapCreated: (controller) {
                              _mapController = controller;
                            },
                            onCameraMove: (position) {
                              setState(() => _selectedLatLng = position.target);
                            },
                            onCameraIdle: () {
                              _updateLocationFromLatLng(_selectedLatLng);
                            },
                            myLocationEnabled: true,
                            myLocationButtonEnabled: false,
                            zoomControlsEnabled: false,
                            mapType: MapType.normal,
                          ),

                          /// Center pin
                          const Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.location_pin,
                                  color: Colors.red,
                                  size: 40,
                                ),
                                SizedBox(height: 20),
                              ],
                            ),
                          ),

                          /// Current location FAB
                          Positioned(
                            bottom: 12,
                            right: 12,
                            child: GestureDetector(
                              onTap: _getCurrentLocation,
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.black26,
                                      blurRadius: 6,
                                    ),
                                  ],
                                ),
                                child: _isLoadingLocation
                                    ? const SizedBox(
                                        width: 22,
                                        height: 22,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.red,
                                        ),
                                      )
                                    : const Icon(
                                        Icons.my_location,
                                        color: Colors.blue,
                                        size: 22,
                                      ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  Row(
                    children: [
                      Expanded(
                        child: CustomButton(
                          text: "Cancel",
                          onPress: () => Navigator.pop(context),
                          borderSide: BorderSide(color: primaryClr),
                          bgColor: Colors.white,
                          textColor: primaryClr,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: CustomButton(
                          text: "Save",
                          onPress: () async {
                            await provider.addAddress(
                              context: context,
                              title: provider.titleAddressController.text,
                              address: provider.addressCntrl.text,
                              pincode: provider.pincodeAddressController.text,
                              lat: _selectedLatLng.latitude.toString(),
                              lng: _selectedLatLng.longitude.toString(),
                              name: provider.nameddressController.text,
                              phone: provider.phoneddressController.text,
                            );
                            provider.titleAddressController.clear();
                            provider.addressCntrl.clear();
                            provider.pincodeAddressController.clear();
                            provider.nameddressController.clear();
                            provider.phoneddressController.clear();
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

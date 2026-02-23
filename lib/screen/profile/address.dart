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

class AddressPage extends StatelessWidget {
  const AddressPage({super.key});

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
                /// Add Address Button
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

                /// Saved Address Title
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

                /// Address Cards
                _addressCard(
                  title: "Home",
                  name: "Steve Harry",
                  address:
                      "Lorem ipsum is simply dummy text of the printing and typesetting industry.",
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _addressCard({
    required String title,
    required String name,
    required String address,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        border: Border.all(color: Color(0xffD1D5DB)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Color(0xff8A8A8A),
                    fontFamily: "Manrope",
                    fontWeight: FontWeight.w700,
                    fontSize: 16.sp,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  name,
                  style: TextStyle(
                    color: Color(0xff131313),
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
          const Icon(Icons.more_vert, color: Colors.grey),
        ],
      ),
    );
  }
}

class AddAddressSheet extends StatefulWidget {
  const AddAddressSheet({super.key});

  @override
  State<AddAddressSheet> createState() => _AddAddressSheetState();
}

class _AddAddressSheetState extends State<AddAddressSheet> {
  GoogleMapController? _mapController;
  LatLng _selectedLatLng = const LatLng(
    20.5937,
    78.9629,
  ); // Default: India center
  bool _isLoadingLocation = false;
  String _locationLabel = "Tap map or use current location";

  @override
  void initState() {
    super.initState();
    _getCurrentLocation(); // Auto-fetch on open
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
    setState(() => _selectedLatLng = latLng);

    try {
      final placemarks = await placemarkFromCoordinates(
        latLng.latitude,
        latLng.longitude,
      );
      if (placemarks.isNotEmpty) {
        final p = placemarks.first;
        final address =
            "${p.street ?? ''}, ${p.subLocality ?? ''}, ${p.locality ?? ''}, ${p.postalCode ?? ''}";
        setState(() => _locationLabel = address);

        // Optionally auto-fill address controller
        final provider = context.read<ProjectProvider>();
        provider.addressCntrl.text = address;
        provider.pincodeAddressController.text = p.postalCode ?? '';
      }
    } catch (_) {
      setState(
        () => _locationLabel =
            "Lat: ${latLng.latitude.toStringAsFixed(5)}, Lng: ${latLng.longitude.toStringAsFixed(5)}",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 20,
      ),
      child: SingleChildScrollView(
        child: Consumer<ProjectProvider>(
          builder: (context, address, _) {
            return Column(
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

                /// Use current location button
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
                          : const Icon(Icons.my_location, color: Colors.red),
                      const SizedBox(width: 8),
                      Text(
                        _isLoadingLocation
                            ? "Fetching location..."
                            : "Use My Current Location",
                        style: TextStyle(
                          color: Colors.red,
                          fontFamily: "Manrope",
                          fontWeight: FontWeight.w600,
                          fontSize: 14.sp,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                CustomTextField(
                  hintText: "Address",
                  fillColor: Colors.white,
                  controller: address.addressCntrl,
                ),
                const SizedBox(height: 12),
                CustomTextField(
                  hintText: "Pin Code",
                  fillColor: Colors.white,
                  controller: address.pincodeAddressController,
                ),
                const SizedBox(height: 12),
                CustomTextField(
                  hintText: "Address Title",
                  fillColor: Colors.white,
                  controller: address.titleAddressController,
                ),
                const SizedBox(height: 12),
                CustomTextField(
                  hintText: "Enter Name (Optional)",
                  fillColor: Colors.white,
                  controller: address.nameddressController,
                ),
                const SizedBox(height: 12),
                CustomTextField(
                  hintText: "Enter Number (Optional)",
                  fillColor: Colors.white,
                  controller: address.phoneddressController,
                ),

                const SizedBox(height: 20),

                const Text(
                  "Choose Location",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4),

                /// Lat/Lng display
                Text(
                  "📍 Lat: ${_selectedLatLng.latitude.toStringAsFixed(6)},  Lng: ${_selectedLatLng.longitude.toStringAsFixed(6)}",
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
                            // Update pin position as map moves
                            setState(() => _selectedLatLng = position.target);
                          },
                          onCameraIdle: () {
                            // Reverse geocode when camera stops
                            _updateLocationFromLatLng(_selectedLatLng);
                          },
                          myLocationEnabled: true,
                          myLocationButtonEnabled: false,
                          zoomControlsEnabled: false,
                          mapType: MapType.normal,
                        ),

                        /// Center pin (moves with map drag)
                        const Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.location_pin,
                                color: Colors.red,
                                size: 40,
                              ),
                              SizedBox(height: 20), // offset to bottom of pin
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
                                boxShadow: [
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
                        onPress: () {
                          // Save lat/lng + address
                          final lat = _selectedLatLng.latitude;
                          final lng = _selectedLatLng.longitude;
                          debugPrint("Saving: lat=$lat, lng=$lng");
                          // Call your provider save method here
                        },
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),
              ],
            );
          },
        ),
      ),
    );
  }
}

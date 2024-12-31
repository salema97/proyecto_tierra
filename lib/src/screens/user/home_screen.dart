import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:proyecto_tierra/src/utils/header_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const HeaderWidget(),
          _buildReportsSection(),
          Expanded(child: _buildMap()),
        ],
      ),
    );
  }

  Widget _buildReportsSection() {
    return Container(
      padding: EdgeInsets.all(16.w),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Reportes',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  'Ver todo',
                  style: TextStyle(fontSize: 16.sp),
                ),
              ),
            ],
          ),
          Card(
            color: Colors.blue,
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Extensómetro N1',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.sp,
                        ),
                      ),
                      Icon(Icons.more_horiz, color: Colors.white, size: 24.sp),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'Ubicación: Aluvial N1',
                    style: TextStyle(color: Colors.white70, fontSize: 14.sp),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'Lunes, 27 Enero 2024',
                    style: TextStyle(color: Colors.white, fontSize: 14.sp),
                  ),
                  Text(
                    '10:00am - 11:00am',
                    style: TextStyle(color: Colors.white70, fontSize: 14.sp),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMap() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Mapa de ubicaciones de los extensómetros',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16.h),
          // Expanded(
          //   child: ClipRRect(
          //     borderRadius: BorderRadius.circular(12),
          //     child: GoogleMap(
          //       initialCameraPosition: CameraPosition(
          //         target: LatLng(-1.831239, -78.183406),
          //         zoom: 7,
          //       ),
          //       markers: {
          //         Marker(
          //           markerId: MarkerId('1'),
          //           position: LatLng(-1.831239, -78.183406),
          //         ),
          //       },
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}

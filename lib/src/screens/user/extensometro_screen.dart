import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:proyecto_tierra/src/utils/header_widget.dart';

class ExtensometroScreen extends StatelessWidget {
  const ExtensometroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const HeaderWidget(),
          _buildCategoryTabs(),
          Expanded(child: _buildDevicesList()),
        ],
      ),
    );
  }

  Widget _buildCategoryTabs() {
    return Container(
      padding: EdgeInsets.all(16.w),
      child: Row(
        children: [
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.r),
              ),
            ),
            child: Text('Todos', style: TextStyle(fontSize: 14.sp)),
          ),
          SizedBox(width: 8.w),
          TextButton(
            onPressed: () {},
            child: Text('Categoría 1', style: TextStyle(fontSize: 14.sp)),
          ),
          SizedBox(width: 8.w),
          TextButton(
            onPressed: () {},
            child: Text('Categoría 2', style: TextStyle(fontSize: 14.sp)),
          ),
        ],
      ),
    );
  }

  Widget _buildDevicesList() {
    return ListView.builder(
      padding: EdgeInsets.all(16.w),
      itemCount: 5,
      itemBuilder: (context, index) {
        return Card(
          margin: EdgeInsets.only(bottom: 8.h),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.grey[200],
              child: Icon(Icons.devices, color: Colors.grey, size: 24.sp),
            ),
            title: Text(
              'Extensómetro N${index + 1}',
              style: TextStyle(fontSize: 16.sp),
            ),
            subtitle: Text(
              'Ubicación: Aluvial N${index + 1}',
              style: TextStyle(fontSize: 14.sp),
            ),
            trailing: Icon(Icons.more_vert, size: 24.sp),
          ),
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:proyecto_tierra/src/models/extensometro.dart';
import 'package:proyecto_tierra/src/models/zona.dart';
import 'package:proyecto_tierra/src/screens/user/extensometro_chart.dart';
import 'package:proyecto_tierra/src/services/extensometro_service.dart';
import 'package:proyecto_tierra/src/services/info_service.dart';
import 'package:proyecto_tierra/src/services/zona_service.dart';
import 'package:proyecto_tierra/src/utils/header_widget.dart';

class ExtensometroScreen extends StatefulWidget {
  const ExtensometroScreen({super.key});

  @override
  State<ExtensometroScreen> createState() => _ExtensometroScreenState();
}

class _ExtensometroScreenState extends State<ExtensometroScreen> {
  List<Zona> _zonas = [];
  List<Extensometro> _extensometros = [];
  int _selectedZonaId = -1;

  @override
  void initState() {
    super.initState();
    _fetchZonas();
    _fetchExtensometros();
  }

  Future<void> _fetchZonas() async {
    final zonas = await ZonaService().obtenerTodasZonas();
    setState(() => _zonas = zonas);
  }

  Future<void> _fetchExtensometros() async {
    final extensometros = await ExtensometroService().obtenerTodosExtensometros();
    setState(() {
      _extensometros = extensometros;
      _selectedZonaId = -1;
    });
  }

  Future<void> _fetchExtensometrosPorZonaId(int zonaId) async {
    final extensometros = await ExtensometroService().obtenerExtensometrosPorZonaId(zonaId);
    setState(() {
      _extensometros = extensometros;
      _selectedZonaId = zonaId;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const HeaderWidget(),
          _buildCategoryTabs(),
          Expanded(child: _buildExtensometrosList()),
        ],
      ),
    );
  }

  Widget _buildCategoryTabs() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Row(
        children: [
          Expanded(
            child: TextButton(
              onPressed: _fetchExtensometros,
              style: TextButton.styleFrom(
                backgroundColor: _selectedZonaId == -1 ? Colors.blue : Colors.white,
                minimumSize: Size(double.infinity, 36.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              child: Text('Todos',
                  style: TextStyle(
                      fontSize: 14.sp,
                      color: _selectedZonaId == -1 ? Colors.white : Colors.black54)),
            ),
          ),
          ..._zonas.map((zona) {
            final isSelected = _selectedZonaId == zona.id;
            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: 14.w),
                child: TextButton(
                  onPressed: () => _fetchExtensometrosPorZonaId(zona.id),
                  style: TextButton.styleFrom(
                    backgroundColor: isSelected ? Colors.blue : Colors.white,
                    minimumSize: Size(double.infinity, 36.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  child: Text(zona.name,
                      style: TextStyle(
                          fontSize: 14.sp, color: isSelected ? Colors.white : Colors.black54)),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildExtensometrosList() {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      itemCount: _extensometros.length,
      itemBuilder: (context, index) {
        final extensometro = _extensometros[index];
        return Card(
          margin: EdgeInsets.only(bottom: 12.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: ListTile(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.r),
            ),
            leading: CircleAvatar(
              backgroundColor: Colors.blue[100],
              child: Icon(Icons.devices, color: Colors.blue, size: 24.sp),
            ),
            title: Text(
              extensometro.name,
              style: TextStyle(fontSize: 16.sp),
            ),
            subtitle: Text(
              'Zona ID: ${extensometro.zonaId}',
              style: TextStyle(fontSize: 14.sp),
            ),
            trailing: Icon(
              Icons.arrow_forward_outlined,
              size: 24.sp,
              color: Colors.blue,
            ),
            onTap: () async {
              final details = await InfoService.obtenerInfoPorExtensometroId(extensometro.id);
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ExtensometroChart(infoDetails: details)));
            },
          ),
        );
      },
    );
  }
}

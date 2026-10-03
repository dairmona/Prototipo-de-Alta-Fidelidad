import 'dart:convert';
import 'dart:html' as html;

import 'package:flutter/material.dart';

void main() => runApp(const AutopartesProApp());

enum UserRole { user, admin }

class AutopartesProApp extends StatelessWidget {
  const AutopartesProApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Autopartes Pro',
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Arial',
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xff0b4f8a),
          primary: const Color(0xff0b4f8a),
          secondary: const Color(0xffef8b22),
          surface: Colors.white,
        ),
      ),
      home: const WorkspaceGate(),
    );
  }
}

class WorkspaceGate extends StatefulWidget {
  const WorkspaceGate({super.key});

  @override
  State<WorkspaceGate> createState() => _WorkspaceGateState();
}

class _WorkspaceGateState extends State<WorkspaceGate> {
  UserRole? _role;

  @override
  Widget build(BuildContext context) {
    if (_role == null) {
      return LoginScreen(onLogin: (role) => setState(() => _role = role));
    }
    return ControlCenter(role: _role!, onLogout: () => setState(() => _role = null));
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({required this.onLogin, super.key});
  final ValueChanged<UserRole> onLogin;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  UserRole _selectedRole = UserRole.user;
  bool _hidePassword = true;
  final _email = TextEditingController(text: 'operaciones@autopartespro.co');
  final _password = TextEditingController(text: '••••••••');

  @override
  void dispose() { _email.dispose(); _password.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.sizeOf(context).width >= 850;
    return Scaffold(
      backgroundColor: const Color(0xfff3f7fa),
      body: Row(children: [
        if (wide) Expanded(flex: 5, child: _brandPanel()),
        Expanded(flex: 4, child: Center(child: SingleChildScrollView(
          padding: const EdgeInsets.all(28),
          child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 430), child: _loginCard()),
        ))),
      ]),
    );
  }

  Widget _brandPanel() => Container(
    color: const Color(0xff062f54),
    padding: const EdgeInsets.all(64),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
  Image.asset(
    'assets/images/logo_rediix.png', // Tu nuevo archivo de logo
    height: 120, // Ajusta este tamaño si lo deseas más grande o pequeño
    color: Colors.white,
    colorBlendMode: BlendMode.multiply,
  ),
      const SizedBox(height: 20), // Espacio reducido para que el eslogan suba
      const Text('Piezas en las que\npuedes confiar.', style: TextStyle(color: Colors.white, fontSize: 34, height: 1.15, fontWeight: FontWeight.w800)),
      const SizedBox(height: 18),
      const Text('Gestiona inventario, clientes y oportunidades comerciales desde un solo lugar.', style: TextStyle(color: Color(0xffb7d0df), fontSize: 16, height: 1.5)),
      const SizedBox(height: 46),
      _benefit(Icons.inventory_2_outlined, 'Inventario disponible y trazable'),
      _benefit(Icons.support_agent_rounded, 'Atención priorizada a tus clientes'),
      _benefit(Icons.insights_outlined, 'Decisiones respaldadas por datos'),
    ]),
  );

  Widget _benefit(IconData icon, String text) => Padding(padding: const EdgeInsets.only(bottom: 17), child: Row(children: [Icon(icon, color: const Color(0xffef8b22), size: 20), const SizedBox(width: 12), Text(text, style: const TextStyle(color: Color(0xffd4e3ed), fontSize: 14))]));

  Widget _loginCard() => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    const Text('Bienvenido de nuevo', style: TextStyle(fontSize: 29, fontWeight: FontWeight.w800, color: Color(0xff17324d))),
    const SizedBox(height: 7),
    const Text('Ingresa para continuar a Rediix Brake.', style: TextStyle(color: Color(0xff637786))),
    const SizedBox(height: 30),
    const Text('Selecciona tu perfil', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xff31566f))),
    const SizedBox(height: 10),
    Row(children: [Expanded(child: _roleSelector(UserRole.user, Icons.badge_outlined, 'Usuario', 'Operación diaria')), const SizedBox(width: 10), Expanded(child: _roleSelector(UserRole.admin, Icons.admin_panel_settings_outlined, 'Administrador', 'Control total'))]),
    const SizedBox(height: 24),
    TextField(controller: _email, keyboardType: TextInputType.emailAddress, decoration: const InputDecoration(labelText: 'Correo corporativo', prefixIcon: Icon(Icons.mail_outline), border: OutlineInputBorder())),
    const SizedBox(height: 16),
    TextField(controller: _password, obscureText: _hidePassword, decoration: InputDecoration(labelText: 'Contraseña', prefixIcon: const Icon(Icons.lock_outline), suffixIcon: IconButton(onPressed: () => setState(() => _hidePassword = !_hidePassword), icon: Icon(_hidePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined)), border: const OutlineInputBorder())),
    const SizedBox(height: 10),
    Align(alignment: Alignment.centerRight, child: TextButton(onPressed: () => _notice('Se enviaron instrucciones a tu correo.'), child: const Text('¿Olvidaste tu contraseña?'))),
    const SizedBox(height: 16),
    SizedBox(width: double.infinity, height: 48, child: FilledButton.icon(onPressed: () => widget.onLogin(_selectedRole), icon: const Icon(Icons.login), label: Text('Ingresar como ${_selectedRole == UserRole.admin ? 'administrador' : 'usuario'}'))),
    const SizedBox(height: 26),
    const Center(child: Text('Entorno demostrativo · Acceso protegido', style: TextStyle(fontSize: 11, color: Color(0xff71808c)))),
  ]);

  Widget _roleSelector(UserRole role, IconData icon, String label, String detail) {
    final chosen = _selectedRole == role;
    return InkWell(onTap: () => setState(() { _selectedRole = role; _email.text = role == UserRole.admin ? 'admin@rediixbrake.co' : 'operaciones@rediixbrake.co'; }), borderRadius: BorderRadius.circular(9), child: AnimatedContainer(duration: const Duration(milliseconds: 160), padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: chosen ? const Color(0xffe9f3fb) : Colors.white, borderRadius: BorderRadius.circular(9), border: Border.all(color: chosen ? const Color(0xff0b67b2) : const Color(0xffd8e0e6), width: chosen ? 2 : 1)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Icon(icon, color: chosen ? const Color(0xff0b67b2) : const Color(0xff71808c)), const SizedBox(height: 10), Text(label, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13)), Text(detail, style: const TextStyle(fontSize: 10, color: Color(0xff71808c)))])));
  }

  void _notice(String message) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message), behavior: SnackBarBehavior.floating));
}

class ControlCenter extends StatefulWidget {
  const ControlCenter({required this.role, required this.onLogout, super.key});
  final UserRole role;
  final VoidCallback onLogout;

  @override
  State<ControlCenter> createState() => _ControlCenterState();
}

class _ControlCenterState extends State<ControlCenter> {
  int _section = 0;
  String _query = '';
  bool _onlyAlerts = false;
  String _inventoryFilter = 'Todos';
  bool _loadingInventory = true;
  int _purchasingTab = 0;
  bool _loadingPurchasing = true;
  bool _loadingCustomerData = true;
  bool _loadingCommercialData = true;
  final _cart = <CartLine>[];
  final _chatInput = TextEditingController();
  final _chatMessages = <ChatMessage>[
    ChatMessage('Hola, soy Asistente Pro. Puedo ayudarte con inventario, pedidos, garantías y horarios.', false),
  ];
  final _items = <PartItem>[
    PartItem('Pastillas de freno cerámicas', 'FR-4821', 'Frenos', 8, 20, 'Bodega Norte', 'Crítico', image: 'fr-4821.png'),
    PartItem('Filtro de aceite premium', 'MO-1198', 'Motor', 42, 25, 'Bodega Central', 'Saludable', image: 'mo-1198.png'),
    PartItem('Amortiguador delantero', 'SU-0732', 'Suspensión', 12, 15, 'Bodega Norte', 'Reponer', image: 'su-0732.png'),
    PartItem('Kit de embrague', 'TR-2984', 'Transmisión', 19, 12, 'Bodega Sur', 'Saludable', image: 'tr-2984.png'),


  ];
  final _suppliers = <Supplier>[
    Supplier('Frenos Colombia S.A.S.', 'PR-001', 'Laura Méndez', 'compras@frenoscolombia.co', 'Frenos', 'Activo'),
    Supplier('Motores Andinos Ltda.', 'PR-002', 'Carlos Rojas', 'ventas@motoresandinos.co', 'Motor', 'Activo'),
    Supplier('Suspensiones del Norte', 'PR-003', 'Diana Gil', 'contacto@suspensionesnorte.co', 'Suspensión', 'Activo'),
  ];
  final _purchaseOrders = <PurchaseOrder>[
    PurchaseOrder('OC-1048', 'Frenos Colombia S.A.S.', 'Pastillas de freno cerámicas', 85, 6240000, 'Enviada', '25 Ago 2026'),
    PurchaseOrder('OC-1047', 'Motores Andinos Ltda.', 'Filtros de aceite premium', 120, 3180000, 'Recibida', '18 Ago 2026'),
    PurchaseOrder('OC-1046', 'Suspensiones del Norte', 'Amortiguadores delanteros', 36, 7560000, 'Borrador', '29 Ago 2026'),
  ];
  final _tickets = <CustomerTicket>[
    CustomerTicket('CAS-301', 'Taller El Pistón', 'Cotización de frenos', 'Alta', 'Abierto', 'Hace 12 min'),
    CustomerTicket('CAS-300', 'Distribuciones J&M', 'Consulta sobre pedido A-1029', 'Media', 'En proceso', 'Hace 24 min'),
    CustomerTicket('CAS-299', 'Carolina Restrepo', 'Garantía de amortiguador', 'Alta', 'Resuelto', 'Hace 1 h'),
  ];
  final _campaigns = <Campaign>[
    Campaign('CAM-018', 'Suspensión para talleres', 'Clientes frecuentes', '21', 'Activa', '15 Ago - 30 Ago'),
    Campaign('CAM-017', 'Frenos seguros', 'Clientes minoristas', '148', 'Borrador', '20 Ago - 05 Sep'),
    Campaign('CAM-016', 'Cambio de aceite', 'Flotas comerciales', '62', 'Finalizada', '01 Ago - 14 Ago'),
  ];

  bool get _canManageInventory => widget.role == UserRole.admin;

  @override
  void initState() {
    super.initState();
    _loadInventory();
    _loadPurchasing();
    _loadCustomerAndCommercialData();
    _loadCart();
  }

  @override
  void dispose() {
    _chatInput.dispose();
    super.dispose();
  }

  void _loadInventory() {
    try {
      final raw = html.window.localStorage['autopartes_pro_inventory'];
      if (raw != null && raw.isNotEmpty) {
        final stored = (jsonDecode(raw) as List<dynamic>)
            .map((item) => PartItem.fromJson(item as Map<String, dynamic>))
            .toList();
        _items
          ..clear()
          ..addAll(stored);
      }
    } catch (_) {
      // If local browser storage cannot be read, demo data remains available.
    }
    if (mounted) setState(() => _loadingInventory = false);
  }

  void _saveInventory() {
    html.window.localStorage['autopartes_pro_inventory'] = jsonEncode(_items.map((item) => item.toJson()).toList());
  }

  void _loadPurchasing() {
    try {
      final suppliersRaw = html.window.localStorage['autopartes_pro_suppliers'];
      final ordersRaw = html.window.localStorage['autopartes_pro_orders'];
      if (suppliersRaw != null && suppliersRaw.isNotEmpty) {
        _suppliers
          ..clear()
          ..addAll((jsonDecode(suppliersRaw) as List<dynamic>).map((item) => Supplier.fromJson(item as Map<String, dynamic>)));
      }
      if (ordersRaw != null && ordersRaw.isNotEmpty) {
        _purchaseOrders
          ..clear()
          ..addAll((jsonDecode(ordersRaw) as List<dynamic>).map((item) => PurchaseOrder.fromJson(item as Map<String, dynamic>)));
      }
    } catch (_) {
      // The screen remains usable with the included demo data.
    }
    if (mounted) setState(() => _loadingPurchasing = false);
  }

  void _savePurchasing() {
    html.window.localStorage['autopartes_pro_suppliers'] = jsonEncode(_suppliers.map((supplier) => supplier.toJson()).toList());
    html.window.localStorage['autopartes_pro_orders'] = jsonEncode(_purchaseOrders.map((order) => order.toJson()).toList());
  }

  void _loadCustomerAndCommercialData() {
    try {
      final ticketsRaw = html.window.localStorage['autopartes_pro_tickets'];
      final campaignsRaw = html.window.localStorage['autopartes_pro_campaigns'];
      if (ticketsRaw != null && ticketsRaw.isNotEmpty) {
        _tickets..clear()..addAll((jsonDecode(ticketsRaw) as List<dynamic>).map((item) => CustomerTicket.fromJson(item as Map<String, dynamic>)));
      }
      if (campaignsRaw != null && campaignsRaw.isNotEmpty) {
        _campaigns..clear()..addAll((jsonDecode(campaignsRaw) as List<dynamic>).map((item) => Campaign.fromJson(item as Map<String, dynamic>)));
      }
    } catch (_) {}
    if (mounted) setState(() { _loadingCustomerData = false; _loadingCommercialData = false; });
  }

  void _saveCustomerData() => html.window.localStorage['autopartes_pro_tickets'] = jsonEncode(_tickets.map((item) => item.toJson()).toList());
  void _saveCommercialData() => html.window.localStorage['autopartes_pro_campaigns'] = jsonEncode(_campaigns.map((item) => item.toJson()).toList());

  void _loadCart() {
    try {
      final raw = html.window.localStorage['autopartes_pro_cart'];
      if (raw != null && raw.isNotEmpty) {
        _cart..clear()..addAll((jsonDecode(raw) as List<dynamic>).map((item) => CartLine.fromJson(item as Map<String, dynamic>)));
      }
    } catch (_) {}
  }

  void _saveCart() => html.window.localStorage['autopartes_pro_cart'] = jsonEncode(_cart.map((item) => item.toJson()).toList());
  int get _cartUnits => _cart.fold(0, (total, line) => total + line.quantity);
  int get _cartTotal => _cart.fold(0, (total, line) => total + line.quantity * line.unitPrice);

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.sizeOf(context).width >= 980;
    return Scaffold(
      backgroundColor: const Color(0xfff5f7fa),
      drawer: wide ? null : Drawer(child: SafeArea(child: _sideMenu())),
      body: Row(children: [
        if (wide) SizedBox(width: 252, child: _sideMenu()),
        Expanded(child: Column(children: [
          _topBar(wide),
          Expanded(child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 36),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1450),
              child: _content(wide),
            ),
          )),
        ])),
      ]),
    );
  }

  Widget _sideMenu() => Container(
    color: const Color(0xff062f54),
    child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Padding(
        padding: EdgeInsets.fromLTRB(25, 30, 20, 30),
         child: Image.asset(
        'assets/images/logo_rediix.png', // Tu nuevo logo
        height: 60, // Altura ideal para la barra lateral
        alignment: Alignment.centerLeft, // Lo mantiene alineado a la izquierda
       ),
    ),
      _nav('Centro de control', Icons.grid_view_rounded, 0),
      _nav('Inventario', Icons.inventory_2_outlined, 1),
      _nav('Atención al cliente', Icons.support_agent_rounded, 2),
      _nav('Visibilidad comercial', Icons.insights_outlined, 3),
      _nav('Compras y proveedores', Icons.local_shipping_outlined, 4),
      const Spacer(),
      const Divider(color: Color(0xff214f71), height: 1),
      if (widget.role == UserRole.admin) _nav('Configuración', Icons.settings_outlined, 5),
      Padding(
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 2),
        child: Row(children: [
          Icon(widget.role == UserRole.admin ? Icons.admin_panel_settings_outlined : Icons.badge_outlined, color: const Color(0xffef8b22), size: 16),
          const SizedBox(width: 7),
          Text(widget.role == UserRole.admin ? 'ROL ADMINISTRADOR' : 'ROL USUARIO', style: const TextStyle(color: Color(0xffb7d0df), fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: .5)),
        ]),
      ),
      const Padding(padding: EdgeInsets.all(20), child: Text('v1.0  •  Entorno demostrativo', style: TextStyle(color: Color(0xff7f9eb4), fontSize: 11))),
    ]),
  );

  Widget _nav(String label, IconData icon, int index) => InkWell(
    onTap: () { setState(() => _section = index); if (Scaffold.maybeOf(context)?.isDrawerOpen ?? false) Navigator.pop(context); },
    child: Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 13),
      decoration: BoxDecoration(color: _section == index ? const Color(0xff176aa6) : Colors.transparent, borderRadius: BorderRadius.circular(8)),
      child: Row(children: [Icon(icon, color: _section == index ? Colors.white : const Color(0xffa4c1d3), size: 21), const SizedBox(width: 13), Text(label, style: TextStyle(color: _section == index ? Colors.white : const Color(0xffc5d8e4), fontWeight: _section == index ? FontWeight.w700 : FontWeight.w400, fontSize: 14))]),
    ),
  );

  Widget _topBar(bool wide) => Container(
    height: 74, color: Colors.white,
    padding: const EdgeInsets.symmetric(horizontal: 24),
    child: Row(children: [
      if (!wide) Builder(builder: (context) => IconButton(icon: const Icon(Icons.menu), onPressed: () => Scaffold.of(context).openDrawer())),
      Expanded(child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 440), child: TextField(
        onChanged: (v) => setState(() => _query = v),
        decoration: InputDecoration(hintText: 'Buscar repuesto, cliente o pedido...', prefixIcon: const Icon(Icons.search), filled: true, fillColor: const Color(0xfff4f6f8), border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none), contentPadding: EdgeInsets.zero),
      ))),
      const SizedBox(width: 14),
      IconButton(onPressed: () => _showMessage('Tienes 3 notificaciones pendientes'), icon: Badge(label: const Text('3'), child: const Icon(Icons.notifications_none_rounded))),
      IconButton(tooltip: 'Carrito de compra', onPressed: _openCart, icon: Badge(isLabelVisible: _cartUnits > 0, label: Text('$_cartUnits'), child: const Icon(Icons.shopping_cart_outlined))),
      const SizedBox(width: 12),
      CircleAvatar(backgroundColor: const Color(0xffdbeaf4), child: Text(widget.role == UserRole.admin ? 'AD' : 'OP', style: const TextStyle(color: Color(0xff0b4f8a), fontWeight: FontWeight.bold))),
      if (wide) Padding(padding: const EdgeInsets.only(left: 9), child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start, children: [Text(widget.role == UserRole.admin ? 'Administrador' : 'Usuario operativo', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700)), Text(widget.role == UserRole.admin ? 'Control total' : 'Gestión comercial', style: const TextStyle(fontSize: 11, color: Color(0xff657786)))])),
      IconButton(tooltip: 'Cerrar sesión', onPressed: widget.onLogout, icon: const Icon(Icons.logout_rounded, size: 21)),
    ]),
  );

  Widget _content(bool wide) {
    final titles = ['Centro de control', 'Inventario inteligente', 'Atención al cliente', 'Visibilidad comercial', 'Compras y proveedores', 'Configuración'];
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(titles[_section], style: const TextStyle(fontSize: 27, fontWeight: FontWeight.w800, color: Color(0xff17324d))),
      const SizedBox(height: 5),
      Text(_section == 0 ? 'Una visión clara de lo que requiere atención hoy.' : _section == 1 ? 'Consulta, registra y mantiene el catálogo de repuestos.' : _section == 2 ? 'Registra y da seguimiento a cada requerimiento de tus clientes.' : _section == 3 ? 'Planea y mide campañas para aumentar la visibilidad comercial.' : _section == 4 ? 'Administra aliados comerciales y abastecimiento desde un solo lugar.' : 'Módulo de demostración conectado a la operación comercial.', style: const TextStyle(color: Color(0xff637786))),
      const SizedBox(height: 24),
      if (_section == 0) _dashboard(wide) else if (_section == 1) _inventoryManagement(wide) else if (_section == 2) _customerManagement() else if (_section == 3) _commercialManagement() else if (_section == 4) _purchasingManagement(wide) else _modulePlaceholder(titles[_section]),
    ]);
  }

  Widget _dashboard(bool wide) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    LayoutBuilder(builder: (context, box) {
      final columns = box.maxWidth >= 1000 ? 4 : box.maxWidth >= 620 ? 2 : 1;
      return GridView.count(crossAxisCount: columns, crossAxisSpacing: 16, mainAxisSpacing: 16, childAspectRatio: columns == 1 ? 3.7 : 2.0, shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), children: const [
        _MetricCard('Ventas del mes', '\$184.6 M', '+12.4%', Icons.trending_up_rounded, Color(0xffe8f3eb), Color(0xff25834a)),
        _MetricCard('Disponibilidad', '93.8%', 'Meta 95%', Icons.inventory_2_outlined, Color(0xffe8f1fa), Color(0xff0b67b2)),
        _MetricCard('Pedidos por atender', '27', '8 prioritarios', Icons.receipt_long_outlined, Color(0xfffff1df), Color(0xffd66b00)),
        _MetricCard('Satisfacción cliente', '4.7/5', '+0.2 vs. mes ant.', Icons.sentiment_satisfied_alt_outlined, Color(0xfff1eafa), Color(0xff7d4da6)),
      ]);
    }),
    const SizedBox(height: 25),
    LayoutBuilder(builder: (context, box) {
      final stacked = box.maxWidth < 940;
      final inventory = _inventoryPanel();
      final actions = _actionsPanel();
      return stacked ? Column(children: [inventory, const SizedBox(height: 18), actions]) : Row(crossAxisAlignment: CrossAxisAlignment.start, children: [Expanded(flex: 7, child: inventory), const SizedBox(width: 18), Expanded(flex: 4, child: actions)]);
    }),
    const SizedBox(height: 24),
    LayoutBuilder(builder: (context, box) => box.maxWidth < 940 ? Column(children: [_salesPanel(), const SizedBox(height: 18), _servicePanel()]) : Row(crossAxisAlignment: CrossAxisAlignment.start, children: [Expanded(flex: 6, child: _salesPanel()), const SizedBox(width: 18), Expanded(flex: 5, child: _servicePanel())])),
  ]);

  Widget _inventoryPanel() {
    final filtered = _items.where((p) => (!_onlyAlerts || p.status != 'Saludable') && ('${p.name} ${p.sku} ${p.category}'.toLowerCase().contains(_query.toLowerCase()))).toList();
    return _panel(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Inventario que requiere gestión', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800)), SizedBox(height: 3), Text('Prioriza quiebres y reposiciones antes de perder ventas.', style: TextStyle(fontSize: 12, color: Color(0xff657786)))])), TextButton.icon(onPressed: () => setState(() => _onlyAlerts = !_onlyAlerts), icon: Icon(_onlyAlerts ? Icons.filter_alt : Icons.filter_alt_outlined, size: 18), label: Text(_onlyAlerts ? 'Ver todos' : 'Solo alertas'))]),
      const SizedBox(height: 18),
      SingleChildScrollView(scrollDirection: Axis.horizontal, child: DataTable(
      headingRowColor: MaterialStatePropertyAll(const Color(0xfff4f7f9)), columnSpacing: 22,
        columns: const [DataColumn(label: Text('REPUESTO')), DataColumn(label: Text('STOCK')), DataColumn(label: Text('UBICACIÓN')), DataColumn(label: Text('ESTADO'))],
        rows: filtered.map((p) => DataRow(cells: [DataCell(Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start, children: [Text(p.name, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)), Text('${p.sku}  ·  ${p.category}', style: const TextStyle(fontSize: 11, color: Color(0xff71808c)))])), DataCell(Text('${p.stock} / mín. ${p.minimum}', style: const TextStyle(fontWeight: FontWeight.w600))), DataCell(Text(p.location, style: const TextStyle(fontSize: 12))), DataCell(_statusChip(p.status))])).toList(),
      )),
      const SizedBox(height: 8), TextButton(onPressed: () => setState(() => _section = 1), child: const Text('Ver inventario completo  →')),
    ]));
  }

  Widget _inventoryManagement(bool wide) {
    final visibleItems = _items.where((item) {
      final matchesText = '${item.name} ${item.sku} ${item.category} ${item.location}'.toLowerCase().contains(_query.toLowerCase());
      final matchesStatus = _inventoryFilter == 'Todos' || item.status == _inventoryFilter;
      return matchesText && matchesStatus;
    }).toList();
    final critical = _items.where((item) => item.status == 'Crítico').length;
    final restock = _items.where((item) => item.status == 'Reponer').length;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Wrap(spacing: 14, runSpacing: 14, children: [
        _miniMetric('Referencias activas', '${_items.length}', Icons.widgets_outlined, const Color(0xff0b67b2)),
        _miniMetric('Stock crítico', '$critical', Icons.warning_amber_rounded, const Color(0xffc3402a)),
        _miniMetric('Por reponer', '$restock', Icons.add_shopping_cart_outlined, const Color(0xffb96400)),
      ]),
      const SizedBox(height: 22),
      _panel(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Catálogo de repuestos', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)), SizedBox(height: 4), Text('Datos guardados localmente en este navegador.', style: TextStyle(fontSize: 12, color: Color(0xff657786)))])),
          if (_canManageInventory) FilledButton.icon(onPressed: _createPart, icon: const Icon(Icons.add), label: const Text('Nuevo repuesto')),
        ]),
        const SizedBox(height: 20),
        Wrap(spacing: 12, runSpacing: 12, crossAxisAlignment: WrapCrossAlignment.center, children: [
          SizedBox(width: wide ? 360 : 280, child: TextField(onChanged: (value) => setState(() => _query = value), decoration: InputDecoration(hintText: 'Buscar por nombre, SKU o categoría', prefixIcon: const Icon(Icons.search), filled: true, fillColor: const Color(0xfff4f7f9), border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none), contentPadding: EdgeInsets.zero))),
          DropdownButtonFormField<String>(value: _inventoryFilter, decoration: const InputDecoration(labelText: 'Estado', border: OutlineInputBorder()), items: const ['Todos', 'Saludable', 'Reponer', 'Crítico'].map((value) => DropdownMenuItem(value: value, child: Text(value))).toList(), onChanged: (value) => setState(() => _inventoryFilter = value ?? 'Todos')),
          if (_canManageInventory) OutlinedButton.icon(onPressed: () => _showMessage('Los cambios se guardan automáticamente.'), icon: const Icon(Icons.cloud_done_outlined), label: const Text('Guardado local')),
        ]),
        const SizedBox(height: 18),
        if (_loadingInventory) const Padding(padding: EdgeInsets.all(42), child: Center(child: CircularProgressIndicator())) else SingleChildScrollView(scrollDirection: Axis.horizontal, child: DataTable(
          headingRowColor: const MaterialStatePropertyAll(Color(0xfff4f7f9)),
          columnSpacing: 24,
          columns: [const DataColumn(label: Text('IMAGEN')), const DataColumn(label: Text('REPUESTO')), const DataColumn(label: Text('CATEGORÍA')), const DataColumn(label: Text('STOCK')), const DataColumn(label: Text('UBICACIÓN')), const DataColumn(label: Text('ESTADO')), const DataColumn(label: Text('CARRITO')), if (_canManageInventory) const DataColumn(label: Text('ACCIONES'))],
          rows: visibleItems.map((item) => DataRow(cells: [
            DataCell(_partImage(item)),
            DataCell(Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start, children: [Text(item.name, style: const TextStyle(fontWeight: FontWeight.w700)), Text(item.sku, style: const TextStyle(fontSize: 11, color: Color(0xff71808c)))])),
            DataCell(Text(item.category)),
            DataCell(Text('${item.stock} / mín. ${item.minimum}', style: const TextStyle(fontWeight: FontWeight.w600))),
            DataCell(Text(item.location)),
            DataCell(_statusChip(item.status)),
            DataCell(IconButton(tooltip: 'Agregar al carrito', onPressed: item.stock == 0 ? null : () => _addToCart(item), icon: const Icon(Icons.add_shopping_cart_outlined, color: Color(0xff0b67b2)))),
            if (_canManageInventory) DataCell(Row(mainAxisSize: MainAxisSize.min, children: [IconButton(tooltip: 'Editar', color: const Color(0xff0b67b2), onPressed: () => _editPart(item), icon: const Icon(Icons.edit_outlined)), IconButton(tooltip: 'Eliminar', color: const Color(0xffc3402a), onPressed: () => _deletePart(item), icon: const Icon(Icons.delete_outline))])),
          ])).toList(),
        )),
        if (visibleItems.isEmpty && !_loadingInventory) const Padding(padding: EdgeInsets.all(28), child: Center(child: Text('No se encontraron repuestos con esos filtros.'))),
      ])),
    ]);
  }
Widget _partImage(dynamic item) {
  final String imageName = item.image ?? '';

  if (imageName.isEmpty) {
    return const SizedBox(
      width: 50,
      height: 50,
      child: Icon(Icons.settings, color: Colors.blueGrey, size: 28),
    );
  }

  // Al estar la carpeta en la raíz, esta es la ruta oficial exacta que Flutter busca:
  final String fullPath = 'assets/images/$imageName';

  return Image.asset(
    fullPath,
    width: 50,
    height: 50,
    fit: BoxFit.cover,
    errorBuilder: (context, error, stackTrace) {
      // Si la foto llega a fallar por el nombre, te pondrá el engranaje de respaldo
      return const SizedBox(
        width: 50,
        height: 50,
        child: Icon(Icons.settings, color: Colors.blueGrey, size: 28),
      );
    },
  );
}

  Widget _miniMetric(String label, String value, IconData icon, Color color) => Container(width: 205, padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(11), border: Border.all(color: const Color(0xffe4e9ed))), child: Row(children: [Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: color.withOpacity(.1), borderRadius: BorderRadius.circular(8)), child: Icon(icon, color: color)), const SizedBox(width: 11), Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800)), Text(label, style: const TextStyle(fontSize: 11, color: Color(0xff657786)))]) ]));

  Future<void> _createPart() async {
    final part = await _partDialog();
    if (part == null) return;
    if (_items.any((item) => item.sku.toLowerCase() == part.sku.toLowerCase())) {
      _showMessage('El SKU ${part.sku} ya existe.');
      return;
    }
    setState(() => _items.add(part));
    _saveInventory();
    _showMessage('Repuesto creado y guardado correctamente.');
  }

  Future<void> _editPart(PartItem item) async {
    final updated = await _partDialog(item: item);
    if (updated == null) return;
    final duplicate = _items.any((candidate) => candidate != item && candidate.sku.toLowerCase() == updated.sku.toLowerCase());
    if (duplicate) { _showMessage('Ese SKU ya está asignado a otro repuesto.'); return; }
    setState(() => _items[_items.indexOf(item)] = updated);
    _saveInventory();
    _showMessage('Cambios guardados correctamente.');
  }

  Future<void> _deletePart(PartItem item) async {
    final confirmed = await showDialog<bool>(context: context, builder: (context) => AlertDialog(title: const Text('Eliminar repuesto'), content: Text('¿Deseas eliminar “${item.name}”? Esta acción actualizará el catálogo guardado.'), actions: [TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')), FilledButton.tonal(onPressed: () => Navigator.pop(context, true), child: const Text('Eliminar'))]));
    if (confirmed != true) return;
    setState(() => _items.remove(item));
    _saveInventory();
    _showMessage('Repuesto eliminado.');
  }

  Future<PartItem?> _partDialog({PartItem? item}) async {
    final formKey = GlobalKey<FormState>();
    final name = TextEditingController(text: item?.name ?? '');
    final sku = TextEditingController(text: item?.sku ?? '');
    final stock = TextEditingController(text: item?.stock.toString() ?? '0');
    final minimum = TextEditingController(text: item?.minimum.toString() ?? '0');
    var category = item?.category ?? 'Motor';
    var location = item?.location ?? 'Bodega Central';
    final result = await showDialog<PartItem>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(item == null ? 'Nuevo repuesto' : 'Editar repuesto'),
          content: SizedBox(
            width: 520,
            child: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  TextFormField(controller: name, autofocus: true, decoration: const InputDecoration(labelText: 'Nombre del repuesto', border: OutlineInputBorder()), validator: (value) => value == null || value.trim().isEmpty ? 'Ingresa un nombre' : null),
                  const SizedBox(height: 14),
                  TextFormField(controller: sku, decoration: const InputDecoration(labelText: 'SKU o referencia', border: OutlineInputBorder()), validator: (value) => value == null || value.trim().isEmpty ? 'Ingresa un SKU' : null),
                  const SizedBox(height: 14),
                  Row(children: [Expanded(child: TextFormField(controller: stock, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Stock actual', border: OutlineInputBorder()), validator: _numberValidator)), const SizedBox(width: 14), Expanded(child: TextFormField(controller: minimum, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Stock mínimo', border: OutlineInputBorder()), validator: _numberValidator))]),
                  const SizedBox(height: 14),
                  DropdownButtonFormField<String>(value: category, decoration: const InputDecoration(labelText: 'Categoría', border: OutlineInputBorder()), items: const ['Motor', 'Frenos', 'Suspensión', 'Transmisión', 'Eléctrico'].map((value) => DropdownMenuItem(value: value, child: Text(value))).toList(), onChanged: (value) => setDialogState(() => category = value!)),
                  const SizedBox(height: 14),
                  DropdownButtonFormField<String>(value: location, decoration: const InputDecoration(labelText: 'Ubicación', border: OutlineInputBorder()), items: const ['Bodega Central', 'Bodega Norte', 'Bodega Sur'].map((value) => DropdownMenuItem(value: value, child: Text(value))).toList(), onChanged: (value) => setDialogState(() => location = value!)),
                ]),
              ),
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
            FilledButton(onPressed: () { if (!formKey.currentState!.validate()) return; final current = int.parse(stock.text); final min = int.parse(minimum.text); final status = current < min ? (current <= min * .5 ? 'Crítico' : 'Reponer') : 'Saludable'; Navigator.pop(context, PartItem(name.text.trim(), sku.text.trim().toUpperCase(), category, current, min, location, status)); }, child: Text(item == null ? 'Crear repuesto' : 'Guardar cambios')),
          ],
        ),
      ),
    );
    name.dispose(); sku.dispose(); stock.dispose(); minimum.dispose();
    return result;
  }

  String? _numberValidator(String? value) => int.tryParse(value ?? '') == null || int.parse(value!) < 0 ? 'Valor inválido' : null;

  Widget _purchasingManagement(bool wide) {
    final activeSuppliers = _suppliers.where((supplier) => supplier.status == 'Activo').length;
    final pendingOrders = _purchaseOrders.where((order) => order.status != 'Recibida').length;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Wrap(spacing: 14, runSpacing: 14, children: [
        _miniMetric('Proveedores activos', '$activeSuppliers', Icons.business_outlined, const Color(0xff0b67b2)),
        _miniMetric('Órdenes abiertas', '$pendingOrders', Icons.receipt_long_outlined, const Color(0xffb96400)),
        _miniMetric('Compra en tránsito', _currency(_purchaseOrders.where((order) => order.status == 'Enviada').fold(0, (sum, order) => sum + order.total)), Icons.local_shipping_outlined, const Color(0xff25834a)),
      ]),
      const SizedBox(height: 22),
      _panel(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Gestión de abastecimiento', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)), SizedBox(height: 4), Text('Información guardada localmente en este navegador.', style: TextStyle(fontSize: 12, color: Color(0xff657786)))])),
          if (_canManageInventory) FilledButton.icon(onPressed: _purchasingTab == 0 ? _createSupplier : _createOrder, icon: const Icon(Icons.add), label: Text(_purchasingTab == 0 ? 'Nuevo proveedor' : 'Nueva orden')),
        ]),
        const SizedBox(height: 18),
        SegmentedButton<int>(segments: const [ButtonSegment(value: 0, icon: Icon(Icons.business_outlined), label: Text('Proveedores')), ButtonSegment(value: 1, icon: Icon(Icons.receipt_long_outlined), label: Text('Órdenes de compra'))], selected: {_purchasingTab}, onSelectionChanged: (value) => setState(() => _purchasingTab = value.first)),
        const SizedBox(height: 20),
        if (_loadingPurchasing) const Padding(padding: EdgeInsets.all(42), child: Center(child: CircularProgressIndicator())) else if (_purchasingTab == 0) _suppliersTable() else _ordersTable(),
      ])),
    ]);
  }

  Widget _suppliersTable() => SingleChildScrollView(scrollDirection: Axis.horizontal, child: DataTable(
    headingRowColor: const MaterialStatePropertyAll(Color(0xfff4f7f9)),
    columnSpacing: 24,
    columns: [const DataColumn(label: Text('PROVEEDOR')), const DataColumn(label: Text('CONTACTO')), const DataColumn(label: Text('LÍNEA')), const DataColumn(label: Text('ESTADO')), if (_canManageInventory) const DataColumn(label: Text('ACCIONES'))],
    rows: _suppliers.map((supplier) => DataRow(cells: [
      DataCell(Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start, children: [Text(supplier.name, style: const TextStyle(fontWeight: FontWeight.w700)), Text(supplier.code, style: const TextStyle(fontSize: 11, color: Color(0xff71808c)))])),
      DataCell(Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start, children: [Text(supplier.contact), Text(supplier.email, style: const TextStyle(fontSize: 11, color: Color(0xff71808c)))])),
      DataCell(Text(supplier.category)),
      DataCell(_supplierStatus(supplier.status)),
      if (_canManageInventory) DataCell(Row(mainAxisSize: MainAxisSize.min, children: [IconButton(tooltip: 'Editar proveedor', onPressed: () => _editSupplier(supplier), icon: const Icon(Icons.edit_outlined, color: Color(0xff0b67b2))), IconButton(tooltip: 'Eliminar proveedor', onPressed: () => _deleteSupplier(supplier), icon: const Icon(Icons.delete_outline, color: Color(0xffc3402a)))])),
    ])).toList(),
  ));

  Widget _ordersTable() => SingleChildScrollView(scrollDirection: Axis.horizontal, child: DataTable(
    headingRowColor: const MaterialStatePropertyAll(Color(0xfff4f7f9)),
    columnSpacing: 24,
    columns: [const DataColumn(label: Text('ORDEN')), const DataColumn(label: Text('PROVEEDOR')), const DataColumn(label: Text('DETALLE')), const DataColumn(label: Text('TOTAL')), const DataColumn(label: Text('ESTADO')), if (_canManageInventory) const DataColumn(label: Text('ACCIONES'))],
    rows: _purchaseOrders.map((order) => DataRow(cells: [
      DataCell(Text(order.code, style: const TextStyle(fontWeight: FontWeight.w700))),
      DataCell(Text(order.supplier)),
      DataCell(Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start, children: [Text(order.detail), Text('${order.units} unidades · ${order.expectedDate}', style: const TextStyle(fontSize: 11, color: Color(0xff71808c)))])),
      DataCell(Text(_currency(order.total), style: const TextStyle(fontWeight: FontWeight.w700))),
      DataCell(_orderStatus(order.status)),
      if (_canManageInventory) DataCell(Row(mainAxisSize: MainAxisSize.min, children: [IconButton(tooltip: 'Editar orden', onPressed: () => _editOrder(order), icon: const Icon(Icons.edit_outlined, color: Color(0xff0b67b2))), IconButton(tooltip: 'Eliminar orden', onPressed: () => _deleteOrder(order), icon: const Icon(Icons.delete_outline, color: Color(0xffc3402a)))])),
    ])).toList(),
  ));

  Widget _supplierStatus(String status) => _statusChip(status == 'Activo' ? 'Saludable' : 'Reponer');
  Widget _orderStatus(String status) { final color = status == 'Recibida' ? const Color(0xff25834a) : status == 'Enviada' ? const Color(0xff0b67b2) : const Color(0xffb96400); return Container(padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5), decoration: BoxDecoration(color: color.withOpacity(.11), borderRadius: BorderRadius.circular(14)), child: Text(status, style: TextStyle(color: color, fontWeight: FontWeight.w700, fontSize: 11))); }
  String _currency(int amount) => '\$${(amount / 1000000).toStringAsFixed(amount >= 10000000 ? 1 : 2)} M';

  Future<void> _createSupplier() async { final supplier = await _supplierDialog(); if (supplier == null) return; if (_suppliers.any((item) => item.code.toLowerCase() == supplier.code.toLowerCase())) { _showMessage('Ese código de proveedor ya existe.'); return; } setState(() => _suppliers.add(supplier)); _savePurchasing(); _showMessage('Proveedor creado correctamente.'); }
  Future<void> _editSupplier(Supplier supplier) async { final updated = await _supplierDialog(supplier: supplier); if (updated == null) return; setState(() => _suppliers[_suppliers.indexOf(supplier)] = updated); _savePurchasing(); _showMessage('Proveedor actualizado.'); }
  Future<void> _deleteSupplier(Supplier supplier) async { if (_purchaseOrders.any((order) => order.supplier == supplier.name)) { _showMessage('No puedes eliminarlo porque tiene órdenes asociadas.'); return; } final confirmed = await _confirmDelete('el proveedor', supplier.name); if (confirmed) { setState(() => _suppliers.remove(supplier)); _savePurchasing(); _showMessage('Proveedor eliminado.'); } }

  Future<void> _createOrder() async { if (_suppliers.isEmpty) { _showMessage('Primero debes registrar un proveedor.'); return; } final order = await _orderDialog(); if (order == null) return; if (_purchaseOrders.any((item) => item.code.toLowerCase() == order.code.toLowerCase())) { _showMessage('Ese número de orden ya existe.'); return; } setState(() => _purchaseOrders.add(order)); _savePurchasing(); _showMessage('Orden de compra creada.'); }
  Future<void> _editOrder(PurchaseOrder order) async { final updated = await _orderDialog(order: order); if (updated == null) return; setState(() => _purchaseOrders[_purchaseOrders.indexOf(order)] = updated); _savePurchasing(); _showMessage('Orden de compra actualizada.'); }
  Future<void> _deleteOrder(PurchaseOrder order) async { final confirmed = await _confirmDelete('la orden', order.code); if (confirmed) { setState(() => _purchaseOrders.remove(order)); _savePurchasing(); _showMessage('Orden eliminada.'); } }

  Future<bool> _confirmDelete(String type, String name) async => await showDialog<bool>(context: context, builder: (context) => AlertDialog(title: const Text('Confirmar eliminación'), content: Text('¿Deseas eliminar $type “$name”? Esta acción actualizará los datos guardados.'), actions: [TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')), FilledButton.tonal(onPressed: () => Navigator.pop(context, true), child: const Text('Eliminar'))])) ?? false;

  Future<Supplier?> _supplierDialog({Supplier? supplier}) async {
    final key = GlobalKey<FormState>();
    final name = TextEditingController(text: supplier?.name ?? '');
    final code = TextEditingController(text: supplier?.code ?? '');
    final contact = TextEditingController(text: supplier?.contact ?? '');
    final email = TextEditingController(text: supplier?.email ?? '');
    var category = supplier?.category ?? 'Motor';
    var status = supplier?.status ?? 'Activo';
    final result = await showDialog<Supplier>(context: context, builder: (context) => StatefulBuilder(builder: (context, update) => AlertDialog(
      title: Text(supplier == null ? 'Nuevo proveedor' : 'Editar proveedor'),
      content: SizedBox(width: 500, child: Form(key: key, child: SingleChildScrollView(child: Column(mainAxisSize: MainAxisSize.min, children: [
        TextFormField(controller: name, autofocus: true, decoration: const InputDecoration(labelText: 'Razón social', border: OutlineInputBorder()), validator: _required),
        const SizedBox(height: 14), TextFormField(controller: code, decoration: const InputDecoration(labelText: 'Código de proveedor', border: OutlineInputBorder()), validator: _required),
        const SizedBox(height: 14), TextFormField(controller: contact, decoration: const InputDecoration(labelText: 'Contacto principal', border: OutlineInputBorder()), validator: _required),
        const SizedBox(height: 14), TextFormField(controller: email, keyboardType: TextInputType.emailAddress, decoration: const InputDecoration(labelText: 'Correo de contacto', border: OutlineInputBorder()), validator: (value) => value == null || !value.contains('@') ? 'Ingresa un correo válido' : null),
        const SizedBox(height: 14), DropdownButtonFormField<String>(value: category, decoration: const InputDecoration(labelText: 'Línea de producto', border: OutlineInputBorder()), items: const ['Motor', 'Frenos', 'Suspensión', 'Transmisión', 'Eléctrico'].map((value) => DropdownMenuItem(value: value, child: Text(value))).toList(), onChanged: (value) => update(() => category = value!)),
        const SizedBox(height: 14), DropdownButtonFormField<String>(value: status, decoration: const InputDecoration(labelText: 'Estado', border: OutlineInputBorder()), items: const ['Activo', 'Inactivo'].map((value) => DropdownMenuItem(value: value, child: Text(value))).toList(), onChanged: (value) => update(() => status = value!)),
      ])))),
      actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')), FilledButton(onPressed: () { if (!key.currentState!.validate()) return; Navigator.pop(context, Supplier(name.text.trim(), code.text.trim().toUpperCase(), contact.text.trim(), email.text.trim(), category, status)); }, child: Text(supplier == null ? 'Crear proveedor' : 'Guardar cambios'))],
    )));
    name.dispose(); code.dispose(); contact.dispose(); email.dispose();
    return result;
  }

  Future<PurchaseOrder?> _orderDialog({PurchaseOrder? order}) async {
    final key = GlobalKey<FormState>();
    final code = TextEditingController(text: order?.code ?? 'OC-${1050 + _purchaseOrders.length}');
    final detail = TextEditingController(text: order?.detail ?? '');
    final units = TextEditingController(text: order?.units.toString() ?? '1');
    final total = TextEditingController(text: order?.total.toString() ?? '0');
    final date = TextEditingController(text: order?.expectedDate ?? '30 Ago 2026');
    var supplier = order?.supplier ?? _suppliers.first.name;
    var status = order?.status ?? 'Borrador';
    final result = await showDialog<PurchaseOrder>(context: context, builder: (context) => StatefulBuilder(builder: (context, update) => AlertDialog(
      title: Text(order == null ? 'Nueva orden de compra' : 'Editar orden de compra'),
      content: SizedBox(width: 500, child: Form(key: key, child: SingleChildScrollView(child: Column(mainAxisSize: MainAxisSize.min, children: [
        TextFormField(controller: code, decoration: const InputDecoration(labelText: 'Número de orden', border: OutlineInputBorder()), validator: _required),
        const SizedBox(height: 14), DropdownButtonFormField<String>(value: supplier, decoration: const InputDecoration(labelText: 'Proveedor', border: OutlineInputBorder()), items: _suppliers.map((item) => DropdownMenuItem(value: item.name, child: Text(item.name))).toList(), onChanged: (value) => update(() => supplier = value!)),
        const SizedBox(height: 14), TextFormField(controller: detail, decoration: const InputDecoration(labelText: 'Detalle de la compra', border: OutlineInputBorder()), validator: _required),
        const SizedBox(height: 14), Row(children: [Expanded(child: TextFormField(controller: units, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Unidades', border: OutlineInputBorder()), validator: _positiveValidator)), const SizedBox(width: 14), Expanded(child: TextFormField(controller: total, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Valor total (COP)', border: OutlineInputBorder()), validator: _positiveValidator))]),
        const SizedBox(height: 14), TextFormField(controller: date, decoration: const InputDecoration(labelText: 'Fecha estimada', border: OutlineInputBorder()), validator: _required),
        const SizedBox(height: 14), DropdownButtonFormField<String>(value: status, decoration: const InputDecoration(labelText: 'Estado', border: OutlineInputBorder()), items: const ['Borrador', 'Enviada', 'Recibida'].map((value) => DropdownMenuItem(value: value, child: Text(value))).toList(), onChanged: (value) => update(() => status = value!)),
      ])))),
      actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')), FilledButton(onPressed: () { if (!key.currentState!.validate()) return; Navigator.pop(context, PurchaseOrder(code.text.trim().toUpperCase(), supplier, detail.text.trim(), int.parse(units.text), int.parse(total.text), status, date.text.trim())); }, child: Text(order == null ? 'Crear orden' : 'Guardar cambios'))],
    )));
    code.dispose(); detail.dispose(); units.dispose(); total.dispose(); date.dispose();
    return result;
  }

  String? _required(String? value) => value == null || value.trim().isEmpty ? 'Este campo es obligatorio' : null;
  String? _positiveValidator(String? value) => int.tryParse(value ?? '') == null || int.parse(value!) <= 0 ? 'Valor inválido' : null;

  Widget _customerManagement() {
    final open = _tickets.where((ticket) => ticket.status != 'Resuelto').length;
    final high = _tickets.where((ticket) => ticket.priority == 'Alta').length;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Wrap(spacing: 14, runSpacing: 14, children: [_miniMetric('Casos activos', '$open', Icons.mark_email_unread_outlined, const Color(0xff0b67b2)), _miniMetric('Prioridad alta', '$high', Icons.priority_high_rounded, const Color(0xffc3402a)), _miniMetric('Satisfacción estimada', '4.7/5', Icons.sentiment_satisfied_alt_outlined, const Color(0xff25834a))]),
      const SizedBox(height: 22),
      _panel(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Bandeja de atención', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)), SizedBox(height: 4), Text('Cada caso conserva su seguimiento localmente.', style: TextStyle(fontSize: 12, color: Color(0xff657786)))])), if (_canManageInventory) FilledButton.icon(onPressed: _createTicket, icon: const Icon(Icons.add), label: const Text('Nuevo caso'))]),
        const SizedBox(height: 18),
        if (_loadingCustomerData) const Center(child: Padding(padding: EdgeInsets.all(42), child: CircularProgressIndicator())) else SingleChildScrollView(scrollDirection: Axis.horizontal, child: DataTable(
          headingRowColor: const MaterialStatePropertyAll(Color(0xfff4f7f9)), columnSpacing: 24,
          columns: [const DataColumn(label: Text('CASO')), const DataColumn(label: Text('CLIENTE')), const DataColumn(label: Text('ASUNTO')), const DataColumn(label: Text('PRIORIDAD')), const DataColumn(label: Text('ESTADO')), if (_canManageInventory) const DataColumn(label: Text('ACCIONES'))],
          rows: _tickets.map((ticket) => DataRow(cells: [DataCell(Text(ticket.code, style: const TextStyle(fontWeight: FontWeight.w700))), DataCell(Text(ticket.customer)), DataCell(Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start, children: [Text(ticket.subject), Text(ticket.updatedAt, style: const TextStyle(fontSize: 11, color: Color(0xff71808c)))])), DataCell(_priorityChip(ticket.priority)), DataCell(_ticketStatus(ticket.status)), if (_canManageInventory) DataCell(Row(mainAxisSize: MainAxisSize.min, children: [IconButton(onPressed: () => _editTicket(ticket), icon: const Icon(Icons.edit_outlined, color: Color(0xff0b67b2))), IconButton(onPressed: () => _deleteTicket(ticket), icon: const Icon(Icons.delete_outline, color: Color(0xffc3402a)))]))])).toList(),
        )),
      ])),
      const SizedBox(height: 20),
      _chatbotPanel(),
    ]);
  }

  Widget _chatbotPanel() => _panel(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    const Row(children: [CircleAvatar(backgroundColor: Color(0xffe8f1fa), child: Icon(Icons.smart_toy_outlined, color: Color(0xff0b67b2))), SizedBox(width: 10), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Asistente Pro', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800)), Text('Respuestas rápidas para clientes y equipo de servicio.', style: TextStyle(fontSize: 12, color: Color(0xff657786)))])), Chip(label: Text('En línea'), avatar: Icon(Icons.circle, size: 10, color: Color(0xff25834a)))]),
    const SizedBox(height: 16),
    Container(
      height: 260,
      decoration: BoxDecoration(color: const Color(0xfff7f9fb), borderRadius: BorderRadius.circular(10)),
      child: ListView.builder(
        padding: const EdgeInsets.all(14),
        itemCount: _chatMessages.length,
        itemBuilder: (context, index) {
          final message = _chatMessages[index];
          return Align(
            alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
            child: Container(
              constraints: const BoxConstraints(maxWidth: 580),
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
              decoration: BoxDecoration(
                color: message.isUser ? const Color(0xff0b67b2) : Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: message.isUser ? null : Border.all(color: const Color(0xffe2e8ed)),
              ),
              child: Text(message.text, style: TextStyle(fontSize: 13, height: 1.35, color: message.isUser ? Colors.white : const Color(0xff31566f))),
            ),
          );
        },
      ),
    ),
    const SizedBox(height: 14),
    Row(
      children: [
        Expanded(
          child: TextField(
            controller: _chatInput,
            onSubmitted: (_) => _sendChatMessage(),
            decoration: InputDecoration(
              hintText: 'Escribe: “¿Tienen filtros de aceite?”',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(9)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            ),
          ),
        ),
        const SizedBox(width: 9),
        FilledButton(
          onPressed: _sendChatMessage,
          style: FilledButton.styleFrom(minimumSize: const Size(48, 48), padding: EdgeInsets.zero),
          child: const Icon(Icons.send_rounded),
        ),
      ],
    ),
    const SizedBox(height: 10),
    Wrap(spacing: 8, runSpacing: 4, children: ['Consultar inventario', 'Estado de pedido', 'Garantías', 'Horario'].map((question) => ActionChip(label: Text(question), onPressed: () { _chatInput.text = question; _sendChatMessage(); })).toList()),
  ]));

  void _sendChatMessage() {
    final question = _chatInput.text.trim();
    if (question.isEmpty) return;
    final response = _chatResponse(question);
    setState(() { _chatMessages.add(ChatMessage(question, true)); _chatMessages.add(ChatMessage(response, false)); _chatInput.clear(); });
  }

  String _chatResponse(String question) {
    final text = question.toLowerCase();
    if (text.contains('inventario') || text.contains('filtro') || text.contains('repuesto')) return 'Tenemos ${_items.length} referencias activas. Puedes consultar disponibilidad exacta desde Inventario o indicar el SKU del repuesto.';
    if (text.contains('pedido') || text.contains('orden')) return 'Actualmente hay ${_purchaseOrders.where((order) => order.status != 'Recibida').length} órdenes de compra abiertas. Para un pedido de cliente, indícame el número de referencia.';
    if (text.contains('garant')) return 'Para gestionar una garantía, solicita la factura, el SKU y una foto del producto. El equipo abrirá un caso de atención.';
    if (text.contains('horario') || text.contains('hora')) return 'Atendemos de lunes a viernes, de 8:00 a. m. a 6:00 p. m., y sábados de 8:00 a. m. a 1:00 p. m.';
    return 'Puedo ayudarte con inventario, estado de pedidos, garantías y horarios. ¿Sobre cuál tema deseas consultar?';
  }

  Widget _commercialManagement() {
    final active = _campaigns.where((campaign) => campaign.status == 'Activa').length;
    final audience = _campaigns.fold(0, (total, campaign) => total + (int.tryParse(campaign.audience) ?? 0));
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Wrap(spacing: 14, runSpacing: 14, children: [_miniMetric('Campañas activas', '$active', Icons.campaign_outlined, const Color(0xff7d4da6)), _miniMetric('Audiencia total', '$audience', Icons.groups_outlined, const Color(0xff0b67b2)), _miniMetric('Alcance proyectado', '68%', Icons.trending_up_rounded, const Color(0xff25834a))]),
      const SizedBox(height: 22),
      _panel(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Campañas comerciales', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)), SizedBox(height: 4), Text('Planifica comunicaciones segmentadas y mide su estado.', style: TextStyle(fontSize: 12, color: Color(0xff657786)))])), if (_canManageInventory) FilledButton.icon(onPressed: _createCampaign, icon: const Icon(Icons.add), label: const Text('Nueva campaña'))]),
        const SizedBox(height: 18),
        if (_loadingCommercialData) const Center(child: Padding(padding: EdgeInsets.all(42), child: CircularProgressIndicator())) else SingleChildScrollView(scrollDirection: Axis.horizontal, child: DataTable(
          headingRowColor: const MaterialStatePropertyAll(Color(0xfff4f7f9)), columnSpacing: 24,
          columns: [const DataColumn(label: Text('CAMPAÑA')), const DataColumn(label: Text('SEGMENTO')), const DataColumn(label: Text('AUDIENCIA')), const DataColumn(label: Text('PERIODO')), const DataColumn(label: Text('ESTADO')), if (_canManageInventory) const DataColumn(label: Text('ACCIONES'))],
          rows: _campaigns.map((campaign) => DataRow(cells: [DataCell(Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start, children: [Text(campaign.name, style: const TextStyle(fontWeight: FontWeight.w700)), Text(campaign.code, style: const TextStyle(fontSize: 11, color: Color(0xff71808c)))])), DataCell(Text(campaign.segment)), DataCell(Text('${campaign.audience} clientes')), DataCell(Text(campaign.period)), DataCell(_campaignStatus(campaign.status)), if (_canManageInventory) DataCell(Row(mainAxisSize: MainAxisSize.min, children: [IconButton(onPressed: () => _editCampaign(campaign), icon: const Icon(Icons.edit_outlined, color: Color(0xff0b67b2))), IconButton(onPressed: () => _deleteCampaign(campaign), icon: const Icon(Icons.delete_outline, color: Color(0xffc3402a)))]))])).toList(),
        )),
      ])),
    ]);
  }

  Widget _priorityChip(String priority) { final color = priority == 'Alta' ? const Color(0xffc3402a) : priority == 'Media' ? const Color(0xffb96400) : const Color(0xff25834a); return _labelChip(priority, color); }
  Widget _ticketStatus(String status) => _labelChip(status, status == 'Resuelto' ? const Color(0xff25834a) : status == 'En proceso' ? const Color(0xff0b67b2) : const Color(0xffb96400));
  Widget _campaignStatus(String status) => _labelChip(status, status == 'Activa' ? const Color(0xff25834a) : status == 'Borrador' ? const Color(0xffb96400) : const Color(0xff71808c));
  Widget _labelChip(String label, Color color) => Container(padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5), decoration: BoxDecoration(color: color.withOpacity(.11), borderRadius: BorderRadius.circular(14)), child: Text(label, style: TextStyle(color: color, fontWeight: FontWeight.w700, fontSize: 11)));

  Future<void> _createTicket() async { final ticket = await _ticketDialog(); if (ticket == null) return; if (_tickets.any((item) => item.code == ticket.code)) { _showMessage('Ese código de caso ya existe.'); return; } setState(() => _tickets.add(ticket)); _saveCustomerData(); _showMessage('Caso creado.'); }
  Future<void> _editTicket(CustomerTicket ticket) async { final updated = await _ticketDialog(ticket: ticket); if (updated == null) return; setState(() => _tickets[_tickets.indexOf(ticket)] = updated); _saveCustomerData(); _showMessage('Caso actualizado.'); }
  Future<void> _deleteTicket(CustomerTicket ticket) async { if (await _confirmDelete('el caso', ticket.code)) { setState(() => _tickets.remove(ticket)); _saveCustomerData(); _showMessage('Caso eliminado.'); } }
  Future<void> _createCampaign() async { final campaign = await _campaignDialog(); if (campaign == null) return; if (_campaigns.any((item) => item.code == campaign.code)) { _showMessage('Ese código ya existe.'); return; } setState(() => _campaigns.add(campaign)); _saveCommercialData(); _showMessage('Campaña creada.'); }
  Future<void> _editCampaign(Campaign campaign) async { final updated = await _campaignDialog(campaign: campaign); if (updated == null) return; setState(() => _campaigns[_campaigns.indexOf(campaign)] = updated); _saveCommercialData(); _showMessage('Campaña actualizada.'); }
  Future<void> _deleteCampaign(Campaign campaign) async { if (await _confirmDelete('la campaña', campaign.name)) { setState(() => _campaigns.remove(campaign)); _saveCommercialData(); _showMessage('Campaña eliminada.'); } }

  Future<CustomerTicket?> _ticketDialog({CustomerTicket? ticket}) async {
    final code = TextEditingController(text: ticket?.code ?? 'CAS-${302 + _tickets.length}');
    final customer = TextEditingController(text: ticket?.customer ?? '');
    final subject = TextEditingController(text: ticket?.subject ?? '');
    var priority = ticket?.priority ?? 'Media';
    var status = ticket?.status ?? 'Abierto';
    final result = await showDialog<CustomerTicket>(context: context, builder: (context) => StatefulBuilder(builder: (context, update) => AlertDialog(
      title: Text(ticket == null ? 'Nuevo caso de atención' : 'Editar caso'),
      content: SizedBox(width: 480, child: SingleChildScrollView(child: Column(mainAxisSize: MainAxisSize.min, children: [
        TextField(controller: code, decoration: const InputDecoration(labelText: 'Código del caso', border: OutlineInputBorder())), const SizedBox(height: 14),
        TextField(controller: customer, decoration: const InputDecoration(labelText: 'Cliente', border: OutlineInputBorder())), const SizedBox(height: 14),
        TextField(controller: subject, decoration: const InputDecoration(labelText: 'Asunto o requerimiento', border: OutlineInputBorder())), const SizedBox(height: 14),
        DropdownButtonFormField<String>(value: priority, decoration: const InputDecoration(labelText: 'Prioridad', border: OutlineInputBorder()), items: const ['Alta', 'Media', 'Baja'].map((value) => DropdownMenuItem(value: value, child: Text(value))).toList(), onChanged: (value) => update(() => priority = value!)), const SizedBox(height: 14),
        DropdownButtonFormField<String>(value: status, decoration: const InputDecoration(labelText: 'Estado', border: OutlineInputBorder()), items: const ['Abierto', 'En proceso', 'Resuelto'].map((value) => DropdownMenuItem(value: value, child: Text(value))).toList(), onChanged: (value) => update(() => status = value!)),
      ]))),
      actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')), FilledButton(onPressed: () { if (code.text.trim().isEmpty || customer.text.trim().isEmpty || subject.text.trim().isEmpty) { _showMessage('Completa todos los campos.'); return; } Navigator.pop(context, CustomerTicket(code.text.trim().toUpperCase(), customer.text.trim(), subject.text.trim(), priority, status, 'Actualizado ahora')); }, child: Text(ticket == null ? 'Crear caso' : 'Guardar cambios'))],
    )));
    code.dispose(); customer.dispose(); subject.dispose();
    return result;
  }

  Future<Campaign?> _campaignDialog({Campaign? campaign}) async {
    final code = TextEditingController(text: campaign?.code ?? 'CAM-${19 + _campaigns.length}'.padLeft(7, '0'));
    final name = TextEditingController(text: campaign?.name ?? '');
    final segment = TextEditingController(text: campaign?.segment ?? '');
    final audience = TextEditingController(text: campaign?.audience ?? '0');
    final period = TextEditingController(text: campaign?.period ?? '01 Sep - 15 Sep');
    var status = campaign?.status ?? 'Borrador';
    final result = await showDialog<Campaign>(context: context, builder: (context) => StatefulBuilder(builder: (context, update) => AlertDialog(
      title: Text(campaign == null ? 'Nueva campaña' : 'Editar campaña'),
      content: SizedBox(width: 480, child: SingleChildScrollView(child: Column(mainAxisSize: MainAxisSize.min, children: [
        TextField(controller: code, decoration: const InputDecoration(labelText: 'Código de campaña', border: OutlineInputBorder())), const SizedBox(height: 14),
        TextField(controller: name, decoration: const InputDecoration(labelText: 'Nombre de la campaña', border: OutlineInputBorder())), const SizedBox(height: 14),
        TextField(controller: segment, decoration: const InputDecoration(labelText: 'Segmento objetivo', border: OutlineInputBorder())), const SizedBox(height: 14),
        TextField(controller: audience, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Audiencia estimada', border: OutlineInputBorder())), const SizedBox(height: 14),
        TextField(controller: period, decoration: const InputDecoration(labelText: 'Periodo', border: OutlineInputBorder())), const SizedBox(height: 14),
        DropdownButtonFormField<String>(value: status, decoration: const InputDecoration(labelText: 'Estado', border: OutlineInputBorder()), items: const ['Borrador', 'Activa', 'Finalizada'].map((value) => DropdownMenuItem(value: value, child: Text(value))).toList(), onChanged: (value) => update(() => status = value!)),
      ]))),
      actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')), FilledButton(onPressed: () { if (code.text.trim().isEmpty || name.text.trim().isEmpty || segment.text.trim().isEmpty || int.tryParse(audience.text) == null || period.text.trim().isEmpty) { _showMessage('Completa los campos con valores válidos.'); return; } Navigator.pop(context, Campaign(code.text.trim().toUpperCase(), name.text.trim(), segment.text.trim(), audience.text, status, period.text.trim())); }, child: Text(campaign == null ? 'Crear campaña' : 'Guardar cambios'))],
    )));
    code.dispose(); name.dispose(); segment.dispose(); audience.dispose(); period.dispose();
    return result;
  }

  void _addToCart(PartItem item) {
    final existing = _cart.where((line) => line.sku == item.sku).toList();
    if (existing.isNotEmpty) {
      if (existing.first.quantity >= item.stock) { _showMessage('No hay más unidades disponibles de ${item.name}.'); return; }
      setState(() => existing.first.quantity++);
    } else {
      setState(() => _cart.add(CartLine(item.sku, item.name, 1, _priceFor(item))));
    }
    _saveCart();
    _showMessage('${item.name} se agregó al carrito.');
  }

  int _priceFor(PartItem item) {
    const prices = {'FR-4821': 78000, 'MO-1198': 26500, 'SU-0732': 210000, 'TR-2984': 390000};
    return prices[item.sku] ?? 50000;
  }

  void _openCart() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (context) => StatefulBuilder(builder: (context, refresh) => SafeArea(child: SizedBox(height: MediaQuery.sizeOf(context).height * .78, child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 4, 24, 24),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Carrito de compra', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800)), SizedBox(height: 3), Text('Revisa las referencias antes de confirmar el pedido.', style: TextStyle(fontSize: 12, color: Color(0xff657786)))])), Text('${_cartUnits} unidades', style: const TextStyle(fontWeight: FontWeight.w700, color: Color(0xff0b67b2)))]),
          const SizedBox(height: 18),
          Expanded(child: _cart.isEmpty ? const Center(child: Column(mainAxisSize: MainAxisSize.min, children: [Icon(Icons.shopping_cart_outlined, size: 52, color: Color(0xff9aabb8)), SizedBox(height: 12), Text('Tu carrito está vacío'), SizedBox(height: 4), Text('Agrega repuestos desde Inventario.', style: TextStyle(color: Color(0xff657786))) ])) : ListView.separated(itemCount: _cart.length, separatorBuilder: (_, __) => const Divider(), itemBuilder: (context, index) { final line = _cart[index]; return ListTile(contentPadding: EdgeInsets.zero, title: Text(line.name, style: const TextStyle(fontWeight: FontWeight.w700)), subtitle: Text('${line.sku} · ${_currency(line.unitPrice)} c/u'), trailing: SizedBox(width: 185, child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [IconButton(onPressed: () { final matches = _items.where((item) => item.sku == line.sku).toList(); if (matches.isNotEmpty && line.quantity < matches.first.stock) { setState(() => line.quantity++); _saveCart(); refresh(() {}); } }, icon: const Icon(Icons.add_circle_outline, color: Color(0xff0b67b2))), Text('${line.quantity}', style: const TextStyle(fontWeight: FontWeight.w800)), IconButton(onPressed: () { if (line.quantity > 1) { setState(() => line.quantity--); } else { setState(() => _cart.removeAt(index)); } _saveCart(); refresh(() {}); }, icon: const Icon(Icons.remove_circle_outline, color: Color(0xff0b67b2))), IconButton(tooltip: 'Eliminar', onPressed: () { setState(() => _cart.removeAt(index)); _saveCart(); refresh(() {}); }, icon: const Icon(Icons.delete_outline, color: Color(0xffc3402a)))]))); })),
          if (_cart.isNotEmpty) Column(children: [const Divider(thickness: 1.2), const SizedBox(height: 8), Row(children: [const Text('Total estimado', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)), const Spacer(), Text(_currency(_cartTotal), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Color(0xff0b4f8a)))]), const SizedBox(height: 16), SizedBox(width: double.infinity, height: 48, child: FilledButton.icon(onPressed: () { setState(() => _cart.clear()); _saveCart(); Navigator.pop(context); _showMessage('Pedido registrado. Te contactaremos para confirmar disponibilidad.'); }, icon: const Icon(Icons.check_circle_outline), label: const Text('Confirmar pedido')))]),
        ]),
      )))),
    );
  }

  Widget _actionsPanel() => _panel(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    const Text('Acciones prioritarias', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800)), const SizedBox(height: 5), const Text('Sugerencias basadas en ventas y existencias.', style: TextStyle(fontSize: 12, color: Color(0xff657786))), const SizedBox(height: 18),
    _action(Icons.warning_amber_rounded, const Color(0xffffead7), 'Evitar quiebre de stock', 'Pastillas FR-4821: quedan 8 unidades.', 'Crear orden'),
    _action(Icons.person_pin_circle_outlined, const Color(0xffe5f1fb), 'Responder cotización', 'Taller El Pistón espera respuesta.', 'Abrir CRM'),
    _action(Icons.campaign_outlined, const Color(0xfff3ebfc), 'Activar campaña', '21 clientes compran suspensión con frecuencia.', 'Ver campaña'),
  ]));

  Widget _salesPanel() => _panel(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    const Row(children: [Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Pulso comercial', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800)), SizedBox(height: 3), Text('Ventas facturadas por semana · Agosto', style: TextStyle(fontSize: 12, color: Color(0xff657786)))])), Icon(Icons.more_horiz)]),
    const SizedBox(height: 28), SizedBox(height: 155, child: _BarChart()),
    const Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [Text('Sem. 1', style: TextStyle(fontSize: 11, color: Color(0xff71808c))), Text('Sem. 2', style: TextStyle(fontSize: 11, color: Color(0xff71808c))), Text('Sem. 3', style: TextStyle(fontSize: 11, color: Color(0xff71808c))), Text('Sem. 4', style: TextStyle(fontSize: 11, color: Color(0xff71808c)))])
  ]));

  Widget _servicePanel() => _panel(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    const Text('Atención al cliente', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800)), const SizedBox(height: 5), const Text('Estado de las conversaciones activas.', style: TextStyle(fontSize: 12, color: Color(0xff657786))), const SizedBox(height: 17),
    _customer('Taller El Pistón', 'Cotización · hace 12 min', 'Esperando respuesta', const Color(0xffd66b00)),
    _customer('Distribuciones J&M', 'Pedido #A-1029 · hace 24 min', 'En preparación', const Color(0xff0b67b2)),
    _customer('Carolina Restrepo', 'Garantía · hace 1 h', 'Asignado a soporte', const Color(0xff7d4da6)),
    const SizedBox(height: 5), TextButton(onPressed: () => setState(() => _section = 2), child: const Text('Ir a bandeja de servicio  →')),
  ]));

  Widget _modulePlaceholder(String name) => _panel(child: SizedBox(height: 330, child: Center(child: Column(mainAxisSize: MainAxisSize.min, children: [Icon(_section == 1 ? Icons.inventory_2_outlined : _section == 2 ? Icons.support_agent : Icons.insights_outlined, size: 58, color: const Color(0xff0b67b2)), const SizedBox(height: 16), Text('$name listo para configurar', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18)), const SizedBox(height: 7), const Text('El panel demostrativo concentra decisiones y tareas clave.', style: TextStyle(color: Color(0xff657786))), const SizedBox(height: 18), FilledButton(onPressed: () => setState(() => _section = 0), child: const Text('Volver al centro de control'))]))));

  Widget _panel({required Widget child}) => Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xffe4e9ed))), child: child);
  Widget _statusChip(String status) { final c = status == 'Saludable' ? const Color(0xff25834a) : status == 'Crítico' ? const Color(0xffc3402a) : const Color(0xffb96400); return Container(padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5), decoration: BoxDecoration(color: c.withOpacity(.11), borderRadius: BorderRadius.circular(14)), child: Text(status, style: TextStyle(color: c, fontWeight: FontWeight.w700, fontSize: 11))); }
  Widget _action(IconData icon, Color bg, String title, String subtitle, String action) => Padding(padding: const EdgeInsets.only(bottom: 15), child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [Container(padding: const EdgeInsets.all(9), decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(8)), child: Icon(icon, size: 20, color: const Color(0xff31566f))), const SizedBox(width: 11), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)), const SizedBox(height: 3), Text(subtitle, style: const TextStyle(fontSize: 12, color: Color(0xff657786))), const SizedBox(height: 5), InkWell(onTap: () => _showMessage('$action: acción registrada'), child: Text(action, style: const TextStyle(fontSize: 12, color: Color(0xff0b67b2), fontWeight: FontWeight.w700)))]))]));
  Widget _customer(String name, String detail, String state, Color color) => Padding(padding: const EdgeInsets.only(bottom: 14), child: Row(children: [CircleAvatar(radius: 18, backgroundColor: color.withOpacity(.12), child: Text(name.substring(0, 1), style: TextStyle(color: color, fontWeight: FontWeight.bold))), const SizedBox(width: 10), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700)), Text(detail, style: const TextStyle(fontSize: 11, color: Color(0xff71808c)))])), Text(state, style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.w700))]));
  void _showMessage(String message) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message), behavior: SnackBarBehavior.floating));
}

class _MetricCard extends StatelessWidget {
  const _MetricCard(this.label, this.value, this.detail, this.icon, this.tint, this.color);
  final String label, value, detail; final IconData icon; final Color tint, color;
  @override Widget build(BuildContext context) => Container(padding: const EdgeInsets.all(18), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xffe4e9ed))), child: Row(children: [Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: tint, borderRadius: BorderRadius.circular(9)), child: Icon(icon, color: color)), const SizedBox(width: 13), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [Text(label, style: const TextStyle(color: Color(0xff637786), fontSize: 12)), const SizedBox(height: 3), Text(value, style: const TextStyle(fontSize: 21, fontWeight: FontWeight.w800, color: Color(0xff17324d))), Text(detail, style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.w600))]))]));
}

class _BarChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const sales = [(68.0, '38M'), (98.0, '46M'), (78.0, '41M'), (126.0, '59M')];
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        for (final item in sales)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 11),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(item.$2, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xff31566f))),
                  const SizedBox(height: 6),
                  Container(
                    height: item.$1,
                    decoration: BoxDecoration(
                      color: item.$1 == 126 ? const Color(0xffef8b22) : const Color(0xff75add2),
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(5)),
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

class PartItem {
  // CORRECCIÓN DEFINITIVA: Ponemos la imagen entre llaves con un valor por defecto
  PartItem(this.name, this.sku, this.category, this.stock, this.minimum, this.location, this.status, {this.image = ''});
  
  final String name, sku, category, location, status, image; 
  final int stock, minimum;

  factory PartItem.fromJson(Map<String, dynamic> json) => PartItem(
    json['name'] as String,
    json['sku'] as String,
    json['category'] as String,
    json['stock'] as int,
    json['minimum'] as int,
    json['location'] as String,
    json['status'] as String,
    image: (json['image'] ?? '') as String, // Cambiado a parámetro nombrado
  );
  Map<String, dynamic> toJson() => {
    'name': name,
    'sku': sku,
    'category': category,
    'stock': stock,
    'minimum': minimum,
    'location': location,
    'status': status,
    'image' : image,
  };
}

class Supplier {
  Supplier(this.name, this.code, this.contact, this.email, this.category, this.status);
  final String name, code, contact, email, category, status;

  factory Supplier.fromJson(Map<String, dynamic> json) => Supplier(json['name'] as String, json['code'] as String, json['contact'] as String, json['email'] as String, json['category'] as String, json['status'] as String);
  Map<String, dynamic> toJson() => {'name': name, 'code': code, 'contact': contact, 'email': email, 'category': category, 'status': status};
}

class PurchaseOrder {
  PurchaseOrder(this.code, this.supplier, this.detail, this.units, this.total, this.status, this.expectedDate);
  final String code, supplier, detail, status, expectedDate;
  final int units, total;

  factory PurchaseOrder.fromJson(Map<String, dynamic> json) => PurchaseOrder(json['code'] as String, json['supplier'] as String, json['detail'] as String, json['units'] as int, json['total'] as int, json['status'] as String, json['expectedDate'] as String);
  Map<String, dynamic> toJson() => {'code': code, 'supplier': supplier, 'detail': detail, 'units': units, 'total': total, 'status': status, 'expectedDate': expectedDate};
}

class CustomerTicket {
  CustomerTicket(this.code, this.customer, this.subject, this.priority, this.status, this.updatedAt);
  final String code, customer, subject, priority, status, updatedAt;
  factory CustomerTicket.fromJson(Map<String, dynamic> json) => CustomerTicket(json['code'] as String, json['customer'] as String, json['subject'] as String, json['priority'] as String, json['status'] as String, json['updatedAt'] as String);
  Map<String, dynamic> toJson() => {'code': code, 'customer': customer, 'subject': subject, 'priority': priority, 'status': status, 'updatedAt': updatedAt};
}

class Campaign {
  Campaign(this.code, this.name, this.segment, this.audience, this.status, this.period);
  final String code, name, segment, audience, status, period;
  factory Campaign.fromJson(Map<String, dynamic> json) => Campaign(json['code'] as String, json['name'] as String, json['segment'] as String, json['audience'] as String, json['status'] as String, json['period'] as String);
  Map<String, dynamic> toJson() => {'code': code, 'name': name, 'segment': segment, 'audience': audience, 'status': status, 'period': period};
}

class CartLine {
  CartLine(this.sku, this.name, this.quantity, this.unitPrice);
  final String sku, name;
  int quantity;
  final int unitPrice;
  factory CartLine.fromJson(Map<String, dynamic> json) => CartLine(json['sku'] as String, json['name'] as String, json['quantity'] as int, json['unitPrice'] as int);
  Map<String, dynamic> toJson() => {'sku': sku, 'name': name, 'quantity': quantity, 'unitPrice': unitPrice};
}

class ChatMessage {
  ChatMessage(this.text, this.isUser);
  final String text;
  final bool isUser;
}

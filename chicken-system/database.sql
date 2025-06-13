CREATE DATABASE chicken_system CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE chicken_system;

-- Tabla: Sucursales
CREATE TABLE sucursales (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    direccion TEXT NOT NULL,
    telefono VARCHAR(20),
    estado ENUM('activa', 'inactiva') DEFAULT 'activa',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Tabla: Usuarios
CREATE TABLE users (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    correo VARCHAR(100) UNIQUE NOT NULL,
    telefono VARCHAR(20),
    direccion TEXT,
    password VARCHAR(255) NOT NULL,
    rol ENUM('cliente', 'admin_general', 'admin_local', 'cocinero', 'repartidor', 'cajero') DEFAULT 'cliente',
    sucursal_id BIGINT NULL,
    remember_token VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (sucursal_id) REFERENCES sucursales(id)
);

-- Tabla: Productos
CREATE TABLE productos (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    descripcion TEXT,
    precio DECIMAL(10,2) NOT NULL,
    imagen VARCHAR(255),
    tipo ENUM('pollo', 'bebida', 'guarnicion', 'combo') DEFAULT 'pollo',
    activo BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Tabla: Promociones
CREATE TABLE promociones (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    titulo VARCHAR(100) NOT NULL,
    descripcion TEXT,
    descuento_porcentaje INT CHECK (descuento_porcentaje >= 0 AND descuento_porcentaje <= 100),
    producto_id BIGINT NOT NULL,
    fecha_inicio DATE,
    fecha_fin DATE,
    imagen VARCHAR(255),
    activa BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (producto_id) REFERENCES productos(id)
);

-- Tabla: Pedidos
CREATE TABLE pedidos (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT NOT NULL,
    sucursal_id BIGINT NOT NULL,
    estado ENUM('pendiente', 'cocinando', 'listo', 'entregado', 'cancelado') DEFAULT 'pendiente',
    total DECIMAL(10,2),
    metodo_pago ENUM('efectivo', 'tarjeta', 'yape', 'plin') DEFAULT 'efectivo',
    fecha_pedido DATETIME DEFAULT CURRENT_TIMESTAMP,
    observaciones TEXT,
    direccion_entrega TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (sucursal_id) REFERENCES sucursales(id)
);

-- Tabla: Detalle de pedidos
CREATE TABLE detalle_pedidos (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    pedido_id BIGINT NOT NULL,
    producto_id BIGINT NOT NULL,
    cantidad INT NOT NULL,
    precio_unitario DECIMAL(10,2) NOT NULL,
    subtotal DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (pedido_id) REFERENCES pedidos(id),
    FOREIGN KEY (producto_id) REFERENCES productos(id)
);

-- Tabla: Inventario
CREATE TABLE inventario (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    sucursal_id BIGINT NOT NULL,
    producto_id BIGINT NOT NULL,
    stock_actual INT NOT NULL,
    stock_minimo INT DEFAULT 5,
    fecha_vencimiento DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (sucursal_id) REFERENCES sucursales(id),
    FOREIGN KEY (producto_id) REFERENCES productos(id)
);

-- Tabla: Entregas
CREATE TABLE entregas (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    pedido_id BIGINT NOT NULL,
    repartidor_id BIGINT NOT NULL,
    estado ENUM('en_camino', 'entregado', 'fallido') DEFAULT 'en_camino',
    latitud_entrega DECIMAL(10,6),
    longitud_entrega DECIMAL(10,6),
    fecha_entrega DATETIME,
    FOREIGN KEY (pedido_id) REFERENCES pedidos(id),
    FOREIGN KEY (repartidor_id) REFERENCES users(id)
);

-- Tabla: Auditoría
CREATE TABLE auditorias (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT,
    accion TEXT NOT NULL,
    tabla_afectada VARCHAR(50),
    id_registro BIGINT,
    fecha_accion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id)
);

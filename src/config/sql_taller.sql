drop database evaluacion_docente;

CREATE DATABASE IF NOT EXISTS evaluacion_docente;
USE evaluacion_docente;

-- Tabla Academia
CREATE TABLE Academia (
    academia_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    academia_nombre VARCHAR(100),
    academia_descripcion TEXT,
    academia_activo TINYINT(1) CHECK (academia_activo IN (1, 0)),
    academia_fecha_de_creacion DATE
);

-- Tabla Departamento Académico
CREATE TABLE Departamento_Academico (
    departamento_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    departamento_nombre VARCHAR(100),
    departamento_descripcion TEXT,
    departamento_academia_id INT,
    departamento_fecha_de_creacion DATE,
    departamento_activo TINYINT(1) CHECK (departamento_activo IN (1, 0)),
    FOREIGN KEY (departamento_academia_id) REFERENCES Academia(academia_id)
);

-- Tabla Carreras
CREATE TABLE Carreras(
    carrera_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    carrera_nombre VARCHAR(100),
    carrera_clave VARCHAR(10) UNIQUE
);

-- Tabla Roles
CREATE TABLE Roles (
    rol_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    rol_nombre VARCHAR(50) UNIQUE,
    rol_descripcion TEXT
);

-- Tabla Usuarios (unificada para profesores, estudiantes y administradores)
CREATE TABLE Usuarios (
    usuario_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    usuario_nombres VARCHAR(100),
    usuario_apellido_paterno VARCHAR(50),
    usuario_apellido_materno VARCHAR(50),
    usuario_clave VARCHAR(10) UNIQUE,
    usuario_password VARCHAR(255),
    usuario_fecha_nacimiento DATE,
    usuario_genero ENUM('M', 'F', 'O'),
    usuario_activo TINYINT(1) CHECK (usuario_activo IN (1, 0)),
    usuario_fecha_alta DATE,
    usuario_fecha_baja DATE,
    usuario_rol_id INT,
    usuario_carrera_id INT DEFAULT NULL,
    usuario_academia_id INT DEFAULT NULL,
    usuario_departamento_id INT DEFAULT NULL,
    FOREIGN KEY (usuario_rol_id) REFERENCES Roles(rol_id),
    FOREIGN KEY (usuario_carrera_id) REFERENCES Carreras(carrera_id),
    FOREIGN KEY (usuario_academia_id) REFERENCES Academia(academia_id),
    FOREIGN KEY (usuario_departamento_id) REFERENCES Departamento_Academico(departamento_id)
);

-- Tabla Ciclo Escolar
CREATE TABLE Ciclo_Escolar (
    ciclo_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    ciclo_nombre VARCHAR(50),
    ciclo_inicio DATE,
    ciclo_final DATE,
    ciclo_activo TINYINT(1) CHECK (ciclo_activo IN (1, 0))
);

-- Tabla Grupo
CREATE TABLE Grupo (
    grupo_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    grupo_nombre VARCHAR(50),
    grupo_descripcion TEXT,
    grupo_activo TINYINT(1) CHECK (grupo_activo IN (1, 0)),
    grupo_ciclo_id INT,
    FOREIGN KEY (grupo_ciclo_id) REFERENCES Ciclo_Escolar(ciclo_id)
);

-- Tabla Usuario_Grupo (Asociación entre usuarios y grupos)
CREATE TABLE Usuario_Grupo (
    usuario_grupo_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    usuario_grupo_usuario_id INT,
    usuario_grupo_grupo_id INT,
    FOREIGN KEY (usuario_grupo_usuario_id) REFERENCES Usuarios(usuario_id),
    FOREIGN KEY (usuario_grupo_grupo_id) REFERENCES Grupo(grupo_id)
);

-- Tabla Criterios
CREATE TABLE Criterios (
    criterio_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    criterio_nombre VARCHAR(100),
    criterio_descripcion TEXT,
    criterio_activo TINYINT(1) CHECK (criterio_activo IN (1, 0))
);

-- Tabla Preguntas
CREATE TABLE Preguntas (
    pregunta_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    pregunta_texto VARCHAR(100),
    pregunta_criterio_id INT,
    FOREIGN KEY (pregunta_criterio_id) REFERENCES Criterios(criterio_id)
);

-- Tabla Evaluaciones (almacena una evaluación por grupo para cada profesor)
CREATE TABLE Evaluaciones (
    evaluacion_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    evaluacion_usuario_id INT, -- Profesor evaluado
    evaluacion_grupo_id INT,
    evaluacion_descripcion VARCHAR(50),
    evaluacion_terminada ENUM('NO', 'SI') NOT NULL DEFAULT 'NO',
    FOREIGN KEY (evaluacion_usuario_id) REFERENCES Usuarios(usuario_id),
    FOREIGN KEY (evaluacion_grupo_id) REFERENCES Grupo(grupo_id),
    UNIQUE (evaluacion_usuario_id, evaluacion_grupo_id)
);

-- Tabla Evaluaciones Pendientes
CREATE TABLE Evaluaciones_Pendientes (
    ev_pndt_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    ev_pndt_evaluacion_id INT NOT NULL,
    ev_pndt_usuario_id INT NOT NULL, -- Usuario pendiente de contestar
    ev_pndt_contestada ENUM('SI', 'NO'),
    FOREIGN KEY (ev_pndt_evaluacion_id) REFERENCES Evaluaciones(evaluacion_id),
    FOREIGN KEY (ev_pndt_usuario_id) REFERENCES Usuarios(usuario_id)
);

-- Tabla Resultados (detalles de cada respuesta en las evaluaciones)
CREATE TABLE Resultados (
    resultado_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    resultado_puntaje INT, -- Se usa INT para puntajes numéricos
    resultado_evaluacion_id INT,
    resultado_pregunta_id INT,
    resultado_usuario_id INT, -- Usuario que respondió
    FOREIGN KEY (resultado_pregunta_id) REFERENCES Preguntas(pregunta_id),
    FOREIGN KEY (resultado_evaluacion_id) REFERENCES Evaluaciones(evaluacion_id),
    FOREIGN KEY (resultado_usuario_id) REFERENCES Usuarios(usuario_id)
);

    


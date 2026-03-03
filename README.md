# Reporting Dashboard — Multi-Channel

Dashboard de reporting multi-canal construido con Next.js (App Router), TypeScript, PostgreSQL y shadcn/ui.

## Setup

### 1. Instalar dependencias

```bash
npm install
```

### 2. Configurar base de datos

Crear una base de datos PostgreSQL y ejecutar el script de seed:

```bash
psql -U tu_usuario -d tu_base_de_datos -f database/seed.sql
```

### 3. Configurar variables de entorno

Copiar el archivo de ejemplo y editar con tus credenciales:

```bash
cp .env.local.example .env.local
```

Editar `.env.local` con tu connection string:

```
DATABASE_URL=postgresql://tu_usuario:tu_password@localhost:5432/tu_base_de_datos
```

### 4. Iniciar el servidor de desarrollo

```bash
npm run dev
```

Abrir [http://localhost:3000](http://localhost:3000) para ver la app.

## Arquitectura

### Stack

| Capa | Tecnología |
|------|-----------|
| Framework | Next.js 16 (App Router) |
| Lenguaje | TypeScript |
| Base de datos | PostgreSQL con `pg` (SQL directo) |
| UI | shadcn/ui + Tailwind CSS |

### Estructura del proyecto

```
lib/
  db.ts              → Pool de conexión PostgreSQL
  reporting.ts       → Función de reporting reutilizable + tipos
app/
  page.tsx           → Server component (llama a reporting directamente)
  api/reporting/
    route.ts         → Endpoint REST GET /api/reporting
components/
  dashboard.tsx      → Componente client-side interactivo
  ui/                → Componentes shadcn/ui
```

### Decisiones clave

**SQL directo con `pg`**: Elegí SQL directo en lugar de un ORM para mantener el control total sobre las queries. La query principal usa `generate_series` para generar un rango de fechas y `LEFT JOIN` contra las tres fuentes de datos, lo que maneja correctamente los días sin datos.

**Función de reporting reutilizable**: La misma función `getReport()` se usa tanto en el server component (carga inicial SSR) como en el endpoint API (actualizaciones client-side). Esto garantiza consistencia y evita duplicación de lógica.

**Cálculo de totales desde datos crudos**: Los totales se calculan agregando los valores crudos primero y luego computando las métricas derivadas (CPM, ROAS, etc.) sobre esos agregados. Esto es más preciso que promediar los valores diarios calculados.

**Separación Server/Client**: La página hace server-side rendering con datos por defecto (orgId=1, últimos 30 días, métricas principales). El componente Dashboard maneja toda la interactividad client-side, consultando el endpoint `/api/reporting` cuando el usuario modifica los filtros.

### API

#### `GET /api/reporting`

| Parámetro | Tipo | Requerido | Descripción |
|-----------|------|-----------|-------------|
| `orgId` | number | Sí | ID de la organización |
| `startDate` | string | Sí | Fecha inicio (YYYY-MM-DD) |
| `endDate` | string | Sí | Fecha fin (YYYY-MM-DD) |
| `metrics` | string | Sí | Métricas separadas por coma |

Ejemplo:
```
GET /api/reporting?orgId=1&startDate=2025-01-01&endDate=2025-01-30&metrics=revenue,profit,roas
```

### Métricas disponibles

**Crudas**: `meta_spend`, `meta_impressions`, `google_spend`, `google_impressions`, `revenue`, `orders`, `fees`

**Calculadas**: `meta_cpm`, `google_cpm`, `average_order_value`

**Derivadas**: `total_spend`, `profit`, `roas`

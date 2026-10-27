# EXO-Broker · Backlog de issues

33 issues en 7 milestones. Repo: `gernavarrete/EXO-Broker`.

## M0 · Fundaciones
_Proyecto, base de datos, deploy y CI._

### #1 [Setup] Inicializar proyecto Next.js + TypeScript + Tailwind + shadcn/ui
Labels: `setup`, `prioridad:alta`

## Objetivo
Base del portal EXO-Broker.

## Tareas
- [ ] Next.js (App Router) + TypeScript estricto
- [ ] Tailwind + shadcn/ui, tema con identidad EXO
- [ ] ESLint + Prettier
- [ ] Estructura: `app/(auth)`, `app/(portal)`, `app/admin`, `lib/insurers`, `lib/supabase`, `supabase/migrations`
- [ ] `.env.example` documentado, `README.md` con cómo levantar el proyecto

## Criterios de aceptación
- `npm run dev` y `npm run build` funcionan sin errores

---

### #2 [Setup] Crear proyecto Supabase (sa-east-1) y flujo de migraciones
Labels: `setup`, `prioridad:alta`

## Tareas
- [ ] Proyecto Supabase `exo-broker` en región São Paulo (latencia AR)
- [ ] Supabase CLI: migraciones versionadas en `supabase/migrations`
- [ ] Separar entornos: dev (sandbox de compañías) y prod
- [ ] Generar tipos TypeScript de la base

## Criterios de aceptación
- Las migraciones se aplican desde el repo, no a mano en el dashboard

---

### #3 [Setup] Deploy en Vercel con previews por PR
Labels: `setup`, `prioridad:media`

## Tareas
- [ ] Proyecto Vercel conectado a `main` (producción) y previews por PR
- [ ] Variables de entorno por ambiente (Supabase URL/keys, secretos server-only)
- [ ] Dominio (ej. `portal.exobroker.com.ar`) — a definir

## Criterios de aceptación
- Cada push a `main` despliega; cada PR genera URL de preview

---

### #4 [Setup] CI en GitHub Actions: lint, typecheck, tests y build
Labels: `setup`, `calidad`, `prioridad:media`

## Tareas
- [ ] Workflow en PR: `lint`, `tsc --noEmit`, `test`, `build`
- [ ] Protección de rama `main` (requiere CI verde)

---

## M1 · Acceso y usuarios
_Login con Google, roles admin/productor, ABM de productores._

### #5 [Auth] Login con cuenta de Google (Gmail)
Labels: `auth`, `prioridad:alta`

## Tareas
- [ ] Crear OAuth Client en Google Cloud Console (pantalla de consentimiento, dominios autorizados)
- [ ] Activar provider Google en Supabase Auth
- [ ] Página `/login` con botón "Ingresar con Google", callback `/auth/callback`
- [ ] Middleware que protege todas las rutas del portal; logout
- [ ] Sesión SSR con `@supabase/ssr`

## Criterios de aceptación
- Un usuario no logueado no puede ver ninguna página interna
- Login y logout funcionan en preview y producción

---

### #6 [Auth] Perfil de usuario con ID de productor único
Labels: `auth`, `prioridad:alta`

## Objetivo
Cada usuario tiene su identificador dentro del bróker.

## Tareas
- [ ] Tabla `profiles` (1:1 con `auth.users`): nombre, email, teléfono, CUIT/DNI, rol, estado, `producer_code` interno (ej. `EXO-0001`, secuencial)
- [ ] Trigger que crea el perfil al primer login
- [ ] Página "Mi perfil" para completar datos

## Criterios de aceptación
- Todo usuario tiene un `producer_code` único e inmutable

---

### #7 [Auth] Roles admin / productor y Row Level Security
Labels: `auth`, `seguridad`, `prioridad:alta`

## Reglas
- **Admin** (dueño del bróker): ve y gestiona todo
- **Productor**: ve solo sus pólizas, cotizaciones, clientes y comisiones

## Tareas
- [ ] Columna `role` en `profiles` + helper `is_admin()` en SQL
- [ ] RLS en todas las tablas con políticas por `producer_id = auth.uid()` o admin
- [ ] Protección de rutas `/admin/*` en middleware y server actions
- [ ] Tests de RLS (un productor no puede leer datos de otro)

## Criterios de aceptación
- Advisors de seguridad de Supabase sin alertas de RLS

---

### #8 [Auth] Alta de productores por aprobación del admin
Labels: `auth`, `admin`, `prioridad:alta`

## Objetivo
Que cualquiera con Gmail no pueda entrar y cotizar con la matrícula del bróker.

## Tareas
- [ ] Usuario nuevo queda en estado `pendiente` tras el primer login (pantalla "Tu cuenta está en revisión")
- [ ] Opcional: invitación por email desde el admin (pre-aprobada)
- [ ] Notificación al admin de nuevas solicitudes

## Criterios de aceptación
- Un usuario `pendiente` o `inactivo` no accede a cotizador, pólizas ni comisiones

---

### #9 [Admin] ABM de productores
Labels: `admin`, `prioridad:alta`

## Tareas
- [ ] Listado de productores con estado, fecha de alta, cantidad de pólizas
- [ ] Aprobar / suspender / reactivar
- [ ] Editar datos: CUIT, condición fiscal, CBU/alias para pagos, teléfono
- [ ] Ver detalle: pólizas, cotizaciones y comisiones del productor

---

## M2 · Configuración del bróker
_Compañías, credenciales del bróker y % de retención por uso de matrícula._

### #10 [Admin] Configuración de compañías aseguradoras
Labels: `admin`, `integraciones`, `prioridad:alta`

## Tareas
- [ ] Tabla `insurers`: nombre, slug, logo, activa (sí/no), ambiente (`sandbox`/`produccion`), ramos habilitados
- [ ] Pantalla admin para activar/desactivar compañías sin tocar código
- [ ] Semilla inicial: Mercantil Andina y Federación Patronal

## Criterios de aceptación
- Una compañía desactivada no aparece en el cotizador

---

### #11 [Seguridad] Credenciales del bróker (matrícula del dueño) cifradas y solo server-side
Labels: `seguridad`, `admin`, `integraciones`, `prioridad:alta`

## Contexto
Todas las cotizaciones y consultas a las compañías se hacen **con las credenciales del productor dueño del bróker** (su código PAS / matrícula). Los productores nunca ven ni usan credenciales propias.

## Tareas
- [ ] Guardar credenciales cifradas (Supabase Vault o cifrado AES con clave en env):
  - Mercantil Andina: `subscription key`, `client_id`, usuario, contraseña, código PAS
  - Federación Patronal: `client_id`, `client_secret`, usuario, contraseña, código de productor
- [ ] Pantalla admin para cargarlas/rotarlas (campos write-only: se ven enmascaradas)
- [ ] Solo accesibles desde API routes / server actions; nunca enviadas al navegador
- [ ] Botón "Probar conexión" por compañía (genera token y muestra OK/error)

## Criterios de aceptación
- Ninguna credencial aparece en el bundle del cliente ni en logs

---

### #12 [Comisiones] % de retención por uso de matrícula configurable desde el panel admin
Labels: `comisiones`, `admin`, `prioridad:alta`

## Contexto
El dueño del bróker cobra a cada productor un porcentaje sobre la comisión por trabajar con su matrícula (para cubrir impuestos). Los productores ven su comisión **ya neta** de ese descuento.

## Tareas
- [ ] Tabla `retention_rates`: porcentaje, `vigente_desde`, alcance (`global` o `producer_id`), creado por, fecha
- [ ] Pantalla admin "Retención por matrícula":
  - % global editable
  - Override opcional por productor (ej. condición especial)
  - Historial de cambios con quién y cuándo
- [ ] Función que resuelve el % aplicable a una comisión según productor y fecha
- [ ] Validaciones: entre 0 y 100, con hasta 2 decimales

## Criterios de aceptación
- El admin cambia el % desde la interfaz, sin deploy
- Un cambio rige desde la fecha indicada y **no modifica liquidaciones ya cerradas** (se guarda el % aplicado en cada comisión)
- El productor nunca ve el % ni el monto retenido si así se configura (definir: ¿mostrar desglose o solo neto?)

---

## M3 · Integraciones
_Adapters Mercantil Andina y Federación Patronal._

### #13 [Integraciones] Capa de adapters de aseguradoras
Labels: `integraciones`, `prioridad:alta`

## Objetivo
Una interfaz común para sumar compañías nuevas sin tocar el cotizador.

## Tareas
- [ ] Interfaz `InsurerAdapter`: `getToken()`, `getVehicleCatalog()`, `quoteAuto(input)`, `issuePolicy()` (fase 2), `getPortfolio()`
- [ ] Cache de tokens hasta `expires_in` (en memoria/DB)
- [ ] Timeouts, reintentos y manejo de errores normalizado
- [ ] Log de requests/responses (`insurer_api_logs`) sin datos sensibles
- [ ] Modo mock para desarrollar sin credenciales

## Criterios de aceptación
- Agregar una tercera compañía = crear un adapter nuevo y registrarlo

---

### #14 [Mercantil Andina] Trámite de credenciales de test
Labels: `mercantil-andina`, `tramite`, `prioridad:alta`

## Checklist (según guía de Mercantil Andina)
- [ ] Registrarse en https://apiportal.mercantilandina.com.ar/
- [ ] Suscribirse a productos: **Autenticación**, **Automotores**, **Pólizas**, **Cartera** (y Webhook si se usa)
- [ ] Copiar la *subscription key* desde "Perfil"
- [ ] Enviar solicitud formal con:
  - Código de PAS a vincular (el del dueño del bróker)
  - Nombre del bróker, CUIT, email y teléfono
  - Finalidad: aplicación para uso de PAS / bróker
  - Uso: cotización de autos, emisión de autos, descarga y gestión de cartera
- [ ] Recibir usuario y contraseña de test
- [ ] Bajar la especificación (OpenAPI) de cada producto al repo en `docs/apis/mercantil/`

---

### #15 [Mercantil Andina] Adapter: token, vehículos y cotización auto
Labels: `mercantil-andina`, `integraciones`, `prioridad:alta`

## Autenticación (documentada)
```
POST https://apidev.mercantilandina.com.ar/credenciales/v2/
Content-Type: application/x-www-form-urlencoded
Ocp-Apim-Subscription-Key: <key>
client_id=api-clientes-login&username=<user>&password=<pass>&grant_type=password
```

## Tareas
- [ ] Generar y cachear token
- [ ] Endpoints de vehículos (marcas, modelos, años, versiones)
- [ ] Cotización autos: mapear input normalizado → request Mercantil, response → coberturas normalizadas
- [ ] Tests con respuestas grabadas (fixtures)

## Dependencias
- Trámite de credenciales de test y especificación de endpoints

---

### #16 [Federación Patronal] Trámite de credenciales sandbox y acceso a documentación
Labels: `federacion-patronal`, `tramite`, `prioridad:alta`

## Checklist
- [ ] Solicitar a Federación Patronal `client_id`, `client_secret`, usuario y contraseña de sandbox vinculados al código de productor del bróker
- [ ] Obtener documentación detallada de **Cotización**, **Vehículos** y **Producto** (las páginas de https://api-sandbox.fedpat.com.ar/servicios.html no muestran los endpoints públicamente)
- [ ] Guardar especificación en `docs/apis/fedpat/`

## Nota
Emisión, Póliza, Cliente e Inspección figuran como "Próximamente" en su portal.

---

### #17 [Federación Patronal] Adapter: OAuth2, vehículos, productos y cotizador
Labels: `federacion-patronal`, `integraciones`, `prioridad:alta`

## Autenticación (documentada)
```
POST https://api-sandbox.fedpat.com.ar/oauth/token   (prod: https://api.fedpat.com.ar/oauth/token)
Content-Type: application/x-www-form-urlencoded
Authorization: Basic base64(CLIENT_ID:CLIENT_SECRET)
grant_type=password&username=<user>&password=<pass>
```
Respuesta: `access_token`, `token_type`, `expires_in`, `scope`, `jti`. Uso: `Authorization: Bearer <token>`. Debe hacerse **solo server-side**.

## Tareas
- [ ] Token con cache según `expires_in`
- [ ] Servicio Vehículos
- [ ] Servicio Producto (coberturas, planes, opciones)
- [ ] Servicio Cotización → normalizar respuesta
- [ ] Tests con fixtures

---

### #18 [Integraciones] Normalización de vehículos y coberturas entre compañías
Labels: `integraciones`, `cotizador`, `prioridad:media`

## Tareas
- [ ] Catálogo de vehículos unificado (código InfoAuto como clave común si ambas lo soportan)
- [ ] Homologar coberturas: RC, Terceros completo (B / C / C+ según compañía), Todo riesgo con franquicia
- [ ] Tabla de equivalencias editable por admin

---

## M4 · Cotizador automotor
_Cotización multi-compañía desde un solo portal._

### #19 [Cotizador] Formulario de cotización automotor
Labels: `cotizador`, `prioridad:alta`

## Campos
- Vehículo: marca, modelo, año, versión (autocompletado), 0 km, GNC, uso (particular/comercial)
- Asegurado: código postal / localidad, fecha de nacimiento, tipo de persona (física/jurídica), DNI/CUIT opcional
- Vigencia y forma de pago

## Tareas
- [ ] Formulario con validación (zod) y buscador de vehículos
- [ ] Guardar borrador

---

### #20 [Cotizador] Cotización simultánea en todas las compañías y comparativo
Labels: `cotizador`, `prioridad:alta`

## Tareas
- [ ] Endpoint server que llama a todos los adapters activos en paralelo
- [ ] Si una compañía falla o tarda, se muestran las demás con aviso
- [ ] Tabla comparativa por cobertura: premio, cuota, suma asegurada, franquicia
- [ ] Filtros y orden por precio
- [ ] Rate limiting por usuario

## Criterios de aceptación
- Con 2 compañías activas, el resultado aparece en una sola pantalla

---

### #21 [Cotizador] Historial de cotizaciones y PDF para el cliente
Labels: `cotizador`, `prioridad:media`

## Tareas
- [ ] Tablas `quotes` y `quote_results` asociadas al productor
- [ ] Historial con búsqueda y re-cotizar
- [ ] PDF / link compartible con marca EXO para enviar al cliente (WhatsApp/email)

---

### #22 [Emisión] Formulario de emisión dinámico por compañía
Labels: `cotizador`, `integraciones`, `prioridad:alta`

## Objetivo
Emitir desde el mismo portal, a partir de la cotización elegida, cargando los campos que exige la API de cada compañía.

## Tareas
- [ ] Cada adapter expone un `emissionSchema` (campos, tipos, obligatorios, listas de valores) derivado de la documentación de su API
- [ ] Formulario que se arma dinámicamente según la compañía y cobertura elegidas (datos del tomador/asegurado, domicilio, vehículo: patente, motor, chasis, color; forma de pago: CBU/tarjeta; beneficiario/acreedor prendario)
- [ ] Precarga con los datos ya ingresados en la cotización y en el cliente existente
- [ ] Validación client + server con el mismo schema (zod)
- [ ] Guardar borrador de emisión para completar después

## Criterios de aceptación
- Un campo nuevo requerido por una compañía se agrega en su schema, sin tocar la pantalla

---

### #23 [Emisión] Envío de emisión a la compañía y alta automática en cartera
Labels: `integraciones`, `polizas`, `prioridad:alta`

## Tareas
- [ ] Mercantil Andina: emisión de autos (producto Automotores)
- [ ] Federación Patronal: servicio Emisión (figura "Próximamente" en su portal; dejar el adapter listo)
- [ ] Manejo de respuestas: emitida, pendiente de inspección, rechazada (mostrar motivo)
- [ ] Inspección / autoinspección (Mercantil Inspecciones: link de autoinspección, adjuntar fotos, estado)
- [ ] Descarga de póliza / certificado de cobertura (PDF)
- [ ] Al emitir, crear cliente y póliza en la cartera del productor que cotizó (queda asignada automáticamente)
- [ ] Webhook de Mercantil de emisión de póliza para confirmar el estado

---

## M5 · Pólizas y comisiones
_Cartera por productor, comisiones netas y liquidaciones._

### #24 [Pólizas] Modelo de datos de clientes y pólizas
Labels: `polizas`, `prioridad:alta`

## Tablas
- `clients`: tipo persona, nombre/razón social, DNI/CUIT, contacto, `producer_id`
- `policies`: compañía, número, ramo, vehículo/bien, vigencia desde/hasta, prima, premio, estado (vigente, anulada, vencida, renovada), `producer_id`, origen (API / manual)

## Criterios de aceptación
- RLS: cada productor ve solo sus clientes y pólizas

---

### #25 [Pólizas] Sincronización de cartera desde las compañías + asignación a productores
Labels: `polizas`, `integraciones`, `admin`, `prioridad:alta`

## Contexto
Como todas las pólizas salen con la matrícula del dueño, la compañía no sabe qué productor interno la vendió. Hay que asignarlas.

## Tareas
- [ ] Job programado que descarga cartera (Mercantil: Pólizas/Cartera; Fedpat: cuando esté disponible)
- [ ] Asignación automática si la póliza nació de una cotización del portal
- [ ] Bandeja admin "Pólizas sin asignar" para asignar productor manualmente
- [ ] Importación CSV/Excel para carga manual
- [ ] Webhook de Mercantil (emisión de póliza) como alternativa al job

---

### #26 [Comisiones] Cálculo de comisión por póliza: bruta → retención → neta
Labels: `comisiones`, `prioridad:alta`

## Regla
```
comision_bruta   = la que paga la compañía por la póliza
retencion        = comision_bruta × % de retención vigente (configurado por el admin)
comision_neta    = comision_bruta − retencion   ← lo que ve el productor
```

## Tareas
- [ ] Tabla `commissions`: póliza, productor, período, bruta, `% aplicado` (snapshot), retención, neta, estado (pendiente / liquidada / pagada)
- [ ] Origen de la comisión bruta: API de Cartera (Mercantil) o carga/import manual
- [ ] Recalcular solo comisiones no liquidadas cuando cambia el %
- [ ] Tests unitarios del cálculo (redondeo a 2 decimales)

---

### #27 [Comisiones] Vista del productor: mis pólizas y mis comisiones netas
Labels: `comisiones`, `polizas`, `prioridad:alta`

## Tareas
- [ ] "Mis pólizas": listado con filtros (compañía, estado, vencimiento), detalle por póliza
- [ ] "Mis comisiones": comisión **neta** por póliza, totales por mes y compañía
- [ ] Exportar a Excel
- [ ] Alertas de vencimientos/renovaciones próximas

---

### #28 [Comisiones] Panel admin de liquidaciones
Labels: `comisiones`, `admin`, `prioridad:media`

## Tareas
- [ ] Resumen mensual por productor: bruta, retención, neta
- [ ] Total retenido por el bróker en el período (para impuestos)
- [ ] Cerrar período (congela montos y % aplicado)
- [ ] Marcar como pagado con fecha y comprobante
- [ ] Export Excel / PDF de liquidación por productor

---

### #29 [Dashboard] Inicio del productor y del admin
Labels: `dashboard`, `prioridad:media`

## Productor
- Pólizas vigentes, cotizaciones del mes, comisión neta del mes, próximos vencimientos

## Admin
- Producción por productor y compañía, retención acumulada, pólizas sin asignar, solicitudes de alta pendientes

---

## M6 · Calidad y lanzamiento
_Seguridad, tests, legales y salida a producción._

### #30 [Seguridad] Auditoría y endurecimiento
Labels: `seguridad`, `calidad`, `prioridad:media`

## Tareas
- [ ] `audit_log`: cambios de %, credenciales, roles, asignación de pólizas, liquidaciones
- [ ] Rate limiting en endpoints de cotización
- [ ] Revisar advisors de seguridad y performance de Supabase
- [ ] Headers de seguridad (CSP) en Next.js

---

### #31 [Calidad] Tests unitarios, de integración y e2e
Labels: `calidad`, `prioridad:media`

## Tareas
- [ ] Unit: cálculo de comisiones y resolución del % vigente
- [ ] Integración: adapters con fixtures
- [ ] e2e (Playwright): login → cotizar → ver resultado; productor no ve datos de otro

---

### #32 [Legal] Términos, privacidad y uso de matrícula
Labels: `calidad`, `prioridad:baja`

## Tareas
- [ ] Política de privacidad (Ley 25.326 de Protección de Datos Personales)
- [ ] Términos de uso del portal para productores, incluyendo condiciones del uso de la matrícula y la retención
- [ ] Revisar con contador/abogado

---

### #33 [Lanzamiento] Pase a producción con compañías
Labels: `setup`, `integraciones`, `prioridad:media`

## Tareas
- [ ] Homologación con Mercantil Andina y Federación Patronal (si la exigen)
- [ ] Credenciales productivas cargadas desde el panel admin
- [ ] Cambio de ambiente `sandbox` → `produccion` por compañía
- [ ] Prueba piloto con 1–2 productores

---

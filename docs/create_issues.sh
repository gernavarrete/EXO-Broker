#!/usr/bin/env bash
# Crea labels, milestones e issues en gernavarrete/EXO-Broker (requiere gh autenticado)
set -euo pipefail
REPO="gernavarrete/EXO-Broker"

gh api "repos/$REPO/labels" -f name=setup -f color=6e7781 >/dev/null 2>&1 || true
gh api "repos/$REPO/labels" -f name=auth -f color=1f6feb >/dev/null 2>&1 || true
gh api "repos/$REPO/labels" -f name=admin -f color=8250df >/dev/null 2>&1 || true
gh api "repos/$REPO/labels" -f name=seguridad -f color=cf222e >/dev/null 2>&1 || true
gh api "repos/$REPO/labels" -f name=integraciones -f color=bf8700 >/dev/null 2>&1 || true
gh api "repos/$REPO/labels" -f name=mercantil-andina -f color=0e8a16 >/dev/null 2>&1 || true
gh api "repos/$REPO/labels" -f name=federacion-patronal -f color=005cc5 >/dev/null 2>&1 || true
gh api "repos/$REPO/labels" -f name=cotizador -f color=fb8500 >/dev/null 2>&1 || true
gh api "repos/$REPO/labels" -f name=polizas -f color=1a7f37 >/dev/null 2>&1 || true
gh api "repos/$REPO/labels" -f name=comisiones -f color=d4a72c >/dev/null 2>&1 || true
gh api "repos/$REPO/labels" -f name=dashboard -f color=54aeff >/dev/null 2>&1 || true
gh api "repos/$REPO/labels" -f name=calidad -f color=6639ba >/dev/null 2>&1 || true
gh api "repos/$REPO/labels" -f name=tramite -f color=e99695 >/dev/null 2>&1 || true
gh api "repos/$REPO/labels" -f name=prioridad:alta -f color=b60205 >/dev/null 2>&1 || true
gh api "repos/$REPO/labels" -f name=prioridad:media -f color=fbca04 >/dev/null 2>&1 || true
gh api "repos/$REPO/labels" -f name=prioridad:baja -f color=c2e0c6 >/dev/null 2>&1 || true
gh api "repos/$REPO/labels" -f name=fase-2 -f color=ededed >/dev/null 2>&1 || true

MS0=$(gh api "repos/$REPO/milestones" -f title='M0 · Fundaciones' -f description='Proyecto, base de datos, deploy y CI.' --jq .number 2>/dev/null || gh api "repos/$REPO/milestones?state=all" --jq '.[] | select(.title=="M0 \u00b7 Fundaciones") | .number')
MS1=$(gh api "repos/$REPO/milestones" -f title='M1 · Acceso y usuarios' -f description='Login con Google, roles admin/productor, ABM de productores.' --jq .number 2>/dev/null || gh api "repos/$REPO/milestones?state=all" --jq '.[] | select(.title=="M1 \u00b7 Acceso y usuarios") | .number')
MS2=$(gh api "repos/$REPO/milestones" -f title='M2 · Configuración del bróker' -f description='Compañías, credenciales del bróker y % de retención por uso de matrícula.' --jq .number 2>/dev/null || gh api "repos/$REPO/milestones?state=all" --jq '.[] | select(.title=="M2 \u00b7 Configuraci\u00f3n del br\u00f3ker") | .number')
MS3=$(gh api "repos/$REPO/milestones" -f title='M3 · Integraciones' -f description='Adapters Mercantil Andina y Federación Patronal.' --jq .number 2>/dev/null || gh api "repos/$REPO/milestones?state=all" --jq '.[] | select(.title=="M3 \u00b7 Integraciones") | .number')
MS4=$(gh api "repos/$REPO/milestones" -f title='M4 · Cotizador automotor' -f description='Cotización multi-compañía desde un solo portal.' --jq .number 2>/dev/null || gh api "repos/$REPO/milestones?state=all" --jq '.[] | select(.title=="M4 \u00b7 Cotizador automotor") | .number')
MS5=$(gh api "repos/$REPO/milestones" -f title='M5 · Pólizas y comisiones' -f description='Cartera por productor, comisiones netas y liquidaciones.' --jq .number 2>/dev/null || gh api "repos/$REPO/milestones?state=all" --jq '.[] | select(.title=="M5 \u00b7 P\u00f3lizas y comisiones") | .number')
MS6=$(gh api "repos/$REPO/milestones" -f title='M6 · Calidad y lanzamiento' -f description='Seguridad, tests, legales y salida a producción.' --jq .number 2>/dev/null || gh api "repos/$REPO/milestones?state=all" --jq '.[] | select(.title=="M6 \u00b7 Calidad y lanzamiento") | .number')

gh api "repos/$REPO/issues" -f title='[Setup] Inicializar proyecto Next.js + TypeScript + Tailwind + shadcn/ui' -f body='## Objetivo
Base del portal EXO-Broker.

## Tareas
- [ ] Next.js (App Router) + TypeScript estricto
- [ ] Tailwind + shadcn/ui, tema con identidad EXO
- [ ] ESLint + Prettier
- [ ] Estructura: `app/(auth)`, `app/(portal)`, `app/admin`, `lib/insurers`, `lib/supabase`, `supabase/migrations`
- [ ] `.env.example` documentado, `README.md` con cómo levantar el proyecto

## Criterios de aceptación
- `npm run dev` y `npm run build` funcionan sin errores' -F milestone="$MS0" -f 'labels[]=setup' -f 'labels[]=prioridad:alta' --jq '"#\(.number) \(.title)"'
gh api "repos/$REPO/issues" -f title='[Setup] Crear proyecto Supabase (sa-east-1) y flujo de migraciones' -f body='## Tareas
- [ ] Proyecto Supabase `exo-broker` en región São Paulo (latencia AR)
- [ ] Supabase CLI: migraciones versionadas en `supabase/migrations`
- [ ] Separar entornos: dev (sandbox de compañías) y prod
- [ ] Generar tipos TypeScript de la base

## Criterios de aceptación
- Las migraciones se aplican desde el repo, no a mano en el dashboard' -F milestone="$MS0" -f 'labels[]=setup' -f 'labels[]=prioridad:alta' --jq '"#\(.number) \(.title)"'
gh api "repos/$REPO/issues" -f title='[Setup] Deploy en Vercel con previews por PR' -f body='## Tareas
- [ ] Proyecto Vercel conectado a `main` (producción) y previews por PR
- [ ] Variables de entorno por ambiente (Supabase URL/keys, secretos server-only)
- [ ] Dominio (ej. `portal.exobroker.com.ar`) — a definir

## Criterios de aceptación
- Cada push a `main` despliega; cada PR genera URL de preview' -F milestone="$MS0" -f 'labels[]=setup' -f 'labels[]=prioridad:media' --jq '"#\(.number) \(.title)"'
gh api "repos/$REPO/issues" -f title='[Setup] CI en GitHub Actions: lint, typecheck, tests y build' -f body='## Tareas
- [ ] Workflow en PR: `lint`, `tsc --noEmit`, `test`, `build`
- [ ] Protección de rama `main` (requiere CI verde)' -F milestone="$MS0" -f 'labels[]=setup' -f 'labels[]=calidad' -f 'labels[]=prioridad:media' --jq '"#\(.number) \(.title)"'
gh api "repos/$REPO/issues" -f title='[Auth] Login con cuenta de Google (Gmail)' -f body='## Tareas
- [ ] Crear OAuth Client en Google Cloud Console (pantalla de consentimiento, dominios autorizados)
- [ ] Activar provider Google en Supabase Auth
- [ ] Página `/login` con botón "Ingresar con Google", callback `/auth/callback`
- [ ] Middleware que protege todas las rutas del portal; logout
- [ ] Sesión SSR con `@supabase/ssr`

## Criterios de aceptación
- Un usuario no logueado no puede ver ninguna página interna
- Login y logout funcionan en preview y producción' -F milestone="$MS1" -f 'labels[]=auth' -f 'labels[]=prioridad:alta' --jq '"#\(.number) \(.title)"'
gh api "repos/$REPO/issues" -f title='[Auth] Perfil de usuario con ID de productor único' -f body='## Objetivo
Cada usuario tiene su identificador dentro del bróker.

## Tareas
- [ ] Tabla `profiles` (1:1 con `auth.users`): nombre, email, teléfono, CUIT/DNI, rol, estado, `producer_code` interno (ej. `EXO-0001`, secuencial)
- [ ] Trigger que crea el perfil al primer login
- [ ] Página "Mi perfil" para completar datos

## Criterios de aceptación
- Todo usuario tiene un `producer_code` único e inmutable' -F milestone="$MS1" -f 'labels[]=auth' -f 'labels[]=prioridad:alta' --jq '"#\(.number) \(.title)"'
gh api "repos/$REPO/issues" -f title='[Auth] Roles admin / productor y Row Level Security' -f body='## Reglas
- **Admin** (dueño del bróker): ve y gestiona todo
- **Productor**: ve solo sus pólizas, cotizaciones, clientes y comisiones

## Tareas
- [ ] Columna `role` en `profiles` + helper `is_admin()` en SQL
- [ ] RLS en todas las tablas con políticas por `producer_id = auth.uid()` o admin
- [ ] Protección de rutas `/admin/*` en middleware y server actions
- [ ] Tests de RLS (un productor no puede leer datos de otro)

## Criterios de aceptación
- Advisors de seguridad de Supabase sin alertas de RLS' -F milestone="$MS1" -f 'labels[]=auth' -f 'labels[]=seguridad' -f 'labels[]=prioridad:alta' --jq '"#\(.number) \(.title)"'
gh api "repos/$REPO/issues" -f title='[Auth] Alta de productores por aprobación del admin' -f body='## Objetivo
Que cualquiera con Gmail no pueda entrar y cotizar con la matrícula del bróker.

## Tareas
- [ ] Usuario nuevo queda en estado `pendiente` tras el primer login (pantalla "Tu cuenta está en revisión")
- [ ] Opcional: invitación por email desde el admin (pre-aprobada)
- [ ] Notificación al admin de nuevas solicitudes

## Criterios de aceptación
- Un usuario `pendiente` o `inactivo` no accede a cotizador, pólizas ni comisiones' -F milestone="$MS1" -f 'labels[]=auth' -f 'labels[]=admin' -f 'labels[]=prioridad:alta' --jq '"#\(.number) \(.title)"'
gh api "repos/$REPO/issues" -f title='[Admin] ABM de productores' -f body='## Tareas
- [ ] Listado de productores con estado, fecha de alta, cantidad de pólizas
- [ ] Aprobar / suspender / reactivar
- [ ] Editar datos: CUIT, condición fiscal, CBU/alias para pagos, teléfono
- [ ] Ver detalle: pólizas, cotizaciones y comisiones del productor' -F milestone="$MS1" -f 'labels[]=admin' -f 'labels[]=prioridad:alta' --jq '"#\(.number) \(.title)"'
gh api "repos/$REPO/issues" -f title='[Admin] Configuración de compañías aseguradoras' -f body='## Tareas
- [ ] Tabla `insurers`: nombre, slug, logo, activa (sí/no), ambiente (`sandbox`/`produccion`), ramos habilitados
- [ ] Pantalla admin para activar/desactivar compañías sin tocar código
- [ ] Semilla inicial: Mercantil Andina y Federación Patronal

## Criterios de aceptación
- Una compañía desactivada no aparece en el cotizador' -F milestone="$MS2" -f 'labels[]=admin' -f 'labels[]=integraciones' -f 'labels[]=prioridad:alta' --jq '"#\(.number) \(.title)"'
gh api "repos/$REPO/issues" -f title='[Seguridad] Credenciales del bróker (matrícula del dueño) cifradas y solo server-side' -f body='## Contexto
Todas las cotizaciones y consultas a las compañías se hacen **con las credenciales del productor dueño del bróker** (su código PAS / matrícula). Los productores nunca ven ni usan credenciales propias.

## Tareas
- [ ] Guardar credenciales cifradas (Supabase Vault o cifrado AES con clave en env):
  - Mercantil Andina: `subscription key`, `client_id`, usuario, contraseña, código PAS
  - Federación Patronal: `client_id`, `client_secret`, usuario, contraseña, código de productor
- [ ] Pantalla admin para cargarlas/rotarlas (campos write-only: se ven enmascaradas)
- [ ] Solo accesibles desde API routes / server actions; nunca enviadas al navegador
- [ ] Botón "Probar conexión" por compañía (genera token y muestra OK/error)

## Criterios de aceptación
- Ninguna credencial aparece en el bundle del cliente ni en logs' -F milestone="$MS2" -f 'labels[]=seguridad' -f 'labels[]=admin' -f 'labels[]=integraciones' -f 'labels[]=prioridad:alta' --jq '"#\(.number) \(.title)"'
gh api "repos/$REPO/issues" -f title='[Comisiones] % de retención por uso de matrícula configurable desde el panel admin' -f body='## Contexto
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
- El productor nunca ve el % ni el monto retenido si así se configura (definir: ¿mostrar desglose o solo neto?)' -F milestone="$MS2" -f 'labels[]=comisiones' -f 'labels[]=admin' -f 'labels[]=prioridad:alta' --jq '"#\(.number) \(.title)"'
gh api "repos/$REPO/issues" -f title='[Integraciones] Capa de adapters de aseguradoras' -f body='## Objetivo
Una interfaz común para sumar compañías nuevas sin tocar el cotizador.

## Tareas
- [ ] Interfaz `InsurerAdapter`: `getToken()`, `getVehicleCatalog()`, `quoteAuto(input)`, `issuePolicy()` (fase 2), `getPortfolio()`
- [ ] Cache de tokens hasta `expires_in` (en memoria/DB)
- [ ] Timeouts, reintentos y manejo de errores normalizado
- [ ] Log de requests/responses (`insurer_api_logs`) sin datos sensibles
- [ ] Modo mock para desarrollar sin credenciales

## Criterios de aceptación
- Agregar una tercera compañía = crear un adapter nuevo y registrarlo' -F milestone="$MS3" -f 'labels[]=integraciones' -f 'labels[]=prioridad:alta' --jq '"#\(.number) \(.title)"'
gh api "repos/$REPO/issues" -f title='[Mercantil Andina] Trámite de credenciales de test' -f body='## Checklist (según guía de Mercantil Andina)
- [ ] Registrarse en https://apiportal.mercantilandina.com.ar/
- [ ] Suscribirse a productos: **Autenticación**, **Automotores**, **Pólizas**, **Cartera** (y Webhook si se usa)
- [ ] Copiar la *subscription key* desde "Perfil"
- [ ] Enviar solicitud formal con:
  - Código de PAS a vincular (el del dueño del bróker)
  - Nombre del bróker, CUIT, email y teléfono
  - Finalidad: aplicación para uso de PAS / bróker
  - Uso: cotización de autos, emisión de autos, descarga y gestión de cartera
- [ ] Recibir usuario y contraseña de test
- [ ] Bajar la especificación (OpenAPI) de cada producto al repo en `docs/apis/mercantil/`' -F milestone="$MS3" -f 'labels[]=mercantil-andina' -f 'labels[]=tramite' -f 'labels[]=prioridad:alta' --jq '"#\(.number) \(.title)"'
gh api "repos/$REPO/issues" -f title='[Mercantil Andina] Adapter: token, vehículos y cotización auto' -f body='## Autenticación (documentada)
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
- Trámite de credenciales de test y especificación de endpoints' -F milestone="$MS3" -f 'labels[]=mercantil-andina' -f 'labels[]=integraciones' -f 'labels[]=prioridad:alta' --jq '"#\(.number) \(.title)"'
gh api "repos/$REPO/issues" -f title='[Federación Patronal] Trámite de credenciales sandbox y acceso a documentación' -f body='## Checklist
- [ ] Solicitar a Federación Patronal `client_id`, `client_secret`, usuario y contraseña de sandbox vinculados al código de productor del bróker
- [ ] Obtener documentación detallada de **Cotización**, **Vehículos** y **Producto** (las páginas de https://api-sandbox.fedpat.com.ar/servicios.html no muestran los endpoints públicamente)
- [ ] Guardar especificación en `docs/apis/fedpat/`

## Nota
Emisión, Póliza, Cliente e Inspección figuran como "Próximamente" en su portal.' -F milestone="$MS3" -f 'labels[]=federacion-patronal' -f 'labels[]=tramite' -f 'labels[]=prioridad:alta' --jq '"#\(.number) \(.title)"'
gh api "repos/$REPO/issues" -f title='[Federación Patronal] Adapter: OAuth2, vehículos, productos y cotizador' -f body='## Autenticación (documentada)
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
- [ ] Tests con fixtures' -F milestone="$MS3" -f 'labels[]=federacion-patronal' -f 'labels[]=integraciones' -f 'labels[]=prioridad:alta' --jq '"#\(.number) \(.title)"'
gh api "repos/$REPO/issues" -f title='[Integraciones] Normalización de vehículos y coberturas entre compañías' -f body='## Tareas
- [ ] Catálogo de vehículos unificado (código InfoAuto como clave común si ambas lo soportan)
- [ ] Homologar coberturas: RC, Terceros completo (B / C / C+ según compañía), Todo riesgo con franquicia
- [ ] Tabla de equivalencias editable por admin' -F milestone="$MS3" -f 'labels[]=integraciones' -f 'labels[]=cotizador' -f 'labels[]=prioridad:media' --jq '"#\(.number) \(.title)"'
gh api "repos/$REPO/issues" -f title='[Cotizador] Formulario de cotización automotor' -f body='## Campos
- Vehículo: marca, modelo, año, versión (autocompletado), 0 km, GNC, uso (particular/comercial)
- Asegurado: código postal / localidad, fecha de nacimiento, tipo de persona (física/jurídica), DNI/CUIT opcional
- Vigencia y forma de pago

## Tareas
- [ ] Formulario con validación (zod) y buscador de vehículos
- [ ] Guardar borrador' -F milestone="$MS4" -f 'labels[]=cotizador' -f 'labels[]=prioridad:alta' --jq '"#\(.number) \(.title)"'
gh api "repos/$REPO/issues" -f title='[Cotizador] Cotización simultánea en todas las compañías y comparativo' -f body='## Tareas
- [ ] Endpoint server que llama a todos los adapters activos en paralelo
- [ ] Si una compañía falla o tarda, se muestran las demás con aviso
- [ ] Tabla comparativa por cobertura: premio, cuota, suma asegurada, franquicia
- [ ] Filtros y orden por precio
- [ ] Rate limiting por usuario

## Criterios de aceptación
- Con 2 compañías activas, el resultado aparece en una sola pantalla' -F milestone="$MS4" -f 'labels[]=cotizador' -f 'labels[]=prioridad:alta' --jq '"#\(.number) \(.title)"'
gh api "repos/$REPO/issues" -f title='[Cotizador] Historial de cotizaciones y PDF para el cliente' -f body='## Tareas
- [ ] Tablas `quotes` y `quote_results` asociadas al productor
- [ ] Historial con búsqueda y re-cotizar
- [ ] PDF / link compartible con marca EXO para enviar al cliente (WhatsApp/email)' -F milestone="$MS4" -f 'labels[]=cotizador' -f 'labels[]=prioridad:media' --jq '"#\(.number) \(.title)"'
gh api "repos/$REPO/issues" -f title='[Emisión] Formulario de emisión dinámico por compañía' -f body='## Objetivo
Emitir desde el mismo portal, a partir de la cotización elegida, cargando los campos que exige la API de cada compañía.

## Tareas
- [ ] Cada adapter expone un `emissionSchema` (campos, tipos, obligatorios, listas de valores) derivado de la documentación de su API
- [ ] Formulario que se arma dinámicamente según la compañía y cobertura elegidas (datos del tomador/asegurado, domicilio, vehículo: patente, motor, chasis, color; forma de pago: CBU/tarjeta; beneficiario/acreedor prendario)
- [ ] Precarga con los datos ya ingresados en la cotización y en el cliente existente
- [ ] Validación client + server con el mismo schema (zod)
- [ ] Guardar borrador de emisión para completar después

## Criterios de aceptación
- Un campo nuevo requerido por una compañía se agrega en su schema, sin tocar la pantalla' -F milestone="$MS4" -f 'labels[]=cotizador' -f 'labels[]=integraciones' -f 'labels[]=prioridad:alta' --jq '"#\(.number) \(.title)"'
gh api "repos/$REPO/issues" -f title='[Emisión] Envío de emisión a la compañía y alta automática en cartera' -f body='## Tareas
- [ ] Mercantil Andina: emisión de autos (producto Automotores)
- [ ] Federación Patronal: servicio Emisión (figura "Próximamente" en su portal; dejar el adapter listo)
- [ ] Manejo de respuestas: emitida, pendiente de inspección, rechazada (mostrar motivo)
- [ ] Inspección / autoinspección (Mercantil Inspecciones: link de autoinspección, adjuntar fotos, estado)
- [ ] Descarga de póliza / certificado de cobertura (PDF)
- [ ] Al emitir, crear cliente y póliza en la cartera del productor que cotizó (queda asignada automáticamente)
- [ ] Webhook de Mercantil de emisión de póliza para confirmar el estado' -F milestone="$MS4" -f 'labels[]=integraciones' -f 'labels[]=polizas' -f 'labels[]=prioridad:alta' --jq '"#\(.number) \(.title)"'
gh api "repos/$REPO/issues" -f title='[Pólizas] Modelo de datos de clientes y pólizas' -f body='## Tablas
- `clients`: tipo persona, nombre/razón social, DNI/CUIT, contacto, `producer_id`
- `policies`: compañía, número, ramo, vehículo/bien, vigencia desde/hasta, prima, premio, estado (vigente, anulada, vencida, renovada), `producer_id`, origen (API / manual)

## Criterios de aceptación
- RLS: cada productor ve solo sus clientes y pólizas' -F milestone="$MS5" -f 'labels[]=polizas' -f 'labels[]=prioridad:alta' --jq '"#\(.number) \(.title)"'
gh api "repos/$REPO/issues" -f title='[Pólizas] Sincronización de cartera desde las compañías + asignación a productores' -f body='## Contexto
Como todas las pólizas salen con la matrícula del dueño, la compañía no sabe qué productor interno la vendió. Hay que asignarlas.

## Tareas
- [ ] Job programado que descarga cartera (Mercantil: Pólizas/Cartera; Fedpat: cuando esté disponible)
- [ ] Asignación automática si la póliza nació de una cotización del portal
- [ ] Bandeja admin "Pólizas sin asignar" para asignar productor manualmente
- [ ] Importación CSV/Excel para carga manual
- [ ] Webhook de Mercantil (emisión de póliza) como alternativa al job' -F milestone="$MS5" -f 'labels[]=polizas' -f 'labels[]=integraciones' -f 'labels[]=admin' -f 'labels[]=prioridad:alta' --jq '"#\(.number) \(.title)"'
gh api "repos/$REPO/issues" -f title='[Comisiones] Cálculo de comisión por póliza: bruta → retención → neta' -f body='## Regla
```
comision_bruta   = la que paga la compañía por la póliza
retencion        = comision_bruta × % de retención vigente (configurado por el admin)
comision_neta    = comision_bruta − retencion   ← lo que ve el productor
```

## Tareas
- [ ] Tabla `commissions`: póliza, productor, período, bruta, `% aplicado` (snapshot), retención, neta, estado (pendiente / liquidada / pagada)
- [ ] Origen de la comisión bruta: API de Cartera (Mercantil) o carga/import manual
- [ ] Recalcular solo comisiones no liquidadas cuando cambia el %
- [ ] Tests unitarios del cálculo (redondeo a 2 decimales)' -F milestone="$MS5" -f 'labels[]=comisiones' -f 'labels[]=prioridad:alta' --jq '"#\(.number) \(.title)"'
gh api "repos/$REPO/issues" -f title='[Comisiones] Vista del productor: mis pólizas y mis comisiones netas' -f body='## Tareas
- [ ] "Mis pólizas": listado con filtros (compañía, estado, vencimiento), detalle por póliza
- [ ] "Mis comisiones": comisión **neta** por póliza, totales por mes y compañía
- [ ] Exportar a Excel
- [ ] Alertas de vencimientos/renovaciones próximas' -F milestone="$MS5" -f 'labels[]=comisiones' -f 'labels[]=polizas' -f 'labels[]=prioridad:alta' --jq '"#\(.number) \(.title)"'
gh api "repos/$REPO/issues" -f title='[Comisiones] Panel admin de liquidaciones' -f body='## Tareas
- [ ] Resumen mensual por productor: bruta, retención, neta
- [ ] Total retenido por el bróker en el período (para impuestos)
- [ ] Cerrar período (congela montos y % aplicado)
- [ ] Marcar como pagado con fecha y comprobante
- [ ] Export Excel / PDF de liquidación por productor' -F milestone="$MS5" -f 'labels[]=comisiones' -f 'labels[]=admin' -f 'labels[]=prioridad:media' --jq '"#\(.number) \(.title)"'
gh api "repos/$REPO/issues" -f title='[Dashboard] Inicio del productor y del admin' -f body='## Productor
- Pólizas vigentes, cotizaciones del mes, comisión neta del mes, próximos vencimientos

## Admin
- Producción por productor y compañía, retención acumulada, pólizas sin asignar, solicitudes de alta pendientes' -F milestone="$MS5" -f 'labels[]=dashboard' -f 'labels[]=prioridad:media' --jq '"#\(.number) \(.title)"'
gh api "repos/$REPO/issues" -f title='[Seguridad] Auditoría y endurecimiento' -f body='## Tareas
- [ ] `audit_log`: cambios de %, credenciales, roles, asignación de pólizas, liquidaciones
- [ ] Rate limiting en endpoints de cotización
- [ ] Revisar advisors de seguridad y performance de Supabase
- [ ] Headers de seguridad (CSP) en Next.js' -F milestone="$MS6" -f 'labels[]=seguridad' -f 'labels[]=calidad' -f 'labels[]=prioridad:media' --jq '"#\(.number) \(.title)"'
gh api "repos/$REPO/issues" -f title='[Calidad] Tests unitarios, de integración y e2e' -f body='## Tareas
- [ ] Unit: cálculo de comisiones y resolución del % vigente
- [ ] Integración: adapters con fixtures
- [ ] e2e (Playwright): login → cotizar → ver resultado; productor no ve datos de otro' -F milestone="$MS6" -f 'labels[]=calidad' -f 'labels[]=prioridad:media' --jq '"#\(.number) \(.title)"'
gh api "repos/$REPO/issues" -f title='[Legal] Términos, privacidad y uso de matrícula' -f body='## Tareas
- [ ] Política de privacidad (Ley 25.326 de Protección de Datos Personales)
- [ ] Términos de uso del portal para productores, incluyendo condiciones del uso de la matrícula y la retención
- [ ] Revisar con contador/abogado' -F milestone="$MS6" -f 'labels[]=calidad' -f 'labels[]=prioridad:baja' --jq '"#\(.number) \(.title)"'
gh api "repos/$REPO/issues" -f title='[Lanzamiento] Pase a producción con compañías' -f body='## Tareas
- [ ] Homologación con Mercantil Andina y Federación Patronal (si la exigen)
- [ ] Credenciales productivas cargadas desde el panel admin
- [ ] Cambio de ambiente `sandbox` → `produccion` por compañía
- [ ] Prueba piloto con 1–2 productores' -F milestone="$MS6" -f 'labels[]=setup' -f 'labels[]=integraciones' -f 'labels[]=prioridad:media' --jq '"#\(.number) \(.title)"'

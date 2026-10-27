# EXO Broker

Portal web para el productor asesor de seguros EXO Broker. Los productores trabajan bajo la matrícula del titular (PAS) y desde el portal podrán cotizar en varias compañías, emitir pólizas y consultar sus comisiones.

Estado actual: base del proyecto (milestone M0). El backlog completo está en [`docs/BACKLOG.md`](docs/BACKLOG.md).

## Stack

- Next.js (App Router) + React + TypeScript estricto
- Tailwind CSS + shadcn/ui (tema "EXO": azul marino corporativo, claro y oscuro)
- zod + react-hook-form para formularios y validaciones
- ESLint + Prettier (con `prettier-plugin-tailwindcss`)
- Vitest + Testing Library para tests
- A futuro: Supabase (Auth con Google, Postgres + RLS) y adaptadores de aseguradoras

## Requisitos

- Node.js 24 (ver `.nvmrc`; mínimo soportado por Next: 20.9)
- npm

## Cómo levantar el proyecto

```bash
nvm use                      # usa la versión de .nvmrc
npm install
cp .env.example .env.local   # completá los valores cuando corresponda
npm run dev                  # http://localhost:3000
```

Por ahora no hace falta completar ninguna variable para correr el proyecto.

## Scripts

| Script                 | Descripción                                |
| ---------------------- | ------------------------------------------ |
| `npm run dev`          | Servidor de desarrollo                     |
| `npm run build`        | Build de producción                        |
| `npm start`            | Sirve el build de producción               |
| `npm run lint`         | ESLint                                     |
| `npm run typecheck`    | Chequeo de tipos (`tsc --noEmit`)          |
| `npm test`             | Tests (Vitest, una sola corrida)           |
| `npm run test:watch`   | Tests en modo watch                        |
| `npm run format`       | Formatea el código con Prettier            |
| `npm run format:check` | Verifica el formato sin modificar archivos |

## Estructura de carpetas

```
app/
  (auth)/            # rutas públicas de autenticación (login)
  (portal)/          # portal de productores (requiere sesión)
  admin/             # administración (solo titular)
components/
  ui/                # componentes de shadcn/ui
lib/
  insurers/          # adaptadores de aseguradoras (Mercantil Andina, Federación Patronal, Mock)
  supabase/          # clientes de Supabase (browser / server)
  utils.ts           # helper `cn`
supabase/
  migrations/        # migraciones SQL
tests/               # setup de Vitest
docs/                # backlog y specs de APIs de aseguradoras
```

## Variables de entorno

Ver [`.env.example`](.env.example). Las variables marcadas como `SERVER-ONLY` nunca deben exponerse al navegador ni commitearse. Los archivos `.env*.local` están ignorados por git.

## Convenciones

- Commits con [Conventional Commits](https://www.conventionalcommits.org/), en español.
- Código, identificadores y comentarios en inglés; textos de interfaz en español (es-AR).

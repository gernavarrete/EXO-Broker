import Link from "next/link";
import { Button } from "@/components/ui/button";

export default function Home() {
  return (
    <main className="flex flex-1 flex-col items-center justify-center gap-8 px-6 py-24 text-center">
      <span className="text-sm font-semibold tracking-[0.3em] text-accent uppercase">
        EXO Broker
      </span>
      <h1 className="max-w-2xl text-4xl font-semibold tracking-tight text-balance text-primary sm:text-5xl">
        Tu cartera de seguros, en un solo lugar
      </h1>
      <p className="max-w-xl text-lg text-balance text-muted-foreground">
        Cotizá en varias compañías, emití pólizas y seguí tus comisiones desde
        el portal de productores.
      </p>
      <div className="flex flex-col gap-3 sm:flex-row">
        <Button asChild size="lg">
          <Link href="/login">Ingresar</Link>
        </Button>
        <Button asChild size="lg" variant="outline">
          <Link href="/dashboard">Ir al portal</Link>
        </Button>
      </div>
    </main>
  );
}

import { render, screen } from "@testing-library/react";
import { describe, expect, it } from "vitest";
import { PagePlaceholder } from "@/components/page-placeholder";

describe("PagePlaceholder", () => {
  it("renders the title, description and a link back home", () => {
    render(<PagePlaceholder title="Ingresar" description="Próximamente" />);

    expect(screen.getByText("Ingresar")).toBeInTheDocument();
    expect(screen.getByText("Próximamente")).toBeInTheDocument();
    expect(
      screen.getByRole("link", { name: "Volver al inicio" }),
    ).toHaveAttribute("href", "/");
  });
});

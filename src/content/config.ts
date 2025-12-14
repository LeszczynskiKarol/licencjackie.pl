// src/content/config.ts
import { defineCollection, z } from "astro:content";

const blogCollection = defineCollection({
  type: "content",
  schema: z.object({
    title: z.string(),
    description: z.string(),
    publishDate: z.date(),
    updateDate: z.date().optional(),
    author: z.string().default("Redakcja Licencjackie.pl"),
    category: z.enum([
      "Poradniki",
      "Struktura pracy",
      "Metodologia",
      "Tematy prac licencjackich",
      "Tematy prac magisterskich",
      "Obrona pracy",
      "Pisanie prac z pedagogiki",
      "Pisanie prac z psychologii",
      "Pisanie prac z prawa",
      "Pisanie prac z administracji",
      "Pisanie prac z historii",
      "Pisanie prac z pielęgniarstwa",
      "Pisanie prac z zarządzania",
      "Pisanie prac z marketingu",
      "Pisanie prac z logistyki",
      "Pisanie prac z socjologii",
      "Pisanie prac z kryminologii",
      "Pisanie prac z turystyki",
      "Pisanie prac z kosmetologii",
      "Pisanie prac z dietetyki",
      "Pisanie prac z ratownictwa medycznego",
      "Pisanie prac z politologii",
      "Pisanie prac z geografii",
      "Pisanie prac z bezpieczeństwa wewnętrznego",
    ]),
    tags: z.array(z.string()).default([]),
    image: z.string().optional(),
    imageAlt: z.string().optional(),
    featured: z.boolean().default(false),
    draft: z.boolean().default(false),
    // Specjalne pola dla prac akademickich
    kierunek: z.string().optional(),
    typ_pracy: z
      .enum(["licencjacka", "magisterska", "inżynierska", "doktorska"])
      .optional(),
    // CTA do Smart-Edu
    showSmartEduCTA: z.boolean().default(true),
  }),
});

export const collections = {
  blog: blogCollection,
};

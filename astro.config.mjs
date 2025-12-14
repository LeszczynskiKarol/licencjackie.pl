import { defineConfig } from 'astro/config';
import tailwind from '@astrojs/tailwind';

export default defineConfig({
  site: 'https://licencjackie.pl',
  integrations: [tailwind()],
  output: 'static',
});

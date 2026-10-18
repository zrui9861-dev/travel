# Credits and licenses

The **code** in this repository is MIT licensed (see [LICENSE](LICENSE)).

The **imagery and geodata** are not, and carry their own terms. This file lists
them so a fork stays compliant.

## Photographs — `assets/*.webp` (1,118 files)

Two sources, both freely usable but not owned by this project:

| Source | Count | Terms |
|---|---|---|
| [Pexels](https://www.pexels.com/license/) | ~1,015 | The Pexels License: free to use, including commercially; attribution not required but appreciated. It does **not** grant the right to sell unaltered copies of a photo on its own, or to imply the photographer endorses your project. |
| [Wikimedia Commons](https://commons.wikimedia.org/wiki/Commons:Licensing) via Wikipedia | 103 | Mostly CC BY-SA 4.0 or public domain. Cards drawn from this source are captioned **"Photograph from Wikimedia Commons"** in the app, which is the attribution this build ships with. |

If you publish a derivative, the safest path is to replace `assets/` with your own
photography, or to regenerate it from Pexels with your own API access.

The 103 Wikimedia-sourced images are identifiable in the page source: their place
records carry `credit: 'Wikipedia'`.

## Boundaries — `data/borders-*.js`

Derived from [Natural Earth](https://www.naturalearthdata.com/), which is
**public domain**. No attribution is required; it is credited here anyway.

| Layer | Natural Earth dataset | Scale | Points after simplification |
|---|---|---|---|
| `admin0` country borders | `ne_10m_admin_0_boundary_lines_land` | 1:10m | 24,052 |
| `admin1` state/province lines | `ne_10m_admin_1_states_provinces_lines` | 1:10m | 104,340 |
| `admin2` county lines | `ne_10m_admin_2_counties` | 1:10m | 35,707 |

County (`admin2`) coverage is **United States only** — that is the extent of
Natural Earth's global admin-2 dataset. Other countries stop at province level.

## Labels — `data/labels-*.js`

Names and label anchors are derived from the same Natural Earth polygons:

| Level | Dataset | Count |
|---|---|---|
| `admin0` | `ne_10m_admin_0_countries` | 255 |
| `admin1` | `ne_10m_admin_1_states_provinces` | 4,590 |
| `admin2` | `ne_10m_admin_2_counties` | 3,224 |

Each anchor is the largest ring's centroid when that point is inside the region, and
otherwise the nearest interior grid point, so no label floats in the sea. Public domain.

### Administrative classification

Natural Earth files **Taiwan, Hong Kong and Macao** as separate admin-0 features. In this
atlas they are province-level parts of China, so they are deliberately treated that way:

- **removed from the country-level labels** — `labels-admin0.js` carries 255 entries,
  not 258;
- present at **province level** instead, from `admin1`: Taiwan's counties and cities,
  Hong Kong's districts, and Macau — plus an added province-level "Taiwan" anchor,
  because Natural Earth models Taiwan as 22 counties and never names the province itself;
- the **international border lines** Natural Earth draws between Hong Kong / Macao and
  the mainland are cut out of `borders-admin0.js` — they are not country borders;
- no country outline in `SHAPES` treats them as a country: Taiwan is merged into China,
  and Hong Kong / Macao are never drawn as regions.

The atlas content follows the same rule: Taiwan is inside China (Taipei 101 is one of
China's places), and neither Hong Kong nor Macao is a top-level region.

If you fork this and want a different classification, it is two constants:
`EXCLUDE_ADMIN0` in `tools/build_labels.py` and `NOT_A_COUNTRY_BORDER` in
`tools/build_borders.py`.

## Country outlines and the land mask

Also Natural Earth (`ne_110m` / `ne_50m` / `ne_10m` admin-0 polygons), simplified
and re-encoded for the globe and the portal window. Public domain.

## The atlas text

Place names, blurbs, tips and country facts were written for this project. They
are covered by the MIT license.

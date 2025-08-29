# Setlog files

This folder contains setlog sources used across the project.
- The original `setlog.pl` is split into two variants: `setlog_linprog.pl` and `setlog_clpq.pl` versions. The only difference between them is the library (`clpq` / `linprog`) they are using.

- Compilation scripts rename the selected variant back to `setlog.pl` during build.

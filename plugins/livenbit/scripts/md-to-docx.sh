#!/bin/bash
# Converte un contratto Markdown in .docx, trovando da solo l'interprete.
#
# Esiste perche' su Windows `python3` e `python` sono quasi sempre i
# segnaposto del Microsoft Store: esistono nel PATH, quindi `command -v` li
# trova, ma eseguiti stampano un invito a installare Python ed escono 49.
# L'unico comando che funziona li' e' `py`. Scrivere `python3` nella skill
# significava, su quelle macchine, non produrre nessun documento.
#
# Uso:  md-to-docx.sh <input.md> <output.docx>
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

for cmd in python3 python py; do
  command -v "$cmd" >/dev/null 2>&1 || continue
  # Non basta che esista: deve essere un Python 3 davvero eseguibile.
  "$cmd" -c 'import sys; sys.exit(0 if sys.version_info >= (3, 8) else 1)' \
    >/dev/null 2>&1 || continue
  exec "$cmd" "$DIR/md-to-docx.py" "$@"
done

echo "Nessun Python 3.8+ eseguibile trovato: provati python3, python, py." >&2
echo "  Su Windows installalo dal sito python.org, non dal Microsoft Store." >&2
exit 1

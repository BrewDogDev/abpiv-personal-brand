#!/usr/bin/env python3
"""Require a bootstrap plan to contain an IAM action, a state move, or both."""

from __future__ import annotations

import argparse
import sys
from pathlib import Path


def evidence_lines(path: Path) -> list[str]:
    return [line for line in path.read_text(encoding="utf-8").splitlines() if line]


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("actions_manifest", type=Path)
    parser.add_argument("moves_manifest", type=Path)
    args = parser.parse_args()

    actions = evidence_lines(args.actions_manifest)
    moves = evidence_lines(args.moves_manifest)
    if not actions and not moves:
        print("Bootstrap plan contains neither resource actions nor state-address moves.", file=sys.stderr)
        return 1

    print(f"Bootstrap evidence contains {len(actions)} action(s) and {len(moves)} state move(s).")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())

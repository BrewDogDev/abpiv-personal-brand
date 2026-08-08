from __future__ import annotations

import subprocess
import sys
import tempfile
import unittest
from pathlib import Path


REPOSITORY_ROOT = Path(__file__).resolve().parents[3]
SCRIPT = REPOSITORY_ROOT / "infra" / "n8n" / "tools" / "assert-bootstrap-evidence.py"


class BootstrapEvidenceTests(unittest.TestCase):
    def run_evidence(
        self, actions: list[str], moves: list[str]
    ) -> subprocess.CompletedProcess[str]:
        with tempfile.TemporaryDirectory() as temporary_directory:
            root = Path(temporary_directory)
            actions_path = root / "actions.txt"
            moves_path = root / "moves.txt"
            actions_path.write_text("\n".join(actions) + ("\n" if actions else ""), encoding="utf-8")
            moves_path.write_text("\n".join(moves) + ("\n" if moves else ""), encoding="utf-8")
            return subprocess.run(
                [sys.executable, str(SCRIPT), str(actions_path), str(moves_path)],
                check=False,
                capture_output=True,
                text=True,
            )

    def test_accepts_initial_and_partial_recovery_evidence(self) -> None:
        cases = {
            "create_and_move": (["create google_service_account.n8n_compute"], ["old -> new"]),
            "create_only": (["create google_service_account.n8n_compute"], []),
            "move_only": ([], ["old -> new"]),
        }
        for name, (actions, moves) in cases.items():
            with self.subTest(name=name):
                result = self.run_evidence(actions, moves)
                self.assertEqual(result.returncode, 0, result.stderr)

    def test_rejects_empty_action_and_move_evidence(self) -> None:
        result = self.run_evidence([], [])
        self.assertNotEqual(result.returncode, 0)


if __name__ == "__main__":
    unittest.main()

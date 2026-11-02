"""Guard the real userspace-tunnel dependency contract without an iPhone."""

import inspect
import unittest
from importlib.metadata import version

from packaging.specifiers import SpecifierSet
from pmd_pytcp import stack
from pmd_pytcp.socket.tcp__socket import TcpSocket
from pmd_pytcp.socket.udp__socket import UdpSocket


class DependencyCompatibilityTests(unittest.TestCase):
    def test_installed_backend_versions_are_compatible(self):
        for package, supported in (
            ("pymobiledevice3", "==9.31.0"),
            ("pmd-pytcp", ">=0.0.4,<0.1.0"),
        ):
            with self.subTest(package=package):
                installed = version(package)
                self.assertIn(
                    installed,
                    SpecifierSet(supported),
                    f"{package} {installed} is incompatible; install {package}{supported}",
                )

    def test_userspace_tunnel_dependencies_have_synchronous_api(self):
        # pymobiledevice3 9.31.0 calls these functions directly or in a thread.
        # Async replacements return unawaited coroutines and can flood its queue.
        for owner, methods in (
            (stack, ("start", "stop")),
            (TcpSocket, ("connect", "send", "recv", "close")),
            (UdpSocket, ("recv", "sendto", "close")),
        ):
            for name in methods:
                with self.subTest(owner=owner.__name__, method=name):
                    self.assertFalse(
                        inspect.iscoroutinefunction(getattr(owner, name)),
                        f"{owner.__name__}.{name} must be synchronous for pymobiledevice3 9.31.0",
                    )


if __name__ == "__main__":
    unittest.main()

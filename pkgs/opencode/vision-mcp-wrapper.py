#!/usr/bin/env python3
"""opencode-vision MCP wrapper (vendored wrapper around opencode-vision 2.1.0).

opencode-vision hand-rolls the LEGACY MCP transport (Content-Length framed
JSON-RPC) and answers `initialize` with protocolVersion "0.1.0". OpenCode and
current MCP SDKs use NEWLINE-delimited JSON-RPC and only accept dated protocol
versions (e.g. 2024-11-05), so the bundled server hangs forever on negotiate
-> "MCP error -32001: Request timed out".

This wrapper overrides the transport layer + initialize response before main()
starts. Run through uvx --from 'opencode-vision[paddle]==2.1.0'.

Keep in sync when bumping opencode-vision. Patch targets:
  - opencode_vision.mcp.recv / send  (newline framing)
  - opencode_vision.server.METHOD_HANDLERS["initialize"]  (protocolVersion)
  - opencode_vision.gemini.GEMINI_MODEL  (gemini-2.5-flash retired -> 3.6-flash)
"""

import json
import logging
import sys

from opencode_vision.server import METHOD_HANDLERS, main

log = logging.getLogger(__name__)


def recv_newline():
    """Read one newline-delimited JSON-RPC message from stdin (current MCP spec)."""
    try:
        line = sys.stdin.buffer.readline()
        if not line:
            return None
        line = line.strip()
        if not line:
            return None
        msg = json.loads(line.decode("utf-8"))
        return msg if isinstance(msg, dict) else None
    except json.JSONDecodeError:
        return None
    except Exception as e:
        log.error("recv_newline error: %s", e)
        return None


def send_newline(msg: dict) -> None:
    """Write one newline-delimited JSON-RPC message to stdout (current MCP spec)."""
    try:
        sys.stdout.write(json.dumps(msg, ensure_ascii=False, default=str) + "\n")
        sys.stdout.flush()
    except Exception as e:
        log.error("send_newline failed: %s", e)


def _patched_initialize(msg):
    return {
        "jsonrpc": "2.0",
        "id": msg["id"],
        "result": {
            "protocolVersion": "2024-11-05",
            "serverInfo": {"name": "opencode-vision-server", "version": "2.0.0"},
            "capabilities": {"tools": {}},
        },
    }


METHOD_HANDLERS["initialize"] = _patched_initialize

from opencode_vision import mcp as vision_mcp

vision_mcp.recv = recv_newline
vision_mcp.send = send_newline

from opencode_vision import gemini as vision_gemini

# Google retired gemini-2.5-flash for new users (HTTP 404) -> move to
# gemini-3.6-flash for the OCR/description fallback endpoint.
vision_gemini.GEMINI_MODEL = "gemini-3.6-flash"

main()
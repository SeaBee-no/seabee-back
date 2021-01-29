import logging
import os
from pathlib import Path

import uvicorn
from dotenv import load_dotenv
from starlette_prometheus import PrometheusMiddleware, metrics
from nivacloud_logging.log_utils import setup_logging

if __name__ == "__main__":
    setup_logging(plaintext=True)
    port = 5000
    if os.environ.get("NIVA_ENVIRONMENT") not in ["dev", "main"]:
        if Path.cwd() == Path("/app"):
            env_file = Path(__file__).parents[1] / "config" / "localdocker.env"
        else:
            env_file = Path(__file__).parents[1] / "config" / "localdev.env"
            port = 9701
        load_dotenv(dotenv_path=env_file, verbose=True)
        load_dotenv(dotenv_path=Path(__file__).parents[1] / "config" / "secrets.env", verbose=True)

    from seabee_back.app import app

    app.add_middleware(PrometheusMiddleware)
    app.add_route("/metrics/", metrics)

    uvicorn.run(app, host="0.0.0.0", port=port, log_level=logging.INFO, access_log=False)

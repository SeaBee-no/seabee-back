import os
import logging

import asyncpg
from fastapi import FastAPI, Depends
from minio import Minio

app = FastAPI(docs_url="/", title="SEABEE API", version="v1")


class ApiPoolManager:
    def __init__(self):
        self.pool = None  # Optional[asyncpg.pool.Pool]

    async def get_conn(self) -> asyncpg.connection.Connection:
        async with self.pool.acquire() as connection:
            yield connection


api_pool_manager = ApiPoolManager()
client = Minio("seabee-buckets.seabee.sigma2.no",
               os.environ["MINIO_SEABEE_ACCESS_TOKEN"],
               os.environ["MINIO_SEABEE_SECRET"])


@app.on_event("startup")
async def startup_event():
    # TODO: This can run before the database is ready, it should actually be lazily tried on the first connection
    # Get DB connection from environment
    db_host = os.environ["SEABEE_DB_SERVICE_HOST"]
    db_port = os.environ["SEABEE_DB_SERVICE_PORT"]
    # TODO: figure out how to add a lower privilge user in flyway
    # db_user = os.environ["SEABEE_DB_USER"]
    # db_pwd = os.environ["SEABEE_DB_PASSWORD"]
    # db_name = os.environ["SEABEE_DB"]
    db_user = os.environ["POSTGRES_USER"]
    db_pwd = os.environ["POSTGRES_PASSWORD"]
    db_name = os.environ["POSTGRES_DB"]
    logging.info("Creating connection pool")

    api_pool_manager.pool = await asyncpg.create_pool(
        user=db_user,
        password=db_pwd,
        # server_settings={"search_path": "seabee,public"},
        host=db_host,
        port=db_port,
        database=db_name,
    )
    logging.info("Successfully created connection pool")


    objects = client.list_objects("calibrations")
    for obj in objects:
        logging.info(obj)
    logging.info("Successfully created Minio Client")


@app.on_event("shutdown")
async def shutdown_event():
    logging.info("Closing connection pool")
    await api_pool_manager.pool.close()
    logging.info("Successfully closed connection pool")


@app.get("/")
async def root():
    return {"message": "Hello World"}


@app.get("/images")
async def root(connection=Depends(api_pool_manager.get_conn)):
    images_rows = await connection.fetch(
        "SELECT * FROM images"
    )

    return [item for item in images_rows]


@app.get("/upload_image")
async def root(path: str, connection=Depends(api_pool_manager.get_conn)):
    await connection.fetchrow(
        "INSERT into images (mission_id, external_path) VALUES (1, $1)",
        path
    )
    # The URL is an endpoint for a PUT request with the http body containing the file.
    url = client.presigned_put_object('camera-images', path)
    return url


@app.get("/confirm_image_upload")
async def root(path: str, connection=Depends(api_pool_manager.get_conn)):
    await connection.fetchrow(
        "UPDATE images SET uploaded=TRUE where external_path like $1",
        path
    )

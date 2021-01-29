FROM flyway/flyway:7.5-alpine

ENV FLYWAY_DRIVER=org.postgresql.Driver
ENV FLYWAY_CONNECT_RETRIES=50

COPY sql /flyway/sql

CMD ["migrate"]
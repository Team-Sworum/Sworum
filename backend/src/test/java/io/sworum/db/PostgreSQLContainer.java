package io.sworum.db;

import org.flywaydb.core.Flyway;

public class PostgreSQLContainer extends org.testcontainers.containers.PostgreSQLContainer<PostgreSQLContainer> {
    public static final PostgreSQLContainer INSTANCE = new PostgreSQLContainer();

    static {
        INSTANCE.start();
        Flyway.configure()
                .dataSource(INSTANCE.getJdbcUrl(), INSTANCE.getUsername(), INSTANCE.getPassword())
                .load()
                .migrate();
    }
    private PostgreSQLContainer() {
        super("postgres:13");
    }
}
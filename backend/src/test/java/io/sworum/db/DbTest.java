package io.sworum.db;

import org.junit.Test;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertTrue;

public class DbTest {
    @Test
    public void connect() throws Exception {
        try (Connection c = PostgreSQLContainer.INSTANCE.createConnection("");
             Statement stmt = c.createStatement();
             ResultSet rs = stmt.executeQuery("SELECT 1")) {
            assertTrue(rs.next());
            assertEquals(1, rs.getInt(1));
        }
    }
}

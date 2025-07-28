package database;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.sql.Connection;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class DatabaseSetup {
    
    public static void initializeDatabase() {
        try (Connection conn = DBUtil.getConnection()) {
            System.out.println("Setting up database schema and sample data...");
            
            // Read and execute schema.sql
            executeSqlFile(conn, "sql/schema.sql");
            
            System.out.println("Database setup completed successfully!");
            
        } catch (Exception e) {
            System.err.println("Error setting up database: " + e.getMessage());
            e.printStackTrace();
        }
    }
    
    private static void executeSqlFile(Connection conn, String resourcePath) throws Exception {
        try (InputStream is = DatabaseSetup.class.getClassLoader().getResourceAsStream(resourcePath)) {
            if (is == null) {
                throw new RuntimeException("Could not find SQL file: " + resourcePath);
            }
            
            try (BufferedReader reader = new BufferedReader(new InputStreamReader(is))) {
                StringBuilder sqlBuilder = new StringBuilder();
                String line;
                
                while ((line = reader.readLine()) != null) {
                    // Skip comments and empty lines
                    if (line.trim().startsWith("--") || line.trim().isEmpty()) {
                        continue;
                    }
                    sqlBuilder.append(line).append("\n");
                }
                
                String sql = sqlBuilder.toString();
                String[] statements = sql.split(";");
                
                try (Statement stmt = conn.createStatement()) {
                    for (String statement : statements) {
                        statement = statement.trim();
                        if (!statement.isEmpty()) {
                            stmt.execute(statement);
                        }
                    }
                }
            }
        }
    }
    
    public static boolean checkDatabaseConnection() {
        try (Connection conn = DBUtil.getConnection()) {
            return conn != null && !conn.isClosed();
        } catch (Exception e) {
            return false;
        }
    }
} 
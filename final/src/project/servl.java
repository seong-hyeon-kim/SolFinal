package project;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;

public class servl {
    private static final String DB_URL = "jdbc:mysql://database-2.clwq0ay02slq.ap-northeast-2.rds.amazonaws.com:3306/db1";
    private static final String DB_USER = "admin";
    private static final String DB_PASSWORD = "adminadmin";

    public static void saveData(String data) {
        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            // MySQL JDBC 드라이버 로드
            Class.forName("com.mysql.cj.jdbc.Driver");

            // 데이터베이스 연결
            conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);

            // SQL 쿼리
            String sql = "INSERT INTO user1 (id) VALUES (?)";

            // PreparedStatement 생성
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, data);

            // SQL 실행
            pstmt.executeUpdate();
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        } finally {
            try {
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}

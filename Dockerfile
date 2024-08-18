# Step 1: Base Image 선택
# Tomcat 9과 JDK 11이 설치된 이미지를 사용합니다.
FROM tomcat:9.0-jdk11

# Step 2: 소스 코드 복사
# 웹 애플리케이션 파일들을 Tomcat의 webapps 디렉토리에 복사합니다.
COPY final/WebContent/ /usr/local/tomcat/webapps/ROOT/

# Step 3: 컴파일된 클래스 파일 복사
# 클래스 파일들을 Tomcat의 webapps/ROOT/WEB-INF/classes 디렉토리에 복사합니다.
COPY final/build/classes/ /usr/local/tomcat/webapps/ROOT/WEB-INF/classes/

# Step 4: 라이브러리 복사
# 필요한 라이브러리 (예: MySQL 커넥터)를 Tomcat의 lib 디렉토리에 복사합니다.
COPY target/your-project-name/WEB-INF/lib/mysql-connector-j-8.0.32.jar /usr/local/tomcat/lib/

# Step 5: Tomcat 서버 실행
CMD ["catalina.sh", "run"]


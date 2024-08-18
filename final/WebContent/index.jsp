<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Save Data to RDS-jenkins two</title>
    <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background-color: #f8f9fa;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
        }
        .card {
            padding: 2rem;
            border-radius: 0.5rem;
            box-shadow: 0 0.5rem 1rem rgba(0, 0, 0, 0.15);
        }
        .form-control {
            height: 3rem;
            font-size: 1.2rem;
        }
        .btn {
            font-size: 1.2rem;
            padding: 0.75rem 1.5rem;
        }
    </style>
</head>
<body>
    <div class="card">
        <h2 class="mb-4">Save Data to RDS - king seong hyeon vV </h2>
        <form id="dataForm" method="post" action="saveData" onsubmit="return handleSubmit()">
            <input type="text" name="data" class="form-control mb-3" placeholder="Enter some data" required />
            <button type="submit" class="btn btn-primary btn-block">Save to Database</button>
        </form>
    </div>

    <script>
        function handleSubmit() {
            // 데이터 전송 후 팝업 메시지 표시
            alert("complete!");
            
            // 팝업에서 확인 버튼을 누르면 페이지를 다시 로드
            location.reload();
            
            
            // true를 반환하여 form이 정상적으로 전송되도록 함
            return true;
        }
    </script>
</body>
</html>

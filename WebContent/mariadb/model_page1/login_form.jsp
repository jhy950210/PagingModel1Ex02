<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script type="text/javascript">
	window.onload = function() {
		document.getElementById("btn").onclick = function() {
			if(document.frm.id.value.trim() == ''){
				alert('아이디를 입력하셔야 합니다.');
				return false;
			}
			if(document.frm.password.value.trim() == ''){
				alert('비밀번호를 입력하셔야 합니다.');
				return false;
			}
			document.frm.submit();
		}
	}
</script>
</head>
<body>
<form action="login_ok.jsp" method="post" name="frm">
아이디<input type="text" name="id" />
/ 비밀번호<input type="password" name="password" />
<input type="button" id="btn" value="로그인" />
</form>
</body>
</html>
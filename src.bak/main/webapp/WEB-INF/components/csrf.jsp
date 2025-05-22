<%-- 
    CSRF Protection Component
    Include this in any form that requires CSRF protection:
    <jsp:include page="/WEB-INF/components/csrf.jsp" />
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<c:if test="${not empty sessionScope.csrfToken}">
    <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">
</c:if> 
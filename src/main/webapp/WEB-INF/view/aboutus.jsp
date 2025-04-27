<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>About Us - SewaSathi</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        :root {
            --primary: #ff6b6b;
            --primary-dark: #ff5252;
            --primary-light: #ffa5a5;
            --secondary: #339af0;
            --text-dark: #212529;
            --text-light: #6c757d;
            --background: #ffffff;
            --gray-light: #f8f9fa;
            --gray-medium: #e9ecef;
            --border-color: #dee2e6;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Inter', sans-serif;
            color: var(--text-dark);
            line-height: 1.6;
        }

        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 15px;
        }

        .about-hero {
            background-image: linear-gradient(rgba(0, 0, 0, 0.5), rgba(0, 0, 0, 0.5)), url('https://images.unsplash.com/photo-1521791136064-7986c2920216?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80');
            background-size: cover;
            background-position: center;
            padding: 100px 0;
            text-align: center;
            color: white;
        }

        .about-hero h1 {
            font-size: 3rem;
            margin-bottom: 1rem;
        }

        .about-hero p {
            font-size: 1.2rem;
            max-width: 800px;
            margin: 0 auto;
        }

        .about-section {
            padding: 80px 0;
        }

        .about-section:nth-child(even) {
            background-color: var(--gray-light);
        }

        .section-title {
            font-size: 2rem;
            margin-bottom: 2rem;
            text-align: center;
        }

        .mission-vision {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 2rem;
            margin-bottom: 3rem;
        }

        .mission-card, .vision-card {
            background: white;
            padding: 2rem;
            border-radius: 10px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
        }

        .mission-card h3, .vision-card h3 {
            color: var(--primary);
            margin-bottom: 1rem;
            font-size: 1.5rem;
        }

        .team-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 2rem;
        }

        .team-member {
            text-align: center;
        }

        .team-member img {
            width: 150px;
            height: 150px;
            border-radius: 50%;
            object-fit: cover;
            margin-bottom: 1rem;
        }

        .team-member h3 {
            margin-bottom: 0.5rem;
        }

        .team-member p {
            color: var(--text-light);
        }

        .stats {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 2rem;
            text-align: center;
        }

        .stat-item h2 {
            color: var(--primary);
            font-size: 2.5rem;
            margin-bottom: 0.5rem;
        }

        .stat-item p {
            color: var(--text-light);
        }
    </style>
</head>
<body>
<jsp:include page="/WEB-INF/components/navbar.jsp" />

<main>
    <section class="about-hero">
        <div class="container">
            <h1>About SewaSathi</h1>
            <p>Connecting donors with causes that matter, helping communities across Nepal recover, rebuild, and thrive.</p>
        </div>
    </section>

    <section class="about-section">
        <div class="container">
            <h2 class="section-title">Our Story</h2>
            <p style="text-align: center; max-width: 800px; margin: 0 auto 2rem;">
                SewaSathi was founded in 2024 with a simple mission: to make giving accessible and impactful.
                We believe that everyone should have the opportunity to support causes they care about,
                and that every community deserves access to the resources they need to thrive.
            </p>

            <div class="mission-vision">
                <div class="mission-card">
                    <h3>Our Mission</h3>
                    <p>To connect donors with verified causes and provide a secure platform for transparent giving,
                        ensuring that every contribution makes a meaningful impact in communities across Nepal.</p>
                </div>
                <div class="vision-card">
                    <h3>Our Vision</h3>
                    <p>To create a world where giving is accessible to all, where communities are empowered to
                        support each other, and where every act of kindness contributes to positive change.</p>
                </div>
            </div>

            <div class="stats">
                <div class="stat-item">
                    <h2>1000+</h2>
                    <p>Campaigns Supported</p>
                </div>
                <div class="stat-item">
                    <h2>50K+</h2>
                    <p>Donors</p>
                </div>
                <div class="stat-item">
                    <h2>₹10M+</h2>
                    <p>Raised</p>
                </div>
                <div class="stat-item">
                    <h2>100%</h2>
                    <p>Transparent</p>
                </div>
            </div>
        </div>
    </section>

<%--    <section class="about-section">--%>
<%--        <div class="container">--%>
<%--            <h2 class="section-title">Our Team</h2>--%>
<%--            <div class="team-grid">--%>
<%--                <div class="team-member">--%>
<%--                    <img src="https://images.unsplash.com/photo-1560250097-0b93528c311a?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60" alt="Team Member">--%>
<%--                    <h3>John Doe</h3>--%>
<%--                    <p>Founder & CEO</p>--%>
<%--                </div>--%>
<%--                <div class="team-member">--%>
<%--                    <img src="https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60" alt="Team Member">--%>
<%--                    <h3>Jane Smith</h3>--%>
<%--                    <p>Operations Director</p>--%>
<%--                </div>--%>
<%--                <div class="team-member">--%>
<%--                    <img src="https://images.unsplash.com/photo-1566492031773-4f4e44671857?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60" alt="Team Member">--%>
<%--                    <h3>Mike Johnson</h3>--%>
<%--                    <p>Technology Lead</p>--%>
<%--                </div>--%>
<%--            </div>--%>
<%--        </div>--%>
<%--    </section>--%>
</main>

<jsp:include page="/WEB-INF/components/footer.jsp" />
</body>
</html>
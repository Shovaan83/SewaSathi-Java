<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Contact Us - SewaSathi</title>
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

        .contact-hero {
            background-image: linear-gradient(rgba(0, 0, 0, 0.5), rgba(0, 0, 0, 0.5)), url('https://images.unsplash.com/photo-1516387938699-a93567ec168e?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80');
            background-size: cover;
            background-position: center;
            padding: 100px 0;
            text-align: center;
            color: white;
        }

        .contact-hero h1 {
            font-size: 3rem;
            margin-bottom: 1rem;
        }

        .contact-hero p {
            font-size: 1.2rem;
            max-width: 800px;
            margin: 0 auto;
        }

        .contact-section {
            padding: 80px 0;
        }

        .contact-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 2rem;
        }

        .contact-info {
            background: white;
            padding: 2rem;
            border-radius: 10px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
        }

        .contact-info h2 {
            color: var(--primary);
            margin-bottom: 1.5rem;
            font-size: 1.8rem;
        }

        .info-item {
            display: flex;
            align-items: flex-start;
            margin-bottom: 1.5rem;
        }

        .info-item i {
            color: var(--primary);
            font-size: 1.2rem;
            margin-right: 1rem;
            margin-top: 0.3rem;
        }

        .info-item div h3 {
            margin-bottom: 0.5rem;
            font-size: 1.1rem;
        }

        .info-item div p {
            color: var(--text-light);
        }

        .contact-form {
            background: white;
            padding: 2rem;
            border-radius: 10px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
        }

        .form-group {
            margin-bottom: 1.5rem;
        }

        .form-group label {
            display: block;
            margin-bottom: 0.5rem;
            font-weight: 500;
        }

        .form-group input,
        .form-group textarea {
            width: 100%;
            padding: 0.8rem;
            border: 1px solid var(--border-color);
            border-radius: 5px;
            font-family: inherit;
            font-size: 1rem;
        }

        .form-group textarea {
            height: 150px;
            resize: vertical;
        }

        .btn {
            padding: 0.8rem 2rem;
            border-radius: 50px;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.3s ease;
            font-size: 1rem;
            display: inline-block;
            text-align: center;
            border: none;
        }

        .btn-primary {
            background-color: var(--primary);
            color: white;
        }

        .btn-primary:hover {
            background-color: var(--primary-dark);
        }

        .map-section {
            padding: 40px 0;
            background-color: var(--gray-light);
        }

        .map-container {
            height: 400px;
            border-radius: 10px;
            overflow: hidden;
        }

        .map-container iframe {
            width: 100%;
            height: 100%;
            border: 0;
        }
    </style>
</head>
<body>
<%--<jsp:include page="/WEB-INF/components/navbar.jsp" />--%>

<main>
    <section class="contact-hero">
        <div class="container">
            <h1>Contact Us</h1>
            <p>Have questions or need assistance? We're here to help!</p>
        </div>
    </section>

    <section class="contact-section">
        <div class="container">
            <div class="contact-grid">
                <div class="contact-info">
                    <h2>Get in Touch</h2>
                    <div class="info-item">
                        <i class="fas fa-map-marker-alt"></i>
                        <div>
                            <h3>Our Location</h3>
                            <p>Sinamangal, Kathmandu, Nepal</p>
                        </div>
                    </div>
                    <div class="info-item">
                        <i class="fas fa-phone-alt"></i>
                        <div>
                            <h3>Phone Number</h3>
                            <p>+977 9861452719</p>
                        </div>
                    </div>
                    <div class="info-item">
                        <i class="fas fa-envelope"></i>
                        <div>
                            <h3>Email Address</h3>
                            <p>sewasathi@gmail.com</p>
                        </div>
                    </div>
                    <div class="info-item">
                        <i class="fas fa-clock"></i>
                        <div>
                            <h3>Working Hours</h3>
                            <p>Monday - Friday: 9:00 AM - 5:00 PM</p>
                        </div>
                    </div>
                </div>

                <div class="contact-form">
                    <h2>Send us a Message</h2>
                    <c:if test="${not empty successMessage}">
                        <div style="background-color: #d4edda; color: #155724; padding: 10px; border-radius: 5px; margin-bottom: 20px;">
                                ${successMessage}
                        </div>
                    </c:if>
                    <form action="${pageContext.request.contextPath}/contact" method="post">
                        <jsp:include page="/WEB-INF/components/csrf.jsp" />
                        <div class="form-group">
                            <label for="name">Your Name</label>
                            <input type="text" id="name" name="name" required>
                        </div>
                        <div class="form-group">
                            <label for="email">Your Email</label>
                            <input type="email" id="email" name="email" required>
                        </div>
                        <div class="form-group">
                            <label for="subject">Subject</label>
                            <input type="text" id="subject" name="subject" required>
                        </div>
                        <div class="form-group">
                            <label for="message">Your Message</label>
                            <textarea id="message" name="message" required></textarea>
                        </div>
                        <button type="submit" class="btn btn-primary">Send Message</button>
                    </form>
                </div>
            </div>
        </div>
    </section>

    <section class="map-section">
        <div class="container">
            <div class="map-container">
                <iframe src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d3532.4563!2d85.3388!3d27.7172!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x39eb198a307baabf%3A0xb5137c1bf18db1ea!2sSinamangal%2C%20Kathmandu%2044600!5e0!3m2!1sen!2snp!4v1645567890123!5m2!1sen!2snp" allowfullscreen="" loading="lazy"></iframe>
            </div>
        </div>
    </section>
</main>

<%--<jsp:include page="/WEB-INF/components/footer.jsp" />--%>
</body>
</html>
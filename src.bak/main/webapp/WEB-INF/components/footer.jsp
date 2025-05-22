<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<style>
  .footer {
    background-color: #333;
    color: #fff;
    padding: 3rem 0 2rem;
    margin-top: 3rem;
  }
  .footer-container {
    max-width: 1200px;
    margin: 0 auto;
    padding: 0 1rem;
    display: grid;
    grid-template-columns: repeat(4, 1fr);
    gap: 2rem;
  }
  .footer-section h3 {
    color: #ff6b6b;
    margin-bottom: 1.5rem;
    font-size: 1.2rem;
  }
  .footer-links {
    list-style: none;
    padding: 0;
    margin: 0;
  }
  .footer-link {
    margin-bottom: 0.75rem;
  }
  .footer-link a {
    color: #e1e1e1;
    text-decoration: none;
    transition: color 0.3s;
  }
  .footer-link a:hover {
    color: #ff6b6b;
  }
  .footer-donate {
    display: inline-block;
    background-color: #ff6b6b;
    color: white;
    padding: 0.6rem 1.5rem;
    border-radius: 50px;
    margin-top: 1rem;
    text-decoration: none;
    font-weight: 600;
    transition: background-color 0.3s;
  }
  .footer-donate:hover {
    background-color: #ff5252;
  }
  .footer-contact p {
    margin-bottom: 0.75rem;
    color: #e1e1e1;
  }
  .footer-social {
    display: flex;
    gap: 1rem;
    margin-top: 1.5rem;
  }
  .social-icon {
    color: #e1e1e1;
    font-size: 1.25rem;
    transition: color 0.3s;
  }
  .social-icon:hover {
    color: #ff6b6b;
  }
  .footer-bottom {
    text-align: center;
    margin-top: 3rem;
    padding-top: 1.5rem;
    border-top: 1px solid #444;
    color: #999;
  }

  @media (max-width: 992px) {
    .footer-container {
      grid-template-columns: repeat(2, 1fr);
    }
  }

  @media (max-width: 576px) {
    .footer-container {
      grid-template-columns: 1fr;
    }
  }
</style>

<footer class="footer">
  <div class="footer-container">
    <div class="footer-section">
      <h3>SewaSathi</h3>
      <p>Empowering communities through collective action and generosity.</p>
      <a href="${pageContext.request.contextPath}/donate" class="footer-donate">
        <i class="fas fa-heart"></i> Donate
      </a>
    </div>

    <div class="footer-section">
      <h3>Quick Links</h3>
      <ul class="footer-links">
        <li class="footer-link"><a href="${pageContext.request.contextPath}/">Home</a></li>
        <li class="footer-link"><a href="${pageContext.request.contextPath}/campaigns">Campaigns</a></li>
        <li class="footer-link"><a href="${pageContext.request.contextPath}/about">About Us</a></li>
        <li class="footer-link"><a href="${pageContext.request.contextPath}/contact">Contact</a></li>
        <li class="footer-link"><a href="${pageContext.request.contextPath}/donate">Donate Now</a></li>
      </ul>
    </div>

    <div class="footer-section">
      <h3>Campaigns</h3>
      <ul class="footer-links">
        <li class="footer-link"><a href="${pageContext.request.contextPath}/campaigns?category=health">Healthcare</a></li>
        <li class="footer-link"><a href="${pageContext.request.contextPath}/campaigns?category=education">Education</a></li>
        <li class="footer-link"><a href="${pageContext.request.contextPath}/campaigns?category=disaster">Disaster Relief</a></li>
        <li class="footer-link"><a href="${pageContext.request.contextPath}/campaigns?category=community">Community Development</a></li>
        <li class="footer-link"><a href="${pageContext.request.contextPath}/campaigns?category=environment">Environment</a></li>
      </ul>
    </div>

    <div class="footer-section footer-contact">
      <h3>Contact Us</h3>
      <p><i class="fas fa-map-marker-alt"></i> 123 Main Street, Kathmandu, Nepal</p>
      <p><i class="fas fa-phone"></i> +977 1 234 5678</p>
      <p><i class="fas fa-envelope"></i> info@sewasathi.org</p>

      <div class="footer-social">
        <a href="#" class="social-icon"><i class="fab fa-facebook-f"></i></a>
        <a href="#" class="social-icon"><i class="fab fa-twitter"></i></a>
        <a href="#" class="social-icon"><i class="fab fa-instagram"></i></a>
        <a href="#" class="social-icon"><i class="fab fa-linkedin-in"></i></a>
      </div>
    </div>
  </div>

  <div class="footer-bottom">
    <p>&copy; 2025 SewaSathi. All rights reserved.</p>
  </div>
</footer>
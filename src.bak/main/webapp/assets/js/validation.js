/**
 * Client-side form validation using regular expressions
 * This file contains validation functions for the registration and login forms
 */

// Regular expressions for validation
const validationPatterns = {
    username: /^[a-zA-Z0-9_]{4,20}$/,
    email: /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/,
    password: /^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d@$!%*#?&]{8,}$/,
    fullName: /^[a-zA-Z\s'-]{2,50}$/,
    phone: /^(\+\d{1,3}[- ]?)?\d{10,14}$/
};

// Error messages for validation
const errorMessages = {
    username: 'Username must be 4-20 characters and can only contain letters, numbers, and underscores',
    email: 'Please enter a valid email address',
    password: 'Password must be at least 8 characters and include at least one letter and one number',
    confirmPassword: 'Passwords do not match',
    fullName: 'Please enter a valid full name (2-50 characters)',
    phone: 'Please enter a valid phone number'
};

/**
 * Creates and displays an error message for a form field
 * @param {HTMLElement} inputElement - The input element to validate
 * @param {string} message - The error message to display
 */
function showError(inputElement, message) {
    // Remove any existing error message
    removeError(inputElement);

    // Create error message element
    const errorElement = document.createElement('div');
    errorElement.className = 'validation-error';
    errorElement.textContent = message;

    // Add error class to input
    inputElement.classList.add('input-error');

    // Insert error message after the input element
    inputElement.parentNode.insertBefore(errorElement, inputElement.nextSibling);
}

/**
 * Removes error message and styling from a form field
 * @param {HTMLElement} inputElement - The input element to remove error from
 */
function removeError(inputElement) {
    // Remove error class from input
    inputElement.classList.remove('input-error');

    // Remove any existing error message
    const existingError = inputElement.parentNode.querySelector('.validation-error');
    if (existingError) {
        existingError.remove();
    }
}

/**
 * Shows success styling for a form field
 * @param {HTMLElement} inputElement - The input element to show success for
 */
function showSuccess(inputElement) {
    // Remove any existing error
    removeError(inputElement);

    // Add success class to input
    inputElement.classList.add('input-success');
}

/**
 * Validates a form field against a regular expression pattern
 * @param {HTMLElement} inputElement - The input element to validate
 * @param {RegExp} pattern - The regular expression pattern to validate against
 * @param {string} errorMessage - The error message to display if validation fails
 * @returns {boolean} - Whether the validation passed
 */
function validateField(inputElement, pattern, errorMessage) {
    const value = inputElement.value.trim();

    // Skip validation if field is empty (HTML required attribute will handle this)
    if (value === '') {
        removeError(inputElement);
        inputElement.classList.remove('input-success');
        return true;
    }

    // Test the value against the pattern
    if (pattern.test(value)) {
        showSuccess(inputElement);
        return true;
    } else {
        showError(inputElement, errorMessage);
        return false;
    }
}

/**
 * Validates that two password fields match
 * @param {HTMLElement} passwordElement - The password input element
 * @param {HTMLElement} confirmPasswordElement - The confirm password input element
 * @returns {boolean} - Whether the passwords match
 */
function validatePasswordMatch(passwordElement, confirmPasswordElement) {
    const password = passwordElement.value;
    const confirmPassword = confirmPasswordElement.value;

    // Skip validation if confirm password is empty
    if (confirmPassword === '') {
        removeError(confirmPasswordElement);
        confirmPasswordElement.classList.remove('input-success');
        return true;
    }

    if (password === confirmPassword) {
        showSuccess(confirmPasswordElement);
        return true;
    } else {
        showError(confirmPasswordElement, errorMessages.confirmPassword);
        return false;
    }
}

/**
 * Validates a select field
 * @param {HTMLElement} selectElement - The select element to validate
 * @param {string} errorMessage - The error message to display if validation fails
 * @returns {boolean} - Whether the validation passed
 */
function validateSelect(selectElement, errorMessage) {
    const value = selectElement.value;

    if (value === '' || value === null) {
        showError(selectElement, errorMessage);
        return false;
    } else {
        showSuccess(selectElement);
        return true;
    }
}

/**
 * Sets up validation for the registration form
 */
function setupRegistrationValidation() {
    const form = document.querySelector('form[action*="RegisterServlet"]');
    if (!form) return;

    // Get form elements
    const usernameInput = document.getElementById('username');
    const emailInput = document.getElementById('email');
    const passwordInput = document.getElementById('password');
    const confirmPasswordInput = document.getElementById('confirmPassword');
    const fullNameInput = document.getElementById('fullName');
    const phoneInput = document.getElementById('phone');

    // Add input event listeners for real-time validation
    if (usernameInput) {
        usernameInput.addEventListener('input', () => {
            validateField(usernameInput, validationPatterns.username, errorMessages.username);
        });
    }

    if (emailInput) {
        emailInput.addEventListener('input', () => {
            validateField(emailInput, validationPatterns.email, errorMessages.email);
        });
    }

    if (passwordInput) {
        passwordInput.addEventListener('input', () => {
            validateField(passwordInput, validationPatterns.password, errorMessages.password);
            // If confirm password has a value, validate it again
            if (confirmPasswordInput && confirmPasswordInput.value !== '') {
                validatePasswordMatch(passwordInput, confirmPasswordInput);
            }
        });
    }

    if (confirmPasswordInput) {
        confirmPasswordInput.addEventListener('input', () => {
            validatePasswordMatch(passwordInput, confirmPasswordInput);
        });
    }

    if (fullNameInput) {
        fullNameInput.addEventListener('input', () => {
            validateField(fullNameInput, validationPatterns.fullName, errorMessages.fullName);
        });
    }

    if (phoneInput) {
        phoneInput.addEventListener('input', () => {
            // Phone is optional, so only validate if it has a value
            if (phoneInput.value.trim() !== '') {
                validateField(phoneInput, validationPatterns.phone, errorMessages.phone);
            } else {
                removeError(phoneInput);
            }
        });
    }

    // Add submit event listener for form validation
    form.addEventListener('submit', (event) => {
        let isValid = true;

        // Validate all required fields
        if (usernameInput) {
            isValid = validateField(usernameInput, validationPatterns.username, errorMessages.username) && isValid;
        }

        if (emailInput) {
            isValid = validateField(emailInput, validationPatterns.email, errorMessages.email) && isValid;
        }

        if (passwordInput) {
            isValid = validateField(passwordInput, validationPatterns.password, errorMessages.password) && isValid;
        }

        if (confirmPasswordInput) {
            isValid = validatePasswordMatch(passwordInput, confirmPasswordInput) && isValid;
        }

        if (fullNameInput) {
            isValid = validateField(fullNameInput, validationPatterns.fullName, errorMessages.fullName) && isValid;
        }

        if (phoneInput && phoneInput.value.trim() !== '') {
            isValid = validateField(phoneInput, validationPatterns.phone, errorMessages.phone) && isValid;
        }

        // Prevent form submission if validation fails
        if (!isValid) {
            event.preventDefault();
        }
    });
}

/**
 * Sets up validation for the login form
 */
function setupLoginValidation() {
    const form = document.querySelector('form[action*="LoginServlet"]');
    if (!form) return;

    // Get form elements
    const usernameInput = document.getElementById('username');
    const passwordInput = document.getElementById('password');

    // Add input event listeners for real-time validation
    if (usernameInput) {
        usernameInput.addEventListener('input', () => {
            // For login, we just check if the field is not empty
            if (usernameInput.value.trim() === '') {
                showError(usernameInput, 'Username is required');
            } else {
                showSuccess(usernameInput);
            }
        });
    }

    if (passwordInput) {
        passwordInput.addEventListener('input', () => {
            // For login, we just check if the field is not empty
            if (passwordInput.value.trim() === '') {
                showError(passwordInput, 'Password is required');
            } else {
                showSuccess(passwordInput);
            }
        });
    }

    // Add submit event listener for form validation
    form.addEventListener('submit', (event) => {
        let isValid = true;

        // Validate username
        if (usernameInput && usernameInput.value.trim() === '') {
            showError(usernameInput, 'Username is required');
            isValid = false;
        }

        // Validate password
        if (passwordInput && passwordInput.value.trim() === '') {
            showError(passwordInput, 'Password is required');
            isValid = false;
        }

        // Prevent form submission if validation fails
        if (!isValid) {
            event.preventDefault();
        }
    });
}

// Initialize validation when the DOM is fully loaded
document.addEventListener('DOMContentLoaded', () => {
    setupRegistrationValidation();
    setupLoginValidation();
});
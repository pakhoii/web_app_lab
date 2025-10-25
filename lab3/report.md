# Lab 3 - JavaScript Fundamentals
Here is how I implemented the requirements in this lab section.
## Task 1.1: Interactive Form Validator
**Validate Username**
```javascript
function validateUsername(username) {
        // TODO: Check length (4-20) and alphanumeric
        const usernameRegex = /^[a-zA-Z0-9]{4,20}$/
        return usernameRegex.test(username)
}
```
Define the regular expression for the string contains alphanumeric with the length is from 4 to 20 characters. Return the validation of the test (`true` or `false`)

---
**Validate Email**
```javascript
function validateEmail(email) {
    // TODO: Use regex for email validation
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    return emailRegex.test(email)
}
```

Define the regular expression to validate email format.
The regex checks for a pattern with characters before and after the `@` symbol, followed by a valid domain.
Return the validation result (`true` or `false`).

---

**Validate Password**

```javascript
function validatePassword(password) {
    // TODO: Check length >= 8, has uppercase, has number
    const passwordRegex = /^(?=.*[A-Z])(?=.*\d).{8,}$/
    return passwordRegex.test(password)
}
```

Define the regular expression to ensure the password:

- Has a length of at least 8 characters
- Contains at least one uppercase letter
- Contains at least one number
  Return the validation result (`true` or `false`).

---

**Validate Password Match**

```javascript
function validatePasswordMatch(pass1, pass2) {
    // TODO: Compare passwords
    if (pass1 && pass2) {
        return pass1 === pass2
    }
    return false
}
```

Compare two password strings to ensure they are identical.
Return `true` if both are non-empty and match, otherwise `false`.

---

**Show Error**

```javascript
function showError(fieldId, message) {
    // TODO: Display error message
    const errorField = document.getElementById(fieldId + 'Error')
    if (errorField) {
        errorField.innerText = message
        errorField.classList.add('show')
    }

    const inputField = document.getElementById(fieldId)
    if (inputField) {
        inputField.classList.add('invalid')
        inputField.classList.remove('valid')
    }
}
```

Display an error message for a specific input field.
It updates the text inside the error message element and changes the input’s CSS class to indicate invalid state.

---

**Clear Error**

```javascript
function clearError(fieldId) {
    // TODO: Clear error message
    const errorField = document.getElementById(fieldId + 'Error')
    if (errorField) {
        errorField.innerText = ''
        errorField.classList.remove('show')
    }

    const inputField = document.getElementById(fieldId)
    if (inputField) {
        inputField.classList.remove('invalid')
        inputField.classList.add('valid')
    }
}
```

Remove the error message and restore the input field to a valid visual state by updating its CSS classes.

---

**Validate Form**

```javascript
function validateForm() {
    const username = document.getElementById('username').value;
    const email = document.getElementById('email').value;
    const password = document.getElementById('password').value;
    const confirmPassword = document.getElementById('confirm').value;
    let isValid = true;

    if (!validateUsername(username)) {
        showError('username', 'Username must be 4-20 alphanumeric characters.')
        isValid = false
    } else {
        clearError('username')
    }

    if (!validateEmail(email)) {
        showError('email', 'Invalid email format.')
        isValid = false
    } else {
        clearError('email')
    }

    if (!validatePassword(password)) {
        showError('password', 'Password must be at least 8 characters long, contain an uppercase letter and a number.')
        isValid = false
    } else {
        clearError('password')
    }

    if (!validatePasswordMatch(password, confirmPassword)) {
        if (password !== '' && confirmPassword !== '') {
            showError('confirm', 'Passwords do not match.')
        }
        isValid = false
    } else {
        clearError('confirm')
    }

    document.getElementById('submitBtn').disabled = !isValid
}
```

Perform real-time form validation for all input fields:

---
**Form Event Listeners**

```javascript
document.getElementById('username').addEventListener('input', validateForm)
document.getElementById('email').addEventListener('input', validateForm)
document.getElementById('password').addEventListener('input', validateForm)
document.getElementById('confirm').addEventListener('input', validateForm)

document.getElementById('signupForm').addEventListener('submit', function(e) {
    e.preventDefault()
    // TODO: Handle form submission
    alert('Form submitted successfully!')
})
```

## Task 1.2: Interactive Shopping Cart

**Add to Cart**
```javascript
function addToCart(productId) {
    // TODO: Add product to cart or increase quantity
    const product = products.find(p => p.id === productId)
    const cartItem = cart.find(item => item.id === productId)
    if (cartItem) {
        cartItem.quantity += 1
    } else {
        cart.push({ ...product, quantity: 1 })
    }
    console.log(cart)
}
```

Add a product to the shopping cart function. The logic is if the product already exists in the cart, increase its quantity by 1. Otherwise, we add the product with an initial quantity of 1.

---

**Remove from Cart**
```javascript
function removeFromCart(itemId) {
    // TODO: Remove item from cart
    cart = cart.filter(item => item.id !== itemId)
    console.log(cart)
}
```

Remove a specific item from the cart based on its ID.

---

**Update Quantity**
```javascript
function updateQuantity(productId, change) {
    const cartItem = cart.find(item => item.id === productId)
    if (cartItem) {
        cartItem.quantity += change
        if (cartItem.quantity <= 0) {
            removeFromCart(productId)
        }
    }
}
```

Update the quantity of a cart item by a specified `change` value (e.g., `+1` or `-1`).  If the quantity drops to 0 or below, remove from cart.

---

**Calculate Total**
```javascript
function calculateTotal() {
    // TODO: Calculate total price
    return cart.reduce((total, item) => total + item.price * item.quantity, 0)
}
```

Compute the total cost of all items in the cart using `reduce()` starting with 0.

---

**Render Products**
```javascript
function renderProducts() {
    // TODO: Display products
    const productsGrid = document.getElementById('productsGrid')
    productsGrid.innerHTML = ''
    
    products.forEach(product => {
        const productCard = document.createElement('div')
        productCard.className = 'product-card'
        productCard.innerHTML = `
            <div class="product-image">${product.image}</div>
            <div class="product-name">${product.name}</div>
            <div class="product-price">$${product.price}</div>
            <button class="add-to-cart-btn" onclick="addToCart(${product.id}); renderCart()">Add to Cart</button>
        `
        productsGrid.appendChild(productCard)
    }) 
}
```
Display the products onto the screen.

---

**Render Cart**
```javascript
function renderCart() {
    // TODO: Display cart items
    const cartItems = document.getElementById('cartItems')
    const cartCount = document.getElementById('cartCount')
    const cartTotal = document.getElementById('cartTotal')

    cartItems.innerHTML = ''
    cartCount.innerText = cart.reduce((sum, item) => sum + item.quantity, 0)
    cartTotal.innerText = calculateTotal().toFixed(2)

    cart.forEach(item => {
        const cartItem = document.createElement('div')
        cartItem.className = 'cart-item'
        cartItem.innerHTML = `
            <div>${item.name} - $${item.price} x ${item.quantity}</div>
            <div class="quantity-controls">
                <button onclick="updateQuantity(${item.id}, -1); renderCart()">-</button>
                <span>${item.quantity}</span>
                <button onclick="updateQuantity(${item.id}, 1); renderCart()">+</button>
            </div>
        `
        cartItems.appendChild(cartItem)
    })
}
```

Render and updates the displayed quantity, total count, and total price.

---

**Toggle Cart**
```javascript
function toggleCart() {
    // TODO: Show/hide cart section
    const cartSection = document.getElementById('cartSection')
    if (cartSection.style.display === 'none') {
        cartSection.style.display = 'block'
    } else {
        cartSection.style.display = 'none'
    }
}
```

Toggle the visibility of the shopping cart section.Switches between showing and hiding the cart when triggered.

---

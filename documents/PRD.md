# Store databases

These are the requirements from the "imaginary product team". The app will be built in compliance with these requirements.

## Business requirements (v0)

### 1 Customers
- Customers can register with their name, email, phone number, and address.
- A customer can have multiple shipping addresses.
- Customers can log in and place orders online.

### 2. Products
- The store sells various products, each with a name, description, brand, tags, category, price, SKU, and quantity in stock.
- Products belong to categories (e.g., Electronics, Clothing, Books).
- Products can have multiple images.

### 3. Orders
- Customers can place orders that contain one or more products.
- Each order must track the products ordered, quantities, and individual prices.
- Orders must have statuses: e.g., *Pending*, *Shipped*, *Delivered*, *Cancelled*, *Returned*.
- Each order is tied to a shipping address and a customer.

### 4. Payments
- Customers can pay using credit cards, PayPal, or store credit.
- Payments are tied to orders and include amount, date, and payment status (*Paid*, *Pending*, *Failed*).
- Partial payments are allowed (optional complexity).

### 5. Invoices
- Each order generates an invoice that includes taxes, discounts, and total amount due.
- Invoices must be stored and be auditable (i.e., never change after generation).
- Invoices include issue date and payment date.

### 6. Shipping
- Shipping information is tracked: carrier, tracking number, shipped date, and delivery date.
- Multiple shipping options: *Standard*, *Expedited*, *Overnight*.

### 7. Inventory Management
- Track stock levels for each product.
- Auto-adjust inventory when orders are placed or canceled.
- Reorder alerts when inventory drops below a threshold.

### 8. Admin Users
- Admins can add/edit/remove products, categories, and manage orders.
- Admins can view reports: daily sales, top-selling products, etc.

## Business requirements (v1)
- Customers can request returns for individual items in an order.
- Returns can be *Approved*, *Rejected*, or *Completed*.
- Return reason and return date must be tracked.
- Discounts and promotions may apply to certain products.
- Product Reviews and Ratings
- Gift Cards or Coupons
- Wishlist or Favorites
- Loyalty Points
- Multi-store setup (stores in different locations)
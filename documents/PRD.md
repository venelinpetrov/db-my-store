# SQL Store Database Design Exercise

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
- Orders can be processed by different admins and change status.

### 4. Taxes
- Tax rates vary by location - Different states/provinces/countries have different rates
- Tax rates change over time - Governments adjust rates, you need historical tracking
- Multiple tax types - Sales tax, VAT, GST, etc.
- Tax exemptions - Some products/customers may be tax-exempt
- Compliance - Proper tax calculation is legally required
- Admin control - Business users can manage rates without developers
- Audit trail - Track when rates changed and why
- Multi-region support - Essential if you expand internationally
- Complex rules - Can handle compound taxes (state + county + city)

### 5. Payments
- Customers can pay using credit cards, PayPal, or store credit.
- Payments are tied to orders and include amount, date, and payment status (*Paid*, *Pending*, *Failed*).

### 6. Invoices
- Each order generates an invoice that includes taxes, discounts, and total amount due.
- Invoices must be stored and be auditable (i.e., never change after generation).
- Invoices include issue date and payment date.

### 7. Shipping
- Shipping information is tracked: carrier, tracking number, shipped date, and delivery date.
- Multiple shipping options: *Standard*, *Expedited*, *Overnight*.

### 8. Inventory Management
- Track stock levels for each product.
- Auto-adjust inventory when orders are placed or canceled.
- Reorder alerts when inventory drops below a threshold.

### 9. Admin Users
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
- Partial payments are allowed

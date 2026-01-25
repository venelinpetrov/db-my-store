# Notes

Notes on the breakdown of the problem domain.

## Customers

The customer / user model.

I eventually decided to split the customer from user models, that is, separating user (authentication and account-level info) from profile (personal and editable info). This way the schema is more realistic and idiomatic for the e-commerce space. Also introducing roles, which will be needed when implementing the security features of the app layer.


### `users` table

- `user_id`: PK, AI
- `email`: UQ
- `password_hash`
- `is_active`
- `created_at` / `updated_at`
- `token_version`

Note: `token_version` column is used to globally log users out, when they change their password.

### `roles` table

- `role_id`: PK, AI
- `name`: UQ
- `description`

### `user_roles` table

This is a junktion table

- `user_id`: NN, FK
- `role_id`: NN, FK
- PK: `user_id` + `role_id`

### `customers` table

- `customer_id`: should be `PK`, `NN`, `AI`,
- `user_id`: FK
- `name`: I choosen name to be a single field to account for different cultures
- `date_of_birth`
- `phone`: `NN`
- `created_at` / `updated_at`

The `address` will be represented in another table in order to support multiple addresses per customer.

### `customer_addresses` table

- The only `NN` columns are `address_id`, `customer_id`, `country`, `city` and `street`

### `address_types` table

- This table is referred by the `customer_addresses` table

## Products

I'm thinking of a "product catalog" and "product inventory" in separation. This means that fields like `SKU`, `unit_price` and `quantity_in_stock` will not belong to the `products` table.

Product variants is another important concept. Most likely, products will need to support different variants. For example a product might have a `color`, another product might have a `size` and a third product might have both. This is one more reason to keep the above metntioned fields separate from product.

In this model a product is just a conceptual entity. It doesn't have `price` and `quantity_in_stock`, the specific variant does. Since "variants" concept is foundational for the model, my thinking is to consider them early on into the design


### `products` table

- `product_id`: `PK`
- `name`
- `description`
- `is_archived`
- `category_id`
- `brand`
- Additional to the mentioned fields in the requirements, let's add `created_at` and `updated_at` fields
- Let's also add `is_archived` to hide deprecated products without deleting them

### `product_categories` table

- `category_id`: `PK`, `AI`
- `name`: `UQ`
- `parent_category_id`: `FK`

### `product_to_categories` junktion table

- `product_id`: `PK`, `FK`
- `category_id`: `PK`, `FK`

### `product_images` table

- `image_id`: `PK`
- `product_id`: `FK`
- `variant_id`: `FK`
- `link`
- `alt_text` - note: this is not in the requirements, but I decided to add it, for accessibility reasons
- `is_primary` - note: this is not in the requirements, but the FE will probably need it, if we want deterministic thumbnails

Note: Right now an images are coupled with the products/variants, meaning that an image can belong to only one product/variant. Alternativelly, images can be designed as a "pool" and reference them from different products and variants, basically modeling a many-to-many relation. This is more flexible and allows for reusing images. For example a store might want to use a generic image for multiple products or a single image for all variants.

This option will require the following changes

### `product_images` table

- `image_id`: PK
- `link`: UQ
- `alt_text`


### `product_image_assignments` table

- `assignemnt_id`: PT - note: we could use a compound key (product_id, image_id) but it turned out very clunky to work with such ids in JPA
- `product_id`: FK
- `imabe_id`: FK
- `is_primary`


### `product_variant_image_assignments` table

- `assignemnt_id`: PT - note: we could use a compound key (product_id, image_id) but it turned out very clunky to work with such ids in JPA
- `variant_id`: FK
- `imabe_id`: FK
- `is_primary`


### `brands` table

- `brand_id`: `PK`
- `name`
- `logo_url`

### `tags`

- `tag_id`: `PK`
- `name`: `UQ`

### `product_tags`

- `product_id`: `FK`, `PK`
- `tag_id`: `FK`, `PK`

### `product_variants` table

Each row is a unique combination of options for a product. For example T-shirt, Red, M. However, it is not easy to enforce uniqueness in a normalized structure. There are few options though. Let's come back to this later and assume for now that, the uniqueness will be enforced by the app layer. We can then add another column that will hold a normalized string, composed of the ids of each variant table below. For example "1-1-2" and enforce unique constrain on this column.

- `variant_id`: `PK`
- `product_id`: `FK`
- `sku`: `UQ`
- `unit_price`
- `is_archived`
- ~~quantity_in_stock~~ - this will be moved to inventory

### `variant_options` table

- `option_id`: `PK`
- `name`

### `variant_option_values` table

- `value_id`: `PK`
- `option_id`: `FK`
- `value`: `UQ`

### `variant_option_assignments` table

- `variant_id`: `PK`
- `value_id`: `FK`


## Orders

I started thinking of shippments early on and came to the conclusion that logistics fulfillment is an entirely separate concept, therefore it should be kept separate from the orders model. Here is the reason why:

**Lifecycle**: Shipping might be booked after an order is created, sometimes after payment.

**Multiple attempts**: A shipment might be re-sent, re-routed, or split.

**Carrier-specific info**: tracking numer, carrier, est. delivery date, don't belong in orders

**Different responsibilities**: order = commerce, shipping = logistics.

With that being said, ordering and shipping are still related, and I'll model this relation in this section.

Q: Where does the `shipping_cost` go?
A: The delivery (shipping) price is a cost tied to the order total, but it originates from the shipping method or provider

Here is my consideration: The most straighrforwad and practical option is to keep it in the order. Let's assume we know the cost at the time of checkout, even if the shippment hasn't occurred yet. This will simplify accounting, because it keeps orders self-contained for invoices, total and reporting.

### `orders` table

- `order_id`: `PK`
- `order_date`
- `shipping_cost`
- `created_at`
- `updated_at`
- `status_id`: `FK`
- `customer_id`: `FK`
- `address_id`: `FK` - this is the shipping address

### `order_items` table

- `order_id`: `PK` `FK`
- `variant_id`: `PK` `FK` - note: very important! I got confused and put product_id at first, but remember, the physical thing we are seeling is a specific "variant". Product is just a conceptual model
- `quantity`
- `unit_price` - note: we denormalize this field because we don't want changes in variant price to affect historical data
- `product_name` - note: we denormalize this field because we don't want changes in product name to affect historical data
- `sku` - sku is here for convenience. It should not change
- `brand_name` - note: we denormalize this field because we don't want changes in brand name to affect historical data. Brand names sometimes change for legitimate reasons like rebranding, acquisition etc.

### `order_statuses` table

- `status_id`: `PK`
- `name`: `UQ` - *Pending*, *Shipped*, *Delivered*, *Cancelled*, *Returned*

### `shipments` table

- `shipment_id`: `PK`
- `carrier`
- `tracking_number`: `UQ`
- `shipped_date`
- `delivery_date`
- `order_id`: `FK`
- `address_id`: `FK`

## Cart

The Cart feature should be available to both, logged-in and annonymous users. The idea is to implement annonymous tracking via sessoin_id. Once the user logs in, we can safely ignore the session_id and use the customer_id to associate with their cart. We could use cart_id for tracking but it must be UUID, not sequential, because sequential ids are easy to guess and present security concern. I choose to use session_id column instead. Maybe a bit redundant, but very safe.


### `cart` table

- `cart_id`: PK, AI
- `session_id`: UQ
- `customer_id`: nullable
- `created_at`
- `updated_at`

### `cart_item` table

- `item_id`: PK, AI
- `cart_id`: FK
- `variant_id`: FK
- `quantity`
- `created_at`
- `updated_at`


## Payments

I think of invoices and payments together, because what the customer pays is the invoice total

Q: How do we insert and update invoices/payments

A: The application layer will be responsible for this, as this is more transparent and controllable.

Q: How is the `invoice_total` calculated

A: We sum all the items multiplied by their quantitites in the order, add taxes and shipping costs and subtract disocunt. Note that discounts are not modeled here yet.

```bash
total = sum(item_price * item_quantity) + tax + shipping_cost - discount
```

Another matter to consider is the "invoice status". Is it entirely determined by the payment status, or we should allow for "manual" adjustment?

Option 1 is no status on invoices

Pros:

- Always reflects live data.
- Eliminates the need for syncing/inconsistencies.

Cons:

- Requires calculating state dynamically in queries.
- More complex reporting (but solvable via views or computed columns).

Option 2 is `status_id` on invoices

Pros:

- Faster reads, especially in dashboards or reporting.
- Easier to track business-specific states (beyond payments).

Cons:

- Risk of stale/inconsistent data unless kept in sync (via triggers or app logic).

Let's go with option 1 for now, no status on ivoices.

### `invoices` table

- `invoice_id`: `PK`
- `order_id`: `FK`
- `customer_id`: `FK`
- `invoice_total`
- `tax`
- `discount`
- `payment_total`
- `invoice_date`
- `due_date`
- `payment_date`


### `payment_methods` table

- `method_id`: `PK`
- `type`
- `name`: `UQ`

### `payment_statuses` table

- `status_id`: `PK`
- `name`: `UQ`

### `payments` table

- `payment_id`: `PK`
- `invoice_id`: `FK`
- `amount`
- `payment_date`
- `payment_method_id`
- `status_id`: `FK`


## Inventory management

Q: Should this be a view or a table

A: A table is more robust and future proof as it will support full audit trail and tracking all kinds of changes, e.g. "In"/"Out"/"Adjustment".

View is good for real time tracking of stock levels.

I'd consider both.

Requirements are a bit vague. Should we support multiple warehouses locations? Should we support suppliers? Should we support restock date and track restocking as well?

Let's model the simplest scenario where we just keep track of all quantities and update them when a change occurs.

Another important change: `quantity_in_stock` should not be a field of `product_variants` anymore, it should be part of `inventory` instead. This will also allow to suport different quantities in different warehaouses (if needed) which by itself suggests that quantity is not really a property of a variant. This will also improve queries performance because we just need to perform a direct lookup by id which is straighforward.

Altohough it's not mentioned in the initial requirements, it is worth considering an `inventory_movements` table that will keep track of all changes. This will make it possible to track and debug all changes in the inventory. So let's do that as well.


Add `trg_after_inventory_movement_insert` trigger to ensure inventory_levels are properly adjusted when there is a new entry in `inventory_movements`

### `inventory_levels` table

- `inventory_id`: `PK`
- `variant_id`: `FK`
- `quantity_in_stock`
- `created_at`
- `updated_at`

### `inventory_movements` table

- `movement_id`: `PK`
- `variant_id`: `FK`
- `movement_type` - for simplicity I'll make it enum, but this is not ideal as it is not normalized
- `quantity`
- `reason`
- `created_at`
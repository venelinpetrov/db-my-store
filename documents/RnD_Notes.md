# Notes

Notes on the breakdown of the problem domain.

## Customers

The customer model.

### `customers` table

- `customer_id`: should be `PK`, `NN`, `AI`
- `name`: I choosen name to be a single field to account for different cultures
- `email`: `NN`, `PK`
- `phone`: `NN`

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
- `link`
- `alt_text` - note: this is not in the requirements, but I decided to add it, for accessibility reasons
- `is_primary` - note: this is not in the requirements, but the FE will probably need it, if we want deterministic thumbnails

### `product_variants` table

Each row is a unique combination of options for a product. For example T-shirt, Red, M. However, it is not easy to enforce uniqueness in a normalized structure. There are few options though. Let's come back to this later and assume for now that, the uniqueness will be enforced by the app layer. We can then add another column that will hold a normalized string, composed of the ids of each variant table below. For example "1-1-2" and enforce unique constrain on this column.

- `variant_id`: `PK`
- `product_id`: `FK`
- `sku`: `UQ`
- `unit_price`
- `quantity_in_stock`

### `variant_options` table

- `option_id`: `PK`
- `name`

### `variant_option_values` table

- `value_id`: `PK`
- `option_id`: `FK`
- `value`: `UQ`

### `variant_options_to_values` table

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
- `created_at`
- `updated_at`
- `status_id`: `FK`
- `customer_id`: `FK`
- `address_id`: `FK` - this is the shipping address

### `order_items` table

- `order_id`: `PK` `FK`
- `variant_id`: `PK` `FK` - note: very important! I got confused and put product_id at first, but remember, the physical thing we are seeling is a specific "variant". Product is just a conceptual model
- `quantity`
- `unit_price`

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
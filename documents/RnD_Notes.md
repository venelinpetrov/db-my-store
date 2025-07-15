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


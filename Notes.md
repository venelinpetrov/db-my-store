# Notes

I'll put some notes while creating the database, mainly my thoughts and considerations along the way.

## `customers` table

- `customer_id`: should be `PK`, `NN`, `AI`
- `name`: I choosen name to be a single field to account for different cultures
- `email`: `NN`, `PK`
- `phone`: `NN`

The `address` will be represented in another table in order to support multiple addresses per customer.

## `customer_addresses` table

- The only `NN` columns are `address_id`, `customer_id`, `country`, `city` and `street`

## `address_types` table

- This table is referred by the `customer_addresses` table
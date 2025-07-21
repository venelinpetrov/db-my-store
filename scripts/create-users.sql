-- Just an example, don't execute this script
-- Store passwords in .env or use secrets manager

-- web/desctop applicatoin
CREATE USER 'store_app'@'%' IDENTIFIED BY 'PaSsworD!'; -- @'%' connect from any host
GRANT SELECT, INSERT, UPDATE, DELETE, EXECUTE
ON my_store.*
TO 'store_app';

-- admin
CREATE USER 'admin'@'localhost' IDENTIFIED by 'SOME_STRONG_PASSWORD';
GRANT ALL PRIVILEGES
ON my_store.*
TO 'admin' WITH GRANT OPTION;
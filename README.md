# Rales Engine

###Summary
Rales Engine is a JSON API that exposes date for 6 database tables: Items, Merchants, Invoices, Invoice Items, Customers, and Transactions. 

###Configuration
Ruby Version 2.5.0
Bundle
Run test through RSPEC Suite : Command: rspec
Run imports through rake : Command: rake import:import_data

###Endpoints
The Rales Engine API Exposes Record, Relationship and Business Intelligence Endpoints. All endpoints currently sit in Api::V1

####_Record EndPoints_
Each resource has available the following Record Endpoints:
For the following I will use merchants as an example resource, though the same applies for items, invoices, invoice_items, transactions and customers:

*'/api/v1/merchants'
*'/api/v1/merchants/:id'
*'api/v1/merchants/find
*'/api/v1/merchants/find_all'
*'/api/v1/merchants/random'

####_Relationship Endpoints are as Follows:_

_Customers_
*'/api/v1/customers/:id/invoices'
*'/api/v1/customers/:id/transactions'

_Merchants_
*'/api/v1/merchants/:id/invoices'
*'/api/v1/merchants/:id/items'

_Items_
*'/api/v1/items/:id/invoice_items'
*'/api/v1/items/:id/merchant'

_Invoices_
*'/api/v1/invoices/:id/customer'
*'/api/v1/invoices/:id/merchant'
*'/api/v1/invoices/:id/invoice_items'
*'/api/v1/invoices/:id/items'
*'/api/v1/invoices/:id/transactions'

_Invoice Items_
*'/api/v1/invoice_items/:id/invoice'
*'/api/v1/invoice_items/:id/item'

_Transactions_
*'/api/v1/transactions/:id/invoice

####_Buiness Intelligence Endpoints_

_Merchants_

For the top X merchants ranked by total revenue: 
'/api/v1/merchants/most_revenue?quantity=X'

For the date with the greatest total revenue for all merchants:
'/api/v1/merchants/revenue?date=YYYY-MM-DD'

For the customer with the greatest total number of successful transactions in association with a merchant:
'/api/v1/merchants/:id/favorite_customer

For the customers who still having pending invoices (no successful transactions to date):
'/api/v1/merchants/:id/customers_with_pending_invoices'

_Items_

For the top X items ranked by total revenue:
'/api/v1/items/most_revenue?quantity=X'

For the date with the most sales for an item (if multiple days have the same number of sales return the most recent date):
'/api/v1/items/:id/best_day'

_Customers_

For the merchant with which the customer has conducted the most successful transactions:
'/api/v1/customers/:id/favorite_merchant'


# Rales Engine

### Summary
Rales Engine is a JSON API that exposes date for 6 database tables: Items, Merchants, Invoices, Invoice Items, Customers, and Transactions. 

![schema](/Users/mcat56/pictures/SCREEN SHOT 2019-11-24 AT 9.14.09 AM.png)

### Configuration
+ Ruby Version 2.5.0
+ Bundle
+ Run test through RSPEC Suite : Command: rspec
+ Run imports through rake : Command: rake import:import_data

### Endpoints
The Rales Engine API Exposes Record, Relationship and Business Intelligence Endpoints. All endpoints currently sit in Api::V1

#### __Record EndPoints__
Each resource has available the following Record Endpoints:
For the following I will use merchants as an example resource, though the same applies for items, invoices, invoice_items, transactions and customers:

* '/api/v1/merchants'
* '/api/v1/merchants/:id'
* 'api/v1/merchants/find
* '/api/v1/merchants/find_all'
* '/api/v1/merchants/random'

#### __Relationship Endpoints are as Follows:__

__Customers__
* '/api/v1/customers/:id/invoices'
* '/api/v1/customers/:id/transactions'

__Merchants__
* '/api/v1/merchants/:id/invoices'
* '/api/v1/merchants/:id/items'

__Items__
* '/api/v1/items/:id/invoice_items'
* '/api/v1/items/:id/merchant'

__Invoices__
* '/api/v1/invoices/:id/customer'
* '/api/v1/invoices/:id/merchant'
* '/api/v1/invoices/:id/invoice_items'
* '/api/v1/invoices/:id/items'
* '/api/v1/invoices/:id/transactions'

__Invoice Items__
* '/api/v1/invoice_items/:id/invoice'
* '/api/v1/invoice_items/:id/item'

__Transactions__
* '/api/v1/transactions/:id/invoice

#### __Buiness Intelligence Endpoints__

__Merchants__

For the top X merchants ranked by total revenue: 
* '/api/v1/merchants/most_revenue?quantity=X'

For the date with the greatest total revenue for all merchants:
* '/api/v1/merchants/revenue?date=YYYY-MM-DD'

For the customer with the greatest total number of successful transactions in association with a merchant:
* '/api/v1/merchants/:id/favorite_customer

For the customers who still having pending invoices (no successful transactions to date):
* '/api/v1/merchants/:id/customers_with_pending_invoices'

__Item__

For the top X items ranked by total revenue:
* '/api/v1/items/most_revenue?quantity=X'

For the date with the most sales for an item (if multiple days have the same number of sales return the most recent date):
* '/api/v1/items/:id/best_day'

__Customers__

For the merchant with which the customer has conducted the most successful transactions:
* '/api/v1/customers/:id/favorite_merchant'




### EndPoint Returns


__Customers__

    {
      "data": {
        "id": "1",
        "type": "customer",
        "attributes": {
          "id": 1,
          "first_name": "Joey",
          "last_name": "Ondricka"
        }
      }
    }

__Merchants__ 

    {
      "data": {
        "id": "1",
        "type": "merchant",
        "attributes": {
          "id": 1,
          "name": "Schroeder-Jerde"
        }
      }
    }

__Items__

    {
      "data": {
        "id": "1",
        "type": "item",
        "attributes": {
          "id": 1,
          "name": "Item Qui Esse",
          "description": "Nihil autem sit odio inventore deleniti. Est laudantium ratione distinctio laborum. Minus voluptatem     nesciunt assumenda dicta voluptatum porro.",
          "merchant_id": 1,
          "unit_price": "751.07"
        }
      }
    }

__Invoices__

    {
      "data": {
        "id": "1",
        "type": "invoice",
        "attributes": {
          "id": 1,
          "status": "shipped",
          "merchant_id": 26,
          "customer_id": 1
        }
      }
    }

__Invoice Items__

    {
      "data": {
        "id": "1",
        "type": "invoice_item",
        "attributes": {
          "id": 1,
          "quantity": 5,
          "invoice_id": 1,
          "item_id": 539,
          "unit_price": "136.35"
        }
      }
    }

__Transactions__
 
    {
      "data": {
        "id": "1",
        "type": "transaction",
        "attributes": {
          "id": 1,
          "result": "success",
          "invoice_id": 1,
          "credit_card_number": "4654405418249632"
        }
      }
    }







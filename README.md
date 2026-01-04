# NEXUS Market

A multi-tenant marketplace application built with Ruby on Rails, featuring tenant isolation, concurrent order processing, and cross-tenant commission handling.

Customers are scoped to a single shop to maintain tenant isolation. Cross-shop orders are not allowed to prevent data leakage and ensure stock and ledger integrity. Customers can register in multiple shops independently if desired.

## Setup Instructions

1. **Prerequisites**:
   - Ruby (3.2.2)
   - Rails
   - PostgreSQL (or your configured database)
   - Bundler

2. **Installation**:
   ```bash
   git clone 
   cd nexus_market
   bundle install
   ```

3. **Database Setup**:
   ```bash
   rails db:create
   rails db:migrate
   rails db:seed  # Optional: loads sample data
   ```

4. **Run the Application**:
   ```bash
   rails server
   ```
   Visit `http://localhost:3000` in your browser.

5. **Run Tests**:
   ```bash
   bundle exec rspec
   ```

## Architecture Notes

### Concurrency/Locking
To prevent overselling in high-concurrency scenarios (e.g., multiple users buying the last item simultaneously), we implement pessimistic locking:
- In `Product#decrement_stock!`, we use `with_lock` to lock the product record during stock decrement, ensuring atomic updates.
- In `OrderCreationService`, we use `Product.lock.find` to acquire a lock before checking and decrementing stock.
- This approach guarantees that only one transaction can modify stock at a time, avoiding race conditions as verified by the concurrency test in the integration suite.

### Cross-Tenant Commission Logic
The platform collects a 5% commission on all orders, stored in a centralized `Ledger` table:
- Commissions are calculated and recorded outside the tenant scope to maintain global financial tracking.
- The `Ledger` model belongs to `Order` but is not constrained by `acts_as_tenant`, allowing cross-tenant aggregation.
- This design ensures commissions are accurately captured regardless of tenant boundaries, while keeping order data tenant-isolated.

## Test Suite

All tests pass, covering models, services, controllers, and integration scenarios:
- **Model Tests**: Validate associations, validations, and business logic.
- **Service Tests**: Unit tests for `OrderCreationService`, ensuring proper order creation, stock handling, and ledger entries.
- **Integration Tests**: End-to-end checkout flow, multitenancy, concurrency prevention, and authentication.
- Run `bundle exec rspec` to execute the full suite (24 examples, 0 failures).

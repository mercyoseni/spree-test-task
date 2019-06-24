# Spree Test Task
- Spree Commerce Test Task to add a feature that will let admins upload products to the Spree database from a `.csv` file

## Getting Started

- Clone this repo `git clone https://github.com/mercyoseni/spree-test-task.git`
- Install the gem dependencies `bundle install`
- To setup database and run migrations `rails db:setup`
- To load seed data, run `bundle exec rake spree_sample:load`

- To run the app (use different tabs):
  - run `redis-server` to start Redis (You can install using `brew install redis`)
  - run `rails s` to start the server
  - run `bundle exec sidekiq` to run Sidekiq

## Import Products CSV
- Here is the [sample.csv](https://github.com/mercyoseni/spree-test-task/blob/master/public/sample.csv) file to import products.
  ```
  ;name;description;price;availability_date;slug;stock_total;category
  ;Ruby on Rails Bag;Animi officia aut amet molestiae atque excepturi. Placeat est cum occaecati molestiae quia. Ut soluta ipsum doloremque perferendis eligendi voluptas voluptatum.;22,99;2017-12-04T14:55:22.913Z;ruby-on-rails-bag;15;Bags
  ;Spree Bag;Rerum quaerat autem non nihil quo laborum aut hic. Iure adipisci neque eum qui dolor. Velit sed molestias nostrum et dolore. Amet sed repellendus quod et ad.;25,99;2017-12-04T14:55:22.913Z;spree-bag;5;Bags
  ;Spree Tote;Consequuntur quibusdam repellendus quia non. Iste et pariatur nulla fugit. In ipsum accusantium quasi mollitia et eos. Ullam veniam quis ut adipisci est autem molestiae eos. Ab necessitatibus et rerum quasi quia debitis eum.;14,99;2017-12-30T14:55:22.913Z;spree-tote;20;Bags
  ```

## Screenshots:
  ### Upload Product CSV modal
  <img width="1913" alt="Screenshot 2019-06-23 at 7 49 32 PM" src="https://user-images.githubusercontent.com/26272984/59980644-b30a5800-95f0-11e9-9eaf-51c850f6cdf2.png">

  ### The modal requires a file before submission
  <img width="1920" alt="Screenshot 2019-06-23 at 7 55 14 PM (2)" src="https://user-images.githubusercontent.com/26272984/59980675-13999500-95f1-11e9-83bb-5cb7cf67bfa6.png">

  #### When an Admin bypasses the frontend validation and submit, the page displays the related error message
  <img width="1920" alt="Screenshot 2019-06-23 at 7 56 37 PM (2)" src="https://user-images.githubusercontent.com/26272984/59980676-13999500-95f1-11e9-8a06-c5bc3da5515e.png">

  ### Product Import Report Page
  #### While the background job is running
  <img width="1920" alt="Screenshot 2019-06-24 at 4 37 35 AM (2)" src="https://user-images.githubusercontent.com/26272984/59990171-153b7b00-963a-11e9-95ec-3ff7914745ce.png">

  #### After the background job is completed
  <img width="1920" alt="Screenshot 2019-06-24 at 4 37 45 AM (2)" src="https://user-images.githubusercontent.com/26272984/59990173-153b7b00-963a-11e9-9110-faf437c79345.png">

## Tests
- To run the tests, run `rspec spec`

## Reference
- [Spree Github](https://github.com/spree/spree)
- [Spree Commerce Guides](https://guides.spreecommerce.org/)

# Spree Test Task
- Spree Commerce Test Task to add a feature that will let admins upload products to the Spree database from a `.csv` file

## Getting Started

- Clone this repo `git clone https://github.com/mercyoseni/spree-test-task.git`
- Install the gem dependencies `bundle install`
- To run migrations as well as adding seed and sample data and to copy frontend views for easy customization (if spree_frontend available) and also create admin user by default, run:

`rails g spree:install --user_class=Spree::User`

## Import Products CSV
- Here is the [sample.csv](https://github.com/mercyoseni/spree-test-task/blob/master/public/sample.csv) file to import products.
  ```
  ;name;description;price;availability_date;slug;stock_total;category
  ;Ruby on Rails Bag;Animi officia aut amet molestiae atque excepturi. Placeat est cum occaecati molestiae quia. Ut soluta ipsum doloremque perferendis eligendi voluptas voluptatum.;22,99;2017-12-04T14:55:22.913Z;ruby-on-rails-bag;15;Bags
  ;Spree Bag;Rerum quaerat autem non nihil quo laborum aut hic. Iure adipisci neque eum qui dolor. Velit sed molestias nostrum et dolore. Amet sed repellendus quod et ad.;25,99;2017-12-04T14:55:22.913Z;spree-bag;5;Bags
  ;Spree Tote;Consequuntur quibusdam repellendus quia non. Iste et pariatur nulla fugit. In ipsum accusantium quasi mollitia et eos. Ullam veniam quis ut adipisci est autem molestiae eos. Ab necessitatibus et rerum quasi quia debitis eum.;14,99;2017-12-30T14:55:22.913Z;spree-tote;20;Bags
  ```

### Screenshots:
  ### Upload Product CSV modal
  <img width="1913" alt="Screenshot 2019-06-23 at 7 49 32 PM" src="https://user-images.githubusercontent.com/26272984/59980644-b30a5800-95f0-11e9-9eaf-51c850f6cdf2.png">

  ### Product Import Report Page
  <img width="1919" alt="Screenshot 2019-06-23 at 7 50 10 PM" src="https://user-images.githubusercontent.com/26272984/59980645-b30a5800-95f0-11e9-93e7-9dc6436d2cd3.png">

  ### Upload Product CSV modal requires a file before submission
  <img width="1920" alt="Screenshot 2019-06-23 at 7 55 14 PM (2)" src="https://user-images.githubusercontent.com/26272984/59980675-13999500-95f1-11e9-83bb-5cb7cf67bfa6.png">

  #### When an Admin bypasses the frontend validation and submit, the admin is redirected to the Products page with the `No file chosen` error message
  <img width="1920" alt="Screenshot 2019-06-23 at 7 56 37 PM (2)" src="https://user-images.githubusercontent.com/26272984/59980676-13999500-95f1-11e9-8a06-c5bc3da5515e.png">

## Tests
- To run the tests, run `rspec spec`

## Reference
- [Spree Github](https://github.com/spree/spree)
- [Spree Commerce Guides](https://guides.spreecommerce.org/)

# README

## Rationale

### Data Fetching

Both endpoints rely heavily on the tree hierarchy imposed by the node object's `parent_id`.
As such, it is probably most efficient to query this hierarcy using a [recursive CTE](https://www.postgresql.org/docs/current/queries-with.html#QUERIES-WITH-RECURSIVE) in the database (postgresql in this example) rather than repeatedly querying the database, building model objects, etc. in the application.
I don't believe Rails natively supports this type of query (there is a `.with` AREL method that would do non-recursive CTE queries).

I made the choice to do the complete query and filtering (so only selecting root and the lowest common ancestor) and joining to other tables in the database.
The tradeoff here is that this doesn't provide generic fetches on the trees and might suggest that additional endpoints would each need to define their own queries.
If this were part of a larger app with other retrieval patterns it might make sense to fetch more from the database and instead do more filtering of results in the application.

This does provide the benefit of not over-fetching from the database which recently I've found to be a common problem in many of the legacy Rails applications I've worked on.
In these cases the Rails servers themselves could easily continue to be scaled horizontally so the database became the scaling bottleneck.
This lead to overly expensive database hosting costs or in some cases, running on the largest database server size available which then leads to trickier scaling techniques like leader write/follower read, sharding or moving to still more expensive database types like Google Spanner.

### API Parameters

The problem description suggests that API parameters (at least for the `/common_ancestor` endpoint) be passed in as http query parameters.
It wasn't specified but I went ahead and extended this to the `/birds` endpoint with a parameter named `node_ids` which takes a comma-separated list of node ids as a string.

I also added validation of parameter keys and value types which I don't believe Rails provides a particularly complete solution out of the box.
To assist with this I added the [dry-schema](https://dry-rb.org/gems/dry-schema/1.13/) gem and build and validate parameter schemas in the controllers.

## Application Info

* Ruby version: 3.3.0

* System dependencies: libpq must be installed and used to build the pg gem (MacOS):
```
$ brew install libpq
$ gem install pg -- --with-pg-include=/opt/homebrew/opt/libpq/include --with-pg-lib=/opt/homebrew/opt/libpq/lib
```

* Database creation: `rails db:create`

* Database initialization: `rails db:migrate`

* How to run the test suite: `rspec`

* How to run and validate with the development server:
```
$ rails db:seed
$ rails s
```
In another terminal:
```
$ curl 'localhost:3000/common_ancestor?a=5497637&b=2820230'
>> {"root_id":130,"lowest_common_ancestor_id":125,"depth":2}
$ curl 'localhost:3000/common_ancestor?a=5497637&b=130'
>> {"root_id":130,"lowest_common_ancestor_id":130,"depth":1}
$ curl 'localhost:3000/common_ancestor?a=5497637&b=4430546'
>> {"root_id":130,"lowest_common_ancestor_id":4430546,"depth":3
$ curl 'localhost:3000/common_ancestor?a=9&b=4430546'
>> {"root_id":null,"lowest_common_ancestor_id":null,"depth":null}
$ curl 'localhost:3000/common_ancestor?a=4430546&b=4430546'
>> {"root_id":130,"lowest_common_ancestor_id":4430546,"depth":3}

$ curl 'localhost:3000/birds?node_ids=130,125'
>> [1,2,3,4,5,6]
```

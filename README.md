# README for `greenhouse`

This is a proof-of-concept Samvera app running on updated `hydra-head` gems, capable of persisting objects to Fedora, PostGres, or migrate  in between.

## Persisting objects

### ActiveFedora

```ruby
a = GenericWork.create(title: "Assault on Precinct 13")
```

#### Output
```ruby
  Load LDP (130.2ms) http://127.0.0.1:8984/rest/dev/f3/f9/6c/fb/f3f96cfb-694c-422e-b08f-7ff2661b5db1 Service: 70347390512740
=> #<GenericWork id: "f3/f9/6c/fb/f3f96cfb-694c-422e-b08f-7ff2661b5db1", title: "Assault on Precinct 13", unique_identifier: nil>
```

```ruby
a.save!
a.update_index # Update the Solr index
```
### Fedora adapter

```ruby
fedora = Valkyrie::MetadataAdapter.find(:fedora)

b = fedora.query_service.find_by(id: "f3f96cfb-694c-422e-b08f-7ff2661b5db1")

postgres.persister.save(resource: b)
```

#### Output 

```ruby
SQL (1.9ms)  INSERT INTO "orm_resources" ("id", "metadata", "created_at", "updated_at") VALUES ($1, $2, $3, $4) RETURNING "id"  [["id", "f3f96cfb-694c-422e-b08f-7ff2661b5db1"], ["metadata", "{\"title\":\"Assault on Precinct 13\",\"info:fedora/fedora-system:def/model#hasModel\":\"GenericWork\",\"id\":{\"id\":\"f3f96cfb-694c-422e-b08f-7ff2661b5db1\"},\"new_record\":false}"], ["created_at", "2019-04-17 15:08:27.435989"], ["updated_at", "2019-04-17 15:08:27.435989"]]
   (1.2ms)  COMMIT
=> #<Valkyrie::GenericWork id=#<Valkyrie::ID:0x007ff604eb5d28 @id="f3f96cfb-694c-422e-b08f-7ff2661b5db1"> internal_resource="Valkyrie::GenericWork" created_at=Wed, 17 Apr 2019 15:08:27 UTC +00:00 updated_at=Wed, 17 Apr 2019 15:08:27 UTC +00:00 new_record=false title="Assault on Precinct 13" unique_identifier=nil resource_type=nil alternate_identifiers=nil>
```

### PostGres

```ruby
postgres = Valkyrie::MetadataAdapter.find(:postgres)
solr = Valkyrie::MetadataAdapter.find(:solr)
solr.persister.save(resource: postgres.query_service.find_by(id: "f3f96cfb-694c-422e-b08f-7ff2661b5db1"))
```

#### Output 

```ruby
Valkyrie::Persistence::Postgres::ORM::Resource Load (0.4ms)  SELECT  "orm_resources".* FROM "orm_resources" WHERE "orm_resources"."id" = $1 LIMIT $2  [["id", "f3f96cfb-694c-422e-b08f-7ff2661b5db1"], ["LIMIT", 1]]
=> #<Valkyrie::GenericWork id=#<Valkyrie::ID:0x007ff60c1d15a0 @id="f3f96cfb-694c-422e-b08f-7ff2661b5db1"> internal_resource="Valkyrie::GenericWork" created_at=2019-04-17 15:08:27 UTC updated_at=2019-04-17 15:11:18 UTC new_record=false title="Assault on Precinct 13" unique_identifier=nil resource_type=nil alternate_identifiers=nil>
```

### Access

* PostGres version - [http://localhost:3000/catalog/f3f96cfb-694c-422e-b08f-7ff2661b5db1](http://localhost:3000/catalog/f3%2Ff9%2F6c%2Ffb%2Ff3f96cfb-694c-422e-b08f-7ff2661b5db1)

* Fedora version (note leading slashes) - [http://localhost:3000/catalog/f3%2Ff9%2F6c%2Ffb%2Ff3f96cfb-694c-422e-b08f-7ff2661b5db1](http://localhost:3000/catalog/f3%2Ff9%2F6c%2Ffb%2Ff3f96cfb-694c-422e-b08f-7ff2661b5db1)

### Removing stale versions 

```ruby
 GenericWork.find("f3/f9/6c/fb/f3f96cfb-694c-422e-b08f-7ff2661b5db1")
 solr.persister.delete(resource: a)
```

#### Output 

```ruby 
=> #<GenericWork id: "f3/f9/6c/fb/f3f96cfb-694c-422e-b08f-7ff2661b5db1", title: "Assault on Precinct 13", unique_identifier: nil>
```
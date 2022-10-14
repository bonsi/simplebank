postgres:
	docker-compose up -d

createdb:
	docker-compose exec -it postgres createdb --username=postgres --owner=postgres simple_bank

dropdb:
	docker-compose exec -it postgres dropdb --username=postgres simple_bank

migrateup:
	migrate -path db/migration -database "postgresql://postgres:secret@localhost:5432/simple_bank?sslmode=disable" -verbose up

migratedown:
	migrate -path db/migration -database "postgresql://postgres:secret@localhost:5432/simple_bank?sslmode=disable" -verbose down

.PHONY: postgres createdb dropdb migrateup migratedown
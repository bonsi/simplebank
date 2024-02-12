postgres:
	# docker-compose up -d
	docker run --name postgres16 -p 5432:5432 -e POSTGRES_USER=root -e POSTGRES_PASSWORD=secret -d postgres:16-alpine

createdb:
	#docker-compose exec -it postgres createdb --username=postgres --owner=postgres simple_bank
	docker exec -it postgres16 createdb --username=root --owner=root simple_bank

dropdb:
	#docker-compose exec -it postgres dropdb --username=postgres simple_bank
	docker exec -it postgres16 dropdb simple_bank

migrateup:
	migrate -path db/migration -database "postgresql://root:secret@localhost:5432/simple_bank?sslmode=disable" -verbose up

migratedown:
	migrate -path db/migration -database "postgresql://root:secret@localhost:5432/simple_bank?sslmode=disable" -verbose down

sqlc:
	sqlc generate

generate:
	sqlc generate

test:
	go test -v -cover ./...

.PHONY: postgres createdb dropdb migrateup migratedown generate sqlc test

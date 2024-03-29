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

migrateup1:
	migrate -path db/migration -database "postgresql://root:secret@localhost:5432/simple_bank?sslmode=disable" -verbose up 1

migratedown:
	migrate -path db/migration -database "postgresql://root:secret@localhost:5432/simple_bank?sslmode=disable" -verbose down

migratedown1:
	migrate -path db/migration -database "postgresql://root:secret@localhost:5432/simple_bank?sslmode=disable" -verbose down 1

sqlc:
	sqlc generate

generate:
	sqlc generate

test:
	go test -v -cover ./...

server:
	go run main.go

mock:
	mockgen -package mockdb -destination db/mock/store.go --build_flags=--mod=mod github.com/bonsi/simplebank/db/sqlc Store


.PHONY: postgres createdb dropdb migrateup migratedown generate sqlc test server mock migratedown1 migrateup1

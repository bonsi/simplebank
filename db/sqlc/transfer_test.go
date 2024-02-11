package db

import (
	"context"
	"testing"
	"time"

	"github.com/bonsi/simplebank/util"
	"github.com/stretchr/testify/require"
)

type CreateTransferOptions struct {
	fromAccountID, toAccountID int64
}

func createRandomTransfer(t *testing.T, o CreateTransferOptions) Transfer {
	var fromAccountID, toAccountID int64
	if o.fromAccountID == 0 {
		fromAccount := createRandomAccount(t)
		fromAccountID = fromAccount.ID
	} else {
		fromAccountID = o.fromAccountID
	}
	if o.toAccountID == 0 {
		toAccount := createRandomAccount(t)
		toAccountID = toAccount.ID
	} else {
		toAccountID = o.toAccountID
	}

	arg := CreateTransferParams{
		FromAccountID: fromAccountID,
		ToAccountID:   toAccountID,
		Amount:        util.RandomMoney(),
	}

	transfer, err := testQueries.CreateTransfer(context.Background(), arg)
	require.NoError(t, err)
	require.NotEmpty(t, transfer)
	require.Equal(t, arg.FromAccountID, transfer.FromAccountID)
	require.Equal(t, arg.ToAccountID, transfer.ToAccountID)
	require.Equal(t, arg.Amount, transfer.Amount)

	require.NotZero(t, transfer.ID)
	require.NotZero(t, transfer.CreatedAt)

	return transfer
}

func TestCreateTransfer(t *testing.T) {
	createRandomTransfer(t, CreateTransferOptions{})
}

func TestGetTransfer(t *testing.T) {
	transfer1 := createRandomTransfer(t, CreateTransferOptions{})
	transfer2, err := testQueries.GetTransfer(context.Background(), transfer1.ID)
	require.NoError(t, err)
	require.NotEmpty(t, transfer2)

	require.Equal(t, transfer1.ID, transfer2.ID)
	require.Equal(t, transfer1.FromAccountID, transfer2.FromAccountID)
	require.Equal(t, transfer1.ToAccountID, transfer2.ToAccountID)
	require.Equal(t, transfer1.Amount, transfer2.Amount)
	require.WithinDuration(t, transfer1.CreatedAt, transfer2.CreatedAt, time.Second)
}

func TestListTransfers(t *testing.T) {
	account1 := createRandomAccount(t)
	account2 := createRandomAccount(t)
	for i := 0; i < 10; i++ {
		createRandomTransfer(t, CreateTransferOptions{fromAccountID: account1.ID, toAccountID: account2.ID})
	}

	arg := ListTransfersParams{
		FromAccountID: account1.ID,
		ToAccountID:   account2.ID,
		Limit:         5,
		Offset:        5,
	}

	transfers, err := testQueries.ListTransfers(context.Background(), arg)
	require.NoError(t, err)
	require.Len(t, transfers, 5)

	for _, transfer := range transfers {
		require.NotEmpty(t, transfer)
	}
}

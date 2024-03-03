package main_test

import (
	"errors"
	"fmt"
	"testing"

	"github.com/stretchr/testify/assert"
)

type Hoge struct {
	x int
	y int
}

func TestHoge(t *testing.T) {
	x := []string{"hoge", "piyo"}
	fmt.Println(x)
	assert.NoError(t, errors.New("hoge"))
}

func TestPiyo(t *testing.T) {
	x := []string{"hoge", "piyo"}
	fmt.Println(x)
}

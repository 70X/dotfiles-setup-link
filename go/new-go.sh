#! /bin/bash

GO_VERSION_REQUIRED="1.23.5"

# Check if project name is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <project_name>"
    exit 1
fi

PROJECT_NAME="$1"

if ! command -v go &> /dev/null; then
    echo "Go is not installed. Please install Go $GO_VERSION_REQUIRED."
    exit 1
fi

GO_VERSION_INSTALLED=$(go version | awk '{print $3}' | sed 's/go//')
if [ "$GO_VERSION_INSTALLED" != "$GO_VERSION_REQUIRED" ]; then
    echo "Go version $GO_VERSION_REQUIRED is required, but found $GO_VERSION_INSTALLED."
    exit 1
fi

echo "Go version $GO_VERSION_REQUIRED is installed."

mkdir -p "$PROJECT_NAME"
cd "$PROJECT_NAME" || exit

go mod init "$PROJECT_NAME"

cat <<EOF > main.go
package main

import "fmt"

func double(n int) int {
    return n * 2
}

func main() {
    fmt.Println("Hello, Go!")
    fmt.Println("Double of 5 is:", double(5))
}
EOF

# Create main_test.go
cat <<EOF > main_test.go
package main

import "testing"

func TestDouble(t *testing.T) {
    result := double(5)
    expected := 10
    if result != expected {
        t.Errorf("double(5) = %d; want %d", result, expected)
    }
}
EOF

# Run the Go program
echo "Running the Go program..."
go run main.go

# Run tests
echo "Running tests..."
go test -v
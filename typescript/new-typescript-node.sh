#!/bin/bash

if [ -n "$1" ]; then
	mkdir -p "$1"
	cd "$1"
fi

echo "Initializing npm project..."
npm init -y

echo "Installing TypeScript..."
npm install typescript --save-dev

echo "Creating tsconfig.json..."
cat > tsconfig.json << 'EOF'
{
	"compilerOptions": {
	"target": "es2016",
	"module": "commonjs",
	"outDir": "./dist",
	"esModuleInterop": true,
	"forceConsistentCasingInFileNames": true,
	"strict": true,
	"skipLibCheck": true
},
"include": ["src/**/*"],
"exclude": ["node_modules", "**/*.test.ts"]
}
EOF

echo "Installing ESLint and related packages..."
npm install eslint@8 @typescript-eslint/eslint-plugin@5 @typescript-eslint/parser@5 --save-dev

echo "Creating .eslintrc.json..."
cat > .eslintrc.json << 'EOF'
{
	"extends": [
		"eslint:recommended",
		"plugin:@typescript-eslint/recommended",
		"plugin:prettier/recommended"
	],
	"parser": "@typescript-eslint/parser",
	"plugins": ["@typescript-eslint"],
	"root": true
}
EOF

echo "Installing Prettier and related packages..."
npm install prettier eslint-config-prettier eslint-plugin-prettier --save-dev

echo "Creating .prettierrc..."
cat > .prettierrc << 'EOF'
{
	"semi": true,
	"trailingComma": "all",
	"singleQuote": true,
	"printWidth": 120,
	"tabWidth": 2
}
EOF

echo "Installing Mocha and related packages..."
npm install mocha @types/mocha ts-node chai @types/chai --save-dev

echo "Updating package.json scripts..."
node -e '
const fs = require("fs");
const packageJson = JSON.parse(fs.readFileSync("package.json"));
packageJson.scripts = {
	...packageJson.scripts,
	"test": "mocha -r ts-node/register \"**/\*.spec.ts\"",
	"lint": "eslint . --ext .ts",
	"format": "prettier --write \"**/\*.ts\"",
	"build": "tsc"
};
fs.writeFileSync("package.json", JSON.stringify(packageJson, null, 2));
'

echo "Creating folder structure..."
mkdir -p src src/__test__

echo "Creating sample source file..."
cat > src/index.ts << 'EOF'
export function greet(name: string): string {
  return `Hello, ${name}!`;
}
EOF

echo "Creating sample test file..."
cat > src/__test__/index.spec.ts << 'EOF'
import { expect } from 'chai';
import { greet } from '../index';

describe('Greet function', () => {
  it('should return greeting with name', () => {
    expect(greet('World')).to.equal('Hello, World!');
  });
});
EOF

echo "Creating .gitignore..."
cat > .gitignore << 'EOF'
node_modules/
dist/
coverage/
.DS_Store
\*.log
EOF

echo "Setup complete! Your TypeScript project has been initialized with ESLint, Prettier, and Mocha."
echo "Run 'npm test' to execute tests."

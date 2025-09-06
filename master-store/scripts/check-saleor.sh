#!/bin/bash

echo "🔍 Checking Saleor data..."

# Check channels
echo -e "\n📺 Channels:"
curl -s -X POST http://localhost:8000/graphql/ \
  -H "Content-Type: application/json" \
  -d '{"query":"{ channels { slug name currencyCode } }"}' | python3 -m json.tool

# Check categories
echo -e "\n📁 Categories:"
curl -s -X POST http://localhost:8000/graphql/ \
  -H "Content-Type: application/json" \
  -d '{"query":"{ categories(first: 10) { edges { node { name slug } } } }"}' | python3 -m json.tool

# Check products in default channel
echo -e "\n📦 Products in default-channel:"
curl -s -X POST http://localhost:8000/graphql/ \
  -H "Content-Type: application/json" \
  -d '{"query":"{ products(first: 10, channel: \"default-channel\") { edges { node { name slug } } } }"}' | python3 -m json.tool

# Check product types
echo -e "\n🏷️ Product Types:"
curl -s -X POST http://localhost:8000/graphql/ \
  -H "Content-Type: application/json" \
  -d '{"query":"{ productTypes(first: 10) { edges { node { name slug } } } }"}' | python3 -m json.tool
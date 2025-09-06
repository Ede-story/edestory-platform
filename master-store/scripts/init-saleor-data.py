#!/usr/bin/env python3
"""
Initialize Saleor with test data for Ede-story shop
"""

import requests
import json

GRAPHQL_URL = "http://localhost:8000/graphql/"
CHANNEL_SLUG = "default-channel"

# GraphQL queries and mutations
CREATE_CATEGORY = """
mutation CreateCategory($input: CategoryInput!) {
  categoryCreate(input: $input) {
    category {
      id
      name
      slug
    }
    errors {
      field
      message
    }
  }
}
"""

CREATE_PRODUCT_TYPE = """
mutation CreateProductType($input: ProductTypeInput!) {
  productTypeCreate(input: $input) {
    productType {
      id
      name
      slug
    }
    errors {
      field
      message
    }
  }
}
"""

CREATE_PRODUCT = """
mutation CreateProduct($input: ProductInput!) {
  productCreate(input: $input) {
    product {
      id
      name
      slug
    }
    errors {
      field
      message
    }
  }
}
"""

CREATE_PRODUCT_VARIANT = """
mutation CreateVariant($input: ProductVariantInput!) {
  productVariantCreate(input: $input) {
    productVariant {
      id
      name
      sku
    }
    errors {
      field
      message
    }
  }
}
"""

UPDATE_CHANNEL_LISTING = """
mutation UpdateChannelListing($id: ID!, $input: ProductChannelListingUpdateInput!) {
  productChannelListingUpdate(id: $id, input: $input) {
    product {
      id
      name
    }
    errors {
      field
      message
    }
  }
}
"""

def execute_query(query, variables=None):
    """Execute a GraphQL query"""
    response = requests.post(
        GRAPHQL_URL,
        json={"query": query, "variables": variables or {}},
        headers={"Content-Type": "application/json"}
    )
    return response.json()

def create_categories():
    """Create product categories"""
    categories = [
        {"name": "Electronics", "slug": "electronics"},
        {"name": "Fashion", "slug": "fashion"},
        {"name": "Home & Garden", "slug": "home-garden"},
        {"name": "Sports", "slug": "sports"},
        {"name": "Beauty", "slug": "beauty"},
    ]
    
    created_categories = []
    for cat in categories:
        result = execute_query(CREATE_CATEGORY, {"input": cat})
        if result.get("data", {}).get("categoryCreate", {}).get("category"):
            created_categories.append(result["data"]["categoryCreate"]["category"])
            print(f"✅ Created category: {cat['name']}")
        else:
            print(f"❌ Failed to create category: {cat['name']}")
    
    return created_categories

def create_product_types():
    """Create product types"""
    types = [
        {
            "name": "Physical Product",
            "slug": "physical-product",
            "hasVariants": True,
            "isShippingRequired": True,
            "weight": "KG"
        }
    ]
    
    created_types = []
    for ptype in types:
        result = execute_query(CREATE_PRODUCT_TYPE, {"input": ptype})
        if result.get("data", {}).get("productTypeCreate", {}).get("productType"):
            created_types.append(result["data"]["productTypeCreate"]["productType"])
            print(f"✅ Created product type: {ptype['name']}")
        else:
            print(f"❌ Failed to create product type: {ptype['name']}")
    
    return created_types

def create_sample_products(category_id, product_type_id):
    """Create sample products"""
    products = [
        {
            "name": "Smartwatch Deportivo Bluetooth 5.0",
            "slug": "smartwatch-deportivo",
            "category": category_id,
            "productType": product_type_id,
            "description": json.dumps({
                "blocks": [{
                    "type": "paragraph",
                    "data": {
                        "text": "Reloj inteligente con monitor de frecuencia cardíaca, GPS, resistente al agua IP68. Envío desde España en 1-3 días."
                    }
                }]
            })
        },
        {
            "name": "Auriculares Inalámbricos TWS Pro",
            "slug": "auriculares-tws-pro",
            "category": category_id,
            "productType": product_type_id,
            "description": json.dumps({
                "blocks": [{
                    "type": "paragraph",
                    "data": {
                        "text": "Auriculares bluetooth con cancelación de ruido activa, 30h de batería. Stock en almacén de Barcelona."
                    }
                }]
            })
        },
        {
            "name": "Power Bank 20000mAh Carga Rápida",
            "slug": "power-bank-20000",
            "category": category_id,
            "productType": product_type_id,
            "description": json.dumps({
                "blocks": [{
                    "type": "paragraph",
                    "data": {
                        "text": "Batería externa con carga rápida 22.5W, 3 puertos USB, pantalla LED. Envío inmediato desde Madrid."
                    }
                }]
            })
        },
        {
            "name": "Funda Móvil Premium Cuero PU",
            "slug": "funda-movil-premium",
            "category": category_id,
            "productType": product_type_id,
            "description": json.dumps({
                "blocks": [{
                    "type": "paragraph",
                    "data": {
                        "text": "Funda de cuero sintético premium con soporte y ranuras para tarjetas. Disponible para todos los modelos."
                    }
                }]
            })
        },
        {
            "name": "Lámpara LED Ring Light 26cm",
            "slug": "lampara-ring-light",
            "category": category_id,
            "productType": product_type_id,
            "description": json.dumps({
                "blocks": [{
                    "type": "paragraph",
                    "data": {
                        "text": "Aro de luz LED regulable con trípode extensible, ideal para streaming y fotografía."
                    }
                }]
            })
        }
    ]
    
    created_products = []
    for product in products:
        result = execute_query(CREATE_PRODUCT, {"input": product})
        if result.get("data", {}).get("productCreate", {}).get("product"):
            created_product = result["data"]["productCreate"]["product"]
            created_products.append(created_product)
            print(f"✅ Created product: {product['name']}")
            
            # Create a variant for the product
            variant_input = {
                "product": created_product["id"],
                "sku": f"SKU-{created_product['slug']}",
                "name": "Default",
                "trackInventory": True,
                "stocks": [{
                    "warehouse": "V2FyZWhvdXNlOjEyMzQ1Njc4OQ==",  # This needs to be a real warehouse ID
                    "quantity": 100
                }]
            }
            
            # For now, we'll skip variant creation as it requires warehouse setup
            
            # Update channel listing to make product visible
            channel_input = {
                "updateChannels": [{
                    "channelId": "Q2hhbm5lbDox",  # Default channel ID
                    "isPublished": True,
                    "isAvailableForPurchase": True,
                    "visibleInListings": True
                }]
            }
            
            # Skip channel update for now as it requires proper channel ID
            
        else:
            print(f"❌ Failed to create product: {product['name']}")
            if result.get("data", {}).get("productCreate", {}).get("errors"):
                print(f"   Errors: {result['data']['productCreate']['errors']}")
    
    return created_products

def main():
    print("\n🚀 Initializing Saleor with test data...\n")
    
    # Create categories
    categories = create_categories()
    if not categories:
        print("⚠️ No categories created, skipping products")
        return
    
    # Create product types
    product_types = create_product_types()
    if not product_types:
        print("⚠️ No product types created, skipping products")
        return
    
    # Create sample products
    products = create_sample_products(
        categories[0]["id"],
        product_types[0]["id"]
    )
    
    print(f"\n✨ Initialization complete!")
    print(f"   - Created {len(categories)} categories")
    print(f"   - Created {len(product_types)} product types")
    print(f"   - Created {len(products)} products")
    print(f"\n🌐 Visit http://localhost:3000/default-channel to see your shop!")

if __name__ == "__main__":
    main()
const { Server } = require('@modelcontextprotocol/sdk');
const { GraphQLClient } = require('graphql-request');

class SaleorMCPServer extends Server {
  constructor() {
    super();
    this.name = 'saleor-mcp-server';
    this.version = '1.0.0';
    this.saleorClient = new GraphQLClient(
      process.env.SALEOR_API_URL,
      {
        headers: {
          Authorization: `Bearer ${process.env.SALEOR_AUTH_TOKEN}`,
        },
      }
    );
  }

  async initialize() {
    this.registerTool('query_products', this.queryProducts.bind(this));
    this.registerTool('create_product', this.createProduct.bind(this));
    this.registerTool('update_inventory', this.updateInventory.bind(this));
    this.registerTool('get_orders', this.getOrders.bind(this));
  }

  async queryProducts({ search, first = 10 }) {
    const query = `
      query GetProducts($search: String, $first: Int) {
        products(first: $first, filter: { search: $search }) {
          edges {
            node {
              id
              name
              description
              pricing {
                priceRange {
                  start {
                    gross {
                      amount
                      currency
                    }
                  }
                }
              }
            }
          }
        }
      }
    `;
    return await this.saleorClient.request(query, { search, first });
  }

  async createProduct({ name, description, price }) {
    // Implementation for creating product
    return { success: true, message: `Product ${name} created` };
  }

  async updateInventory({ productId, quantity }) {
    // Implementation for updating inventory
    return { success: true, message: `Inventory updated for ${productId}` };
  }

  async getOrders({ status }) {
    // Implementation for getting orders
    return { success: true, orders: [] };
  }
}

// Start server
const server = new SaleorMCPServer();
server.start();

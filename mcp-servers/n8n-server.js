const { Server } = require('@modelcontextprotocol/sdk');
const axios = require('axios');

class N8nMCPServer extends Server {
  constructor() {
    super();
    this.name = 'n8n-mcp-server';
    this.version = '1.0.0';
    this.n8nClient = axios.create({
      baseURL: process.env.N8N_API_URL,
      headers: {
        'X-N8N-API-KEY': process.env.N8N_API_KEY,
      },
    });
  }

  async initialize() {
    this.registerTool('trigger_workflow', this.triggerWorkflow.bind(this));
    this.registerTool('get_workflows', this.getWorkflows.bind(this));
    this.registerTool('get_executions', this.getExecutions.bind(this));
  }

  async triggerWorkflow({ workflowId, data }) {
    const response = await this.n8nClient.post(
      `/webhook/${workflowId}`,
      data
    );
    return response.data;
  }

  async getWorkflows() {
    const response = await this.n8nClient.get('/workflows');
    return response.data;
  }

  async getExecutions({ workflowId }) {
    const response = await this.n8nClient.get(
      `/executions?workflowId=${workflowId}`
    );
    return response.data;
  }
}

// Start server
const server = new N8nMCPServer();
server.start();

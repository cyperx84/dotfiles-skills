---
name: API Doc Generator
description: >
  Activate when user says "generate API docs", "create swagger spec", "document endpoints",
  "OpenAPI from code", "API reference", or needs to document REST APIs. Auto-generates
  API documentation from code annotations, creates OpenAPI specs, and builds interactive
  documentation with examples and error codes.
tools:
  - Bash
  - Read
  - Write
  - Grep
  - Glob
version: 1.0.0
author: Dotfiles Skills
---

# API Doc Generator Skill

## Overview

The API Doc Generator automates API documentation creation. Manually writing API docs is tedious - documenting every endpoint, parameter, response type, and error code. This skill scans your code, extracts API definitions, generates beautiful documentation, and keeps it synchronized with code changes.

## Prerequisites

### Required Tools
- **Node.js** - For npm-based doc generators (`brew install node`)
- **jq** - JSON processing (`brew install jq`)

### Optional Tools (per framework)
- **swagger-cli** - OpenAPI validation (`npm install -g @apidevtools/swagger-cli`)
- **redoc-cli** - Interactive docs (`npm install -g redoc-cli`)
- **spectral** - API linting (`npm install -g @stoplight/spectral-cli`)

### Verification
```bash
# Check core prerequisites
command -v node >/dev/null && echo "✓ node" || echo "✗ node missing"
command -v jq >/dev/null && echo "✓ jq" || echo "✗ jq missing"
```

### Environment
- Node.js 16+ recommended
- Project with detectable API framework (Express, FastAPI, Gin, etc.)
- Git repository (for tracking doc changes)

## When to Use This Skill

Activate when the user:
- Needs to document API endpoints
- Wants to generate OpenAPI/Swagger specs
- Is creating API reference docs
- Needs to update outdated documentation
- Mentions keywords like: "API docs", "document endpoints", "generate swagger", "API reference"

## Workflow

### Phase 1: API Discovery

**Scan for API Definitions**:

```bash
# Detect API frameworks
detect_api_framework() {
  grep -q "express" package.json && echo "express"
  grep -q "fastapi" requirements.txt && echo "fastapi"
  grep -q "actix-web" Cargo.toml && echo "actix-web"
  grep -q "gin" go.mod && echo "gin"
}
```

**Extract Endpoints**:

```bash
# Parse routes from code
extract_express_routes() {
  grep -r "app\.\(get\|post\|put\|delete\)" . \
    --include="*.js" --include="*.ts" \
    | sed 's/.*\.\(get\|post\|put\|delete\)(\([^,]*\).*/\U\1\E \2/'
}
```

### Phase 2: Documentation Generation

**Generate OpenAPI Spec**:

```bash
generate_openapi() {
  cat > openapi.yaml << 'EOF'
openapi: 3.0.0
info:
  title: ${API_TITLE}
  version: 1.0.0
paths:
  /api/users:
    get:
      summary: List users
      responses:
        '200':
          description: Success
EOF
}
```

**Create Interactive Docs**:

```bash
# Generate Swagger UI
npm install swagger-ui-express
# Generate Redoc
npm install redoc-cli
```

### Phase 3: Example Generation

**Auto-generate Examples**:

```bash
create_examples() {
  # cURL examples
  echo "curl -X GET https://api.example.com/users"

  # Response examples
  echo '{"users": [{"id": 1, "name": "John"}]}'
}
```

## Guidelines

### DO:
✅ Extract from code comments
✅ Generate request/response examples
✅ Include error codes
✅ Keep docs synchronized with code
✅ Support multiple output formats

### DON'T:
❌ Generate docs without validation
❌ Skip error documentation
❌ Ignore deprecated endpoints

## Error Handling

### Framework Not Detected
**Symptom**: "Could not detect API framework"
**Cause**: Project uses non-standard framework or custom routing
**Resolution**:
1. Check for supported frameworks (Express, FastAPI, Gin, Actix-web)
2. Manually specify framework with environment variable
3. Use annotation-based extraction if auto-detection fails

### Missing Type Information
**Symptom**: "Cannot infer request/response types"
**Cause**: Dynamic typing or missing type annotations
**Resolution**:
1. Add JSDoc comments or TypeScript types to endpoints
2. Use Pydantic models for FastAPI
3. Provide example requests/responses manually

### Invalid OpenAPI Spec
**Symptom**: "OpenAPI validation failed"
**Cause**: Generated spec has structural issues
**Resolution**:
1. Run `swagger-cli validate openapi.yaml` for details
2. Fix missing required fields (paths, info, etc.)
3. Validate schema references exist

## Limitations

This skill:
- ❌ Cannot document internal/private APIs automatically
- ❌ Does not support GraphQL (REST/OpenAPI only)
- ❌ Cannot infer authentication without annotations
- ❌ May miss dynamically generated routes
- ❌ Does not generate SDK clients (documentation only)
- ❌ Requires code annotations for complete accuracy

## Success Metrics

- ✅ All endpoints documented
- ✅ Examples included
- ✅ Types/schemas defined
- ✅ Error codes documented
- ✅ < 2 minutes generation time

## Version History

- v1.0.0 (2025-10-30): Initial release

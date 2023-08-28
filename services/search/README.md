# Search Service

## Description

This implements the search service for the excel academy project.
This makes use of typesense as a search engine.

The project is made of the following components:

- **search-service**: This is the search service that exposes the search API.
- **search-indexer**: This is the search indexer that indexes the data from the
database into the search engine.
- **search-indexer-cronjob**: This is the cronjob that runs the indexer periodically.

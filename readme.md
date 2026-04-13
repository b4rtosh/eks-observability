# EKS Observability Platform for FastAPI

This repository is a maintained fork of the original demo project:

- Upstream source: `https://github.com/blueswen/fastapi-observability`
- Upstream license: MIT (`LICENSE`)

## Fork Baseline and Ownership

This fork preserves upstream attribution and establishes a new delivery baseline.

- Baseline origin: application foundation from `blueswen/fastapi-observability`
- Baseline commit in this fork: `4f3f08423af844a657b76eb8589e5e2cb4ab8059`
- Ownership statement: all commits after the baseline commit are implementation work in this fork

## Project Intent

Production-oriented FastAPI deployment on Amazon EKS with a complete observability stack:

- OpenTelemetry (instrumentation and OTLP export)
- Prometheus (metrics storage and scraping)
- Loki (log aggregation)
- Tempo (distributed tracing backend)
- Grafana (unified dashboards and correlation across logs, metrics, and traces)

## Target Architecture

1. `fastapi_app` emits telemetry using OpenTelemetry SDK and auto/manual instrumentation.
2. Telemetry is sent to OpenTelemetry Collector running in EKS.
3. Collector pipelines route data by signal:
	- Metrics -> Prometheus (remote write or scrape integration)
	- Logs -> Loki
	- Traces -> Tempo
4. Grafana consumes Prometheus, Loki, and Tempo as data sources.
5. Dashboards, alerts, and SLOs are managed as code.

## Local Development (Application)

From `fastapi_app/`:

```bash
uv sync
uv run main.py
```

## Acknowledgment

The original FastAPI observability demo application was created by the upstream project maintainer(s) at `blueswen/fastapi-observability`.
This fork extends that baseline for enterprise-grade EKS and observability platform implementation.
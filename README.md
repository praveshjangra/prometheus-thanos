# The Complete Monitoring Journey — Single Guide

**One document for everything** — share this single file with your team. Includes Parts 1–7 plus Appendices A–D (all former `docs/*.md` content).

| Part | Read when | Contents |
|---|---|---|
| **[7-day curriculum](#7-day-learning-curriculum)** | **Start here to plan** | ~18–22 h over one week, day-by-day tasks |
| **[Part 1: Learn](#part-1)** | First — zero prior Prometheus OK | Story, steps 0–10, Operator vs STS, Thanos |
| **[Part 2: Deploy & practice](#part-2)** | Ready to run the lab | Runbook, commands, practice checklist |
| **[Part 3: Reference tables](#part-3)** | Need field-level YAML detail | CR fields, dependencies, sizing |
| **[Part 4: Deep dive](#part-4)** | "How does config really work?" | Generated prometheus.yml, relabel, AM lifecycle |
| **[Part 5: Interview Q&A](#part-5)** | Review / interview prep | How / what / why tables |
| **[Part 6: Troubleshooting](#part-6)** | Something broke | Decision tree, matrix, debug commands |
| **[Part 7: Production](#part-7)** | Going beyond kind | Checklist, multi-team, routing patterns |
| **[Appendix A](#appendix-a)** | Which YAML file? | Manifest index `00–13` + Thanos |
| **[Appendix B](#appendix-b)** | Extended reference | Quick ref, recording rules, Staff playbook |
| **[Appendix C](#appendix-c)** | Config lookup | Full config/relabel/Alertmanager deep dive |
| **[Appendix D](#appendix-d)** | kind runbook | Deploy/validate command cheat sheet |


---

## 7-day learning curriculum

**One week to learn this stack:** ~18–22 hours total (~2.5–3 hours per day).

| | |
|---|---|
| **Prerequisites** | `kubectl`, Pods/Services/Deployments, port-forward, basic YAML. No prior Prometheus required. |
| **Cluster** | kind (`kind-otel-test` or your cluster name) |
| **Repo root** | `~/Desktop/local-repo` — all commands run from here |
| **Capstone (Day 7)** | Deploy default → break 3 things → fix with [Part 6](#part-6) → deploy Thanos → pass [Part 5](#part-5) quiz |

### How to use each day

| Symbol | Meaning |
|---|---|
| 📖 | Read sections in this doc |
| 🛠 | Hands-on on kind cluster |
| ✅ | Self-check — do without notes |
| ⭐ | Optional if you finish early |

### Week at a glance

| Day | Theme | Parts | Hours |
|---|---|---|---|
| [1](#day-1) | Why metrics + Prometheus | Part 1 (Steps 0–1) | ~2.5 h |
| [2](#day-2) | Operator, RBAC, CRDs | Part 1 (Steps 2–4b) | ~3 h |
| [3](#day-3) | Deploy stack + scrape path | Part 1 (5–7), [Part 2](#part-2) | ~3 h |
| [4](#day-4) | Alerts, AM, Grafana | Part 1 (8–9), Part 2 lab | ~3 h |
| [5](#day-5) | Thanos + long-term storage | Part 1 (Step 10) | ~3 h |
| [6](#day-6) | YAML reference + interview prep | [Part 3](#part-3), [Part 4](#part-4) skim, [Part 5](#part-5) | ~3 h |
| [7](#day-7) | Debug + production + capstone | [Part 6](#part-6), [Part 7](#part-7) | ~3 h |

```
  Mon      Tue       Wed        Thu         Fri        Sat         Sun
  Day 1    Day 2     Day 3      Day 4       Day 5      Day 6       Day 7
  ────     ────      ────       ────        ────       ────        ────
  story    operator  DEPLOY     alerts      thanos     deep dive   fix + prod
  app      CRDs      scrape     grafana     dedup      interview   capstone
  prom
```

---

<a id="day-1"></a>

### Day 1 — Why metrics and Prometheus

**Goal:** Understand the problem and what Prometheus does before touching YAML.

| Block | Time | Activity |
|---|---|---|
| Morning | 45 min | 📖 [Problem](#the-problem-in-one-sentence), [Journey map](#the-journey-map-read-top-to-bottom) |
| | 45 min | 📖 [Step 0](#step-0-the-application-status-web) — skim `manifests/prod/status-web-*` |
| Afternoon | 45 min | 📖 [Step 1](#step-1-prometheus--the-historian) |
| | 30 min | 🛠 `curl` podinfo `/metrics` if app already running; else read sample metrics |
| ✅ | | Explain pull vs push; name one metric from status-web |

---

<a id="day-2"></a>

### Day 2 — Operator, RBAC, and CRDs

**Goal:** Know who installs what — Operator vs `prometheus-k8s`.

| Block | Time | Activity |
|---|---|---|
| Morning | 45 min | 📖 [Step 2](#step-2-kubernetes-rbac--why-prometheus-needs-permission) |
| | 45 min | 📖 [Step 3](#step-3-crds--new-kubernetes-object-types) |
| Afternoon | 60 min | 📖 [Step 4](#step-4-prometheus-operator--the-compiler), [Step 4b](#step-4b-two-workloads-youll-see--prometheus-operator-vs-prometheus-k8s) |
| | 30 min | 🛠 Draw compiler-vs-engine diagram; list `07` vs `08` vs `10` files |
| ✅ | | One sentence: Deployment `prometheus-operator` vs STS `prometheus-k8s` |

---

<a id="day-3"></a>

### Day 3 — Deploy and scrape

**Goal:** Running stack with `up{job="status-web"} == 1`.

| Block | Time | Activity |
|---|---|---|
| Morning | 45 min | 📖 [Step 5](#step-5-prometheus-cr--run-prometheus-like-this)–[7](#step-7-prometheusrule--alerts-and-recording-rules) |
| | 30 min | 📖 [Part 2](#part-2) file order + runbook |
| Afternoon | 60 min | 🛠 `./scripts/manual-stack/deploy_manual_stack.sh` |
| | 45 min | 🛠 Port-forward Prometheus; Targets UI; query `up{job="status-web"}` |
| ✅ | | Target UP; explain ServiceMonitor three-way contract |

---

<a id="day-4"></a>

### Day 4 — Alerts, routing, and Grafana

**Goal:** Full path rule → Prometheus → Alertmanager → Grafana.

| Block | Time | Activity |
|---|---|---|
| Morning | 45 min | 📖 [Step 8](#step-8-alertmanager--alert-routing-separate-from-prometheus) |
| | 30 min | 📖 [Step 9](#step-9-grafana--dashboards) |
| Afternoon | 45 min | 🛠 `./scripts/manual-stack/test_manual_stack.sh` |
| | 45 min | 🛠 [Practice lab](#practice-lab--end-to-end-checklist) steps 1–8; port-forward AM + Grafana |
| | 15 min | 🛠 Prometheus **Alerts** tab (not Graph) |
| ✅ | | Trace one alert from rule file `13` to Alertmanager UI |

---

<a id="day-5"></a>

### Day 5 — Thanos

**Goal:** Deploy Thanos mode; understand Query, sidecar, dedup.

| Block | Time | Activity |
|---|---|---|
| Morning | 60 min | 📖 [Step 10](#step-10-thanos--when-one-prometheus-disk-is-not-enough) + [dedup](#how-thanos-deduplicates-and-why-it-matters) |
| Afternoon | 45 min | 🛠 `PRELOAD_IMAGES=true ./scripts/manual-stack/deploy_manual_stack.sh thanos` |
| | 45 min | 🛠 `curl /api/v1/stores`; port-forward `thanos-query`; pod `3/3` |
| ⭐ | | Sketch: sidecar → MinIO → Store → Query |
| ✅ | | Explain Thanos Query dedup vs Alertmanager dedup |

---

<a id="day-6"></a>

### Day 6 — Reference, config, and interview

**Goal:** Field-level YAML confidence + interview self-test.

| Block | Time | Activity |
|---|---|---|
| Morning | 60 min | 📖 [Part 3](#part-3) — CR field table, namespace scope, sizing |
| | 45 min | 📖 [Part 4](#part-4) — big picture, where config lives, top-level sections only |
| Afternoon | 45 min | 🛠 `kubectl get secret prometheus-k8s -o yaml` — find generated scrape job |
| | 30 min | 📖 [Part 5](#part-5) — quiz yourself on 10 random questions |
| ✅ | | Answer 8/10 Part 5 questions without looking |

---

<a id="day-7"></a>

### Day 7 — Troubleshoot, production, and capstone

**Goal:** Fix breaks like on-call; know production gaps in this lab.

| Block | Time | Activity |
|---|---|---|
| Morning | 45 min | 📖 [Part 6](#part-6) decision tree + mistakes table |
| | 45 min | 📖 [Part 7](#part-7) production checklist |
| Afternoon | 30 min | 🛠 **Break 1:** wrong port name on ServiceMonitor → fix |
| | 30 min | 🛠 **Break 2:** remove `release` label from SM → fix |
| | 30 min | 🛠 **Break 3:** edit `02` without AM restart → fix |
| | 30 min | 🛠 Capstone: `cleanup_manual_stack.sh` → redeploy default → thanos |
| ✅ | | Fix dropped target in under 15 min using Part 6 |

**Week complete when:** You can deploy from memory, draw the [full city diagram](#the-full-city--all-components-together), and explain every box in 10 minutes.

---

### If you fall behind

| Situation | Do this |
|---|---|
| **Only 1 hour/day** | Spread each day across 2 calendar days (2-week pace, same 7-day content) |
| **Weekends only** | Sat–Sun: Days 1–4 then 5–7 over two weekends |
| **Already know Prometheus** | Skip Day 1 Step 1; start Day 2 at [Step 4](#step-4-prometheus-operator--the-compiler) |
| **No Thanos needed** | Skip Day 5; use extra time on [Part 4](#part-4) §16–17 (Alertmanager depth) |

---

### Progress checklist

```markdown
Day 1  [ ] Pull model  [ ] /metrics explained
Day 2  [ ] Operator vs prometheus-k8s explained
Day 3  [ ] Default stack deployed  [ ] up{job="status-web"} == 1
Day 4  [ ] Alert in AM  [ ] Grafana graph
Day 5  [ ] Thanos deployed  [ ] /api/v1/stores works
Day 6  [ ] Part 5 quiz 8/10+  [ ] Peeked generated prometheus.yml
Day 7  [ ] Fixed 3 breaks  [ ] Capstone redeploy  [ ] Part 7 read
```

---

<a id="part-1"></a>

# Part 1: Learn the story

## The problem in one sentence

You run `status-web` in Kubernetes. Something breaks at 3am. **How do you know?**

Metrics + rules + routing + dashboards answer that question. Each component owns one step.

---

## The journey map (read top to bottom)

```
  PHASE 1          PHASE 2              PHASE 3                 PHASE 4
  Your app         Prometheus           Alerts & routing        Dashboards
  ---------        ----------           ----------------        ----------

  status-web  -->  scrapes /metrics --> rules fire       -->  Alertmanager --> Slack
  exposes          stores in TSDB         (PrometheusRule)       (team routes)
  /metrics:9898                         |
                                        v
                                   Grafana graphs
```

**Optional Phase 5 (Thanos):** keep metrics longer than the Prometheus disk → object storage + Query.

---

## Step 0: The application (`status-web`)

### What you want

Know if the app is up and if HTTP errors (5xx) are too high.

### What you need

An app that exposes **Prometheus text metrics** on an HTTP path (usually `/metrics`).

### Our lab app

```yaml
# manifests/prod/status-web-deployment.yaml (simplified)
containers:
- name: podinfo
  image: ghcr.io/stefanprodan/podinfo:6.6.3
  ports:
  - containerPort: 9898
    name: http-metrics
```

```yaml
# manifests/prod/status-web-service.yaml (simplified)
spec:
  ports:
  - name: http-metrics    # NAME matters for ServiceMonitor — not just port number
    port: 9898
```

### Key metric

```promql
http_request_duration_seconds_count{job="status-web", status="503"}
```

**Without an app exposing metrics, nothing else in this stack has data to collect.**

---

## Step 1: Prometheus — the historian

### What you want

Store metric values over time and run queries like “5xx rate in the last 5 minutes.”

### What Prometheus does

| Job | Detail |
|---|---|
| **Scrape** | HTTP GET `/metrics` every N seconds (pull model) |
| **Store** | Time-series database (TSDB) on disk |
| **Evaluate rules** | PromQL expressions → firing alerts |
| **Send alerts** | HTTP to Alertmanager (not Slack directly) |

### Minimal mental model

```
  every 30s:  GET http://status-web:9898/metrics
              parse lines like: http_requests_total{status="200"} 42
              save (timestamp, value, labels)
```

### In our repo

- **Pod:** `prometheus-k8s-0` (StatefulSet)
- **UI / API:** Service `prometheus-k8s:9090`
- **Config:** generated by Operator (you don't edit `prometheus.yml` by hand)

### Snippet: what a scrape target looks like in the UI

Target health:

```promql
up{job="status-web"} == 1
```

---

## Step 2: Kubernetes RBAC — why Prometheus needs permission

### What you want

Prometheus to **find** Services and Pods automatically in the cluster.

### Why RBAC exists

Prometheus talks to the **Kubernetes API** for service discovery. That requires a ServiceAccount + ClusterRole.

### Two RBAC actors in our lab

| Who | File | Why |
|---|---|---|
| **Prometheus Operator** | `07-operator-rbac.yaml` | Watches CRs, creates StatefulSets, Secrets |
| **Prometheus pods** | `09-operator-prometheus-rbac.yaml` | Discovers Services/Endpoints/Pods to scrape |

```yaml
# 09-operator-prometheus-rbac.yaml (concept)
rules:
- apiGroups: [""]
  resources: ["services", "endpoints", "pods", "namespaces"]
  verbs: ["get", "list", "watch"]
```

**Mistake:** ServiceMonitor exists but no targets → often RBAC or wrong namespace on Operator `--namespaces`.

---

## Step 3: CRDs — new Kubernetes object types

### What you want

Declare “scrape this app” and “alert on 5xx” as **Kubernetes YAML**, not a hand-written `prometheus.yml`.

### What is a CRD?

A **Custom Resource Definition** teaches Kubernetes a new kind of object.

| CRD registers… | You create… | Purpose |
|---|---|---|
| `prometheuses.monitoring.coreos.com` | `Prometheus` | “Run a Prometheus instance with these settings” |
| `servicemonitors.monitoring.coreos.com` | `ServiceMonitor` | “Scrape Services matching these labels” |
| `prometheusrules.monitoring.coreos.com` | `PrometheusRule` | “These alert/recording rules” |

### File

Deploy script installs **full upstream CRDs** (v0.76.0) via `install_operator_crds.sh`.  
`01-crds.yaml` is an offline fallback only (3 types, no Thanos schema).

**Mistake:** `kubectl apply` Prometheus CR fails with `No match for kind "Prometheus"` → CRDs not installed.

---

## Step 4: Prometheus Operator — the compiler

### What you want

Someone to turn your CRs into a working Prometheus pod + valid `prometheus.yml`.

### What the Operator does

```
  YOU apply:                    OPERATOR writes:              POD runs:
  Prometheus CR          -->    Secret (generated config)  -->  Prometheus
  ServiceMonitor CR      -->    scrape jobs added
  PrometheusRule CR      -->    rule files added
```

### Deployment

```yaml
# 08-operator-deployment.yaml (key args)
args:
- --namespaces=monitoring-manual,default
- --prometheus-instance-namespaces=monitoring-manual
```

| Flag | Meaning |
|---|---|
| `--namespaces` | Operator **watches** CRs in these namespaces only |
| `--prometheus-instance-namespaces` | Where it may create Prometheus **pods** |

**You never kubectl exec into Prometheus to edit config in CR mode** — you edit CRs; Operator reconciles.

---

## Step 4b: Two workloads you'll see — `prometheus-operator` vs `prometheus-k8s`

After deploy, `kubectl get deploy` and `kubectl get sts` show **two different things**. Beginners often think both are "Prometheus." They are not.

### At a glance

| | `prometheus-operator` | `prometheus-k8s` |
|---|---|---|
| **kubectl** | `kubectl get deploy` | `kubectl get sts` |
| **Kind** | Deployment | StatefulSet |
| **You install via** | `08-operator-deployment.yaml` (you apply YAML) | **Not applied directly** — Operator creates it from Prometheus CR |
| **Image** | `prometheus-operator:v0.76.0` | `prometheus` (scraping engine) |
| **Role** | **Manager** — watches CRs, builds config, creates workloads | **Engine** — scrapes metrics, stores TSDB, evaluates rules, sends alerts |
| **Touches metrics?** | No | Yes — this is your monitoring data plane |
| **Needs disk?** | No | Yes — PVC for TSDB (`prometheus-k8s-db-prometheus-k8s-0`) |
| **Typical replicas** | 1 controller | `spec.replicas` on Prometheus CR (1 in lab) |

### Why we need both

| Without Operator | With Operator (our lab) |
|---|---|
| Hand-write `prometheus.yml` in a ConfigMap | Declare intent in CRs (`Prometheus`, `ServiceMonitor`, `PrometheusRule`) |
| Restart Prometheus after every scrape/rule change | Operator + config-reloader hot-reload |
| Easy to drift from git | CRs are the source of truth |

| Without Prometheus (`prometheus-k8s`) | With it |
|---|---|
| Operator alone collects nothing | Something actually scrapes `/metrics` and runs PromQL |

**One sentence:** The **Operator** is the compiler; **`prometheus-k8s`** is the program.

### How each is installed

```
  INSTALL PATH A — you apply YAML                INSTALL PATH B — Operator reconciles CR

  07-operator-rbac.yaml                          10-operator-prometheus-cr.yaml
  08-operator-deployment.yaml    ──creates──►    (Prometheus CR, name: k8s)
         │                                              │
         ▼                                              ▼
  Deployment: prometheus-operator              StatefulSet: prometheus-k8s
  Pod: prometheus-operator-xxxxx               Pod: prometheus-k8s-0
```

| Step | What you run | What appears |
|---|---|---|
| Deploy script applies `07` + `08` | `kubectl apply -f 08-operator-deployment.yaml` | `deploy/prometheus-operator` |
| Deploy script applies `10` | `kubectl apply -f 10-operator-prometheus-cr.yaml` | Operator creates `sts/prometheus-k8s` within seconds |

You never `kubectl apply` a StatefulSet manifest for Prometheus in CR mode. If `prometheus-k8s` is missing, check the Operator logs and the `Prometheus` CR status — not your git for a missing STS file.

### Compiler vs program (data flow)

```
  YOU apply (git)                 OPERATOR (Deployment)              PROMETHEUS (StatefulSet)
  ---------------                 ---------------------              ------------------------

  Prometheus CR (10)      ──►     reads spec, generates Secret
  ServiceMonitor (12)   ──►     adds scrape jobs to prometheus.yml
  PrometheusRule (13)   ──►     adds rule files
                                         │
                                         ▼
                                  reloads / updates
                                         │
                                         ▼
                                  prometheus-k8s-0
                                    ├─ prometheus      (scrape, store, alert)
                                    └─ config-reloader (watch Secret, hot reload)
```

### Who talks to whom

```
  default namespace                    monitoring-manual namespace
  ┌──────────────────┐                ┌────────────────────────────────────────────┐
  │ status-web       │                │                                            │
  │   /metrics       │◄─── scrape ────│  prometheus-k8s-0                          │
  └──────────────────┘                │       │                                    │
                                      │       ├── alerts ──► alertmanager          │
                                      │       └── queried by ◄── grafana           │
                                      │                                            │
                                      │  prometheus-operator (Deployment)          │
                                      │       ▲                                    │
                                      │       │ watches CRs, owns STS lifecycle    │
                                      │  Prometheus / ServiceMonitor / Rule CRs    │
                                      └────────────────────────────────────────────┘
```

The Operator **does not** scrape your app. Only `prometheus-k8s-0` does.

### What's inside `prometheus-k8s-0`?

| Container | Present when | Job |
|---|---|---|
| `prometheus` | always | HTTP scrape, TSDB, PromQL, rule evaluation, alert send |
| `config-reloader` | always | Reload Prometheus when Operator updates generated config |
| `thanos-sidecar` | Thanos mode only | Upload TSDB blocks to MinIO; gRPC store for Query |

```bash
kubectl -n monitoring-manual get pod prometheus-k8s-0 -o jsonpath='{.status.containerStatuses[*].name}{"\n"}'
# default:  prometheus config-reloader
# thanos:   prometheus config-reloader thanos-sidecar
```

`kubectl get pods` shows **2/2** (default) or **3/3** (Thanos) — that is normal.

### Why Deployment vs StatefulSet?

| Operator → Deployment | Prometheus → StatefulSet |
|---|---|
| Stateless controller; pod can be replaced freely | Stable pod name `prometheus-k8s-0` |
| No time-series data on disk | PVC survives pod restart — metrics kept |
| One replica is enough | Can run multiple replicas for HA (advanced) |

### Snippets from this repo

**Operator — you apply this:**

```yaml
# manifests/manual-stack/08-operator-deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: prometheus-operator
spec:
  replicas: 1
  template:
    spec:
      containers:
      - name: prometheus-operator
        image: quay.io/prometheus-operator/prometheus-operator:v0.76.0
        args:
        - --namespaces=monitoring-manual,default
        - --prometheus-instance-namespaces=monitoring-manual
```

**Prometheus CR — Operator reads this and creates the StatefulSet:**

```yaml
# manifests/manual-stack/10-operator-prometheus-cr.yaml
apiVersion: monitoring.coreos.com/v1
kind: Prometheus
metadata:
  name: k8s                    # Operator names STS: prometheus-k8s
  namespace: monitoring-manual
spec:
  replicas: 1
  scrapeInterval: 30s
  retention: 24h
  serviceMonitorSelector:
    matchLabels:
      release: manual-operator
```

### What the Operator creates (you don't apply these)

| Object | Name | Purpose |
|---|---|---|
| StatefulSet | `prometheus-k8s` | Runs Prometheus pod(s) |
| Pod | `prometheus-k8s-0` | Actual scrape engine |
| PVC | `prometheus-k8s-db-prometheus-k8s-0` | TSDB on disk |
| Secret | `prometheus-k8s` (generated) | Compiled `prometheus.yml` + rules |
| Service (headless) | `prometheus-operated` | Stable pod DNS; Thanos gRPC `:10901` |
| Service (yours) | `prometheus-k8s` | UI/API `:9090` — from file `11` |

### Quick checks

```bash
# Manager running?
kubectl -n monitoring-manual get deploy prometheus-operator

# Engine running?
kubectl -n monitoring-manual get sts prometheus-k8s
kubectl -n monitoring-manual get prometheus k8s

# Who owns the StatefulSet?
kubectl -n monitoring-manual get sts prometheus-k8s \
  -o jsonpath='{.metadata.ownerReferences[0].kind}{"/"}{.metadata.ownerReferences[0].name}{"\n"}'
# expect: Prometheus/k8s

# Operator logs (CR not reconciling?)
kubectl -n monitoring-manual logs deploy/prometheus-operator --tail=30
```

### When to debug which?

| Symptom | Likely fix in |
|---|---|
| `prometheus-k8s` StatefulSet never appears | Operator logs, CRDs, `08` namespace flags, Prometheus CR `describe` |
| Targets missing / `up` empty | ServiceMonitor `12`, app Service port name, RBAC `09` |
| Rules don't fire | PrometheusRule `13`, Prometheus **Alerts** tab (not Graph) |
| CR applied but config stale | Operator + config-reloader; rarely restart `prometheus-k8s-0` |

**Mistake:** Editing a ConfigMap for `prometheus.yml` by hand in CR mode — Operator overwrites it. Change CRs (`10`, `12`, `13`) instead.

---

## Step 5: Prometheus CR — “run Prometheus like this”

> See also [Step 4b](#step-4b-two-workloads-youll-see--prometheus-operator-vs-prometheus-k8s) for `kubectl get deploy` vs `kubectl get sts`.

### What you want

One object that says: replicas, retention, which ServiceMonitors to use, where to send alerts.

### File

### Snippet: the contracts that matter

```yaml
# 10-operator-prometheus-cr.yaml (essential fields)
spec:
  serviceAccountName: prometheus-k8s
  serviceMonitorSelector:
    matchLabels:
      release: manual-operator   # only SMs with this label
  ruleSelector: {}               # all PrometheusRules in allowed namespaces
  alerting:
    alertmanagers:
    - name: alertmanager         # Service name in 03-alertmanager.yaml
      namespace: monitoring-manual
      port: http                 # port NAME on Service, not 9093
```

### What the Operator creates for you

| Object | Name | Why |
|---|---|---|
| StatefulSet | `prometheus-k8s` | Prometheus pod(s) |
| Service (headless) | `prometheus-operated` | Pod DNS + Thanos gRPC `:10901` |
| Service (yours) | `prometheus-k8s` | Friendly `:9090` for UI/Grafana |

**Mistake:** Alerts never reach Alertmanager → `spec.alerting` name/port wrong, or Alertmanager not deployed.

---

## Step 6: ServiceMonitor — the scrape contract

### What you want

“Scrape every Service with `app=status-web` on port `http-metrics`, path `/metrics`.”

### File

`12-operator-status-web-servicemonitor.yaml`

```yaml
metadata:
  namespace: default          # where the SM object lives
  labels:
    release: manual-operator  # must match Prometheus CR selector
spec:
  namespaceSelector:
    matchNames: [default]     # where to FIND target Services
  selector:
    matchLabels:
      app: status-web
  endpoints:
  - port: http-metrics        # Service port NAME — must match prod Service
    path: /metrics
    interval: 30s
```

### Three-way contract (all must agree)

```
  ServiceMonitor label     Prometheus CR              App Service
  release: manual-operator  serviceMonitorSelector     port name http-metrics
         |                          |                          |
         +--------------------------+--------------------------+
                    all must match or target is DROPPED
```

**Mistake #1 in this lab:** ServiceMonitor says `port: http` but Service says `http-metrics` → no metrics, `up` empty.

---

## Step 7: PrometheusRule — alerts and recording rules

### What you want

“When 5xx rate > 2% for 10m, fire alert `StatusWebHigh5xxRate` with `team: payments`.”

### File

`13-operator-status-web-prometheusrule.yaml`

```yaml
spec:
  groups:
  - name: status-web-alerts
    rules:
    - alert: StatusWebHigh5xxRate
      expr: |
        (sum(rate(http_request_duration_seconds_count{job="status-web",status=~"5.."}[5m]))
         / sum(rate(http_request_duration_seconds_count{job="status-web"}[5m]))) > 0.02
        and on() sum(up{job="status-web"} == 1) > 0
      for: 10m
      labels:
        team: payments
        job: status-web
```

| Field | Meaning |
|---|---|
| `expr` | PromQL — when true, alert becomes **Pending** |
| `for` | Must stay true this long before **Firing** |
| `labels.team` | Used by Alertmanager routing |

**Where to check:** Prometheus UI → **Alerts** tab (not Graph).  
**Mistake:** Rule in Graph returns data but no alert → you're on Graph tab; or `for:` not elapsed yet.

---

## Step 8: Alertmanager — alert routing (separate from Prometheus)

### Why a separate app?

| Prometheus | Alertmanager |
|---|---|
| Detects problem (rule fires) | Decides **who gets notified** |
| Sends all fires to AM | Groups, dedupes, routes by `team` label |
| Good at math | Good at on-call noise control |

### Files

| File | Role |
|---|---|
| `02-alertmanager-config.yaml` | Secret with `alertmanager.yml` (routes, receivers, inhibit) |
| `03-alertmanager.yaml` | Deployment + Service `alertmanager:9093` |

### Snippet: team routing

```yaml
# 02-alertmanager-config.yaml (simplified)
route:
  routes:
  - matchers: [team="payments"]
    receiver: team-payments
receivers:
- name: team-payments
  slack_configs:
  - channel: '#alerts-payments'
```

**Data flow**

```
  PrometheusRule → Prometheus evaluates → FIRING
       → HTTP → Alertmanager → Slack / PagerDuty
```

**Mistake:** Change `02` but no effect → must `kubectl rollout restart deploy/alertmanager`.

---

## Step 9: Grafana — dashboards

### What you want

Graphs without writing curl commands.

### Files

| File | Role |
|---|---|
| `04-grafana-secret.yaml` | Admin password |
| `05-grafana-datasource.yaml` | Points at Prometheus (`prometheus-k8s`) |
| `06-grafana.yaml` | Grafana Deployment |

```yaml
# 05-grafana-datasource.yaml
url: http://prometheus-k8s.monitoring-manual.svc:9090
```

Grafana **queries** metrics; it does **not** scrape apps or fire alerts.

---

## Step 10: Thanos — when one Prometheus disk is not enough

### What problem Thanos solves

| Limit of Prometheus alone | Thanos adds |
|---|---|
| Metrics die when pod disk fills or retention ends | Copy blocks to **object storage** (MinIO/S3) |
| One pod = one view | **Query** merges live + historical data |
| Long retention = huge local disk | **Compactor** manages long-term storage |
| HA replicas return duplicate series in queries | **Query dedup** on `replica` / `prometheus_replica` labels |

### Story: “I want 30 days of metrics”

You need **five new pieces** (our lab):

```
  Prometheus pod
       + thanos-sidecar (uploads blocks)
              |
              v
           MinIO (S3 bucket "thanos")
              |
     +--------+--------+
     v                 v
 Store Gateway    Compactor
 (read old)       (compact/downsample)
     |
     v
 Thanos Query  <--- Grafana (Thanos mode)
 (one PromQL API)
```

### Component cheat sheet

| Component | File | One-line job |
|---|---|---|
| **MinIO** | `thanos/01-minio.yaml` | Fake S3 for kind lab |
| **Bucket job** | `thanos/02-minio-bucket-job.yaml` | Creates `thanos` bucket |
| **Objstore secret** | `thanos/03-objstore-secret.yaml` | S3 config for sidecar/store/compactor |
| **Prometheus CR + sidecar** | `thanos/04-prometheus-cr-thanos.yaml` | `spec.thanos` + PVC |
| **Thanos Query** | `thanos/05-thanos-query.yaml` | PromQL entrypoint for Grafana |
| **Store Gateway** | `thanos/06-thanos-store-gateway.yaml` | Serves blocks from MinIO |
| **Compactor** | `thanos/07-thanos-compactor.yaml` | Maintains object storage |

### Sidecar on `prometheus-k8s-0`

```
  3/3 Running = prometheus + config-reloader + thanos-sidecar
```

### Snippet: Thanos on Prometheus CR

```yaml
# thanos/04-prometheus-cr-thanos.yaml
spec:
  retention: 6h
  thanos:
    objectStorageConfig:
      name: thanos-objstore-config
      key: thanos.yaml
  storage:
    volumeClaimTemplate:
      spec:
        resources:
          requests:
            storage: 5Gi
```

### How to know you're on Thanos (not direct Prometheus)

```bash
curl http://thanos-query:9090/api/v1/stores   # lists sidecar + store — Prometheus alone has no this
kubectl get pods | grep thanos
```

**Mistake:** Port-forward `prometheus-k8s` and think it's Thanos — use `thanos-query` Service.

### How Thanos deduplicates (and why it matters)

#### What is the problem?

Duplicates appear when **the same metric** exists more than once in the data Thanos Query sees. Common causes:

| Cause | Example |
|---|---|
| **Prometheus HA** | `replicas: 2` — both pods scrape `status-web`; you get two identical series differing only by `prometheus_replica` |
| **Multiple stores** | Query talks to **sidecar** (live) + **Store Gateway** (historical) — same block window can overlap briefly |
| **Multi-cluster / federation** | Two clusters export `http_requests_total{job="api"}` — need `cluster` label to tell them apart; without it, looks like dupes |

Without dedup, PromQL like `sum(rate(http_requests_total[5m]))` **doubles** your answer (2 replicas × same value).

#### What deduplicates what? (don't mix layers)

```
  METRICS (time series)              ALERTS (notifications)
  ---------------------              ----------------------

  Prometheus HA replicas  ──►        Same rule fires on both replicas
         │                                    │
         ▼                                    ▼
  Thanos Query dedup          Alertmanager dedup / group / inhibit
  (at PromQL query time)      (at notification time)
         │                                    │
         ▼                                    ▼
  Grafana sees 1 line         On-call gets 1 page (not 2)
```

| Layer | Tool | What it dedupes |
|---|---|---|
| **Query** | Thanos Query | Duplicate **metric series** when querying |
| **Compaction** | Thanos Compactor | Duplicate **blocks** in object storage over time |
| **Alerts** | Alertmanager | Duplicate **alert notifications** (not Thanos Query's job) |

Alerts still **evaluate on each Prometheus replica**. Thanos Query is for **reading** metrics in Grafana — it does not fire or dedupe alerts.

#### How Thanos Query dedup works (the idea)

Thanos Query fans out your PromQL to every connected store (sidecars, store gateways), collects all matching series, then **merges duplicates**:

1. Two series are considered duplicates if they have the **same labels** after removing **replica labels**.
2. Replica labels are configured with `--query.replica-label`.
3. For each duplicate group, Query keeps **one** sample — typically from the replica/store with the **most recent timestamp** (newest wins).

**In our repo** (`thanos/05-thanos-query.yaml`):

```yaml
args:
- query
- --query.replica-label=replica
- --query.replica-label=prometheus_replica
```

| Flag | Meaning |
|---|---|
| `--query.replica-label=replica` | Label `replica` identifies a Prometheus replica copy |
| `--query.replica-label=prometheus_replica` | Label `prometheus_replica` (Operator HA) also identifies replica copy |

**Example — two HA replicas scrape the same target:**

```
  prometheus-k8s-0  ──►  http_requests_total{job="status-web", prometheus_replica="prometheus-k8s-0"}  value=42
  prometheus-k8s-1  ──►  http_requests_total{job="status-web", prometheus_replica="prometheus-k8s-1"}  value=42
```

Thanos Query strips `prometheus_replica`, sees one logical series, returns **one** value (not 84 when you `sum()`).

```
  BEFORE dedup (what stores return)          AFTER dedup (what Grafana sees)

  series A: {job="status-web",               series: {job="status-web",
            prometheus_replica="0"} 42                 cluster="kind"} 42
  series B: {job="status-web",
            prometheus_replica="1"} 42
```

#### Where do replica labels come from?

| Source | Label | How |
|---|---|---|
| Prometheus Operator HA | `prometheus_replica` | Operator injects per-pod external label when `spec.replicas > 1` |
| Manual / Helm | `replica` | Set in `spec.externalLabels` on Prometheus CR or `external_labels` in config |
| Sharding | `prometheus` + hashmod | Different shards — not duplicates; different scrape subsets |

Our lab runs `replicas: 1`, so you **won't see dedup in action** until you scale HA — but Query is already configured for it.

```yaml
# Production HA pattern on Prometheus CR
spec:
  replicas: 2
  externalLabels:
    cluster: kind-otel-test
    # do NOT hardcode prometheus_replica — Operator sets per pod
```

#### Sidecar + Store Gateway overlap

```
  time ──────────────────────────────────────────────►

  [  local TSDB on pod  ][ uploaded block in MinIO  ]
         sidecar gRPC          store gateway gRPC
                \                    /
                 \                  /
                  ▼                ▼
                    Thanos Query
                  (merges overlap;
                   dedup replica labels)
```

For the same replica, sidecar serves **recent** data; Store Gateway serves **uploaded** blocks. Overlap at block boundaries is normal — Query merges time ranges. Replica dedup handles HA; store priority handles overlap.

#### Compactor dedup (object storage layer)

**Compactor** (`thanos/07`) is a separate dedup path:

- When HA replicas upload blocks with replica labels, object storage can hold **redundant copies** of the same time range.
- Compactor **compacts** blocks: merges, deduplicates, and creates downsampled resolutions (`5m`, `1h`).
- This saves disk in MinIO/S3 and speeds long-range queries — not the same moment-to-moment path as Query dedup.

#### Lab vs production

| Our kind lab | Production HA |
|---|---|
| `replicas: 1` on Prometheus CR | `replicas: 2+` |
| Dedup flags set but rarely needed | Dedup prevents doubled Grafana graphs |
| Single sidecar store | Multiple sidecars + store gateways |
| MinIO, short retention | S3 + Compactor downsampling |

**Verify Query replica labels:**

```bash
kubectl -n monitoring-manual get deploy thanos-query -o yaml | grep query.replica-label
```

**Mistake:** HA Prometheus without `--query.replica-label` → `sum()` and `rate()` show 2× (or N×) the real value in Grafana via Thanos.

**Mistake:** Using `prometheus_replica` in dashboard filters or alert labels for business logic — it's for **infrastructure dedup**, not team routing. Use `team`, `cluster`, `namespace` instead.

---

## The full city — all components together

```
  default namespace                         monitoring-manual namespace
  ┌─────────────────────┐                  ┌─────────────────────────────────────────┐
  │ status-web          │                  │ Operator (08) watches CRs               │
  │   Service           │◄── scrape ───────│ Prometheus CR (10) → pod prometheus-k8s-0│
  │   ServiceMonitor(12)│───selector──────►│ PrometheusRule (13) → rules in pod       │
  └─────────────────────┘                  │ Alertmanager (02-03) ◄── alerts         │
                                             │ Grafana (04-06) ──queries──► Prometheus   │
                                             └─────────────────────────────────────────┘

  Thanos mode adds: MinIO, Query, Store, Compactor; Grafana → thanos-query
```

---

## “I want this feature” → what you need

| I want… | Components involved | Files |
|---|---|---|
| Scrape my app | App metrics + ServiceMonitor + Prometheus CR | prod status-web, `12`, `10` |
| Fire alert on 5xx | PrometheusRule + scrape working | `13` |
| Slack per team | PrometheusRule `team` label + Alertmanager routes | `13`, `02` |
| Dashboards | Grafana + datasource | `04-06` |
| Long-term metrics | Thanos sidecar + MinIO + Query + Store + Compactor | `thanos/*` |
| GitOps-friendly config | CRs + Operator | `01`, `07-13` |
| Understand `get deploy` vs `get sts` | Operator Deployment + Prometheus StatefulSet | [Step 4b](#step-4b-two-workloads-youll-see--prometheus-operator-vs-prometheus-k8s), `08`, `10` |

---

---

<a id="part-2"></a>

# Part 2: Deploy & hands-on practice

**Deploy only after Part 1.** You should know *what* each file does.

## Story flow — what we are doing

| Phase | Action | Outcome |
|---|---|---|
| 1 | Deploy app + Service | `/metrics` endpoint exists |
| 2 | Deploy stack (`00`–`13`) | Operator, Prometheus, AM, Grafana ready |
| 3 | ServiceMonitor wires scrape | `up{job="status-web"} == 1` |
| 4 | Generate traffic | 200/400/503 rates visible |
| 5 | Rules + routing | Alert lifecycle testable |
| 6 | Tune / troubleshoot | Less noise, reliable signals |

## File order (00 → 13)

| # | File | Component |
|---|---|---|
| 00 | namespace | `monitoring-manual` |
| 01 | CRDs | Full upstream via `install_operator_crds.sh` (v0.76.0) |
| 02-03 | Alertmanager | Routing + process |
| 04-06 | Grafana | Dashboards (optional) |
| 07-09 | Operator + RBAC | Compiler + permissions |
| 10 | Prometheus CR | The historian (Operator creates STS) |
| 11 | Service | `prometheus-k8s:9090` |
| 12 | ServiceMonitor | Scrape contract |
| 13 | PrometheusRule | Alerts |

Plus `manifests/prod/status-web-*` for the demo app.

## Deployment runbook

| Step | Command | Success signal |
|---|---|---|
| 1 App | `kubectl apply -f manifests/prod/status-web-deployment.yaml` + service | Pod Running |
| 2 Stack | `./scripts/manual-stack/deploy_manual_stack.sh` | All applies OK |
| 3 Health | `kubectl -n monitoring-manual get pods` | operator + prometheus-k8s + am ready |
| 4 Traffic | `./scripts/manual-stack/test_manual_stack.sh` | Queries return data |
| 5 UI | port-forward `prometheus-k8s:9090` | Targets active |

```bash
cd ~/Desktop/local-repo

# Default
./scripts/manual-stack/cleanup_manual_stack.sh
./scripts/manual-stack/deploy_manual_stack.sh

# Thanos + MinIO (kind)
PRELOAD_IMAGES=true KIND_CLUSTER_NAME=kind-otel-test ./scripts/manual-stack/deploy_manual_stack.sh thanos
```

## Verify after deploy

```bash
kubectl -n monitoring-manual get deploy,sts,pods
kubectl -n monitoring-manual port-forward svc/prometheus-k8s 9090:9090

# Target up?
curl -s 'http://127.0.0.1:9090/api/v1/query?query=up{job="status-web"}' | python3 -m json.tool

# Thanos mode
kubectl -n monitoring-manual port-forward svc/thanos-query 9090:9090
curl http://127.0.0.1:9090/api/v1/stores
```

## Practice lab — end-to-end checklist

1. **Deploy** stack + app (commands above).
2. **Targets** — Prometheus UI → Status → Targets → `status-web` state = UP.
3. **Query** — `sum by (status) (rate(http_request_duration_seconds_count{job="status-web"}[5m]))`.
4. **Rules** — Prometheus UI → **Alerts** tab (not Graph); wait for `for:` window.
5. **Alertmanager** — port-forward `:9093`, confirm grouped alerts.
6. **Grafana** — port-forward `:3000`, explore Prometheus datasource.
7. **Break it** — scale status-web to 0; confirm alert + inhibit behavior.
8. **Fix it** — scale back; confirm resolved notification path.
9. **Thanos** (optional) — redeploy with `thanos` mode; verify `/api/v1/stores`.

## Cleanup and rerun

| Action | Command |
|---|---|
| Teardown | `./scripts/manual-stack/cleanup_manual_stack.sh` |
| Full reset (PVCs) | `DELETE_PVCS=true ./scripts/manual-stack/cleanup_manual_stack.sh` |
| Thanos only off | `./scripts/manual-stack/thanos/cleanup_thanos_stack.sh` |

---

<a id="part-3"></a>

# Part 3: Reference tables

## Prometheus CR YAML Field Table

Source YAML: manifests/manual-stack/10-operator-prometheus-cr.yaml

| YAML Field | Meaning | Why it exists |
|---|---|---|
| apiVersion: monitoring.coreos.com/v1 | Uses Operator CRD API | Needed to create Prometheus custom resource |
| kind: Prometheus | Declares Prometheus instance | Operator reconciles this object |
| metadata.name: k8s | Logical instance name | Used in generated labels/selectors |
| metadata.namespace: monitoring-manual | CR object namespace | Keeps monitoring control-plane in one namespace |
| metadata.labels.app.kubernetes.io/name | Organizational label | Easier resource filtering |
| spec.replicas: 1 | One replica | Minimal local environment footprint |
| spec.serviceAccountName: prometheus-k8s | Pod identity | Maps to RBAC in file 12 |
| spec.evaluationInterval: 30s | Rule evaluation cadence | Balances responsiveness and CPU |
| spec.scrapeInterval: 30s | Default scrape cadence | Balances granularity and ingestion |
| spec.retention: 24h | Metric retention | Limits local disk usage |
| spec.enableAdminAPI: true | Enables admin API | Useful for debugging in local setup |
| spec.ruleSelector: {} | Rule selection | Selects PrometheusRules (scope depends on namespace selector) |
| spec.ruleNamespaceSelector: {} | Rule namespace filter | Works within namespaces visible to operator |
| spec.serviceMonitorSelector.matchLabels.release: manual-operator | ServiceMonitor label filter | Isolates to intended ServiceMonitors |
| spec.serviceMonitorNamespaceSelector: {} | ServiceMonitor namespace filter | Applies within operator watch scope |
| spec.podMonitorSelector: {} | PodMonitor filter | Optional path, broad by default |
| spec.podMonitorNamespaceSelector: {} | PodMonitor namespace filter | Optional path, broad by default |
| spec.resources.requests | Scheduler reservation | Guarantees minimum CPU and memory |
| spec.resources.limits | Runtime cap | Prevents uncontrolled resource growth |

### Prometheus CR Example Snippet

```yaml
apiVersion: monitoring.coreos.com/v1
kind: Prometheus
metadata:
	name: k8s
	namespace: monitoring-manual
	labels:
		app.kubernetes.io/name: prometheus
spec:
	replicas: 1
	serviceAccountName: prometheus-k8s
	evaluationInterval: 30s
	scrapeInterval: 30s
	retention: 24h
	enableAdminAPI: true
	ruleSelector: {}
	ruleNamespaceSelector: {}
	serviceMonitorSelector:
		matchLabels:
			release: manual-operator
	serviceMonitorNamespaceSelector: {}
	podMonitorSelector: {}
	podMonitorNamespaceSelector: {}
	resources:
		requests:
			cpu: 200m
			memory: 512Mi
		limits:
			cpu: 1000m
			memory: 2Gi
```

---

## Operator Namespace Scope Table

| Layer | Configuration | Function |
|---|---|---|
| Operator process scope | manifests/manual-stack/08-operator-deployment.yaml args: --namespaces=monitoring-manual,default | Hard watch boundary; operator cannot see outside this list |
| Per-Prometheus CR scope | manifests/manual-stack/10-operator-prometheus-cr.yaml serviceMonitorNamespaceSelector | Additional filter inside operator-visible namespaces |

### Adding payments namespace to operator args

| Item | Value |
|---|---|
| File | manifests/manual-stack/08-operator-deployment.yaml |
| Required args line | --namespaces=monitoring-manual,default,payments |
| Apply command | kubectl apply -f manifests/manual-stack/08-operator-deployment.yaml |
| Restart command | kubectl -n monitoring-manual rollout restart deploy/prometheus-operator |
| Verify command | kubectl -n monitoring-manual rollout status deploy/prometheus-operator --timeout=180s |

```yaml
# manifests/manual-stack/08-operator-deployment.yaml (args excerpt)
args:
- --log-level=info
- --kubelet-service=kube-system/kubelet
- --prometheus-config-reloader=quay.io/prometheus-operator/prometheus-config-reloader:v0.76.0
- --prometheus-instance-namespaces=monitoring-manual
- --alertmanager-instance-namespaces=monitoring-manual
- --thanos-ruler-instance-namespaces=monitoring-manual
- --namespaces=monitoring-manual,default,payments
```

```bash
kubectl apply -f manifests/manual-stack/08-operator-deployment.yaml
kubectl -n monitoring-manual rollout restart deploy/prometheus-operator
kubectl -n monitoring-manual rollout status deploy/prometheus-operator --timeout=180s
```

---

## File purpose and dependency table

| # | File | Purpose | Depends on |
|---|---|---|---|
| 00 | `00-namespace.yaml` | Namespace | — |
| 01 | CRDs via `install_operator_crds.sh` | API types | 00 |
| 02–03 | Alertmanager | Routing + workload | 00 |
| 04–06 | Grafana | Dashboards | 00, Prometheus Service |
| 07–08 | Operator RBAC + Deployment | Controller | 00, CRDs |
| 09 | Prometheus RBAC | Discovery permissions | 00 |
| 10 | Prometheus CR | Declares Prometheus instance | 07–09 |
| 11 | `prometheus-k8s` Service | UI/API `:9090` | 10 (STS created by Operator) |
| 12 | ServiceMonitor | Scrape contract for status-web | 10 selector, prod Service |
| 13 | PrometheusRule | Alerts + recording rules | 10 `ruleSelector` |
| prod | `status-web-*` | Demo app + `http-metrics` port | — |

**Deploy:** `./scripts/manual-stack/deploy_manual_stack.sh` applies all of the above in order.

## ServiceMonitor Limits and Sizing

### Primary Limit Factors

| Factor | Signal | Impact |
|---|---|---|
| Ingestion rate | targets x metrics_per_target / scrape_interval_seconds | Higher CPU, WAL and memory |
| Label cardinality | High-cardinality labels like user_id/request_id | Memory blow-up, slower queries |
| Timeout to interval ratio | scrapeTimeout near scrapeInterval | Overlaps and scrape failures |
| Discovery breadth | Broad selectors across many namespaces | Higher API and relabel overhead |
| Rule/query complexity | Frequent heavy PromQL | Evaluation latency and CPU pressure |

### ServiceMonitor Constraints

| Constraint | Required condition |
|---|---|
| CRD presence | Prometheus Operator CRDs installed |
| Operator health | Operator deployment running |
| Label match | ServiceMonitor labels satisfy CR serviceMonitorSelector |
| Namespace visibility | Namespace visible to operator args and allowed by CR namespace selector |
| Port match | ServiceMonitor endpoints.port equals Service port name |

### Tuning Playbook

| Symptom | Action |
|---|---|
| High CPU | Increase scrapeInterval, simplify rules, scale CPU |
| High memory | Remove high-cardinality labels, drop noisy metrics, raise memory |
| Missing targets | Check selectors, namespaces, ServiceMonitor port name |
| Slow evaluations | Increase evaluationInterval or split workload |

---

<a id="part-4"></a>

# Part 4: Deep dive — config & alerting

> Operator mode: you edit CRs; Operator writes `prometheus.yml` into Secret `prometheus-k8s`.


## Prometheus Config Deep Dive (Operator + kube-prometheus-stack)

## Who this is for
This guide is for beginners who can see Prometheus config but do not yet understand what each section means.

Your environment (this repo):
- Kubernetes kind cluster, namespace `monitoring-manual`
- Prometheus Operator v0.76.0 manages config from CRs
- Generated config lives in Secret `prometheus-k8s`

---

## Index (Read in This Order)

1. Start here
- [1) Big picture first](#1-big-picture-first)
- [2) Where this config lives](#2-where-this-config-lives)

2. Core config understanding
- [3) Understand the top-level sections](#3-understand-the-top-level-sections)
- [14) kubernetes_sd_configs Roles Explained (with real examples)](#14-kubernetes_sd_configs-roles-explained-with-real-examples)
- [15) relabel_configs: In Depth](#15-relabel_configs-in-depth)

3. App scraping flow
- [4) Deep dive into one scrape job](#4-deep-dive-into-one-scrape-job)
- [13) Appendix: Your Exact status-web Job, Annotated](#13-appendix-your-exact-status-web-job-annotated)
- [8) Mapping your webapp case to config](#8-mapping-your-webapp-case-to-config)

4. Validation and troubleshooting
- [10) Quick commands reference](#10-quick-commands-reference)
- [7) How to read config without getting overwhelmed](#7-how-to-read-config-without-getting-overwhelmed)
- [9) Most common beginner mistakes](#9-most-common-beginner-mistakes)

5. Alerting and production hardening
- [16) Alertmanager Config Secret: Use Case and Fields](#16-alertmanager-config-secret-use-case-and-fields)
- [17) How Prometheus Contacts Alertmanager and How Alerts Resolve](#17-how-prometheus-contacts-alertmanager-and-how-alerts-resolve)
- [5) Why ServiceMonitor label matters](#5-why-servicemonitor-label-matters)
- [6) Why no data without ServiceMonitor](#6-why-no-data-without-servicemonitor)
- [11) Final simplified summary](#11-final-simplified-summary)

---

## Step-by-Step Execution Path (Deploy to Test)

Follow this checklist in order.

### Step 1: Deploy the stack and app

1. Deploy manual monitoring stack:
```bash
./scripts/manual-stack/deploy_manual_stack.sh
```
2. Confirm pods are running:
```bash
kubectl -n monitoring-manual get pods
kubectl -n default get pods -l app=status-web
```

### Step 2: Generate traffic and verify scraping

1. Run load and query tests:
```bash
./scripts/manual-stack/test_manual_stack.sh
```
2. Validate target is up and rate query returns data.

Read now:
- [4) Deep dive into one scrape job](#4-deep-dive-into-one-scrape-job)
- [13) Appendix: Your Exact status-web Job, Annotated](#13-appendix-your-exact-status-web-job-annotated)

### Step 3: Inspect live Prometheus config

1. Open Prometheus config from pod:
```bash
POD=$(kubectl -n monitoring-manual get pod -l app.kubernetes.io/name=prometheus -o jsonpath='{.items[0].metadata.name}')
kubectl -n monitoring-manual exec "$POD" -- sed -n '1,220p' /etc/prometheus/config/prometheus.yml
```
2. Compare with sections:
- [3) Understand the top-level sections](#3-understand-the-top-level-sections)
- [14) kubernetes_sd_configs Roles Explained (with real examples)](#14-kubernetes_sd_configs-roles-explained-with-real-examples)
- [15) relabel_configs: In Depth](#15-relabel_configs-in-depth)

### Step 4: Validate alerting path end-to-end

1. Port-forward Prometheus and Alertmanager:
```bash
kubectl -n monitoring-manual port-forward svc/prometheus-k8s 9090:9090
kubectl -n monitoring-manual port-forward svc/alertmanager 9093:9093
```
2. Check active alerts:
```bash
curl -s http://127.0.0.1:9090/api/v1/alerts | python3 -m json.tool
curl -s http://127.0.0.1:9093/api/v2/alerts | python3 -m json.tool
```

Read now:
- [16) Alertmanager Config Secret: Use Case and Fields](#16-alertmanager-config-secret-use-case-and-fields)
- [17) How Prometheus Contacts Alertmanager and How Alerts Resolve](#17-how-prometheus-contacts-alertmanager-and-how-alerts-resolve)

### Step 5: Practice routing, grouping, inhibition

Use section 17 snippets to:
1. Set `group_by: [alertname, team, namespace]`
2. Add team-based routes
3. Add inhibition rules
4. Re-test with API payload examples

Then validate with:
```bash
curl -s http://127.0.0.1:9093/api/v2/alerts | python3 -m json.tool
```

### Step 6: Troubleshoot if anything fails

Use this order:
1. [10) Quick commands reference](#10-quick-commands-reference)
2. [9) Most common beginner mistakes](#9-most-common-beginner-mistakes)
3. [7) How to read config without getting overwhelmed](#7-how-to-read-config-without-getting-overwhelmed)

### Step 7: Cleanup and rerun lab

```bash
./scripts/manual-stack/cleanup_manual_stack.sh
```

Rerun from Step 1 to build hands-on confidence.

---

## 1) Big picture first

In Prometheus Operator setup, you usually do **not** hand-edit a static `prometheus.yml`.

Instead:
1. You create Kubernetes resources (Prometheus, ServiceMonitor, PodMonitor, PrometheusRule).
2. Prometheus Operator reads those resources.
3. Operator generates the effective Prometheus config.
4. Generated config is stored in a Secret and rendered into the Prometheus Pod.

So when you see a long config with many `serviceMonitor/...` jobs, that is generated output.

---

## 2) Where this config lives

### A) In Kubernetes Secret (generated source)
Secret name pattern:
- `prometheus-<prometheus-cr-name>`

### B) Inside Prometheus Pod (rendered file)
File path:
- `/etc/prometheus/config_out/prometheus.env.yaml`

This is the effective runtime config that Prometheus uses.

---

## 3) Understand the top-level sections

You shared a config structure like this:
- `global`
- `runtime`
- `alerting`
- `rule_files`
- `scrape_configs`
- `storage`
- `otlp`

Here is what each means.

### 3.1 global
Controls default behavior for all scrape jobs unless a job overrides it.

Common fields:
- `scrape_interval`: default how often to scrape targets (for example 30s).
- `scrape_timeout`: max time per scrape before timeout.
- `evaluation_interval`: how often Prometheus evaluates alerting/recording rules.
- `external_labels`: labels automatically attached to all time series and alerts.

Why it matters:
- If `scrape_interval` is too high, graphs look sparse.
- If timeout is too low, slow endpoints may fail with scrape timeout.

#### More on `external_labels` (important in production)

`external_labels` are static labels Prometheus adds to:
- all alerts sent to Alertmanager
- outbound samples sent via remote_write

Typical labels:
- `cluster`: identifies source cluster (`prod-us-east-1`)
- `environment`: `prod`, `staging`, `dev`
- `prometheus`: logical Prometheus instance name
- `prometheus_replica`: replica identity in HA setups

Example:
```yaml
global:
  external_labels:
    cluster: prod-us-east-1
    environment: prod
    prometheus: k8s-main
    prometheus_replica: prom-0
```

Why this matters:
1. Multi-cluster querying
- Same metric name from different clusters can be separated by `cluster` label.

2. Alert routing context
- Alertmanager can route based on `cluster` or `environment` without editing every alert rule.

3. HA deduplication
- In two-replica Prometheus HA, both replicas send same alert/samples.
- `prometheus_replica` lets downstream systems deduplicate correctly.

4. Remote write attribution
- Long-term storage can identify where samples came from.

Collision behavior:
- If a label with same key already exists on a series, Prometheus does not overwrite that series label with external label in local TSDB.
- For alerts, external labels are added to alert payload unless label key already exists on alert.

Good practice:
- Keep keys stable across org (`cluster`, `environment`, `team`).
- Do not use high-cardinality values (hostnames, UUIDs, request IDs) as external labels.
- Keep `prometheus_replica` only for dedup pipelines, not dashboard filtering.

Quick verification:
```bash
## check active config
curl -s http://localhost:9090/api/v1/status/config | python3 -m json.tool

## check alert labels include external labels
curl -s http://localhost:9090/api/v1/alerts | python3 -m json.tool
```

In the alert JSON, confirm labels like `cluster` and `environment` are present.

End-to-end example (production style):

1) Prometheus config with external labels:
```yaml
global:
  scrape_interval: 30s
  evaluation_interval: 30s
  external_labels:
    cluster: prod-us-east-1
    environment: prod
    team: platform
    prometheus: monitoring-main
    prometheus_replica: prom-0
```

2) Alert rule (no cluster/environment hardcoding needed):
```yaml
groups:
- name: app-alerts
  rules:
  - alert: ApiHigh5xxRate
    expr: |
      (
        sum(rate(http_request_duration_seconds_count{job="api",status=~"5.."}[5m]))
        /
        sum(rate(http_request_duration_seconds_count{job="api"}[5m]))
      ) > 0.02
    for: 10m
    labels:
      severity: critical
    annotations:
      summary: API 5xx rate is high
      description: 5xx ratio greater than 2% for 10m
```

3) Example alert payload received by Alertmanager:
```json
{
  "labels": {
    "alertname": "ApiHigh5xxRate",
    "severity": "critical",
    "job": "api",
    "cluster": "prod-us-east-1",
    "environment": "prod",
    "team": "platform",
    "prometheus": "monitoring-main",
    "prometheus_replica": "prom-0"
  },
  "annotations": {
    "summary": "API 5xx rate is high",
    "description": "5xx ratio greater than 2% for 10m"
  }
}
```

4) Alertmanager routing using those labels:
```yaml
route:
  receiver: default
  group_by: [alertname, cluster, environment, team]
  routes:
  - match:
      environment: prod
      severity: critical
    receiver: pagerduty-prod
  - match:
      environment: prod
      severity: warning
    receiver: slack-prod-warning
```

Result: one alert rule works across environments, and routing is controlled by stable external labels.

### 3.2 runtime
Runtime tuning for Prometheus process itself.

Example:
- `gogc: 75` controls Go GC aggressiveness.

Usually advanced tuning; most users leave defaults unless troubleshooting memory/CPU.

### 3.3 alerting
Defines where alerts are sent and how alert labels are relabeled.

Key parts:
- `alertmanagers`: where Prometheus sends firing alerts.
- `alert_relabel_configs`: modify alert labels before sending.

In your config, Alertmanager discovery uses Kubernetes endpoints in namespace `monitoring`.

### 3.4 rule_files
Paths to rule files loaded by Prometheus.

These include:
- Recording rules (precompute expressions)
- Alerting rules (fire alerts when conditions match)

Operator mounts these files into the Pod.

### 3.5 scrape_configs
Most important section for target scraping.

Each entry is one job.
Examples from your config:
- `serviceMonitor/monitoring/kube-prom-grafana/0`
- `serviceMonitor/monitoring/kube-prom-kube-prometheus-alertmanager/0`
- `serviceMonitor/monitoring/status-web/0`

This section tells Prometheus:
- where to discover targets
- which targets to keep/drop
- which endpoint path/scheme/port to use
- how to relabel metadata into metric labels

### 3.6 storage
TSDB retention and storage behavior.

Example:
- `retention.time: 1w` means keep 1 week of data.

### 3.7 otlp
OpenTelemetry ingestion translation behavior.

If you are not pushing OTLP into Prometheus, this is usually not your day-1 concern.

---

## 4) Deep dive into one scrape job

Use this mental model on any job:

### 4.1 job_name
Example:
- `serviceMonitor/monitoring/status-web/0`

Meaning:
- generated from ServiceMonitor named `status-web` in namespace `monitoring`
- `/0` is endpoint index in ServiceMonitor endpoints list

### 4.2 scrape interval/timeout at job level
If present here, these override global defaults.

In your status-web job, interval is set from ServiceMonitor endpoint (`15s`).

### 4.3 metrics_path and scheme
- `metrics_path: /metrics`
- `scheme: http` or `https`

These map directly to endpoint config and target protocol.

### 4.4 kubernetes_sd_configs
Defines Kubernetes service discovery source.

Example:
- `role: endpoints`
- namespace list controls where discovery happens (`default`, `monitoring`, etc).

This means Prometheus asks Kubernetes API for endpoint objects and then filters.

### 4.5 relabel_configs
This is the most confusing but most powerful part.

Think of relabeling as a target filter and label mapper pipeline.

Typical relabel actions in your config:
- keep only matching services by labels
- keep only matching endpoint port names
- map kubernetes metadata to labels like `namespace`, `service`, `pod`, `container`
- drop pods in terminal phase (`Failed|Succeeded`)
- set final `job` and `endpoint` labels

If a keep rule does not match, target is dropped.
That is often why people see no data.

### 4.6 metric_relabel_configs
Applied after scraping, on each sample.

Used to:
- drop noisy metrics
- reduce cardinality
- keep only selected metrics

In your config, some kubelet jobs drop many high-volume metrics to reduce storage pressure.

---

## 5) Why ServiceMonitor label matters

You asked why `release: kube-prom` mattered.

Because Prometheus CR has selector:
- `spec.serviceMonitorSelector.matchLabels.release = kube-prom`

Meaning:
- Operator only includes ServiceMonitors with that label.
- Included ServiceMonitors become generated jobs in `scrape_configs`.

That is exactly why your `status-web` job appeared only after adding matching label.

---

## 6) Why no data without ServiceMonitor

Without matching ServiceMonitor:
- no generated `serviceMonitor/.../status-web/...` scrape job
- Prometheus has no instruction to scrape your app
- query returns empty even if app responds 200/400/503

With matching ServiceMonitor:
- job appears in `scrape_configs`
- target appears in Targets UI and becomes UP
- metrics become queryable

---

## 7) How to read config without getting overwhelmed

Use this order every time:

1. Find top-level `global` to know defaults.
2. Find your job in `scrape_configs` by name.
3. Verify `metrics_path`, `scheme`, `scrape_interval`.
4. Verify `kubernetes_sd_configs` namespace and role.
5. Read relabel rules in order; check keep/drop conditions.
6. Confirm target status in Prometheus Targets page.
7. Then debug PromQL labels (`job`, `namespace`, `service`, `status`).

---

## 8) Mapping your webapp case to config

Your app:
- Service name: `status-web`
- Namespace: `default`
- Metrics: `/metrics` on port `http` (9898)

Your generated job:
- `job_name: serviceMonitor/monitoring/status-web/0`
- discovery from namespace `default`
- relabels set labels such as `namespace=default`, `service=status-web`

Metric for status codes in podinfo:
- `http_request_duration_seconds_count`
- label key `status`

Good PromQL:
- `sum by (status) (rate(http_request_duration_seconds_count{job="status-web",status=~"200|400|503"}[5m]))`

---

## 9) Most common beginner mistakes

1. Wrong ServiceMonitor label (not selected by Prometheus CR).
2. Wrong ServiceMonitor namespace.
3. Wrong service label selector in ServiceMonitor.
4. Wrong endpoint port name (must match Service port name, not container port number).
5. Querying wrong metric name or wrong label key (`code` vs `status`).
6. Looking at PromQL before first successful scrapes.

---

## 10) Quick commands reference

### Show Prometheus selector (which ServiceMonitors are accepted)

```bash
kubectl -n monitoring get prometheus -o jsonpath='{.items[0].spec.serviceMonitorSelector.matchLabels}'
```

### Show generated config from Secret

```bash
PROM=$(kubectl -n monitoring get prometheus -o jsonpath='{.items[0].metadata.name}')
kubectl -n monitoring get secret "prometheus-${PROM}" -o jsonpath='{.data.prometheus\.yaml\.gz}' \
| openssl base64 -d -A | gunzip -c
```

### Show rendered config inside Pod

```bash
POD=$(kubectl -n monitoring get pod -l app.kubernetes.io/name=prometheus -o jsonpath='{.items[0].metadata.name}')
kubectl -n monitoring exec "$POD" -c config-reloader -- sed -n '1,120p' /etc/prometheus/config_out/prometheus.env.yaml
```

### Find your job quickly

```bash
kubectl -n monitoring exec "$POD" -c config-reloader -- \
  grep -n 'job_name: serviceMonitor/monitoring/status-web/0' /etc/prometheus/config_out/prometheus.env.yaml
```

---

## 11) Final simplified summary

- Prometheus Operator builds config for you.
- `scrape_configs` is where target scraping rules live.
- ServiceMonitor creates those scrape jobs.
- Label selectors decide whether a ServiceMonitor is included.
- If job exists and target is UP, your PromQL should work.

---

## 12) Regex and Relabeling: In and Out

This section explains the regex rules you see in `relabel_configs` and `metric_relabel_configs`.

### 12.1 Why regex appears everywhere

Prometheus Kubernetes discovery gives many metadata labels like:
- `__meta_kubernetes_service_label_*`
- `__meta_kubernetes_endpoint_port_name`
- `__meta_kubernetes_namespace`

Relabel rules use regex to:
- keep only desired targets
- drop unwanted targets
- extract values from metadata
- rewrite labels (`job`, `namespace`, `pod`, etc.)

---

### 12.2 Core relabel actions and exact meaning

#### action: keep

Meaning:
- Keep target only if regex matches source labels.
- If no match, target is dropped.

Example from your config:

```yaml
- action: keep
  source_labels:
  - __meta_kubernetes_service_label_release
  - __meta_kubernetes_service_labelpresent_release
  regex: (kube-prom);true
```

How to read:
- Join source labels with `separator: ;` (default is `;`), so value becomes like `kube-prom;true`.
- Keep only if service label `release` exists and equals `kube-prom`.

#### action: drop

Meaning:
- Drop target/sample if regex matches.

Example:

```yaml
- action: drop
  source_labels:
  - __meta_kubernetes_pod_phase
  regex: (Failed|Succeeded)
```

How to read:
- Ignore completed/failed pods from scraping.

#### action: replace

Meaning:
- Set `target_label` using regex capture groups.

Example:

```yaml
- source_labels:
  - __meta_kubernetes_service_name
  target_label: job
  replacement: ${1}
```

Usually paired with a regex that captures value into group 1.

Another common one from your config:

```yaml
- source_labels:
  - __meta_kubernetes_endpoint_address_target_kind
  - __meta_kubernetes_endpoint_address_target_name
  regex: Pod;(.*)
  replacement: ${1}
  target_label: pod
```

How to read:
- Input like `Pod;status-web-xxxxx` => set `pod=status-web-xxxxx`.

#### action: hashmod

Meaning:
- Hash label value and take modulus.
- Used for sharding targets across Prometheus replicas.

Example:

```yaml
- source_labels:
  - __tmp_hash
  modulus: 1
  target_label: __tmp_hash
  action: hashmod
```

With modulus 1, all hashes become 0 (single shard setup).

---

### 12.3 Regex building blocks you will see

#### (value)
Capturing group 1.

Example:
- `regex: (kube-prom);true`

#### (a|b|c)
Alternation (OR).

Example:
- `regex: (Failed|Succeeded)`

#### (.*)
Capture any text.

Example:
- `regex: Pod;(.*)` captures pod name.

#### .+
One or more characters.

Example:
- `regex: (.+)` means value must be non-empty.

#### Anchoring behavior
Prometheus relabel regex is matched against full concatenated value for relabel processing.
In practice, write explicit patterns as if full value should match.

---

### 12.4 labelpresent pattern: why two source labels are used

Pattern in your config:

```yaml
source_labels:
- __meta_kubernetes_service_label_release
- __meta_kubernetes_service_labelpresent_release
regex: (kube-prom);true
```

Why this is used:
- first label gives actual value (`kube-prom`)
- second label indicates existence (`true`/`false`)

This prevents accidental matches when label is missing.

---

### 12.5 separator and concatenation

When multiple `source_labels` are used:
- Values are joined by `separator` (default `;`).

So with:
- value1 = `kube-prom`
- value2 = `true`

Input to regex becomes:
- `kube-prom;true`

That is why many regex patterns in your file include a semicolon.

---

### 12.6 ${1} and $1 replacement

Both represent captured group 1 depending on context/style generated.

Examples from generated configs:
- `replacement: ${1}`
- `replacement: $1`

Both mean: substitute first regex capture group.

---

### 12.7 SHARD placeholder you see in generated config

You may see:

```yaml
regex: $(SHARD);|.+;.+
```

Meaning:
- This is templated by operator for shard logic.
- Combined with `hashmod`, it keeps only targets for this Prometheus shard.
- In single replica/single shard setups, effectively all intended targets are kept.

Do not manually edit this in generated config; it is operator-managed.

---

### 12.8 Reading one keep rule end to end

Rule:

```yaml
- action: keep
  source_labels:
  - __meta_kubernetes_endpoint_port_name
  regex: http
```

Interpretation:
1. Read endpoint port name from Kubernetes metadata.
2. Keep only endpoints whose port name is exactly `http`.
3. If service exposes only `metrics` port name but rule expects `http`, target is dropped.

This is a common cause of missing targets.

---

### 12.9 metric_relabel regex (post-scrape)

Example style from your kubelet jobs:

```yaml
- source_labels: [__name__]
  regex: container_spec.*
  action: drop
```

Meaning:
- scrape succeeds
- then samples with metric names matching `container_spec.*` are removed
- helps reduce cardinality/storage

Important:
- `relabel_configs` filters targets before scrape
- `metric_relabel_configs` filters samples after scrape

---

### 12.10 Regex troubleshooting checklist

If a target is missing, verify in this order:

1. ServiceMonitor label matches Prometheus selector.
2. Service labels match ServiceMonitor selector.
3. Endpoint `port` name matches relabel keep rule.
4. Namespace in discovery block includes your namespace.
5. Keep/drop regex does not exclude your target.

If metrics are missing but target is UP:

1. Check metric name exists.
2. Check label key (`status` vs `code`).
3. Check metric_relabel rules are not dropping the metric.

---

### 12.11 Safe rule of thumb for beginners

- Treat generated regex blocks as read-only output.
- Make changes in ServiceMonitor/PodMonitor/Prometheus spec, not in generated file.
- After change, verify generated job appears and target is UP.

---


## 14) kubernetes_sd_configs Roles Explained (with real examples)

You asked about this block:

```yaml
- job_name: kubernetes-service-endpoints
  kubernetes_sd_configs:
  - role: endpoints
```

Meaning:
- `job_name` is just the scrape job label/name.
- `kubernetes_sd_configs` tells Prometheus to discover targets from Kubernetes API.
- `role: endpoints` means discover endpoint addresses behind Services.

### 14.1 Common Kubernetes SD roles

#### role: endpoints
- Discovers Endpoints objects (service backends).
- Best when scraping through Services.
- Common for service-level monitoring.

Typical use:
```yaml
- job_name: kubernetes-service-endpoints
  kubernetes_sd_configs:
  - role: endpoints
```

Pros:
- Stable service-based discovery.
- Works well with Service annotations and ServiceMonitor-like patterns.

#### role: pod
- Discovers pods directly.
- Good when scraping pod endpoints not exposed via Service.
- Often used with pod annotations or PodMonitor-like behavior.

Typical use:
```yaml
- job_name: kubernetes-pods
  kubernetes_sd_configs:
  - role: pod
```

Pros:
- Fine-grained per-pod control.

Trade-off:
- More target churn as pods restart frequently.

#### role: service
- Discovers Services as targets (service DNS/cluster IP model).
- Less common for app metrics than `endpoints`.
- Useful for service-level blackbox style checks.

Typical use:
```yaml
- job_name: kubernetes-services
  kubernetes_sd_configs:
  - role: service
```

#### role: endpointslice
- Discovers EndpointSlice resources (newer scalable replacement for Endpoints).
- Better scalability in large clusters.

Typical use:
```yaml
- job_name: kubernetes-endpointslice
  kubernetes_sd_configs:
  - role: endpointslice
```

#### role: node
- Discovers cluster nodes.
- Useful for kubelet/node-exporter style scraping.

Typical use:
```yaml
- job_name: kubernetes-nodes
  kubernetes_sd_configs:
  - role: node
```

#### role: ingress
- Discovers Ingress resources.
- Usually used with blackbox probing rather than direct app metrics scraping.

Typical use:
```yaml
- job_name: kubernetes-ingress
  kubernetes_sd_configs:
  - role: ingress
```

### 14.2 Which role to use for your app

For your current app monitoring lab:
- Use `role: endpoints` if you scrape via Kubernetes Service.
- Use `role: pod` only when you intentionally want pod-direct scraping.

Since your app is exposed with Service `status-web`, `endpoints` is the right choice.

### 14.3 Quick decision matrix

- Service-based scraping with stable port name: `endpoints`
- Pod-level scraping with pod annotations: `pod`
- Node metrics: `node`
- Large clusters with EndpointSlice adoption: `endpointslice`
- Ingress/URL probing workflows: `ingress`

### 14.4 Important follow-up

Role only decides discovery source. You still need `relabel_configs` to:
- keep only the right targets
- set labels (`job`, `namespace`, `service`, `pod`)
- drop noisy or invalid targets

So `role: endpoints` is step 1 (discover), relabeling is step 2 (select and shape).

---

## 15) relabel_configs: In Depth

### 15.1 What is relabel_configs?

After Prometheus discovers targets from Kubernetes (using `kubernetes_sd_configs`), every discovered target carries a large set of temporary metadata labels that start with `__meta_`.

`relabel_configs` is a pipeline of rules that:
1. Reads those `__meta_*` labels.
2. Filters targets (keep/drop).
3. Transforms labels (rename, extract, rewrite).
4. Produces the final set of labels attached to all scraped metrics.

If relabeling drops a target, Prometheus never scrapes it.

---

### 15.2 Pipeline model (sequential, not parallel)

Rules are applied top to bottom, one at a time.

```
discovered target
  → rule 1 (runs on current labels)
  → rule 2 (runs on result of rule 1)
  → rule 3 (runs on result of rule 2)
  → ...
  → final target labels OR dropped
```

If any keep rule does not match, target is dropped immediately and remaining rules do not run.

---

### 15.3 Every available action

#### action: keep
Keep target only when regex matches joined source labels.  
If no match: target dropped.

```yaml
- action: keep
  source_labels: [__meta_kubernetes_service_annotation_prometheus_io_scrape]
  regex: true
```

Meaning: only keep targets where the annotation `prometheus.io/scrape` equals `true`.

---

#### action: drop
Drop target when regex matches.  
If match: target dropped.

```yaml
- action: drop
  source_labels: [__meta_kubernetes_pod_phase]
  regex: (Failed|Succeeded)
```

Meaning: drop completed/terminated pods.

---

#### action: replace
Read source labels, apply regex, write capture group into target label.  
Default action when action is omitted.

```yaml
- source_labels: [__meta_kubernetes_namespace]
  target_label: namespace
```

Meaning: copy namespace metadata into final `namespace` label on every metric.

With regex and capture group:

```yaml
- source_labels: [__address__, __meta_kubernetes_service_annotation_prometheus_io_port]
  regex: ([^:]+)(?::\d+)?;(\d+)
  replacement: $1:$2
  target_label: __address__
```

Meaning: rewrite scrape target address to use port from annotation instead of default.

---

#### action: labelmap
Copy labels matching regex to new label names based on replacement pattern.

```yaml
- action: labelmap
  regex: __meta_kubernetes_service_label_(.+)
```

Meaning: copy all service labels from metadata into metric labels. For example, `__meta_kubernetes_service_label_app` becomes `app`.

---

#### action: labeldrop
Remove labels matching regex from final label set.

```yaml
- action: labeldrop
  regex: (prometheus_replica)
```

Meaning: remove `prometheus_replica` label before storing/alerting.  
Seen in your Alertmanager alert_relabel_configs.

---

#### action: labelkeep
Keep only labels matching regex, drop all others.

```yaml
- action: labelkeep
  regex: (job|namespace|service|status)
```

Meaning: strip all labels except the ones listed.

---

#### action: hashmod
Hash source label values and compute modulus.  
Used for sharding targets across Prometheus replicas.

```yaml
- source_labels: [__address__]
  modulus: 3
  target_label: __tmp_hash
  action: hashmod
```

Meaning: assign each target to one of 3 shards based on hash of address.

---

### 15.4 Special internal labels

These are written by Prometheus relabeling engine itself:

| Label | Meaning |
|---|---|
| `__address__` | target host:port used for scraping |
| `__metrics_path__` | metrics path (default /metrics) |
| `__scheme__` | http or https |
| `__param_<name>` | URL query params passed to scrape |
| `__tmp_*` | temporary working labels, not stored in final metrics |

Example of rewriting the scrape address:

```yaml
- source_labels: [__address__, __meta_kubernetes_service_annotation_prometheus_io_port]
  regex: ([^:]+)(?::\d+)?;(\d+)
  replacement: $1:$2
  target_label: __address__
```

This rewrites `10.0.0.5:80` into `10.0.0.5:9898` using port annotation value.

---

### 15.5 Available __meta_* labels per role

When using `role: endpoints`:

| Label | Value |
|---|---|
| `__meta_kubernetes_namespace` | namespace of the endpoint |
| `__meta_kubernetes_service_name` | service name |
| `__meta_kubernetes_endpoint_port_name` | port name from Service spec |
| `__meta_kubernetes_endpoint_port_protocol` | TCP or UDP |
| `__meta_kubernetes_endpoint_address_target_kind` | Node or Pod |
| `__meta_kubernetes_endpoint_address_target_name` | pod or node name |
| `__meta_kubernetes_service_label_<labelname>` | any service label |
| `__meta_kubernetes_service_annotation_<annotationname>` | any service annotation |
| `__meta_kubernetes_pod_name` | pod name backing this endpoint |
| `__meta_kubernetes_pod_label_<labelname>` | any pod label |

When using `role: pod`:

| Label | Value |
|---|---|
| `__meta_kubernetes_pod_name` | pod name |
| `__meta_kubernetes_pod_namespace` | namespace |
| `__meta_kubernetes_pod_label_<labelname>` | pod labels |
| `__meta_kubernetes_pod_annotation_<annotationname>` | pod annotations |
| `__meta_kubernetes_pod_container_name` | container name |
| `__meta_kubernetes_pod_container_port_name` | container port name |
| `__meta_kubernetes_pod_ip` | pod IP |
| `__meta_kubernetes_pod_phase` | Running/Pending/Failed/Succeeded |

When using `role: node`:

| Label | Value |
|---|---|
| `__meta_kubernetes_node_name` | node name |
| `__meta_kubernetes_node_label_<labelname>` | node labels |
| `__meta_kubernetes_node_annotation_<annotationname>` | node annotations |
| `__meta_kubernetes_node_address_InternalIP` | node internal IP |

---

### 15.6 How ServiceMonitor becomes a scrape job (this repo)

You declare scrape intent in [manifests/manual-stack/12-operator-status-web-servicemonitor.yaml](../manifests/manual-stack/12-operator-status-web-servicemonitor.yaml). The Operator generates a job with `kubernetes_sd_configs` + `relabel_configs` similar to:

```yaml
# Generated conceptually — do not edit by hand
- job_name: serviceMonitor/default/status-web/0
  kubernetes_sd_configs:
  - role: endpoints
    namespaces:
      names: [default]
  relabel_configs:
  - source_labels: [__meta_kubernetes_service_label_app]
    regex: status-web
    action: keep
  - source_labels: [__meta_kubernetes_endpoint_port_name]
    regex: http-metrics
    action: keep
```

**Why ServiceMonitor instead of annotations?** In CR mode you never maintain annotation-based discovery (`prometheus.io/scrape`) — the ServiceMonitor is the contract.

Step by step:

1. Rule 1 (keep): Only scrape services where annotation `prometheus.io/scrape=true` is set. Everything else is dropped.
2. Rule 2 (replace): If service has annotation `prometheus.io/path`, rewrite `__metrics_path__` to that value. Otherwise defaults to `/metrics`.
3. Rule 3 (replace): Rewrite scrape address to use port from annotation `prometheus.io/port`. This overrides any default service port.
4. Rule 4 (replace): Copy namespace metadata into final `namespace` label on metrics.
5. Rule 5 (replace): Copy service name into final `service` label.
6. Rule 6 (replace): Copy service name into final `job` label.

Result of this pipeline for your status-web service:
- Scrapes `10.x.x.x:9898/metrics`
- Attaches labels: `job=status-web`, `service=status-web`, `namespace=default`

---

### 15.7 Common mistakes with relabel_configs

1. Wrong source label name
- `__meta_kubernetes_service_annotation_prometheus_io_scrape` is the correct key.
- Annotation `prometheus.io/scrape` maps to label name with dots replaced by underscores and slash replaced by underscore.
- So `prometheus.io/scrape` becomes `prometheus_io_scrape` in the key suffix.

2. Missing keep rule matching
- If annotation is absent or value is not exact `true`, target is dropped at rule 1.
- Changing annotation to `yes` or `1` breaks discovery.

3. Address rewrite regex mismatch
- Regex `([^:]+)(?::\d+)?;(\d+)` expects two source labels joined by `;`.
- `$1` is the host part of address, `$2` is the port from annotation.
- If annotation is missing, second part is empty and rewrite may fail.

4. Wrong target_label name
- Writing to `__address__` changes scrape target.
- Writing to `__metrics_path__` changes scrape path.
- Writing to anything else just adds a label to metrics.

---

## 16) Alertmanager Config Secret: Use Case and Fields

### 16.1 Why a Secret, not a ConfigMap?

Alertmanager config frequently contains sensitive credentials:
- Slack webhook URLs
- PagerDuty API keys
- Email SMTP passwords
- OpsGenie tokens

So it is stored as a Kubernetes Secret (base64-encoded, RBAC-restricted) instead of a plain ConfigMap.

### 16.2 How it is mounted into the Alertmanager pod

In `manifests/manual-stack/03-alertmanager.yaml`:

```yaml
volumes:
- name: config
  secret:
    secretName: alertmanager-config
```

Kubernetes mounts the Secret as a file at:
- `/etc/alertmanager/alertmanager.yml`

Alertmanager reads that file at startup.

### 16.3 Each field explained

```yaml
global:
  resolve_timeout: 5m
```
When a firing alert stops firing, Alertmanager waits 5 minutes before sending a "resolved" notification.

```yaml
route:
  receiver: default-receiver
  group_wait: 30s
  group_interval: 5m
  repeat_interval: 3h
```

- `group_wait`: when a new alert fires, wait 30s before sending the first notification.  
  Gives time for related alerts to arrive so they can be grouped into one notification.
- `group_interval`: after sending the first notification for a group, wait 5m before sending again if new alerts join the same group.
- `repeat_interval`: if an alert keeps firing with no change, re-send notification every 3h.

```yaml
receivers:
- name: default-receiver
```
- This is a no-op receiver used for the lab (no real notification target).
- In production you would add Slack/PagerDuty/email config here.

### 16.4 Production example with Slack receiver

```yaml
receivers:
- name: default-receiver
  slack_configs:
  - api_url: https://hooks.slack.com/services/xxx/yyy/zzz
    channel: '#alerts'
    title: '{{ .GroupLabels.alertname }}'
    text: '{{ range .Alerts }}{{ .Annotations.description }}{{ end }}'
```

This is why Alertmanager config is a Secret: the webhook URL is sensitive and should not be in a plain ConfigMap.

### 16.5 Routing tree (production pattern)

In larger setups, routes can be nested by team/severity:

```yaml
route:
  receiver: default-receiver
  group_by: [alertname, namespace]
  routes:
  - match:
      severity: critical
    receiver: pagerduty-receiver
  - match:
      team: payments
    receiver: slack-payments
receivers:
- name: default-receiver
- name: pagerduty-receiver
  pagerduty_configs:
  - routing_key: <your-pagerduty-key>
- name: slack-payments
  slack_configs:
  - api_url: https://hooks.slack.com/services/xxx/yyy/zzz
    channel: '#payments-alerts'
```

This routes:
- `severity=critical` alerts to PagerDuty.
- `team=payments` alerts to a Slack channel.
- Everything else to default.

---

## 17) How Prometheus Contacts Alertmanager and How Alerts Resolve

### 17.1 Full alert lifecycle flow

```
Prometheus evaluates rule every evaluation_interval (30s)
  → expression becomes true
  → alert state = PENDING (if for: duration set)
  → after for: duration passes, state = FIRING
  → Prometheus POSTs alert payload to Alertmanager POST /api/v2/alerts

Alertmanager receives alert
  → groups it with other alerts sharing same group_by labels
  → waits group_wait (30s) for more alerts to join same group
  → sends ONE grouped notification to matched receiver

While alert stays FIRING:
  → Prometheus re-sends alert to Alertmanager every ~60s
  → Alertmanager re-notifies every repeat_interval (e.g. 3h)

Expression becomes false:
  → Prometheus sends RESOLVED flag to Alertmanager
  → Alertmanager waits resolve_timeout (5m)
  → sends "resolved" notification to receiver
```

### 17.2 How Prometheus knows where Alertmanager is

In `prometheus.yml`, the `alerting` block defines Alertmanager discovery.

Static (hard-coded, fragile):
```yaml
alerting:
  alertmanagers:
  - static_configs:
    - targets:
      - alertmanager.monitoring-manual.svc:9093
```

Dynamic (Kubernetes service discovery, production-safe):
```yaml
alerting:
  alertmanagers:
  - kubernetes_sd_configs:
    - role: endpoints
      namespaces:
        names:
        - monitoring-manual
    relabel_configs:
    - action: keep
      source_labels: [__meta_kubernetes_service_name]
      regex: alertmanager
    - action: keep
      source_labels: [__meta_kubernetes_endpoint_port_name]
      regex: http
    api_version: v2
```

Why dynamic is better:
- Alertmanager pod IP can change after restart.
- Dynamic discovery follows the pod automatically.
- No config file edit required when Alertmanager moves.

### 17.3 The `for:` duration and PENDING state

```yaml
- alert: StatusWebTargetDown
  expr: up{job="status-web"} == 0
  for: 5m
```

- When expression first becomes true, alert enters `PENDING`.
- It stays in PENDING for 5 minutes.
- Only after 5 continuous minutes does it become `FIRING` and notification is sent.

Why this matters:
- Prevents false alarms for transient flaps.
- A pod restart that takes 30s would not trigger the alert.
- A real outage lasting 5+ minutes will trigger it.

### 17.4 The 100-alerts scenario: grouping behavior

Suppose your system fires 100 alerts at once, all with the same `alertname` and `namespace`.

Without grouping:
- Alertmanager sends 100 separate notifications.
- On-call engineer wakes up to 100 pages.
- Alert fatigue begins immediately.

With grouping (how Alertmanager works by default):
```yaml
route:
  group_by: [alertname, namespace]
  group_wait: 30s
  group_interval: 5m
  repeat_interval: 3h
```

What happens:
1. All 100 alerts arrive within seconds of each other.
2. Alertmanager groups them into one group because they share `alertname` and `namespace`.
3. Alertmanager waits `group_wait: 30s` for more alerts to join.
4. Sends **one notification** summarizing all 100 alerts in the group.

So yes, 100 alerts = 1 notification (assuming same group labels).

### 17.5 What happens after 3 hours if alerts are still active

```
T+0m   → 100 alerts fire → grouped → 1 notification sent
T+30m  → 20 more alerts join same group → group_interval (5m) passes → 1 more notification
T+3h   → all 100 still firing → repeat_interval fires → 1 reminder notification
T+6h   → still firing → 1 more reminder
```

So you still get notified, but as a single grouped reminder every 3h rather than 100 individual pages.

### 17.6 How resolution works for a group

When alerts start resolving:
- If all 100 alerts resolve → one "resolved" notification sent after `resolve_timeout`.
- If 50 resolve, 50 still fire → Alertmanager updates the group, sends one notification with the current state.

Prometheus sends a `resolved` flag per alert individually to Alertmanager.  
Alertmanager tracks which alerts in the group are still active.

### 17.7 Reducing alert fatigue: production strategies

#### Strategy 1: Correct group_by labels

Group by meaningful dimensions, not too narrow and not too wide.

Too narrow (causes alert storm):
```yaml
group_by: [alertname, namespace, pod]
```
Each pod generates its own group → separate notification per pod.

Better for multi-pod outage:
```yaml
group_by: [alertname, namespace]
```
All pods in same namespace grouped → one notification.

#### Strategy 2: Tune group_wait for burst tolerance

```yaml
group_wait: 60s
```
Give Alertmanager 60s to collect all alerts from a cascading failure before sending.  
Reduces initial burst of notifications during mass outage.

#### Strategy 3: Increase repeat_interval for non-critical alerts

```yaml
routes:
- match:
    severity: warning
  repeat_interval: 12h
- match:
    severity: critical
  repeat_interval: 1h
```

Warning alerts do not need hourly reminders.  
Critical alerts should remind every hour until resolved.

#### Strategy 4: Use inhibition rules

Suppress child alerts when parent alert is already firing.

Example: if a node is down, suppress all pod alerts on that node:
```yaml
inhibit_rules:
- source_match:
    alertname: NodeDown
  target_match_re:
    alertname: (PodCrashLooping|TargetDown)
  equal: [node]
```

Effect: if NodeDown fires, all PodCrashLooping/TargetDown alerts for same node are silenced.  
On-call sees 1 alert (NodeDown) not 50 (NodeDown + 49 pod alerts).

#### Strategy 5: Silence during maintenance

Alertmanager supports silences via UI or API:
```bash
## silence all alerts for status-web for 2 hours
amtool silence add --alertmanager.url=http://alertmanager:9093 \
  job=status-web --duration=2h --comment="planned maintenance"
```

#### Strategy 6: Alert on symptoms not causes

Bad (too many alerts, all overlapping):
- Alert on pod restart
- Alert on container OOM
- Alert on high CPU
- Alert on disk full
- Alert on slow DB

Better (alert on user-visible impact):
- Alert on high 5xx rate (user-facing symptom)
- Alert on latency p99 above SLO threshold

This cuts alert volume from 20+ to 2-3 meaningful signals.

### 17.8 Production recommended route config

```yaml
route:
  receiver: default-receiver
  group_by: [alertname, namespace]
  group_wait: 60s
  group_interval: 5m
  repeat_interval: 4h
  routes:
  - match:
      severity: critical
    receiver: pagerduty-receiver
    repeat_interval: 1h
    group_wait: 30s
  - match:
      severity: warning
    receiver: slack-warnings
    repeat_interval: 24h

inhibit_rules:
- source_match:
    severity: critical
  target_match:
    severity: warning
  equal: [alertname, namespace]

receivers:
- name: default-receiver
- name: pagerduty-receiver
  pagerduty_configs:
  - routing_key: <key>
- name: slack-warnings
  slack_configs:
  - api_url: <webhook>
    channel: '#alerts-warning'
```

Effect:
- Critical alerts go to PagerDuty, remind every 1h.
- Warning alerts go to Slack, remind every 24h.
- If critical and warning fire for same issue, warning is suppressed (inhibition).
- All grouped by alertname + namespace, so 100 pod alerts = 1 notification.

---

### 17.2 What an alert payload looks like (100 alerts)

When Prometheus fires alerts, it POSTs JSON to Alertmanager.
Here is exactly what the payload looks like for one alert and for 100 alerts.

Single alert payload:
```json
[
  {
    "labels": {
      "alertname": "StatusWebTargetDown",
      "severity": "warning",
      "job": "status-web",
      "namespace": "default",
      "team": "payments"
    },
    "annotations": {
      "summary": "status-web target is down",
      "description": "Prometheus cannot scrape status-web for 5m."
    },
    "startsAt": "2024-06-17T10:00:00Z",
    "endsAt": "0001-01-01T00:00:00Z",
    "generatorURL": "http://prometheus:9090/graph?g0.expr=up%7Bjob%3D%22status-web%22%7D+%3D%3D+0"
  }
]
```

Key fields:
- `labels`: all labels attached to alert rule plus target labels
- `annotations`: summary/description text shown in notification
- `startsAt`: when alert fired
- `endsAt`: zero value = still firing; set to real time when resolved
- `generatorURL`: link back to Prometheus graph for debugging

When 100 pods all fire the same alert, Prometheus sends 100 objects in one POST:
```json
[
  { "labels": { "alertname": "PodCrashLooping", "pod": "app-1",   "namespace": "prod", "team": "payments" }, "annotations": { "description": "Pod app-1 is crash looping"   } },
  { "labels": { "alertname": "PodCrashLooping", "pod": "app-2",   "namespace": "prod", "team": "payments" }, "annotations": { "description": "Pod app-2 is crash looping"   } },
  ...
  { "labels": { "alertname": "PodCrashLooping", "pod": "app-100", "namespace": "prod", "team": "payments" }, "annotations": { "description": "Pod app-100 is crash looping" } }
]
```

All 100 share same `alertname`, `namespace`, `team` but different `pod` label.
Alertmanager groups them by `group_by` labels and sends ONE notification.

---

### 17.3b group_by: [alertname, team, namespace] in depth

```yaml
route:
  group_by: [alertname, team, namespace]
```

Alertmanager groups alerts into the same bucket only if ALL THREE labels share the same value.

Scenario: 100 PodCrashLooping alerts across 2 teams.

| pod | alertname | team | namespace |
|---|---|---|---|
| app-1 to app-80 | PodCrashLooping | payments | prod |
| svc-1 to svc-20 | PodCrashLooping | orders | prod |

With `group_by: [alertname, team, namespace]`:
- Group 1: team=payments → 80 alerts → **1 notification to payments team**
- Group 2: team=orders → 20 alerts → **1 notification to orders team**
- Total: 2 notifications instead of 100

With `group_by: [alertname, namespace]` (no team):
- Group 1: namespace=prod → all 100 alerts → **1 notification to default receiver**
- Both teams share the same single notification (or neither gets it if routing isn't split)

Wrong grouping: `group_by: [alertname, namespace, pod]`
- Each pod makes its own group (100 unique pod labels)
- 100 alerts = 100 separate notifications
- Alert storm

---

### 17.4b How to route alerts to different teams

The `team` label in the alert rule is the key trigger.

Step 1: Add team label in PrometheusRule:
```yaml
apiVersion: monitoring.coreos.com/v1
kind: PrometheusRule
metadata:
  name: payments-alerts
  namespace: monitoring-manual
  labels:
    release: kube-prom
spec:
  groups:
  - name: payments.alerts
    rules:
    - alert: PodCrashLooping
      expr: kube_pod_container_status_restarts_total{namespace="prod"} > 5
      for: 5m
      labels:
        severity: critical
        team: payments
      annotations:
        summary: "Pod {{ $labels.pod }} crash looping"
        description: "Pod {{ $labels.pod }} in {{ $labels.namespace }} restarted >5 times"
```

Step 2: Route in Alertmanager config Secret based on team label:
```yaml
route:
  receiver: default-receiver
  group_by: [alertname, team, namespace]
  group_wait: 60s
  group_interval: 5m
  repeat_interval: 4h
  routes:
  - match:
      team: payments
    receiver: slack-payments
    repeat_interval: 2h
  - match:
      team: orders
    receiver: slack-orders
    repeat_interval: 2h
  - match:
      team: platform
    receiver: pagerduty-platform
    repeat_interval: 30m

receivers:
- name: default-receiver
- name: slack-payments
  slack_configs:
  - api_url: https://hooks.slack.com/services/xxx
    channel: '#payments-alerts'
    title: '[{{ .Status | toUpper }}] {{ .GroupLabels.alertname }}'
    text: |
      *Team:* {{ .GroupLabels.team }}
      *Namespace:* {{ .GroupLabels.namespace }}
      *Total firing:* {{ len .Alerts.Firing }}
      {{ range .Alerts.Firing }}
      • *Pod:* {{ .Labels.pod }} — {{ .Annotations.description }}
      {{ end }}
- name: slack-orders
  slack_configs:
  - api_url: https://hooks.slack.com/services/yyy
    channel: '#orders-alerts'
    title: '[{{ .Status | toUpper }}] {{ .GroupLabels.alertname }}'
    text: |
      *Team:* {{ .GroupLabels.team }}
      *Total firing:* {{ len .Alerts.Firing }}
      {{ range .Alerts.Firing }}
      • *Pod:* {{ .Labels.pod }} — {{ .Annotations.description }}
      {{ end }}
- name: pagerduty-platform
  pagerduty_configs:
  - routing_key: <key>
    description: '{{ .GroupLabels.alertname }} — {{ len .Alerts }} alerts in {{ .GroupLabels.namespace }}'
```

Where to make changes summary:
- Add `team` label → PrometheusRule `labels:` block
- Routing logic → `route.routes` in Alertmanager config Secret
- Receiver targets → `receivers` in Alertmanager config Secret

---

### 17.5b Inhibition rules: in depth

Inhibition suppresses (silences) child alerts when a parent alert is already firing.

Problem without inhibition:
- Node goes down → Prometheus fires NodeDown
- All 49 pods on that node crash → Prometheus fires 49x PodCrashLooping
- All 20 services unavailable → Prometheus fires 20x TargetDown
- On-call gets 70 alerts, most caused by the single node failure

With inhibition:
- NodeDown fires → on-call gets 1 page
- All pod/target alerts on same node are silenced automatically

Inhibition rule structure:
```yaml
inhibit_rules:
- source_match:           # parent alert that causes suppression
    alertname: NodeDown
  target_match_re:        # child alerts to suppress (regex)
    alertname: (PodCrashLooping|TargetDown)
  equal: [node]           # both parent and child MUST share this label value
```

How it works step by step:
1. NodeDown fires for `node=worker-1`
2. PodCrashLooping fires for `node=worker-1, pod=app-1`
3. Alertmanager checks: is there a NodeDown with `node=worker-1`?
4. Yes → PodCrashLooping for `node=worker-1` is suppressed
5. On-call only sees NodeDown

The `equal` field is critical:
- `equal: [node]` means source AND target must share exact same `node` value
- Without it, ANY NodeDown would suppress ALL PodCrashLooping everywhere

Multiple inhibition rules:
```yaml
inhibit_rules:
## critical suppresses warning for same issue
- source_match:
    severity: critical
  target_match:
    severity: warning
  equal: [alertname, namespace, team]

## NodeDown suppresses pod/target alerts on same node
- source_match:
    alertname: NodeDown
  target_match_re:
    alertname: (PodCrashLooping|TargetDown|ContainerOOMKilled)
  equal: [node]

## Namespace quota exceeded suppresses individual OOM on same namespace
- source_match:
    alertname: NamespaceQuotaExceeded
  target_match:
    alertname: ContainerOOMKilled
  equal: [namespace]
```

Concrete label-level example (how matching really happens):

Inhibition rule:
```yaml
inhibit_rules:
- source_match:
    alertname: NodeDown
  target_match_re:
    alertname: (PodCrashLooping|TargetDown)
  equal: [node]
```

Source (parent) alert labels:
```yaml
labels:
  alertname: NodeDown
  severity: critical
  node: worker-1
  team: platform
annotations:
  summary: Node worker-1 is down
```

Target (child) alert labels:
```yaml
labels:
  alertname: PodCrashLooping
  severity: warning
  node: worker-1
  pod: payments-api-7c4d9f6f8d-x2m9p
  namespace: prod
  team: payments
annotations:
  summary: Pod crash looping on worker-1
```

Why this child alert is suppressed:
1. `source_match` is true because parent has `alertname=NodeDown`.
2. `target_match_re` is true because child has `alertname=PodCrashLooping`.
3. `equal: [node]` is true because both have `node=worker-1`.

Child alert that is NOT suppressed (different node):
```yaml
labels:
  alertname: PodCrashLooping
  node: worker-2
  pod: orders-api-55f6c8d9f-9l2kt
```

This one is not inhibited because `node` value does not match the source alert.

API payload test example (post both alerts to Alertmanager):
```json
[
  {
    "labels": {
      "alertname": "NodeDown",
      "node": "worker-1",
      "severity": "critical",
      "team": "platform"
    },
    "annotations": {
      "summary": "Node worker-1 is down"
    },
    "startsAt": "2026-06-17T10:00:00Z"
  },
  {
    "labels": {
      "alertname": "PodCrashLooping",
      "node": "worker-1",
      "pod": "payments-api-abc",
      "namespace": "prod",
      "severity": "warning",
      "team": "payments"
    },
    "annotations": {
      "summary": "Pod crash looping on worker-1"
    },
    "startsAt": "2026-06-17T10:00:00Z"
  }
]
```

### 17.5c Avoid hardcoded node label values in alert rules

You are correct: in production, alert rules should not hardcode specific node names like `node="worker-1"`.

Bad (hardcoded node value):
```promql
up{job="node-exporter", node="worker-1"} == 0
```

Why bad:
- New/replaced node names break alert intent.
- Rule does not scale with autoscaling/cluster changes.

Good pattern 1 (all nodes, dynamic labels from metrics):
```promql
up{job="node-exporter"} == 0
```

Good pattern 2 (scope by stable metadata, not node name):
```promql
up{job="node-exporter", cluster="prod-us-east-1"} == 0
```

Good pattern 3 (role/team scoping via node labels joined from kube-state-metrics):
```promql
(
  up{job="node-exporter"} == 0
)
* on (node) group_left(label_node_role_kubernetes_io_worker)
  kube_node_labels{label_node_role_kubernetes_io_worker="true"}
```

This alerts on worker nodes dynamically, without hardcoding individual node names.

Production recommendation:
1. Hardcode only stable dimensions (`cluster`, `environment`, `team`).
2. Never hardcode ephemeral identities (`pod`, specific node name, replica hash).
3. Let target labels from discovery/metrics provide per-node values.

### 17.5d How to implement this in production (step by step)

Below is a practical pattern to avoid hardcoded node names and still get actionable alerts.

Step 1: Ensure node metrics include a stable node label

Check label shape first:
```promql
up{job="node-exporter"}
```

You should see labels like:
- `instance="10.0.0.12:9100"`
- `job="node-exporter"`
- often `node="worker-1"` (if relabeling adds it)

If `node` label is not present, add relabeling in scrape config to map node name into `node`.

Step 2: Scope alerts by stable dimensions only

Good production alert (cluster + env scope, no node hardcoding):
```yaml
- alert: NodeExporterTargetDown
  expr: up{job="node-exporter",cluster="prod-us-east-1",environment="prod"} == 0
  for: 10m
  labels:
    severity: critical
    team: platform
  annotations:
    summary: "Node exporter target down"
    description: "Node exporter target {{ $labels.instance }} is down in {{ $labels.cluster }}"
```

Step 3: Use node roles dynamically when needed

Alert only for worker nodes (dynamic role filtering):
```yaml
- alert: WorkerNodeDown
  expr: |
    (
      up{job="node-exporter",cluster="prod-us-east-1"} == 0
    )
    * on (node) group_left(label_node_role_kubernetes_io_worker)
      kube_node_labels{label_node_role_kubernetes_io_worker="true"}
  for: 10m
  labels:
    severity: critical
    team: platform
  annotations:
    summary: "Worker node down"
    description: "Worker node {{ $labels.node }} is down"
```

Step 4: Keep alert volume low using aggregation

Instead of one alert per noisy metric series, aggregate by stable dimensions:
```yaml
- alert: HighNodeExporterDownRatio
  expr: |
    (
      sum(up{job="node-exporter",cluster="prod-us-east-1"} == 0)
      /
      count(up{job="node-exporter",cluster="prod-us-east-1"})
    ) > 0.2
  for: 10m
  labels:
    severity: critical
    team: platform
  annotations:
    summary: "High node target down ratio"
    description: "More than 20% node-exporter targets are down in prod-us-east-1"
```

Step 5: Route using team/severity, not node name

```yaml
route:
  receiver: default-receiver
  group_by: [alertname, team, cluster, environment]
  routes:
  - match:
      team: platform
      severity: critical
    receiver: pagerduty-platform
```

Step 6: Validate before production rollout

Use these checks:

```bash
## 1) ensure no hardcoded node value in rules
kubectl -n monitoring get prometheusrule -o yaml | grep -E 'node="[^"]+"' || true

## 2) preview affected series for alert query
kubectl -n monitoring port-forward svc/prometheus-k8s 9090:9090
curl -s 'http://127.0.0.1:9090/api/v1/query?query=up%7Bjob%3D%22node-exporter%22%2Ccluster%3D%22prod-us-east-1%22%7D' | python3 -m json.tool

## 3) verify rule is loaded and active
curl -s 'http://127.0.0.1:9090/api/v1/rules' | python3 -m json.tool
```

Expected production behavior:
- New/replaced nodes are automatically covered by the same rule.
- No rule edits required when node names change.
- Team routing remains stable because routing keys use stable labels (`team`, `severity`, `cluster`).

---

### 17.6b How 100 grouped alerts appear in notification

Alertmanager sends one message with all alerts via template:

```yaml
text: |
  *Group:* {{ .GroupLabels.alertname }} in {{ .GroupLabels.namespace }}
  *Total alerts:* {{ len .Alerts }}
  *Firing:* {{ len .Alerts.Firing }}
  *Resolved:* {{ len .Alerts.Resolved }}
  {{ range .Alerts.Firing }}
  • Pod: {{ .Labels.pod }} — {{ .Annotations.description }}
  {{ end }}
```

This produces one Slack message:
```
Group: PodCrashLooping in prod
Total alerts: 100
Firing: 100
Resolved: 0
• Pod: app-1 — Pod app-1 is crash looping
• Pod: app-2 — Pod app-2 is crash looping
...
```

---

### 17.7b Verification checklist: how to confirm everything is wired correctly

Check 1: Prometheus alert state:
```bash
kubectl -n monitoring-manual port-forward svc/prometheus-k8s 9090:9090 &
curl -s http://localhost:9090/api/v1/alerts | python3 -m json.tool
```
Expected: alerts with `state: firing` or `state: pending`.

Check 2: Alertmanager receives alerts:
```bash
kubectl -n monitoring-manual port-forward svc/alertmanager 9093:9093 &
curl -s http://localhost:9093/api/v2/alerts | python3 -m json.tool
```
Expected: fired alerts appear with their labels.

Check 3: Test routing logic manually:
```bash
## simulate routing for a payments/critical alert
curl -s -X POST http://localhost:9093/api/v2/alerts \
  -H 'Content-Type: application/json' \
  -d '[{"labels":{"alertname":"TestAlert","team":"payments","severity":"critical","namespace":"prod"},"annotations":{"summary":"test"},"startsAt":"2024-06-17T10:00:00Z","endsAt":"0001-01-01T00:00:00Z","generatorURL":"http://test"}]'
## then check http://localhost:9093 UI to see which group/receiver it landed in
```

Check 4: Verify grouping in Alertmanager UI:
- Open http://localhost:9093
- See grouped alerts under their group key labels
- Confirm grouping matches your `group_by`

Check 5: Confirm inhibition is working:
```bash
curl -s http://localhost:9093/api/v2/alerts | \
  python3 -c "
import sys, json
for a in json.load(sys.stdin):
    print(a['labels'].get('alertname'), '| inhibited:', a.get('inhibited', False))
"
```
Expected: suppressed alerts show `inhibited: True`.

---

### 17.8b Production complete config

```yaml
global:
  resolve_timeout: 5m

route:
  receiver: default-receiver
  group_by: [alertname, team, namespace]
  group_wait: 60s
  group_interval: 5m
  repeat_interval: 4h
  routes:
  - match:
      severity: critical
      team: payments
    receiver: pagerduty-payments
    repeat_interval: 1h
    group_wait: 30s
  - match:
      severity: critical
      team: orders
    receiver: pagerduty-orders
    repeat_interval: 1h
  - match:
      severity: warning
    receiver: slack-warnings
    repeat_interval: 24h

inhibit_rules:
- source_match:
    severity: critical
  target_match:
    severity: warning
  equal: [alertname, namespace, team]
- source_match:
    alertname: NodeDown
  target_match_re:
    alertname: (PodCrashLooping|TargetDown)
  equal: [node]

receivers:
- name: default-receiver
- name: pagerduty-payments
  pagerduty_configs:
  - routing_key: <payments-key>
    description: '{{ .GroupLabels.alertname }} — {{ len .Alerts }} alerts'
- name: pagerduty-orders
  pagerduty_configs:
  - routing_key: <orders-key>
    description: '{{ .GroupLabels.alertname }} — {{ len .Alerts }} alerts'
- name: slack-warnings
  slack_configs:
  - api_url: <webhook>
    channel: '#alerts-warning'
    title: '[WARNING] {{ .GroupLabels.alertname }}'
    text: |
      *Namespace:* {{ .GroupLabels.namespace }}
      *Team:* {{ .GroupLabels.team }}
      *Firing:* {{ len .Alerts.Firing }}
      {{ range .Alerts.Firing }}• {{ .Labels.pod }}: {{ .Annotations.summary }}
      {{ end }}
```

What this achieves:
- 100 payments alerts → 1 PagerDuty page to payments team
- 50 orders alerts → 1 PagerDuty page to orders team
- Warnings → Slack only, no repeat for 24h
- If critical and warning fire for same issue → warning suppressed
- If node goes down → pod/target alerts on that node suppressed

---

<a id="part-5"></a>

# Part 5: Interview & cross-questions (how / what / why)

Use these as self-checks after Parts 1–4.

## Architecture

| Question | Short answer |
|---|---|
| **What** is the difference between `prometheus-operator` and `prometheus-k8s`? | Operator = Deployment controller that compiles CRs; `prometheus-k8s` = StatefulSet running the actual Prometheus engine. See [Step 4b](#step-4b-two-workloads-youll-see--prometheus-operator-vs-prometheus-k8s). |
| **Why** use an Operator instead of a ConfigMap `prometheus.yml`? | GitOps-friendly CRs, auto-reload, fewer manual restarts, selector-based multi-tenancy. |
| **How** does Prometheus discover `status-web` in our lab? | ServiceMonitor `12` → Operator generates scrape job → Prometheus pulls `/metrics` on port name `http-metrics`. |
| **Why** does ServiceMonitor need `release: manual-operator`? | Prometheus CR `serviceMonitorSelector` only admits ServiceMonitors with that label. |
| **What** is a CRD and **why** install it before the Operator? | CRD registers API types (`Prometheus`, `ServiceMonitor`, `PrometheusRule`); without it `kubectl apply` of CRs fails. |

## Scraping & config

| Question | Short answer |
|---|---|
| **What** is the pull vs push model? | Prometheus **pulls** metrics via HTTP GET on an interval; it does not receive pushes (except Pushgateway pattern). |
| **Why** port **name** not port number in ServiceMonitor? | Operator resolves `endpoints.port` to the Service's named port; mismatch = dropped target. |
| **How** do you read generated `prometheus.yml` in CR mode? | `kubectl get secret prometheus-k8s -o yaml` or exec into `prometheus-k8s-0` — do not edit by hand. |
| **What** is `relabel_configs` vs `metric_relabel_configs`? | Relabel runs on **target metadata** before scrape; metric relabel runs on **sample labels** after scrape. |
| **Why** `role: endpoints` for apps behind a Service? | Discovers Pod IPs behind Service endpoints — standard pattern for ServiceMonitor-generated jobs. |

## Alerting

| Question | Short answer |
|---|---|
| **Why** Alertmanager separate from Prometheus? | Prometheus detects; Alertmanager groups, dedupes, routes, silences — different problems. |
| **How** does Prometheus find Alertmanager? | `spec.alerting.alertmanagers` on Prometheus CR → compiled into `alerting` block. |
| **What** does `for: 10m` do? | Alert stays **Pending** until condition true for 10m, then **Firing**. |
| **What** is `group_by`? | Buckets alerts into notification groups (e.g. same `team` + `alertname` → one Slack message). |
| **Why** restart Alertmanager after editing `02`? | Config is in a Secret mounted at start; unlike Operator Prometheus, no hot-reload for AM in our lab. |
| **What** are inhibition rules? | Suppress noisy child alerts when parent alert fires (e.g. node down inhibits pod alerts). |

## Thanos

| Question | Short answer |
|---|---|
| **Why** Thanos if Prometheus has a disk? | Local retention is limited; sidecar uploads blocks to object storage for long-term query. |
| **What** does Thanos Query do? | Single PromQL API merging live sidecar data + historical Store Gateway data. |
| **What** are the 3 containers in Thanos mode? | `prometheus`, `config-reloader`, `thanos-sidecar`. |
| **How** verify Thanos wiring? | `curl thanos-query:9090/api/v1/stores` lists sidecar + store components. |
| **How** does Thanos dedupe metrics? | Query merges series that match after stripping `--query.replica-label` labels (`replica`, `prometheus_replica`); keeps newest sample. See [Step 10 dedup](#how-thanos-deduplicates-and-why-it-matters). |
| **Why** `--query.replica-label`? | HA Prometheus (`replicas: 2`) scrapes the same targets twice — without replica labels stripped, `sum()` doubles. |
| **Does** Thanos dedupe alerts? | **No.** Alertmanager dedupes notifications; Thanos Query only dedupes **metric series** at query time. |
| **What** does Compactor dedupe? | Redundant **blocks** in object storage during compaction/downsampling — different layer from Query. |

## Operations & production

| Question | Short answer |
|---|---|
| **How** scale scrape load? | Increase `scrapeInterval`, drop cardinality, split Prometheus CRs per team, add resources. |
| **What** are external labels? | Labels added to all metrics/alerts from a Prometheus — required for multi-cluster/HA routing. |
| **Why** multiple Prometheus CRs? | Team isolation, different retention, selectors, or blast-radius control. |
| **How** silence during maintenance? | Alertmanager UI or `amtool silence add`. |
| **What** is the first debug command for missing metrics? | Prometheus UI → Status → Targets (check Dropped). |

---

<a id="part-6"></a>

# Part 6: Troubleshooting & common mistakes

## Decision tree

```
  No metrics?
    → kubectl get servicemonitor, svc status-web -o yaml
    → port NAME match? (http-metrics)
    → Prometheus Targets UI — Dropped?

  Metrics OK, no alert?
    → Prometheus Alerts tab (not Graph)
    → wait for `for:` duration
    → expr uses correct job label?

  Alert fires, no Slack?
    → Alertmanager UI / API
    → team label matches route in 02?
    → restart alertmanager after 02 change?

  prometheus-k8s STS missing?
    → kubectl get prometheus k8s; operator logs

  Thanos Query empty?
    → thanos-query pod running?
    → prometheus-k8s-0 is 3/3?
    → curl /api/v1/stores
```

## Top mistakes (this lab)

| # | Mistake | Symptom | Fix |
|---|---|---|---|
| 1 | ServiceMonitor `port: http` vs Service `http-metrics` | Target dropped | Align port names in `12` and prod Service |
| 2 | SM missing `release: manual-operator` | SM ignored | Add label; check `10` selector |
| 3 | Operator `--namespaces` missing `default` | SM not seen | Fix `08` args |
| 4 | Edit Alertmanager `02`, no restart | Old routing | `rollout restart deploy/alertmanager` |
| 5 | Check Graph tab for alerts | "Rule never fires" | Use **Alerts** tab |
| 6 | Thanos Query not deployed | port-forward fails | Apply `thanos/05-07` or full deploy |
| 7 | Bad `minio/mc` image tag | ImagePullBackOff | `minio/mc:latest` + preload |
| 8 | Wrong working directory | path not found | `cd` to repo root |
| 9 | Apply trimmed `01-crds.yaml` only | CRD validation errors | Use deploy script / `USE_FULL_CRDS=true install_operator_crds.sh` |
| 10 | Hand-edit prometheus.yml Secret | Operator overwrites | Change CRs `10/12/13` |
| 11 | HA Prometheus + Thanos, no replica labels | Grafana `sum()` 2× real value | Set `--query.replica-label` on Query; use Operator HA external labels |

## Troubleshooting matrix

| Problem | Checks | Likely fix |
|---|---|---|
| `up{job="status-web"}` empty | pods, svc, SM yaml | Fix selectors, port name, SM label |
| Target UP, query empty | metric names, traffic | Run test script; check `job` label |
| Alerts not in AM | `spec.alerting` on CR, AM pods | Fix `10` alerting block; check AM API |
| Too many pages | AM config | Tune `group_by`, `inhibit_rules`, `repeat_interval` |
| High Prometheus memory | label cardinality | Drop high-cardinality labels |
| Operator not reconciling | CRD, RBAC, logs | Full CRDs; check `07-08` |

## Debug commands

```bash
kubectl -n monitoring-manual get prometheus,servicemonitor,prometheusrule
kubectl -n monitoring-manual describe prometheus k8s
kubectl -n monitoring-manual logs deploy/prometheus-operator --tail=50
kubectl -n monitoring-manual port-forward svc/prometheus-k8s 9090:9090
curl -s 'http://127.0.0.1:9090/api/v1/targets?state=active' | python3 -m json.tool
curl -s 'http://127.0.0.1:9090/api/v1/rules' | python3 -m json.tool
curl -s 'http://127.0.0.1:9093/api/v2/alerts' | python3 -m json.tool
```

---

<a id="part-7"></a>

# Part 7: Production-grade checklist

## Before go-live

| Area | What to verify | Why |
|---|---|---|
| Discovery | ServiceMonitor labels match CR selectors; operator `--namespaces` includes app NS | Wrong scope = silent blind spots |
| RBAC | Prometheus SA can list/watch services, endpoints, pods in target NS | Without it, SD returns empty |
| Target health | `up{job="..."} == 1` stable | Flapping targets = alert noise |
| Cardinality | No `user_id`, `request_id` in labels | Memory and query cost explode |
| Alert quality | Every alert has `summary`, `description`, `severity`, owner `team` | On-call can act without guessing |
| Routing | `group_by`, `repeat_interval`, receivers tested with synthetic alert | Prevents pager storms |
| Inhibition | Parent/child rules for infra vs app alerts | Reduces duplicate pages |
| External labels | `cluster`, `environment` on Prometheus CR | Multi-cluster Alertmanager dedup |
| Retention & disk | PVC size vs `retention` + ingestion rate | Disk full = data loss |
| Security | No admin API in prod; TLS on ingress; secrets not in git | Attack surface |
| Thanos (if used) | Object store lifecycle, compactor running, Query HA | Long-term query reliability |
| Runbooks | Link from alert annotations to Confluence/wiki | MTTR |

## Multi-team pattern (when one Prometheus is not enough)

```
  Team payments SM (label release=payments-prom)
        │
        ▼
  Prometheus CR "payments"  ──►  STS prometheus-payments
        │
        └── team: payments on PrometheusRule labels ──► AM route ──► #alerts-payments

  Team platform SM (label release=platform-prom)
        │
        ▼
  Prometheus CR "platform"  ──►  STS prometheus-platform
```

Key knobs: `serviceMonitorSelector`, `ruleSelector`, operator `--namespaces`, Alertmanager `route.routes` matchers on `team`.

## Recommended Alertmanager route shape

```yaml
route:
  group_by: [alertname, team, namespace]
  group_wait: 30s
  group_interval: 5m
  repeat_interval: 4h
  receiver: default
  routes:
  - matchers: [severity="critical"]
    receiver: pagerduty-critical
    repeat_interval: 1h
  - matchers: [team="payments"]
    receiver: slack-payments
```

## Production vs this lab

| Lab | Production |
|---|---|
| `enableAdminAPI: true` | `false` |
| 1 replica | 2+ Prometheus or Thanos HA |
| 24h retention | Thanos / remote write / longer PVC |
| Slack webhook in Secret | Vault + rotated tokens |
| kind + MinIO | Managed S3/GCS + IRSA |

---

# Appendices (merged reference library)

All former `docs/*.md` files are included below for single-file sharing.

<a id="appendix-a"></a>

# Appendix A: Manifest file reference

Sequential manifests under `manifests/manual-stack/` — apply in order **00 → 13**.

| # | File | Purpose |
|---|---|---|
| 00 | `00-namespace.yaml` | Creates `monitoring-manual` namespace |
| 01 | `01-crds.yaml` | Offline fallback CRDs (3 types). Deploy uses full upstream CRDs via `install_operator_crds.sh`. |
| 02 | `02-alertmanager-config.yaml` | Secret with `alertmanager.yml` (team routes, inhibit rules) |
| 03 | `03-alertmanager.yaml` | Alertmanager Deployment + Service `alertmanager` |
| 04 | `04-grafana-secret.yaml` | Grafana admin credentials (demo defaults) |
| 05 | `05-grafana-datasource.yaml` | Datasource → `prometheus-k8s` (**default** deploy) |
| 06 | `06-grafana.yaml` | Grafana Deployment + Service |
| 07 | `07-operator-rbac.yaml` | ServiceAccount + cluster-admin for the operator |
| 08 | `08-operator-deployment.yaml` | **Deployment** `prometheus-operator` — controller ([Step 4b](#step-4b-two-workloads-youll-see--prometheus-operator-vs-prometheus-k8s)) |
| 09 | `09-operator-prometheus-rbac.yaml` | `prometheus-k8s` ServiceAccount + discovery RBAC |
| 10 | `10-operator-prometheus-cr.yaml` | **Prometheus CR** — Operator creates **StatefulSet** `prometheus-k8s` (default, no Thanos) |
| 11 | `11-operator-prometheus-service.yaml` | Service `prometheus-k8s` on port 9090 |
| 12 | `12-operator-status-web-servicemonitor.yaml` | Scrapes `status-web` (`port: http-metrics`) |
| 13 | `13-operator-status-web-prometheusrule.yaml` | Recording rules + alerts with `team` labels |

#### Optional Thanos stack (`thanos/`)

Used only when `./deploy_manual_stack.sh thanos` (or `WITH_THANOS=true`).

| File | Purpose |
|---|---|
| `thanos/01-minio.yaml` | MinIO (S3-compatible) for kind |
| `thanos/02-minio-bucket-job.yaml` | Creates `thanos` bucket |
| `thanos/03-objstore-secret.yaml` | Object storage config Secret |
| `thanos/04-prometheus-cr-thanos.yaml` | Prometheus CR with `spec.thanos` + PVC (**replaces file 10**) |
| `thanos/05-thanos-query.yaml` | Thanos Query (Grafana PromQL entrypoint) |
| `thanos/06-thanos-store-gateway.yaml` | Serves historical blocks from MinIO |
| `thanos/07-thanos-compactor.yaml` | Compacts blocks in object storage |
| `thanos/08-grafana-datasource-thanos.yaml` | Grafana → `thanos-query` (**replaces file 05** in thanos mode) |

Thanos mode installs **full upstream CRDs** (required for `spec.thanos` and `storage` on the Prometheus CR).

#### Deploy

```bash
### Default (no Thanos)
./scripts/manual-stack/deploy_manual_stack.sh

### Thanos + MinIO on kind
./scripts/manual-stack/deploy_manual_stack.sh thanos

### Podman + kind: preload images first
PRELOAD_IMAGES=true KIND_CLUSTER_NAME=kind-otel-test ./scripts/manual-stack/deploy_manual_stack.sh thanos
```

Env: `WITH_GRAFANA=false`, `WITH_STATUS_WEB=false`, `WITH_THANOS=true`, `PRELOAD_IMAGES=true`.

#### Cleanup

```bash
### Full teardown (default + Thanos)
./scripts/manual-stack/cleanup_manual_stack.sh

### Also remove Prometheus PVCs (full reset)
DELETE_PVCS=true ./scripts/manual-stack/cleanup_manual_stack.sh

### Remove Thanos only; keep base Prometheus stack
./scripts/manual-stack/thanos/cleanup_thanos_stack.sh
```

#### Application (prod)

| File | Purpose |
|---|---|
| `manifests/prod/status-web-deployment.yaml` | Demo app |
| `manifests/prod/status-web-service.yaml` | Service `http-metrics` port |

See [Chapter 6.5](#chapter-65-thanos--minio-optional-long-term-storage) for architecture and verification.

---

<a id="appendix-b"></a>

# Appendix B: Prometheus Bible (extended reference)

> Quick-reference tables, recording rules, deploy chapters, Staff engineer playbook, and PromQL appendix.

**Reference and deep-dive companion** for this repository.  
**Structure of this file (experienced users):**

| Section | Content |
|---|---|
| [Quick reference](#quick-reference-what-file-to-change) | Which file to edit |
| [Copy-Paste Pack](#copy-paste-pack) | Manifest snippets |
| Chapters 1–4 | Concepts (expanded in journey doc) |
| Chapters 5–6.5 | **Deploy** demos (default + Thanos) |
| Chapter 7+ | **Troubleshooting**, production, Staff playbook |
| Appendices | Manifest map, scripts, PromQL |

You are not just applying YAML files. You are building a complete observability path: from a running application, through discovery and scraping, to rules, alerts, routing, and dashboards.

**Audience:** Use [Part 1](#part-1) for onboarding. **Chapters 8–9** below are for Staff engineers who own production rollout.

---

### How to read this book

| If you are… | Start here |
|---|---|
| **Brand new — learn why each component exists** | **[Part 1](#part-1)** |
| **Deploy vs StatefulSet (`prometheus-operator` / `prometheus-k8s`)** | [Step 4b](#step-4b-two-workloads-youll-see--prometheus-operator-vs-prometheus-k8s) |
| **Ready to deploy the lab** | **[Part 2](#part-2)** |
| **Something broke** | **[Part 6](#part-6)** |
| Thanos + long-term storage | [Journey — Step 10](#step-10-thanos--when-one-prometheus-disk-is-not-enough) · [Chapter 6.5](#chapter-65-thanos--minio-optional-long-term-storage) |
| Operator + CR deep dive | [Chapter 3.5](#chapter-35-deep-dive--prometheus-operator-and-custom-resources) |
| **What file do I change?** | [Quick reference](#quick-reference-what-file-to-change) |
| Interview / cross-questions | [Part 5](#part-5) |
| Production checklist | [Part 7](#part-7) · [Chapter 8](#chapter-8-production-grade) |
| Staff engineer playbook | [Chapter 9](#chapter-9-staff-engineer-production-playbook) |

---

### Quick reference: what file to change?

Use this table when you know **what** you want to change but not **where** in the repo.

| I want to… | Edit this file | Mode | After apply |
|---|---|---|---|
| **Alerting rules** | | | |
| Change alert `expr`, `for`, `severity` | `13-operator-status-web-prometheusrule.yaml` | Operator | `kubectl apply -f` file 13 — auto-reload |
| Add `team: payments` (or `order`) on alerts | `13` | Operator | `kubectl apply` file 13 |
| Add **recording rule** (`record:`) | `13` → group `status-web.recording` | Operator | `kubectl apply` file 13 |
| **Alertmanager routing** | | | |
| Route alerts to a team (`team="payments"`) | `02-alertmanager-config.yaml` → `route.routes` | Shared | `kubectl apply` file 02 + **restart** Alertmanager |
| Add **receiver** (Slack, PagerDuty, webhook) | `02` → `receivers` | Shared | apply + restart Alertmanager |
| Change Slack message (`GroupLabels.team`, etc.) | `02` → receiver `slack_configs.text` | Shared | apply + restart Alertmanager |
| Change **group_by** / `group_wait` / `repeat_interval` | `02` → `route` | Shared | apply + restart Alertmanager |
| Add or change **inhibit_rules** (`equal`, matchers) | `02` → `inhibit_rules` | Shared | apply + restart Alertmanager |
| Add new team (e.g. `team: order`) end-to-end | `13` labels + `02` route + receiver | Operator | apply 13 + 02, restart AM |
| **Prometheus → Alertmanager** | | | |
| Tell operator Prometheus where to send alerts | `10-operator-prometheus-cr.yaml` → `spec.alerting` | Operator | `kubectl apply` file 10 — auto-reload |
| **Scraping / discovery** | | | |
| Change scrape interval, path, port (CR) | `12-operator-status-web-servicemonitor.yaml` | Operator | `kubectl apply` file 12 — auto-reload |
| Which apps get scraped (CR) | `12` selector + `10` `serviceMonitorSelector` label | Operator | apply 12 (+ label on SM) |
| App Service port name (`http-metrics`) | `manifests/prod/status-web-service.yaml` | App | apply Service; **must match** file 12 `endpoints.port` |
| **Operator / CR wiring** | | | |
| Which PrometheusRules get loaded | `10` → `ruleSelector` / `ruleNamespaceSelector` | Operator | apply file 10 |
| Which ServiceMonitors get loaded | `10` → `serviceMonitorSelector` | Operator | apply file 10 |
| Install CRDs | `install_operator_crds.sh` (deploy script runs this automatically) | CR | before files 07-13 |
| Operator watch namespaces | `08-operator-deployment.yaml` → `--namespaces` | Operator | apply + restart operator |
| **Workloads** | | | |
| Deploy / scale status-web app | `manifests/prod/status-web-deployment.yaml` | App | `kubectl apply` / `scale` |
| Alertmanager process | `03-alertmanager.yaml` | Shared | apply (config is in `02` Secret) |
| Operator-managed Prometheus | `10` (CR) — Operator creates pod | Operator | apply file 10 |
| Grafana datasource URL | `05-grafana-datasource.yaml` | Shared | apply + restart Grafana |
| **Maintenance** | | | |
| Silence alerts (planned downtime) | Alertmanager API / `amtool` (not a file) | Shared | no file change |
| Avoid 5xx alert when scaled to 0 | `13` expr guard + `02` inhibit | Operator | apply rules + `02` |

**Restart vs auto-reload:**

| Component | Config source | After change |
|---|---|---|
| Operator Prometheus | CR / PrometheusRule / ServiceMonitor | Operator + config-reloader → **no pod restart** |
| Alertmanager | Secret `02` | `kubectl rollout restart deploy/alertmanager` |
| Prometheus Operator | Deployment `08` | restart operator pod |

**Which UI to check:**

| Question | Port-forward |
|---|---|
| Did alert fire? | `svc/prometheus-k8s` → `/api/v1/alerts` |
| Did Alertmanager route it? | `svc/alertmanager` → `/api/v2/alerts` |
| Is target scraped? | Prometheus → Status → Targets |

See also [Appendix A: Manifest map](#appendix-a-manifest-map-files-00-13).

---

### Copy-Paste Pack

If you want to recreate this lab from this document alone, copy these manifests into separate files and apply them in the order shown.

**Canonical source:** The repo files under `manifests/manual-stack/` are always authoritative. Prefer:

```bash
./scripts/manual-stack/deploy_manual_stack.sh          # default
./scripts/manual-stack/deploy_manual_stack.sh thanos # optional Thanos + MinIO
```

**Apply order (manual):** `00` → `01` CRDs → `02-03` Alertmanager → (optional `04-06` Grafana) → prod status-web → `07-13`. Thanos adds `thanos/*` — see [Chapter 6.5](#chapter-65-thanos--minio-optional-long-term-storage).

---

#### Base namespace and workload

> Use `manifests/prod/status-web-deployment.yaml` + `status-web-service.yaml` (port name `http-metrics`).

```yaml
apiVersion: v1
kind: Namespace
metadata:
  name: monitoring-manual
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: status-web
  namespace: default
  labels:
    app: status-web
spec:
  replicas: 1
  selector:
    matchLabels:
      app: status-web
  template:
    metadata:
      labels:
        app: status-web
    spec:
      containers:
      - name: podinfo
        image: ghcr.io/stefanprodan/podinfo:6.6.3
        ports:
        - containerPort: 9898
          name: http
---
apiVersion: v1
kind: Service
metadata:
  name: status-web
  namespace: default
  labels:
    app: status-web
spec:
  selector:
    app: status-web
  ports:
  - name: http
    port: 9898
    targetPort: http
```

#### Alertmanager (shared)

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: alertmanager-config
  namespace: monitoring-manual
type: Opaque
stringData:
  alertmanager.yml: |
    global:
      resolve_timeout: 1m
    route:
      receiver: default-receiver
      group_by: ['alertname', 'team', 'namespace']
      group_wait: 30s
      group_interval: 5m
      repeat_interval: 3h
      routes:
      - matchers:
        - team="payments"
        receiver: team-payments
        continue: false
      - matchers:
        - team="order"
        receiver: team-order
        continue: false
    inhibit_rules:
    - source_matchers:
      - alertname="StatusWebTargetDown"
      target_matchers:
      - alertname="StatusWebHigh5xxRate"
      equal: ['job', 'namespace', 'team']
    - source_matchers:
      - severity="critical"
      target_matchers:
      - severity="warning"
      equal: ['alertname', 'namespace', 'team']
    receivers:
    - name: default-receiver
      webhook_configs:
      - url: http://127.0.0.1:1/unrouted
        send_resolved: true
    - name: team-payments
      slack_configs:
      - api_url: https://hooks.slack.com/services/REPLACE/PAYMENTS/WEBHOOK
        channel: '#alerts-payments'
        send_resolved: true
        title: '[{{ .Status | toUpper }}] {{ .GroupLabels.alertname }}'
        text: |
          Team: {{ .GroupLabels.team }}
          Namespace: {{ .GroupLabels.namespace }}
          {{ range .Alerts.Firing }}• {{ .Annotations.summary }}
          {{ end }}
    - name: team-order
      slack_configs:
      - api_url: https://hooks.slack.com/services/REPLACE/ORDER/WEBHOOK
        channel: '#alerts-order'
        send_resolved: true
        title: '[{{ .Status | toUpper }}] {{ .GroupLabels.alertname }}'
        text: |
          Team: {{ .GroupLabels.team }}
          Namespace: {{ .GroupLabels.namespace }}
          {{ range .Alerts.Firing }}• {{ .Annotations.summary }}
          {{ end }}
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: alertmanager
  namespace: monitoring-manual
spec:
  replicas: 1
  selector:
    matchLabels:
      app: alertmanager
  template:
    metadata:
      labels:
        app: alertmanager
    spec:
      containers:
      - name: alertmanager
        image: prom/alertmanager:v0.27.0
        args:
        - --config.file=/etc/alertmanager/alertmanager.yml
        - --storage.path=/alertmanager
        ports:
        - name: http
          containerPort: 9093
        volumeMounts:
        - name: config
          mountPath: /etc/alertmanager
        - name: data
          mountPath: /alertmanager
      volumes:
      - name: config
        secret:
          secretName: alertmanager-config
      - name: data
        emptyDir: {}
---
apiVersion: v1
kind: Service
metadata:
  name: alertmanager
  namespace: monitoring-manual
spec:
  selector:
    app: alertmanager
  ports:
  - name: http
    port: 9093
    targetPort: http
---
apiVersion: v1
kind: Secret
metadata:
  name: grafana-admin
  namespace: monitoring-manual
type: Opaque
stringData:
  admin-user: admin
  admin-password: admin123
---
apiVersion: v1
kind: ConfigMap
metadata:
  name: grafana-datasources
  namespace: monitoring-manual
data:
  datasources.yaml: |
    apiVersion: 1
    datasources:
    - name: Prometheus
      type: prometheus
      access: proxy
      url: http://prometheus-k8s.monitoring-manual.svc:9090
      isDefault: true
      editable: true
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: grafana
  namespace: monitoring-manual
spec:
  replicas: 1
  selector:
    matchLabels:
      app: grafana
  template:
    metadata:
      labels:
        app: grafana
    spec:
      containers:
      - name: grafana
        image: grafana/grafana:11.1.0
        env:
        - name: GF_SECURITY_ADMIN_USER
          valueFrom:
            secretKeyRef:
              name: grafana-admin
              key: admin-user
        - name: GF_SECURITY_ADMIN_PASSWORD
          valueFrom:
            secretKeyRef:
              name: grafana-admin
              key: admin-password
        ports:
        - name: http
          containerPort: 3000
        volumeMounts:
        - name: datasources
          mountPath: /etc/grafana/provisioning/datasources
      volumes:
      - name: datasources
        configMap:
          name: grafana-datasources
---
apiVersion: v1
kind: Service
metadata:
  name: grafana
  namespace: monitoring-manual
spec:
  selector:
    app: grafana
  ports:
  - name: http
    port: 3000
    targetPort: http
```

#### Operator CRDs (required before operator deployment)

Before deploying the Prometheus Operator, install the custom resource definitions (CRDs):

```yaml
apiVersion: apiextensions.k8s.io/v1
kind: CustomResourceDefinition
metadata:
  name: prometheuses.monitoring.coreos.com
spec:
  group: monitoring.coreos.com
  names:
    kind: Prometheus
    plural: prometheuses
  scope: Namespaced
  versions:
  - name: v1
    served: true
    storage: true
    schema:
      openAPIV3Schema:
        type: object
        properties:
          spec:
            type: object
            properties:
              replicas:
                type: integer
              scrapeInterval:
                type: string
              evaluationInterval:
                type: string
              retention:
                type: string
              serviceAccountName:
                type: string
              serviceMonitorSelector:
                type: object
              serviceMonitorNamespaceSelector:
                type: object
              ruleSelector:
                type: object
              ruleNamespaceSelector:
                type: object
              podMonitorSelector:
                type: object
              podMonitorNamespaceSelector:
                type: object
              enableAdminAPI:
                type: boolean
              resources:
                type: object
---
apiVersion: apiextensions.k8s.io/v1
kind: CustomResourceDefinition
metadata:
  name: servicemonitors.monitoring.coreos.com
spec:
  group: monitoring.coreos.com
  names:
    kind: ServiceMonitor
    plural: servicemonitors
  scope: Namespaced
  versions:
  - name: v1
    served: true
    storage: true
    schema:
      openAPIV3Schema:
        type: object
        properties:
          spec:
            type: object
            properties:
              namespaceSelector:
                type: object
              selector:
                type: object
              endpoints:
                type: array
---
apiVersion: apiextensions.k8s.io/v1
kind: CustomResourceDefinition
metadata:
  name: prometheusrules.monitoring.coreos.com
spec:
  group: monitoring.coreos.com
  names:
    kind: PrometheusRule
    plural: prometheusrules
  scope: Namespaced
  versions:
  - name: v1
    served: true
    storage: true
    schema:
      openAPIV3Schema:
        type: object
        properties:
          spec:
            type: object
            properties:
              groups:
                type: array
```

#### Operator CR mode

```yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: prometheus-operator
  namespace: monitoring-manual
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: prometheus-operator-cluster-admin
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin
subjects:
- kind: ServiceAccount
  name: prometheus-operator
  namespace: monitoring-manual
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: prometheus-operator
  namespace: monitoring-manual
  labels:
    app.kubernetes.io/name: prometheus-operator
spec:
  replicas: 1
  selector:
    matchLabels:
      app.kubernetes.io/name: prometheus-operator
  template:
    metadata:
      labels:
        app.kubernetes.io/name: prometheus-operator
    spec:
      serviceAccountName: prometheus-operator
      containers:
      - name: prometheus-operator
        image: quay.io/prometheus-operator/prometheus-operator:v0.76.0
        imagePullPolicy: IfNotPresent
        args:
        - --log-level=info
        - --kubelet-service=kube-system/kubelet
        - --prometheus-config-reloader=quay.io/prometheus-operator/prometheus-config-reloader:v0.76.0
        - --prometheus-instance-namespaces=monitoring-manual
        - --alertmanager-instance-namespaces=monitoring-manual
        - --thanos-ruler-instance-namespaces=monitoring-manual
        - --namespaces=monitoring-manual,default
        ports:
        - name: http
          containerPort: 8080
        resources:
          requests:
            cpu: 100m
            memory: 128Mi
          limits:
            cpu: 500m
            memory: 512Mi
```

```yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: prometheus-k8s
  namespace: monitoring-manual
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: prometheus-k8s
rules:
- apiGroups: [""]
  resources: ["nodes", "nodes/proxy", "services", "endpoints", "pods", "namespaces"]
  verbs: ["get", "list", "watch"]
- apiGroups: ["networking.k8s.io"]
  resources: ["ingresses"]
  verbs: ["get", "list", "watch"]
- nonResourceURLs: ["/metrics"]
  verbs: ["get"]
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: prometheus-k8s
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: prometheus-k8s
subjects:
- kind: ServiceAccount
  name: prometheus-k8s
  namespace: monitoring-manual
---
apiVersion: monitoring.coreos.com/v1
kind: Prometheus
metadata:
  name: k8s
  namespace: monitoring-manual
  labels:
    app.kubernetes.io/name: prometheus
spec:
  replicas: 1
  serviceAccountName: prometheus-k8s
  evaluationInterval: 30s
  scrapeInterval: 30s
  retention: 24h
  enableAdminAPI: true
  alerting:
    alertmanagers:
    - namespace: monitoring-manual
      name: alertmanager
      port: http
      apiVersion: v2
  ruleSelector: {}
  ruleNamespaceSelector: {}
  serviceMonitorSelector:
    matchLabels:
      release: manual-operator
  serviceMonitorNamespaceSelector: {}
  podMonitorSelector: {}
  podMonitorNamespaceSelector: {}
  resources:
    requests:
      cpu: 200m
      memory: 512Mi
    limits:
      cpu: 1000m
      memory: 2Gi
---
apiVersion: v1
kind: Service
metadata:
  name: prometheus-k8s
  namespace: monitoring-manual
  labels:
    app.kubernetes.io/name: prometheus
spec:
  selector:
    operator.prometheus.io/name: k8s
  ports:
  - name: web
    port: 9090
    targetPort: 9090
---
apiVersion: monitoring.coreos.com/v1
kind: ServiceMonitor
metadata:
  name: status-web
  namespace: default
  labels:
    release: manual-operator
spec:
  namespaceSelector:
    matchNames:
    - default
  selector:
    matchLabels:
      app: status-web
  endpoints:
  - port: http-metrics   # must match Service port NAME (see port name table below)
    path: /metrics
    interval: 30s
    scrapeTimeout: 10s
    honorLabels: false
```

#### PrometheusRule + recording rules (file 13)

Matches `manifests/manual-stack/13-operator-status-web-prometheusrule.yaml`.

```yaml
apiVersion: monitoring.coreos.com/v1
kind: PrometheusRule
metadata:
  name: status-web-rules
  namespace: monitoring-manual
  labels:
    release: manual-operator
spec:
  groups:
  - name: status-web.recording
    interval: 30s
    rules:
    - record: job:status_web:http_requests_total:rate5m
      expr: |
        sum by (namespace) (
          rate(http_request_duration_seconds_count{job="status-web"}[5m])
        )
    - record: job:status_web:http_requests_errors:rate5m
      expr: |
        sum by (namespace) (
          rate(http_request_duration_seconds_count{job="status-web", status=~"5.."}[5m])
        )
  - name: status-web-alerts
    interval: 30s
    rules:
    - alert: StatusWebTargetDown
      expr: up{job="status-web"} == 0
      for: 5m
      labels:
        severity: warning
        team: payments
        job: status-web
        namespace: default
      annotations:
        summary: "status-web target is down"
        description: "Prometheus cannot scrape status-web for 5m."
    - alert: StatusWebHigh5xxRate
      expr: |
        (
          sum(rate(http_request_duration_seconds_count{job="status-web",status=~"5.."}[5m]))
          /
          sum(rate(http_request_duration_seconds_count{job="status-web"}[5m]))
        ) > 0.02
        and on()
        sum(up{job="status-web"} == 1) > 0
      for: 10m
      labels:
        severity: critical
        team: payments
        job: status-web
        namespace: default
      annotations:
        summary: "status-web high 5xx rate"
        description: "5xx ratio is above 2% for 10m."
```

---

### Chapter 1: The Journey

> **Beginners:** This chapter is a short overview. For the full story, read **[Part 1](#part-1)** first.

Imagine you join the team on day one. Someone says: *"We need to know when status-web is unhealthy."* That simple sentence hides a chain of five responsibilities.

```
  status-web app          Discovery              Prometheus
  exposes /metrics   -->  (what to scrape)  -->  stores time series
                                                      |
                        +-----------------------------+-----------------------------+
                        |                             |                             |
                        v                             v                             v
                   Alert rules                  Alertmanager                    Grafana
                 evaluate conditions         routes notifications            visualizes metrics
```

**The story in six phases:**

| Phase | What happens | Outcome |
|---|---|---|
| 1 | Deploy the app and expose a metrics endpoint | Something exists to scrape |
| 2 | Deploy the monitoring stack | Prometheus, Alertmanager, Grafana are running |
| 3 | Configure discovery | Prometheus finds `status-web` automatically |
| 4 | Generate traffic | HTTP 200, 400, and 503 metrics appear |
| 5 | Rules fire | Alerts move through PENDING → FIRING |
| 6 | Tune and troubleshoot | Noise goes down; reliability goes up |

**Namespaces in this lab:**

| Namespace | What lives there |
|---|---|
| `default` | `status-web` application and its Service |
| `monitoring-manual` | Prometheus, Alertmanager, Grafana, Operator, CRs |

---

### Chapter 2: Meet the Cast — Every Component

Think of the monitoring stack as a small city. Each building has one job.

#### The application: status-web

- **What:** A demo web app ([podinfo](https://github.com/stefanprodan/podinfo)) that serves HTTP and exposes Prometheus metrics at `/metrics` on port `9898`.
- **Where:** `default` namespace.
- **Key metric:** `http_request_duration_seconds_count` with label `status` (values like `200`, `400`, `503`).
- **Manifests:** `manifests/prod/status-web-deployment.yaml`, `manifests/prod/status-web-service.yaml`

#### Prometheus — the historian

Prometheus **pulls** metrics from targets on a schedule, stores them in a time-series database (TSDB), and evaluates alert rules.

This lab runs **operator-managed** Prometheus:

| Instance | Service DNS | Discovery model | Config source |
|---|---|---|---|
| Operator Prometheus | `prometheus-k8s.monitoring-manual.svc:9090` | **ServiceMonitor** CR | Operator generates config from CRs |

**CR mode manifests:** `10`–`16` (Operator + Prometheus CR + ServiceMonitor + PrometheusRule)

#### Prometheus Operator — the config generator

In CR mode you do **not** hand-edit `prometheus.yml`. You declare intent with Kubernetes custom resources:

1. You create `Prometheus`, `ServiceMonitor`, `PrometheusRule` objects.
2. The Operator watches them.
3. It generates effective scrape config into a Secret.
4. Prometheus pods mount and use that generated config.

**Key files:** `08-operator-deployment.yaml`, `10-operator-prometheus-cr.yaml`

#### ServiceMonitor — the scrape contract (CR mode only)

A ServiceMonitor answers three questions for the Operator:
- **Which Services?** (`selector.matchLabels`)
- **Which namespace?** (`namespaceSelector`)
- **Which port and path?** (`endpoints`)

It must carry a label that matches the Prometheus CR selector — in this repo: `release: manual-operator`.

**File:** `12-operator-status-web-servicemonitor.yaml`

#### Alertmanager — the traffic controller for alerts

Prometheus **fires** alerts; Alertmanager **routes** them. It groups related alerts, waits for bursts to settle, suppresses duplicates, and sends notifications to receivers (Slack, PagerDuty, etc.).

**Files:** `02-alertmanager-config.yaml` (routing rules), `03-alertmanager.yaml` (deployment + Service)

**How Prometheus finds it:**
- **Plain mode:** `alerting.alertmanagers` in `02-prometheus-config.yaml` discovers the `alertmanager` Service via Kubernetes SD.
- **Operator mode:** same wiring declared on the **Prometheus CR** as `spec.alerting` (file 10). See [Prometheus CR → Alertmanager wiring](#prometheus-cr--alertmanager-wiring-specalerting).

Alertmanager routing config (`alertmanager.yml`) is **separate** — it lives in Secret `04` and is **not** read by Prometheus.

#### Grafana — the dashboard

Grafana queries Prometheus and renders graphs. Admin credentials live in a Secret; datasource points at the plain Prometheus service.

**Files:** `04-grafana-secret.yaml`, `06-grafana.yaml`

#### RBAC — the keys to the kingdom

Prometheus needs Kubernetes API read access to discover Services and Endpoints. Plain mode uses `prometheus-manual` ServiceAccount (`01-rbac.yaml`). Operator-managed Prometheus uses `prometheus-k8s` (`09-operator-prometheus-rbac.yaml`).

---

### Chapter 3: Two Roads to the Same Metrics

Both roads end at `up{job="status-web"} == 1` and queryable HTTP status rates. They differ in **how Prometheus learns about the target**.

**Plain mode (annotations)**

```
  Service status-web
  (prometheus.io/scrape=true)
           |
           v
  Plain Prometheus
  job: kubernetes-service-endpoints
```

**CR mode (ServiceMonitor)**

```
  Service status-web -----> ServiceMonitor (release=manual-operator)
                                    |
                                    v
                          Prometheus Operator (selected by CR)
                                    |
                                    v
                          Operator Prometheus
                          job: serviceMonitor/.../status-web/0
```

#### Road 1: Plain Prometheus (annotation discovery)

**Story:** You annotate the Kubernetes Service. Prometheus discovers all endpoints cluster-wide, keeps only services with `prometheus.io/scrape=true`, rewrites the scrape address from annotations, and scrapes `/metrics`.

Required Service annotations:

```yaml
metadata:
  annotations:
    prometheus.io/scrape: "true"
    prometheus.io/path: /metrics
    prometheus.io/port: "9898"
```

The relabel pipeline in `02-prometheus-config.yaml` does the rest:

1. **keep** — only services where `prometheus.io/scrape=true`
2. **replace** — set metrics path from `prometheus.io/path`
3. **replace** — rewrite `__address__` to use `prometheus.io/port`
4. **replace** — copy `namespace`, `service`, and `job` labels onto every sample

**When to use plain mode:** Small clusters, learning, legacy setups, or when you cannot run the Operator.

#### Road 2: Operator + Prometheus CR (ServiceMonitor discovery)

**Story:** You create a `ServiceMonitor` that selects Services with `app=status-web`. The Operator sees it only if:
- the ServiceMonitor has label `release: manual-operator`, and
- the Prometheus CR's `serviceMonitorSelector` matches that label, and
- the Operator's `--namespaces` arg includes the ServiceMonitor's namespace.

The Operator generates a job like `serviceMonitor/default/status-web/0` with relabel rules that:
- keep services where `app=status-web`
- keep endpoints where port name is `http`
- map Kubernetes metadata to `namespace`, `service`, `pod`, `job` labels

**When to use CR mode:** Production Kubernetes, GitOps, multi-team environments, kube-prometheus-stack, anything managed at scale.

#### Side-by-side comparison

| Topic | Plain mode | CR mode |
|---|---|---|
| Discovery trigger | Service annotations | ServiceMonitor CR |
| Config editing | Edit ConfigMap `02` | Edit CRs; Operator generates config |
| Prometheus service | `prometheus` | `prometheus-k8s` |
| Alert rules | Embedded in `02` (`alerts.yml`) | PrometheusRule CR (or embedded in plain config) |
| Label contract | `prometheus.io/*` annotations | `release: manual-operator` on ServiceMonitor |
| Port matching | Annotation port number | Service **port name** (`http`) |

---

### Chapter 3.5: Deep Dive — Prometheus Operator and Custom Resources

This section explains **who does what** in CR mode: the Operator process, each Custom Resource (CR), the workloads they create, and how `status-web` flows through every layer. Read this before debugging "ServiceMonitor exists but no scrape job."

#### Mental model: declare intent, not config files

In plain mode **you** write `prometheus.yml`. In CR mode **you** write Kubernetes objects; the **Operator** compiles them into `prometheus.yml` and keeps running Pods in sync.

```
  YOU write                         OPERATOR compiles              PROMETHEUS runs
  ---------                         ----------------              ----------------
  Prometheus CR        ────┐
  ServiceMonitor CR    ────┼──>  prometheus.yml (generated)  ──>  scrape /metrics
  PrometheusRule CR    ────┤        + rule files                    evaluate rules
  Alertmanager CR      ────┘        stored in Secret                send alerts
```

You almost never edit `/etc/prometheus/config_out/prometheus.env.yaml` by hand. That file is **output**. The CRs are **source of truth**.

#### Control plane vs data plane

```
+------------------------------------------------------------------+
|  CONTROL PLANE (monitoring-manual namespace)                      |
|                                                                   |
|  +---------------------------+                                    |
|  | Prometheus Operator Pod   |  watches CRs via Kubernetes API    |
|  | (08-operator-deployment)  |  reconciles every few seconds      |
|  +-------------+-------------+                                    |
|                |                                                  |
|                | creates/updates                                   |
|                v                                                  |
|  +---------------------------+   +---------------------------+   |
|  | Prometheus CR (k8s)       |   | ServiceMonitor CR         |   |
|  | (13-operator-prometheus)  |   | (15-status-web-sm)        |   |
|  | "I want a Prometheus      |   | "scrape Services with     |   |
|  |  instance with these      |   |  app=status-web on        |   |
|  |  selectors"               |   |  port http"               |   |
|  +---------------------------+   +---------------------------+   |
|                |                              ^                   |
|                | generates                    | you create        |
|                v                              |                   |
|  +---------------------------+                |                   |
|  | Secret prometheus-k8s     |                |                   |
|  | (gzip prometheus.yml)     |                |                   |
|  +-------------+-------------+                |                   |
|                | mounts                        |                   |
|                v                              |                   |
|  +---------------------------+                |                   |
|  | Prometheus Pod(s)         |  reads SM +   |                   |
|  | (created by Operator)     |  Endpoints ---+                   |
|  | SA: prometheus-k8s        |                                    |
|  +-------------+-------------+                                    |
|                |                                                  |
|  +-------------+-------------+   Service prometheus-k8s:9090    |
+------------------------------------------------------------------+
                 |
                 | HTTP GET /metrics every 30s
                 v
+------------------------------------------------------------------+
|  DATA PLANE (default namespace)                                   |
|                                                                   |
|  +------------------+      +------------------+                   |
|  | status-web Pod   |<-----| status-web Svc   |                   |
|  | podinfo :9898    |      | port name: http  |                   |
|  +------------------+      +------------------+                   |
+------------------------------------------------------------------+
```

| Layer | Component | Function |
|---|---|---|
| **Control plane** | Prometheus Operator | Watches CRs; generates config; creates/updates Prometheus & Alertmanager workloads |
| **Configuration** | CRs (`Prometheus`, `ServiceMonitor`, …) | Human/GitOps-friendly declaration of desired monitoring state |
| **Generated** | Secret `prometheus-<cr-name>` | Compiled `prometheus.yml` + rule files (do not edit) |
| **Data plane** | Prometheus Pod | Pulls metrics from app targets; evaluates rules; fires alerts |
| **Data plane** | Application (`status-web`) | Exposes `/metrics` for scraping |

#### Every Custom Resource and its job

| CR kind | API | You define | Operator does with it |
|---|---|---|---|
| **Prometheus** | `monitoring.coreos.com/v1` | Instance name, replicas, retention, **selectors** for which SMs/rules to load, resources, storage | Creates StatefulSet/Deployment, Service, Secret with generated config, config-reloader sidecar |
| **ServiceMonitor** | `monitoring.coreos.com/v1` | Which **Services** to scrape: label selector, namespace, port **name**, path, interval | If selected by a Prometheus CR → becomes one or more `scrape_configs` jobs |
| **PodMonitor** | `monitoring.coreos.com/v1` | Which **Pods** to scrape directly (no Service) | Same as ServiceMonitor but for pod-level discovery |
| **PrometheusRule** | `monitoring.coreos.com/v1` | Recording + alerting rules in PromQL | If selected by Prometheus CR → mounted as rule file |
| **Alertmanager** | `monitoring.coreos.com/v1` | Replicas, config Secret name, storage | Creates Alertmanager StatefulSet + Service |
| **Probe** | `monitoring.coreos.com/v1` | Blackbox probe targets | Adds probe scrape jobs |

**This repo uses:** `Prometheus` (file 10) + `ServiceMonitor` (file 12). Rules can live in `PrometheusRule` CR or in plain ConfigMap for the non-operator Prometheus.

#### The reconciliation loop (step by step)

What happens after `kubectl apply -f 10-operator-prometheus-cr.yaml`:

```
Step 1   Kubernetes API stores Prometheus CR object "k8s"
           |
Step 2   Operator informer sees CREATE/UPDATE on Prometheus CR
           |
Step 3   Operator lists all ServiceMonitors in watched namespaces
           |  (--namespaces=monitoring-manual,default from file 08)
           |
Step 4   FILTER: keep ServiceMonitors where:
           |    (a) namespace visible to operator, AND
           |    (b) labels match Prometheus.spec.serviceMonitorSelector
           |        e.g. release=manual-operator
           |
Step 5   For each matching ServiceMonitor, Operator reads:
           |    - spec.selector (which Services)
           |    - spec.namespaceSelector (which namespaces)
           |    - spec.endpoints (port, path, interval)
           |
Step 6   Operator compiles scrape_configs + relabel_configs
           |    job name pattern: serviceMonitor/<ns>/<name>/<endpointIndex>
           |
Step 7   Operator writes Secret "prometheus-k8s" with prometheus.yaml.gz
           |
Step 8   Operator ensures Prometheus StatefulSet/Deployment exists
           |    pods labeled operator.prometheus.io/name=k8s
           |
Step 9   config-reloader sidecar detects Secret change
           |    reloads /etc/prometheus/config_out/prometheus.env.yaml
           |
Step 10  Prometheus begins scraping; target appears in /targets UI
```

If you change **only** the ServiceMonitor, Steps 3–10 rerun. You do **not** restart the Operator manually.

#### Three gates: why a ServiceMonitor might be ignored

A ServiceMonitor must pass **three independent filters** before it becomes a scrape job. Missing any gate = no metrics.

```
  ServiceMonitor "status-web"
  namespace: default
  labels: release=manual-operator
           |
           |  GATE 1 — Operator watch scope
           v
  +--------------------------------------------------+
  | Is namespace "default" in operator args?           |
  | --namespaces=monitoring-manual,default  (file 08) |
  +------------------------+-------------------------+
                           | YES
                           v
  +--------------------------------------------------+
  | GATE 2 — Prometheus CR label selector          |
  | serviceMonitorSelector:                          |
  |   matchLabels:                                   |
  |     release: manual-operator        (file 10)    |
  |                                                  |
  | ServiceMonitor.labels.release == manual-operator |
  +------------------------+-------------------------+
                           | YES
                           v
  +--------------------------------------------------+
  | GATE 3 — ServiceMonitor spec (runtime discovery) |
  | namespaceSelector.matchNames: [default]          |
  | selector.matchLabels.app: status-web             |
  | endpoints.port: http-metrics  ==  Service port NAME   |
  |   (prod deploy) OR http (manual-stack file 09 only)   |
  +------------------------+-------------------------+
                           | YES
                           v
              scrape job created:
              serviceMonitor/default/status-web/0
```

| Gate | Config location | This repo value | If wrong |
|---|---|---|---|
| 1 | `08-operator-deployment.yaml` `--namespaces` | `monitoring-manual,default` | Operator never sees the SM |
| 2 | `10-operator-prometheus-cr.yaml` `serviceMonitorSelector` | `release: manual-operator` | SM exists but no job generated |
| 3 | `12-operator-status-web-servicemonitor.yaml` spec | `app: status-web`, port `http-metrics` (prod) or `http` (file 09) | Targets **dropped** silently — no metrics, alerts never fire |

#### Object relationship map (this repository)

Full wiring for files `10`–`15`:

```
manifests/manual-stack/
|
|-- 07-operator-rbac.yaml
|     ServiceAccount: prometheus-operator
|     ClusterRoleBinding -> cluster-admin (lab only; tighten in prod)
|           |
|           | identity for
|           v
|-- 08-operator-deployment.yaml
|     Deployment: prometheus-operator
|     args: --namespaces=monitoring-manual,default
|     args: --prometheus-instance-namespaces=monitoring-manual
|           |
|           | watches + reconciles
|           v
|-- 10-operator-prometheus-cr.yaml          12-operator-status-web-servicemonitor.yaml
|     kind: Prometheus                         kind: ServiceMonitor
|     name: k8s                                name: status-web
|     namespace: monitoring-manual             namespace: default
|     spec.alerting ->                         labels.release: manual-operator
|       Service alertmanager (file 05)             |
|     serviceMonitorSelector:                      | selected by selector
|       release: manual-operator                   |
|           |                                      |
|           +<-------------------------------------+
|           |
|     ruleSelector: {}  -->  loads any PrometheusRule in watched namespaces
|           |
|           +<----- 13-operator-status-web-prometheusrule.yaml
|                  kind: PrometheusRule (monitoring-manual)
|           |
|           | Operator creates
|           v
|     Secret: prometheus-k8s (generated prometheus.yml)
|     StatefulSet/Deployment: prometheus-k8s-0
|     labels: operator.prometheus.io/name=k8s
|           |
|           | uses SA from
|           v
|-- 09-operator-prometheus-rbac.yaml
|     ServiceAccount: prometheus-k8s
|     ClusterRole: read nodes/services/endpoints/pods
|           |
|           | exposed via
|           v
|-- 11-operator-prometheus-service.yaml
      Service: prometheus-k8s:9090
      selector: operator.prometheus.io/name=k8s
```

**Parallel path — application side (not created by Operator):**

```
09-status-web-service-annotations.yaml (or manifests/prod/status-web-*)
  Deployment status-web  -->  Service status-web (port name: http, :9898)
                                    ^
                                    | matched by ServiceMonitor selector
                                    |
                              12-operator-status-web-servicemonitor.yaml
```

#### Who creates what (you vs Operator)

| Kubernetes object | Created by | File in this repo |
|---|---|---|
| `Deployment/prometheus-operator` | **You** (`kubectl apply`) | `08-operator-deployment.yaml` |
| `Prometheus` CR | **You** | `10-operator-prometheus-cr.yaml` |
| `ServiceMonitor` CR | **You** | `12-operator-status-web-servicemonitor.yaml` |
| `ServiceAccount/prometheus-k8s` | **You** | `09-operator-prometheus-rbac.yaml` |
| `Service/prometheus-k8s` | **You** (stable DNS; selector points to operator pods) | `11-operator-prometheus-service.yaml` |
| `Secret/prometheus-k8s` | **Operator** (generated) | — |
| `StatefulSet` or `Deployment` for Prometheus | **Operator** (from Prometheus CR) | — |
| `Pod/prometheus-k8s-0` | **Operator** | — |
| `config-reloader` sidecar container | **Operator** (in Prometheus pod) | — |

#### Inside the Prometheus Pod (generated runtime)

```
+---------------------------------------------------------------+
|  Pod: prometheus-k8s-0                                        |
|                                                               |
|  +------------------------+   +-----------------------------+ |
|  | config-reloader        |   | prometheus                  | |
|  | (operator sidecar)     |   | (prom/prometheus:v2.53.0)   | |
|  |                        |   |                             | |
|  | watches Secret mount   |   | reads config_out/           | |
|  | calls Prometheus       |   | scrapes targets             | |
|  | POST /-/reload         |   | evaluates rules             | |
|  +-----------+------------+   +-------------+---------------+ |
|              |                              |                 |
|              v                              v                 |
|  /etc/prometheus/config_out/     /prometheus (TSDB data)     |
|    prometheus.env.yaml  <------ compiled from CRs             |
|                                                               |
|  Volumes:                                                     |
|    Secret/prometheus-k8s  -> generated prometheus.yml         |
|    PVC or emptyDir        -> TSDB (lab uses emptyDir)         |
+---------------------------------------------------------------+
```

Verify generated config:

```bash
## Generated Secret (source)
kubectl -n monitoring-manual get secret prometheus-k8s \
  -o jsonpath='{.data.prometheus\.yaml\.gz}' | openssl base64 -d -A | gunzip -c | head -80

## Rendered file inside pod (runtime)
POD=$(kubectl -n monitoring-manual get pod -l operator.prometheus.io/name=k8s -o jsonpath='{.items[0].metadata.name}')
kubectl -n monitoring-manual exec "$POD" -c config-reloader -- \
  grep -n 'status-web' /etc/prometheus/config_out/prometheus.env.yaml
```

#### status-web: end-to-end scrape path

```
[1] podinfo container listens on :9898/metrics
         |
[2] Service status-web (default) exposes port name "http-metrics" (prod) or "http" (file 09)
         |
[3] ServiceMonitor status-web selects app=status-web in namespace default
         |
[4] Label release=manual-operator on ServiceMonitor
         |
[5] Prometheus CR k8s serviceMonitorSelector matches release=manual-operator
         |
[6] Operator compiles job:
         job_name: serviceMonitor/default/status-web/0
         kubernetes_sd_configs: role endpoints, namespace default
         relabel: keep app=status-web, keep port name http-metrics (or http)
         |
[7] Prometheus Pod scrapes pod IP:9898/metrics every 30s
         |
[8] Metric stored with labels: job=status-web, namespace=default, ...
         |
[9] PromQL works: up{job="status-web"} == 1
```

#### Prometheus CR fields → runtime behavior

From `10-operator-prometheus-cr.yaml`:

| `spec` field | Runtime effect |
|---|---|
| `replicas: 1` | One Prometheus pod (lab); use `2` in prod for HA |
| `serviceAccountName: prometheus-k8s` | Pod identity for K8s API discovery (file 12) |
| `scrapeInterval: 30s` | Default scrape frequency unless SM overrides |
| `evaluationInterval: 30s` | How often alert/recording rules run |
| `retention: 24h` | Local TSDB retention (short in lab) |
| `serviceMonitorSelector.matchLabels.release` | **Which ServiceMonitors get compiled into config** |
| `serviceMonitorNamespaceSelector: {}` | All namespaces (within operator watch) allowed |
| `ruleSelector: {}` | All PrometheusRules in namespaces allowed by `ruleNamespaceSelector` (see below) |
| `ruleNamespaceSelector: {}` | All namespaces (within operator `--namespaces` watch list) |
| `alerting.alertmanagers` | Where Prometheus POSTs firing alerts — Operator writes this into generated `prometheus.yml` |
| `enableAdminAPI: true` | Admin HTTP endpoints enabled (disable in prod) |
| `resources` | CPU/memory for Prometheus container |

#### Prometheus CR → Alertmanager wiring (`spec.alerting`)

Prometheus needs two different configs for alerting. Do not mix them up:

| Config | File / CR | What it controls |
|---|---|---|
| **Where to send alerts** | Prometheus CR `spec.alerting` (file 10) or plain `02` | Prometheus → Alertmanager HTTP target |
| **How to route notifications** | Secret `04` (`alertmanager.yml`) | Alertmanager → Slack/PagerDuty/email |

In file `10-operator-prometheus-cr.yaml`:

```yaml
spec:
  alerting:
    alertmanagers:
    - namespace: monitoring-manual
      name: alertmanager
      port: http
      apiVersion: v2
```

**What each field means:**

| Field | Meaning | In this lab |
|---|---|---|
| `namespace` | Namespace of the **Kubernetes Service** that fronts Alertmanager | `monitoring-manual` |
| `name` | **`metadata.name` of that Service** — not the Deployment name, not the pod name, not the Alertmanager CR name (lab has no Alertmanager CR) | Service `alertmanager` from `03-alertmanager.yaml` |
| `port` | **Service port name** (`spec.ports[].name`) — **not** the port number `9093` | `http` (see `03-alertmanager.yaml` → `ports[].name: http`) |
| `apiVersion` | Alertmanager HTTP API version Prometheus uses when POSTing alerts | `v2` (current standard) |

**How the Operator uses this:**

```
Prometheus CR spec.alerting
        |
        v
Operator compiles into generated prometheus.yml:
        alerting:
          alertmanagers:
          - static_configs:
            - targets: ["alertmanager.monitoring-manual.svc:9093"]
            ...
        |
        v
Prometheus pod POSTs firing alerts to Alertmanager /api/v2/alerts
        |
        v
Alertmanager reads alertmanager.yml from Secret 04 (routing only)
```

**DNS resolution:** `name` + `namespace` resolve to cluster DNS:

```
alertmanager.monitoring-manual.svc.cluster.local:9093
```

The Operator looks up Service `alertmanager` in namespace `monitoring-manual`, finds port **name** `http`, reads its **number** (`9093`), and puts that in generated config.

**Plain vs CR — same idea, different source:**

| Mode | You write | Operator? |
|---|---|---|
| Plain | `02-prometheus-config.yaml` → `alerting.alertmanagers` with kubernetes_sd | No — ConfigMap is source of truth |
| CR | `10-operator-prometheus-cr.yaml` → `spec.alerting` | Yes — Operator writes `alerting` block into Secret |

**Lab note:** Alertmanager runs as a plain Deployment (`05`), not an Alertmanager CR. That is fine — `spec.alerting` only needs a **Service** to exist. The Operator flag `--alertmanager-instance-namespaces` applies when you use an **Alertmanager CR**; it does not auto-wire Prometheus.

**Verify wiring after apply:**

```bash
kubectl apply -f manifests/manual-stack/10-operator-prometheus-cr.yaml
## wait ~30s for reconcile

kubectl -n monitoring-manual get secret prometheus-k8s \
  -o jsonpath='{.data.prometheus\.yaml\.gz}' | openssl base64 -d -A | gunzip -c | grep -A8 'alerting:'

kubectl -n monitoring-manual port-forward svc/prometheus-k8s 9090:9090 &
curl -s 'http://127.0.0.1:9090/api/v1/alertmanagers' | python3 -m json.tool

## After an alert fires:
kubectl -n monitoring-manual port-forward svc/alertmanager 9093:9093 &
curl -s 'http://127.0.0.1:9093/api/v2/alerts' | python3 -m json.tool
```

#### CRD installation (required before files 07-13)

`Prometheus`, `ServiceMonitor`, and `PrometheusRule` are **Custom Resources**. The Kubernetes API does not know them until CRDs are registered. If you skip this step you get:

```
Error from server (NotFound): the server could not find the requested resource
  (post prometheuses.monitoring.coreos.com)
Error from server (NotFound): the server could not find the requested resource
  (post servicemonitors.monitoring.coreos.com)
```

**Install order:**

```
1. manifests/manual-stack/01-crds.yaml          (register API types)
2. manifests/manual-stack/07-09                (operator + prometheus RBAC)
3. manifests/manual-stack/08                   (operator Deployment)
4. manifests/manual-stack/10-13                (Prometheus CR, SM, rules)
```

**File:** `manifests/manual-stack/01-crds.yaml` — lab CRDs for three types:

| CRD | API resource | Used by |
|---|---|---|
| `prometheuses.monitoring.coreos.com` | `Prometheus` | File 13 |
| `servicemonitors.monitoring.coreos.com` | `ServiceMonitor` | File 15 |
| `prometheusrules.monitoring.coreos.com` | `PrometheusRule` | File 16 |

**Deploy script (automatic):** `install_operator_crds.sh` runs before files 07-13. It applies `01-crds.yaml` if CRDs are not already registered; otherwise skips.

```bash
./scripts/manual-stack/deploy_manual_stack.sh
./scripts/manual-stack/deploy_manual_stack.sh thanos

## CRDs only (full upstream — required for Thanos)
USE_FULL_CRDS=true ./scripts/manual-stack/operator-stack/install_operator_crds.sh
```

**Manual apply:**

```bash
kubectl apply -f manifests/manual-stack/01-crds.yaml
kubectl get crd prometheuses.monitoring.coreos.com \
  servicemonitors.monitoring.coreos.com \
  prometheusrules.monitoring.coreos.com
```

#### `ruleSelector: {}` vs `serviceMonitorSelector` (important difference)

In `10-operator-prometheus-cr.yaml` the two selectors behave **very differently**:

```yaml
## STRICT — only ServiceMonitors with this label are scraped
serviceMonitorSelector:
  matchLabels:
    release: manual-operator

## PERMISSIVE — every PrometheusRule in scope is loaded (no label required)
ruleSelector: {}
ruleNamespaceSelector: {}
```

| Selector | `{}` or empty meaning | Label required on child CR? |
|---|---|---|
| `serviceMonitorSelector.matchLabels` | N/A — must match explicitly | **Yes** — `release: manual-operator` on ServiceMonitor (file 12) |
| `ruleSelector: {}` | Match **all** PrometheusRules | **No** — any PrometheusRule in a watched namespace is loaded |
| `ruleNamespaceSelector: {}` | Rules from **all namespaces** the operator watches | Namespace must be in `--namespaces` (file 08) |

```
Operator --namespaces=monitoring-manual,default
        |
        +--> ServiceMonitor in default
        |      MUST have label release=manual-operator  (Gate 2)
        |
        +--> PrometheusRule in monitoring-manual
        |      NO label required (ruleSelector: {})
        |
        +--> PrometheusRule in kube-system
               NO — namespace not in --namespaces
```

**Lab alert rules — file 10:** Operator Prometheus loads these automatically because `ruleSelector: {}` picks up any `PrometheusRule` in `monitoring-manual` or `default`.

**File:** `manifests/manual-stack/13-operator-status-web-prometheusrule.yaml`

```yaml
apiVersion: monitoring.coreos.com/v1
kind: PrometheusRule
metadata:
  name: status-web-rules
  namespace: monitoring-manual
  labels:
    release: manual-operator   # optional with ruleSelector: {}; required if you tighten ruleSelector later
spec:
  groups:
  - name: status-web-alerts
    interval: 30s
    rules:
    - alert: StatusWebTargetDown
      expr: up{job="status-web"} == 0
      for: 5m
      labels:
        severity: warning
      annotations:
        summary: "status-web target is down"
        description: "Prometheus cannot scrape status-web for 5m."
    - alert: StatusWebHigh5xxRate
      expr: |
        (
          sum(rate(http_request_duration_seconds_count{job="status-web",status=~"5.."}[5m]))
          /
          sum(rate(http_request_duration_seconds_count{job="status-web"}[5m]))
        ) > 0.02
      for: 10m
      labels:
        severity: critical
      annotations:
        summary: "status-web high 5xx rate"
        description: "5xx ratio is above 2% for 10m."
```

**Production tightening:** Replace `ruleSelector: {}` with a label gate (same pattern as ServiceMonitors):

```yaml
ruleSelector:
  matchLabels:
    prometheus: kube-prom
ruleNamespaceSelector:
  matchLabels:
    monitoring: enabled
```

Then every `PrometheusRule` must carry `prometheus: kube-prom`.

**Verify rules loaded on operator Prometheus:**

```bash
kubectl -n monitoring-manual get prometheusrule
kubectl -n monitoring-manual port-forward svc/prometheus-k8s 9090:9090 &
curl -s 'http://127.0.0.1:9090/api/v1/rules' | python3 -m json.tool
```

#### ServiceMonitor fields → generated scrape job

From `12-operator-status-web-servicemonitor.yaml`:

| `spec` field | Generated config effect |
|---|---|
| `namespaceSelector.matchNames: [default]` | Only discover endpoints in `default` |
| `selector.matchLabels.app: status-web` | Relabel `keep` on `__meta_kubernetes_service_label_app` |
| `endpoints[0].port: http-metrics` | Relabel `keep` on port **name** `http-metrics` (must match Service `ports[].name`, not `9898`) |
| `endpoints[0].path: /metrics` | `metrics_path: /metrics` |
| `endpoints[0].interval: 30s` | Overrides global scrape interval for this job |
| `endpoints[0].scrapeTimeout: 10s` | Per-scrape timeout |
| `metadata.labels.release` | Must match Prometheus CR selector (Gate 2) |

#### Operator vs Prometheus CR: separate responsibilities

People conflate these. They are different objects with different jobs.

```
+---------------------------+       +---------------------------+
|  Prometheus Operator      |       |  Prometheus CR (k8s)      |
|  (Deployment, file 08)    |       |  (file 10)                |
+---------------------------+       +---------------------------+
| ONE per cluster/namespace |       | ONE OR MANY per cluster   |
| Watches CRD types         |       | Declares ONE Prometheus   |
| Compiles YAML             |       |   instance                |
| Creates child resources   |       | Defines selectors,        |
| Runs reconciliation loop  |       |   retention, replicas     |
| Args: which namespaces    |       | Does NOT scrape itself    |
|   to watch globally       |       | (the Pod it creates does) |
+---------------------------+       +---------------------------+
            |                                     |
            |           reconciles                |
            +------------------------------------>+
```

| Question | Answer |
|---|---|
| "I added a ServiceMonitor; why no scrape?" | Check Gates 1–3; Operator may not have reconciled yet |
| "I changed scrape interval; where?" | ServiceMonitor `endpoints.interval`, not Operator Deployment |
| "I need a second Prometheus for team B" | Create a **second Prometheus CR** with different `serviceMonitorSelector` |
| "Do I restart Operator after SM change?" | No — Operator watches and recompiles automatically |
| "Do I restart Prometheus after PrometheusRule change?" | No — Operator + config-reloader hot-reload rules |
| "How does Prometheus find Alertmanager in CR mode?" | `spec.alerting` on Prometheus CR (file 10) — Operator compiles into generated config |
| "What is `name` under alertmanagers?" | Kubernetes **Service** name (`alertmanager` in file 05), not Deployment or CR name |
| "Alert not firing but I'm sending 500s" | Check `up{job="status-web"}` first; port name mismatch drops all targets |

#### Multi-team pattern (production)

Two teams, one Operator, two Prometheus instances:

```
                    Prometheus Operator
                    (--namespaces=monitoring,default,payments)
                              |
              +---------------+---------------+
              |                               |
              v                               v
    Prometheus CR "platform"        Prometheus CR "payments"
    serviceMonitorSelector:         serviceMonitorSelector:
      prometheus: platform            prometheus: payments
              |                               |
              v                               v
    SM label prometheus=platform    SM label prometheus=payments
    scrapes infra exporters         scrapes payments apps only
```

Each team owns ServiceMonitors + PrometheusRules in their namespace with matching label. Platform owns the Prometheus CRs and Operator.

#### Quick diagnostic commands (Operator + CR)

```bash
## Operator running?
kubectl -n monitoring-manual get deploy prometheus-operator
kubectl -n monitoring-manual logs deploy/prometheus-operator --tail=50

## Prometheus CR status
kubectl -n monitoring-manual get prometheus k8s -o yaml

## ServiceMonitors in cluster
kubectl get servicemonitor -A

## Does SM label match CR selector?
kubectl -n monitoring-manual get prometheus k8s \
  -o jsonpath='{.spec.serviceMonitorSelector.matchLabels}'; echo
kubectl -n default get servicemonitor status-web \
  -o jsonpath='{.metadata.labels}'; echo

## Operator-created pods
kubectl -n monitoring-manual get pods -l operator.prometheus.io/name=k8s

## Active targets (after port-forward prometheus-k8s:9090)
curl -s 'http://127.0.0.1:9090/api/v1/targets?state=active' | python3 -m json.tool
```

---

### Chapter 4: Things to Always Remember

These are the lessons that save hours of debugging. Read them before your first deploy.

#### Discovery is a filter, not magic

Prometheus discovers **many** candidates, then **relabel_configs** keep or drop each one. If a `keep` rule fails, the target vanishes silently. Always check **Status → Targets** in the Prometheus UI before writing PromQL.

#### Port **name** vs port **number**

- **Plain mode:** annotation `prometheus.io/port` is the **number** (`9898`).
- **CR mode:** ServiceMonitor `endpoints.port` must equal the Service port **name**, not the number `9898`.

**This repo has two valid port-name pairs** — they must match within each deploy path:

| Deploy path | Service manifest | Port name on Service | ServiceMonitor `endpoints.port` |
|---|---|---|---|
| **Prod / Chapter 5 demo** | `manifests/prod/status-web-service.yaml` | `http-metrics` | `http-metrics` (file 12) |
| **Manual-stack only** | `manifests/manual-stack/09-status-web-service-annotations.yaml` | `http` | `http` (if you change file 12 back) |

If you deploy the app from **prod** manifests but file 12 still says `port: http`, Prometheus discovers endpoints then **drops** them in relabel. Symptom: empty `up{job="status-web"}`, alerts stay **inactive** forever even under load.

```bash
## Confirm Service port name
kubectl -n default get svc status-web -o jsonpath='{.spec.ports[0].name}'; echo

## Confirm ServiceMonitor expects the same name
kubectl -n default get servicemonitor status-web -o jsonpath='{.spec.endpoints[0].port}'; echo

## Dropped targets (port mismatch shows endpoints here, not under Active)
kubectl -n monitoring-manual port-forward svc/prometheus-k8s 9090:9090 &
curl -s 'http://127.0.0.1:9090/api/v1/targets?state=dropped' | python3 -m json.tool
```

#### The `job` label comes from discovery

In plain mode, `job` is set to the Service name (`status-web`). In CR mode, generated config also sets `job=status-web`. Your alert rules and dashboards should use `job="status-web"`.

#### Metric names and label keys matter

podinfo exposes `http_request_duration_seconds_count` with label **`status`**, not `code`. A query using `code` returns empty even when scraping works.

Good PromQL:

```promql
sum by (status) (
  rate(http_request_duration_seconds_count{job="status-web", status=~"200|400|503"}[5m])
)
```

#### The `for:` window prevents false alarms

```yaml
- alert: StatusWebTargetDown
  expr: up{job="status-web"} == 0
  for: 5m
```

The expression must stay true for 5 continuous minutes before the alert fires. A 30-second pod restart does not page anyone.

#### Two Prometheus instances = know which one you query

| Mode | Port-forward command |
|---|---|
| Plain | `kubectl -n monitoring-manual port-forward svc/prometheus 9090:9090` |
| Operator | `kubectl -n monitoring-manual port-forward svc/prometheus-k8s 9090:9090` |

#### Never edit generated config in the Operator pod

Files like `/etc/prometheus/config_out/prometheus.env.yaml` are **output**. Change the ServiceMonitor, Prometheus CR, or Helm values — then verify the generated job appears.

#### Cardinality is your enemy

Never put `user_id`, `request_id`, or unbounded values into metric labels. High cardinality explodes memory and slows queries. Use `metric_relabel_configs` to drop noisy series in production.

#### External labels are for routing, not filtering dashboards

In production, set stable `external_labels` on Prometheus (`cluster`, `environment`, `team`). They attach to every alert sent to Alertmanager. Do **not** use high-cardinality values like hostnames.

---

### Chapter 4.5: Managing Expensive Queries with Recording Rules

Dashboards and alerts that call `rate()`, `histogram_quantile()`, or heavy `sum by (pod)` on **raw** metrics get slow fast. At scale the same expensive expression may run hundreds of times per minute (Grafana refresh × panels × users). **Recording rules** pre-compute those expressions once per `evaluation_interval` and store the result as a **new metric** you query instead.

#### How recording rules work

```
Every evaluation_interval (e.g. 30s):

  Raw metrics (scraped)                Recording rule (runs once)
  ---------------------              ---------------------------
  http_request_duration_seconds_count  -->  rate() + sum by (status)
  http_request_duration_seconds_bucket -->       |
                                                 v
                                    NEW metric stored in TSDB:
                                    job:status_web:http_requests:rate5m

  Grafana / alerts query the NEW metric (cheap instant vector)
  instead of re-running rate() on raw counters (expensive)
```

| Concept | Recording rule | Alerting rule |
|---|---|---|
| YAML key | `record: <new_metric_name>` | `alert: <AlertName>` |
| `expr` output | Stored as time series | Compared to threshold; may fire alert |
| Purpose | Pre-aggregate for speed | Notify humans |
| Query in Grafana | Yes — preferred | No — use recorded metrics instead |

**Rule group order matters:** recording rules that depend on other recorded metrics must appear **earlier in the same group** or in an **earlier group** evaluated first.

#### Naming convention (use consistently)

```
<aggregation_level>:<metric_name>:<operations>
```

| Segment | Meaning | Example |
|---|---|---|
| `job` / `namespace` / `cluster` | Labels kept after aggregation | `namespace:status_web:...` |
| `status_web` | Logical service (snake_case) | |
| `rate5m` / `p99_5m` / `ratio5m` | What was computed | |

---

#### Example 1 — Small: pre-compute request rate by status

**Problem:** This Grafana query runs `rate()` over every pod on every refresh:

```promql
sum by (status) (
  rate(http_request_duration_seconds_count{job="status-web", status=~"200|400|503"}[5m])
)
```

With 2 pods and 10 dashboard users refreshing every 30s, Prometheus re-parses and re-scans counters constantly.

**Fix:** One recording rule evaluates `rate()` once every 30s. Everyone queries the recorded metric.

##### Plain Prometheus — add to ConfigMap

**File:** `manifests/manual-stack/02-prometheus-config.yaml` (add `recording-rules.yml` key)  
**Or lab file:** `manifests/manual-stack/02-prometheus-config-recording.yaml`

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: prometheus-config
  namespace: monitoring-manual
data:
  prometheus.yml: |
    global:
      scrape_interval: 30s
      evaluation_interval: 30s

    alerting:
      alertmanagers:
      - kubernetes_sd_configs:
        - role: endpoints
          namespaces:
            names:
            - monitoring-manual
        relabel_configs:
        - action: keep
          source_labels: [__meta_kubernetes_service_name]
          regex: alertmanager
        - action: keep
          source_labels: [__meta_kubernetes_endpoint_port_name]
          regex: http
        api_version: v2

    rule_files:
    - /etc/prometheus/rules/recording-rules.yml
    - /etc/prometheus/rules/alerts.yml

    scrape_configs:
    - job_name: prometheus
      static_configs:
      - targets: ["localhost:9090"]
    - job_name: kubernetes-service-endpoints
      kubernetes_sd_configs:
      - role: endpoints
      relabel_configs:
      - source_labels: [__meta_kubernetes_service_annotation_prometheus_io_scrape]
        action: keep
        regex: true
      - source_labels: [__meta_kubernetes_service_annotation_prometheus_io_path]
        action: replace
        target_label: __metrics_path__
        regex: (.+)
      - source_labels: [__address__, __meta_kubernetes_service_annotation_prometheus_io_port]
        action: replace
        target_label: __address__
        regex: ([^:]+)(?::\d+)?;(\d+)
        replacement: $1:$2
      - source_labels: [__meta_kubernetes_namespace]
        target_label: namespace
      - source_labels: [__meta_kubernetes_service_name]
        target_label: service
      - source_labels: [__meta_kubernetes_service_name]
        target_label: job

  recording-rules.yml: |
    groups:
    - name: status-web.recording.basic
      interval: 30s
      rules:
      - record: job:status_web:http_requests:rate5m
        expr: |
          sum by (status, namespace) (
            rate(http_request_duration_seconds_count{job="status-web", status=~"200|400|503"}[5m])
          )

  alerts.yml: |
    groups:
    - name: status-web-alerts
      rules:
      - alert: StatusWebTargetDown
        expr: up{job="status-web"} == 0
        for: 5m
        labels:
          severity: warning
        annotations:
          summary: "status-web target is down"
          description: "Prometheus cannot scrape status-web for 5m."
```

**Mount in Deployment** (`03-prometheus.yaml` — add volume mount for `recording-rules.yml` alongside `alerts.yml`).

**Query after recording rule is active:**

```promql
## Cheap — no rate() on raw counter
job:status_web:http_requests:rate5m
```

**Verify:**

```bash
kubectl -n monitoring-manual port-forward svc/prometheus 9090:9090 &
curl -s 'http://127.0.0.1:9090/api/v1/rules?type=record' | python3 -m json.tool
curl -s 'http://127.0.0.1:9090/api/v1/query?query=job%3Astatus_web%3Ahttp_requests%3Arate5m' | python3 -m json.tool
```

---

#### Example 2 — Medium: recording chain + alert on recorded ratio

**Problem:** Error-ratio alerts combine two `rate()` calls and a division. Every evaluation scans all counter series twice:

```promql
sum(rate(http_request_duration_seconds_count{job="status-web", status=~"5.."}[5m]))
/
sum(rate(http_request_duration_seconds_count{job="status-web"}[5m]))
```

**Fix:** Three recording rules build a pipeline; the alert reads one pre-computed ratio.

```
Step A   job:status_web:http_requests_errors:rate5m   (5xx rate only)
Step B   job:status_web:http_requests_total:rate5m   (all traffic rate)
Step C   job:status_web:http_5xx:ratio5m             (A / B)
Alert    expr: job:status_web:http_5xx:ratio5m > 0.02
```

##### Operator mode — full PrometheusRule

**File:** `manifests/prod/status-web-recording-rules.yaml`  
**Apply:** `kubectl apply -f manifests/prod/status-web-recording-rules.yaml`  
**Selected by:** Prometheus CR `ruleSelector.matchLabels.prometheus: kube-prom`

```yaml
apiVersion: monitoring.coreos.com/v1
kind: PrometheusRule
metadata:
  name: status-web-recording-rules
  namespace: default
  labels:
    prometheus: kube-prom
    app.kubernetes.io/name: status-web
spec:
  groups:
  - name: status-web.recording
    interval: 30s
    rules:
  # Step A — error request rate (5xx only)
    - record: job:status_web:http_requests_errors:rate5m
      expr: |
        sum by (namespace) (
          rate(http_request_duration_seconds_count{job="status-web", status=~"5.."}[5m])
        )
  # Step B — total request rate
    - record: job:status_web:http_requests_total:rate5m
      expr: |
        sum by (namespace) (
          rate(http_request_duration_seconds_count{job="status-web"}[5m])
        )
  # Step C — ratio from recorded metrics (no raw rate() here)
    - record: job:status_web:http_5xx:ratio5m
      expr: |
        job:status_web:http_requests_errors:rate5m
        /
        job:status_web:http_requests_total:rate5m
  - name: status-web.alerts-from-recording
    interval: 30s
    rules:
    - alert: StatusWebHigh5xxRate
      expr: job:status_web:http_5xx:ratio5m > 0.02
      for: 10m
      labels:
        severity: critical
        team: payments
      annotations:
        summary: status-web 5xx error rate is high
        description: "5xx ratio is {{ $value | humanizePercentage }} (threshold 2%) for 10m."
        runbook_url: https://wiki.example.com/runbooks/status-web-high-5xx
```

**Grafana panel query (medium tier):**

```promql
job:status_web:http_5xx:ratio5m
```

**Why this is faster:** Alert evaluation touches 3 low-cardinality series (per namespace) instead of re-scanning every pod's raw counter twice.

---

#### Example 3 — Complex: histogram p99, multi-label aggregation, SLO-style burn

**Problem:** Latency percentiles are the most expensive PromQL in production:

```promql
histogram_quantile(0.99,
  sum by (le, namespace, pod) (
    rate(http_request_duration_seconds_bucket{job="status-web"}[5m])
  )
)
```

`histogram_quantile` on high-cardinality labels (`pod`) inside Grafana across a 24h range can timeout or OOM the query path.

**Fix:** Multi-step recording pipeline — aggregate **up** (drop pod label early), then quantile on slim series.

```
Raw buckets (per pod, per le)
        |
        |  Rule 1: sum by (le, namespace) — drop pod
        v
namespace:status_web:http_request_duration_seconds:bucket:rate5m
        |
        |  Rule 2: histogram_quantile(0.99, ...)
        v
namespace:status_web:http_request_duration_seconds:p99_5m
        |
        |  Rule 3: compare to SLO threshold (optional)
        v
namespace:status_web:http_latency:slo_burn_5m
```

##### Full PrometheusRule (complex)

**File:** `manifests/prod/status-web-recording-rules-advanced.yaml`  
**Apply:** `kubectl apply -f manifests/prod/status-web-recording-rules-advanced.yaml`

```yaml
apiVersion: monitoring.coreos.com/v1
kind: PrometheusRule
metadata:
  name: status-web-recording-rules-advanced
  namespace: default
  labels:
    prometheus: kube-prom
    app.kubernetes.io/name: status-web
spec:
  groups:
  - name: status-web.recording.latency
    interval: 30s
    rules:
    # Rule 1 — aggregate bucket rates to namespace level (removes pod cardinality)
    - record: namespace:status_web:http_request_duration_seconds:bucket:rate5m
      expr: |
        sum by (le, namespace) (
          rate(http_request_duration_seconds_bucket{job="status-web"}[5m])
        )
    # Rule 2 — p99 from recorded buckets (reads Rule 1 output; no raw rate() here)
    - record: namespace:status_web:http_request_duration_seconds:p99_5m
      expr: |
        histogram_quantile(0.99,
          namespace:status_web:http_request_duration_seconds:bucket:rate5m
        )
    # Rule 3 — p50 for dashboard comparison
    - record: namespace:status_web:http_request_duration_seconds:p50_5m
      expr: |
        histogram_quantile(0.50,
          namespace:status_web:http_request_duration_seconds:bucket:rate5m
        )
  - name: status-web.recording.slo
    interval: 30s
    rules:
    # Rule 4 — binary "is latency over 500ms SLO?" (1 = violating, 0 = ok)
    - record: namespace:status_web:http_latency:slo_violation:5m
      expr: |
        (
          namespace:status_web:http_request_duration_seconds:p99_5m > 0.5
        )
    # Rule 5 — smoothed burn signal for alerting (avg violation over 30m)
    - record: namespace:status_web:http_latency:slo_burn:30m
      expr: |
        avg_over_time(namespace:status_web:http_latency:slo_violation:5m[30m])
  - name: status-web.recording.cross-service
    interval: 30s
    rules:
    # Rule 6 — cluster-wide rollup (drop namespace for executive dashboard)
    - record: cluster:status_web:http_requests:rate5m
      expr: |
        sum by (status) (
          job:status_web:http_requests:rate5m
        )
    # Rule 7 — top-line error ratio at cluster level (depends on Example 2 metrics)
    - record: cluster:status_web:http_5xx:ratio5m
      expr: |
        sum(job:status_web:http_requests_errors:rate5m)
        /
        sum(job:status_web:http_requests_total:rate5m)
  - name: status-web.alerts-from-recording.advanced
    interval: 30s
    rules:
    - alert: StatusWebHighLatencyP99
      expr: namespace:status_web:http_request_duration_seconds:p99_5m > 0.5
      for: 15m
      labels:
        severity: warning
        team: payments
      annotations:
        summary: status-web p99 latency above 500ms
        description: "p99 latency is {{ $value }}s in namespace {{ $labels.namespace }}."
        runbook_url: https://wiki.example.com/runbooks/status-web-high-latency
    - alert: StatusWebSLOBurnHigh
      expr: namespace:status_web:http_latency:slo_burn:30m > 0.1
      for: 10m
      labels:
        severity: critical
        team: payments
      annotations:
        summary: status-web latency SLO burn elevated
        description: "SLO burn {{ $value | humanizePercentage }} over 30m in {{ $labels.namespace }}."
        runbook_url: https://wiki.example.com/runbooks/status-web-slo-burn
```

**Grafana queries (complex tier — all cheap instant/range on recorded metrics):**

```promql
## p99 latency per namespace
namespace:status_web:http_request_duration_seconds:p99_5m

## p50 vs p99 on same panel
namespace:status_web:http_request_duration_seconds:p50_5m
namespace:status_web:http_request_duration_seconds:p99_5m

## Cluster-wide traffic by status (executive dashboard)
cluster:status_web:http_requests:rate5m
```

---

#### Before vs after (cost model)

| Scenario | Without recording rules | With recording rules |
|---|---|---|
| 1 Grafana panel, 10 users, 30s refresh | `rate()` × 20/min | Recorded metric × 20/min (cheap) |
| `rate()` computation | 20/min on raw counters | 2/min (evaluation_interval 30s) |
| Alert on 5xx ratio | 2× `rate()` per eval | Read 1 recorded ratio per eval |
| Histogram p99 dashboard | `histogram_quantile` on raw buckets every query | Quantile computed 2/min; dashboard reads result |

```
Cost without recording:
  Grafana_queries_per_minute × cost(rate/histogram_quantile)

Cost with recording:
  (60 / evaluation_interval) × cost(expr)
  + Grafana_queries_per_minute × cost(read recorded metric)   <-- usually tiny
```

---

#### Verification checklist

```bash
## 1. Rules loaded?
kubectl -n monitoring-manual port-forward svc/prometheus-k8s 9090:9090 &
curl -s 'http://127.0.0.1:9090/api/v1/rules' | python3 -m json.tool

## 2. Recording rules specifically
curl -s 'http://127.0.0.1:9090/api/v1/rules?type=record' | python3 -m json.tool

## 3. Recorded metric has data?
curl -s 'http://127.0.0.1:9090/api/v1/query?query=job%3Astatus_web%3Ahttp_requests%3Arate5m' | python3 -m json.tool

## 4. Rule evaluation errors?
curl -s 'http://127.0.0.1:9090/api/v1/rules' | \
  python3 -c "import sys,json; d=json.load(sys.stdin); \
  [print(g['name'], r['name'], r.get('lastError','ok')) \
   for g in d['data']['groups'] for r in g['rules']]"

## 5. Compare eval duration (should drop after recording rules)
curl -s 'http://127.0.0.1:9090/api/v1/query?query=prometheus_rule_group_last_duration_seconds' | python3 -m json.tool
```

---

#### Rules of thumb and pitfalls

| Do | Don't |
|---|---|
| Drop `pod` label in recording rules used by global dashboards | Record `sum by (pod, ...)` unless you need per-pod dashboards |
| Keep `[5m]` window ≥ 4× scrape interval | Use `[1m]` rate on 30s scrape (noisy + sparse) |
| Put recording groups **before** alert groups that depend on them | Reference a recorded metric defined later in the file |
| Name metrics with `level:service:operation` | Reuse raw metric names (collision risk) |
| Alert on recorded metrics | Run `histogram_quantile` in alert `expr` at scale |
| Test with `/api/v1/rules` before wiring Grafana | Deploy 20 recording rules without measuring cardinality |

**Cardinality trap:** A recording rule that keeps `pod` + `status` + `namespace` does not reduce series count — it **adds** new series on top of raw metrics. Always aggregate away labels you do not need in the recorded output.

**When recording rules are not enough:** If Prometheus itself is overloaded (>5M active series), recording rules help query speed but not ingestion — combine with higher `scrapeInterval`, `metric_relabel_configs` drops, or shard Prometheus (Chapter 9).

---

### Chapter 5: Demo — Operator/CR stack + status-web

> **Deploy section.** Read [Part 2](#part-2) first if you haven't deployed before.

This is your first hands-on chapter. Follow it top to bottom on a kind cluster.

#### Prerequisites

```bash
kubectl config current-context    # should be your kind context
kubectl get ns                  # cluster reachable
```

#### Step 1: Deploy the full lab stack

```bash
./scripts/manual-stack/deploy_manual_stack.sh
```

This applies namespace, Alertmanager, Grafana, prod `status-web`, CRDs, and operator files `07-13`. Skip optional parts with `WITH_GRAFANA=false` or `WITH_STATUS_WEB=false`.

#### Step 2: Generate traffic

```bash
kubectl -n default run load-gen --image=curlimages/curl:8.8.0 --restart=Never --rm -i -- sh -c '
for i in $(seq 1 60); do
  curl -s -o /dev/null http://status-web.default.svc:9898/;
  curl -s -o /dev/null http://status-web.default.svc:9898/status/400;
  curl -s -o /dev/null http://status-web.default.svc:9898/status/503;
done
echo "traffic done"
'
```

#### Step 3: Verify operator Prometheus sees the target

```bash
kubectl -n monitoring-manual port-forward svc/prometheus-k8s 9090:9090 &
sleep 2

curl -s 'http://127.0.0.1:9090/api/v1/query?query=up%7Bjob%3D%22status-web%22%7D' | python3 -m json.tool
curl -s 'http://127.0.0.1:9090/api/v1/targets?state=active' | python3 -m json.tool
```

**Success signals:**
- `up{job="status-web"}` returns value `1`
- Targets UI shows `serviceMonitor/monitoring-manual/status-web/0` UP

---

### Chapter 6: Demo — Operator CR deep dive

Deploy files **02-03** (Alertmanager) + **07-13** (CRDs → operator → Prometheus CR → ServiceMonitor → PrometheusRule). The deploy script installs CRDs, Grafana, and status-web automatically.

```bash
./scripts/manual-stack/deploy_manual_stack.sh
```

File `13` `spec.alerting` points at Service `alertmanager` — without files 02-03, Prometheus has nowhere to send alerts.

#### Step 0: Install Prometheus Operator CRDs (required first time)

CRDs register the `Prometheus`, `ServiceMonitor`, and `PrometheusRule` API types. Without them, `kubectl apply` on files 07-13 fails with `NotFound`.

**Recommended — deploy script installs CRDs for you:**

```bash
./scripts/manual-stack/deploy_manual_stack.sh
## or operator-only (no Grafana / status-web):
./scripts/manual-stack/operator-stack/deploy_operator_stack.sh
```

Both call `scripts/manual-stack/operator-stack/install_operator_crds.sh`, which applies `manifests/manual-stack/01-crds.yaml` when CRDs are not yet registered.

**Manual — apply CRDs yourself:**

```bash
kubectl apply -f manifests/manual-stack/01-crds.yaml
kubectl get crd prometheuses.monitoring.coreos.com \
  servicemonitors.monitoring.coreos.com \
  prometheusrules.monitoring.coreos.com
```

| Method | When to use |
|---|---|
| `install_operator_crds.sh` / deploy script | Lab and repeatable deploys (uses local `01-crds.yaml`) |
| Upstream full CRDs from prometheus-operator v0.76.0 | Production clusters needing all CRD types |

#### Step 1: Deploy operator extension (02-03 + 07-13)

```bash
./scripts/manual-stack/deploy_manual_stack.sh
## or operator-only:
./scripts/manual-stack/operator-stack/deploy_operator_stack.sh

## Or manual (after Step 0)
kubectl apply -f manifests/manual-stack/02-alertmanager-config.yaml
kubectl apply -f manifests/manual-stack/03-alertmanager.yaml
kubectl apply -f manifests/manual-stack/01-crds.yaml
kubectl apply -f manifests/manual-stack/07-operator-rbac.yaml
kubectl apply -f manifests/manual-stack/08-operator-deployment.yaml
kubectl apply -f manifests/manual-stack/09-operator-prometheus-rbac.yaml
kubectl apply -f manifests/manual-stack/10-operator-prometheus-cr.yaml
kubectl apply -f manifests/manual-stack/11-operator-prometheus-service.yaml
kubectl apply -f manifests/manual-stack/12-operator-status-web-servicemonitor.yaml
kubectl apply -f manifests/manual-stack/13-operator-status-web-prometheusrule.yaml

kubectl -n monitoring-manual rollout status deploy/alertmanager --timeout=180s
kubectl -n monitoring-manual rollout status deploy/prometheus-operator --timeout=180s
```

| File | Kind | Purpose |
|---|---|---|
| `02` | Secret | Alertmanager routing config (`alertmanager.yml`) |
| `03` | Deployment + Service | Alertmanager workload + Service `alertmanager` (target for file 10 `spec.alerting`) |
| `01` | CRD | Register Prometheus / ServiceMonitor / PrometheusRule APIs |
| `07`–`09` | RBAC | Operator and managed-Prometheus permissions |
| `08` | Deployment | Prometheus Operator process |
| `10` | Prometheus CR | Declares operator-managed Prometheus instance `k8s` |
| `11` | Service | DNS `prometheus-k8s:9090` |
| `12` | ServiceMonitor | Scrape contract for `status-web` |
| `13` | PrometheusRule | Alert rules (auto-loaded via `ruleSelector: {}`) |

#### Step 2: Verify the contract chain

Three objects must agree:

**Prometheus CR** (`10-operator-prometheus-cr.yaml`) selects ServiceMonitors and sends alerts to Alertmanager:

```yaml
serviceMonitorSelector:
  matchLabels:
    release: manual-operator

alerting:
  alertmanagers:
  - namespace: monitoring-manual
    name: alertmanager      # Service metadata.name (file 05)
    port: http              # Service port NAME (not 9093)
    apiVersion: v2
```

See [spec.alerting field reference](#prometheus-cr--alertmanager-wiring-specalerting).

**ServiceMonitor** (`12-operator-status-web-servicemonitor.yaml`) carries that label and selects the app:

```yaml
metadata:
  labels:
    release: manual-operator
spec:
  selector:
    matchLabels:
      app: status-web
  endpoints:
  - port: http-metrics   # must match Service port NAME (prod service uses http-metrics)
    path: /metrics
```

**Service** (`manifests/prod/status-web-service.yaml`) must expose port name `http-metrics` on 9898 and label `app: status-web`:

```yaml
spec:
  ports:
  - name: http-metrics
    port: 9898
    targetPort: http-metrics
```

If the Service port name does not match the ServiceMonitor `endpoints.port`, the target is dropped — see [Port name vs port number](#port-name-vs-port-number).

**Operator** (`08-operator-deployment.yaml`) must watch the right namespaces:

```yaml
args:
- --namespaces=monitoring-manual,default
```

**PrometheusRule** (`13-operator-status-web-prometheusrule.yaml`) — loaded automatically because the Prometheus CR has `ruleSelector: {}` (no label gate). See [Chapter 3.5 — ruleSelector vs serviceMonitorSelector](#ruleselector--vs-servicemonitorselector-important-difference).

#### Step 3: Verify operator Prometheus

```bash
./scripts/manual-stack/operator-stack/check_status_web_target.sh
```

Or manually:

```bash
kubectl -n monitoring-manual port-forward svc/prometheus-k8s 9090:9090 &
sleep 2

curl -s 'http://127.0.0.1:9090/api/v1/query?query=up%7Bjob%3D%22status-web%22%7D' | python3 -m json.tool
curl -s 'http://127.0.0.1:9090/api/v1/targets?state=active' | python3 -m json.tool
curl -s 'http://127.0.0.1:9090/api/v1/rules' | python3 -m json.tool
curl -s 'http://127.0.0.1:9090/api/v1/alertmanagers' | python3 -m json.tool   # should list alertmanager:9093
```

#### Step 4: Read the generated config

```bash
PROM=k8s
kubectl -n monitoring-manual get secret "prometheus-${PROM}" \
  -o jsonpath='{.data.prometheus\.yaml\.gz}' | openssl base64 -d -A | gunzip -c | grep -A5 'status-web'
```

You should see a job named `serviceMonitor/default/status-web/0` (namespace may vary). That job is proof the Operator wired everything correctly.

#### Step 5: Compare both modes

| Check | Plain (`prometheus`) | CR (`prometheus-k8s`) |
|---|---|---|
| Target job name | `kubernetes-service-endpoints` | `serviceMonitor/.../status-web/0` |
| Discovery source | Service annotations | ServiceMonitor CR |
| Config file | ConfigMap | Operator-generated Secret |

Both should return `up{job="status-web"} == 1` when healthy.

---

### Chapter 6.5: Thanos + MinIO (optional long-term storage)

This chapter covers the **optional Thanos path** for the manual lab: Prometheus keeps scraping and alerting; Thanos adds **durable object storage** and a **global query** layer backed by MinIO on kind.

#### Why Thanos?

| Problem (default stack) | How Thanos helps |
|---|---|
| Metrics live only on the Prometheus pod disk (`24h`, ephemeral without PVC) | Blocks uploaded to **object storage** (MinIO/S3) for long retention |
| Grafana queries one Prometheus instance | **Thanos Query** federates live sidecar + historical store |
| Prometheus disk fills or pod is rescheduled | Historical data survives in object storage |
| Multiple Prometheus replicas (HA) return duplicate series | Query deduplicates on `replica` / `prometheus_replica` labels |
| Compaction / downsampling for cheap long-range queries | **Compactor** maintains resolution tiers in object storage |

**What does not change:** ServiceMonitor (`12`), PrometheusRule (`13`), Alertmanager routing (`02`–`03`). Alerts still **fire from Prometheus** → Alertmanager. Thanos Query is for **reading** metrics (Grafana, ad-hoc PromQL), not alert evaluation.

#### Architecture (default vs Thanos)

**Default (`./deploy_manual_stack.sh`):**

```
  status-web ────────────────┐
  ServiceMonitor (12) ───────┼──► Prometheus ──► local TSDB (24h)
  PrometheusRule (13) ───────┘         │
                                       ├──► Alertmanager (02-03)  [alerts]
  Grafana (05-06) ─────────────────────┘  [queries Prometheus :9090]
```

**Thanos mode (`./deploy_manual_stack.sh thanos`):**

```
  ┌── scrape + alerts (unchanged) ─────────────────────────────────────┐
  │  status-web ──► Prometheus + Thanos sidecar ──► Alertmanager       │
  │                 ▲                                                   │
  │     ServiceMonitor (12) / PrometheusRule (13)                       │
  └─────────────────┼──────────────────────────────────────────────────┘
                    │ upload TSDB blocks
                    ▼
               ┌─────────┐
               │  MinIO  │◄──────── Thanos Compactor (07)
               │ bucket  │
               │ thanos  │
               └────┬────┘
                    │
         ┌──────────┴──────────┐
         ▼                     │
  Thanos Store Gateway (06)    │
         ▲                     │
         └─────────────────────┘
                    ▲
                    │
           Thanos Query (05) ◄──── Grafana (queries :9090)
                    │
                    └── gRPC: prometheus-operated:10901 (live sidecar data)
```

**Data flow:**

1. Prometheus scrapes and evaluates rules (same as today).
2. **Sidecar** (injected by the operator when `spec.thanos` is set) uploads closed TSDB blocks to MinIO.
3. **Store Gateway** serves blocks already in MinIO (data older than local retention).
4. **Compactor** compacts and downsamples blocks in MinIO.
5. **Query** fans out to sidecar gRPC (`prometheus-operated:10901`) + Store Gateway; Grafana talks to Query.

#### Deploy commands

```bash
## Default — no Thanos (files 00-13 only)
./scripts/manual-stack/deploy_manual_stack.sh
./scripts/manual-stack/deploy_manual_stack.sh default

## Thanos + MinIO on kind
./scripts/manual-stack/deploy_manual_stack.sh thanos

## Equivalent env var
WITH_THANOS=true ./scripts/manual-stack/deploy_manual_stack.sh
```

**Cleanup (both modes):**

```bash
./scripts/manual-stack/cleanup_manual_stack.sh
```

#### Thanos manifest map (`manifests/manual-stack/thanos/`)

| File | Component | Purpose |
|---|---|---|
| `01-minio.yaml` | MinIO | S3-compatible object store for kind lab |
| `02-minio-bucket-job.yaml` | Job | Creates `thanos` bucket |
| `03-objstore-secret.yaml` | Secret | `thanos.yaml` S3 config shared by sidecar, store, compactor |
| `04-prometheus-cr-thanos.yaml` | Prometheus CR | **Replaces** `10-operator-prometheus-cr.yaml` when Thanos enabled |
| `05-thanos-query.yaml` | Thanos Query | PromQL HTTP `:9090` for Grafana |
| `06-thanos-store-gateway.yaml` | Store Gateway | Historical blocks from MinIO |
| `07-thanos-compactor.yaml` | Compactor | Compaction / retention in object storage |
| `08-grafana-datasource-thanos.yaml` | ConfigMap | Grafana → `thanos-query` (+ direct Prometheus optional) |

Base stack files **00–09**, **11–13** are unchanged. Only **which Prometheus CR** and **Grafana datasource** differ.

#### What changes, file by file (with snippets)

##### 1. CRDs (`01-crds.yaml`) — Thanos mode uses **full** upstream CRDs

The trimmed lab CRD does not include `spec.thanos` or `storage`. Thanos deploy runs:

```bash
USE_FULL_CRDS=true ./scripts/manual-stack/operator-stack/install_operator_crds.sh
```

The deploy script does this automatically in `thanos` mode.

##### 2. Prometheus CR — **main change** (`thanos/04-prometheus-cr-thanos.yaml`)

Replaces `10-operator-prometheus-cr.yaml`. Adds sidecar config, PVC, shorter local retention, external labels:

```yaml
spec:
  retention: 6h                    # short local; long history in MinIO
  externalLabels:
    cluster: manual-lab
  thanos:
    objectStorageConfig:
      name: thanos-objstore-config
      key: thanos.yaml
  storage:
    volumeClaimTemplate:
      spec:
        accessModes: ["ReadWriteOnce"]
        resources:
          requests:
            storage: 5Gi
```

The operator injects the **Thanos sidecar** container; gRPC store API is on headless Service **`prometheus-operated`** port `10901` (not a separate `*-thanos-discovery` Service in this operator version).

**Unchanged on the CR:** `alerting`, `serviceMonitorSelector`, `ruleSelector` — alerts still go to Alertmanager.

##### 3. Object storage Secret (`thanos/03-objstore-secret.yaml`)

```yaml
stringData:
  thanos.yaml: |
    type: S3
    config:
      bucket: thanos
      endpoint: minio.monitoring-manual.svc:9000
      access_key: minio
      secret_key: minio123
      insecure: true   # kind lab only
```

Production: replace with real S3/GCS, TLS, and secrets from a vault — never commit real keys.

##### 4. MinIO (`thanos/01-minio.yaml`, `02-minio-bucket-job.yaml`)

Lab-only S3. Credentials in Secret `minio-credentials` (`minio` / `minio123`). Bucket job runs after MinIO is ready.

##### 5. Thanos Query (`thanos/05-thanos-query.yaml`)

```yaml
args:
- query
- --http-address=0.0.0.0:9090
- --store=dnssrv+_grpc._tcp.prometheus-operated.monitoring-manual.svc.cluster.local
- --store=dnssrv+_grpc._tcp.thanos-store-gateway.monitoring-manual.svc.cluster.local
- --query.replica-label=replica
- --query.replica-label=prometheus_replica
```

##### 6. Grafana (`thanos/08-grafana-datasource-thanos.yaml` vs `05-grafana-datasource.yaml`)

**Default:** `url: http://prometheus-k8s.monitoring-manual.svc:9090`

**Thanos:**

```yaml
- name: Thanos
  url: http://thanos-query.monitoring-manual.svc:9090
  isDefault: true
```

##### 7. No changes required

| File | Why |
|---|---|
| `12-operator-status-web-servicemonitor.yaml` | Scraping unchanged |
| `13-operator-status-web-prometheusrule.yaml` | Rules unchanged |
| `02-alertmanager-config.yaml`, `03-alertmanager.yaml` | Routing unchanged |
| `08-operator-deployment.yaml` | Already has `--thanos-ruler-instance-namespaces` |

#### Verification

```bash
## Thanos Query (same PromQL API as Prometheus)
kubectl -n monitoring-manual port-forward svc/thanos-query 9090:9090 &
curl -s 'http://127.0.0.1:9090/api/v1/query?query=up{job="status-web"}' | python3 -m json.tool

## List stores Query sees (sidecar + store gateway)
curl -s http://127.0.0.1:9090/api/v1/stores | python3 -m json.tool

## Direct Prometheus (debug alerts / rules)
kubectl -n monitoring-manual port-forward svc/prometheus-k8s 9091:9090 &
curl -s 'http://127.0.0.1:9091/api/v1/rules' | python3 -m json.tool

## MinIO console (lab)
kubectl -n monitoring-manual port-forward svc/minio 9001:9001
## login: minio / minio123 — check bucket "thanos" for uploaded blocks
```

**Success signals:**

- Query returns `up{job="status-web"} == 1`
- `/api/v1/stores` shows sidecar + store gateway endpoints
- MinIO bucket `thanos` gains objects after ~2h (block upload cadence)
- Grafana default datasource **Thanos** returns metrics
- Alerts still visible on Prometheus `/api/v1/alerts` and Alertmanager

#### Troubleshooting Thanos on kind

| Symptom | Check | Fix |
|---|---|---|
| `ImagePullBackOff` on `minio-create-thanos-bucket` | `kubectl describe pod -l job-name=minio-create-thanos-bucket` | Job uses `minio/mc:latest`. Run commands from **repo root** (`~/Desktop/local-repo`), not `manifests/manual-stack`. Preload: `cd ~/Desktop/local-repo && KIND_CLUSTER_NAME=<name> ./scripts/manual-stack/thanos/preload_images_podman_kind.sh` (`kind get clusters` for name) |
| `spec.thanos` rejected on apply | `kubectl get crd prometheuses.monitoring.coreos.com -o yaml \| grep thanos` | Run full CRD install (`USE_FULL_CRDS=true`) before Prometheus CR |
| PVC pending | `kubectl get pvc -n monitoring-manual` | Ensure kind has default StorageClass |
| Query empty stores | `kubectl get svc prometheus-operated`; `curl thanos-query:9090/api/v1/stores` | Wait for Prometheus pod 3/3; confirm `--store` points at `prometheus-operated` |
| No blocks in MinIO | Sidecar logs: `kubectl logs prometheus-k8s-0 -c thanos-sidecar` | Verify objstore Secret, bucket job, MinIO reachable |
| Grafana no data | Datasource URL | Thanos mode must use `thanos-query`, not `prometheus-k8s` |
| Alerts missing in Thanos | Expected | Query does not evaluate alerts — check Prometheus + Alertmanager |

#### Production notes (beyond kind)

- Swap MinIO for managed S3/GCS with encryption and lifecycle policies.
- Run `replicas: 2` on Prometheus CR with `externalLabels` for HA.
- Add Thanos Ruler only if you need global recording rules from object storage (optional; most teams keep rules on Prometheus).
- Monitor compactor and upload failures; alert on object storage errors.

---

### Chapter 7: Troubleshooting

> **Start here when stuck:** [Part 6](#part-6). This chapter goes deeper.

When metrics are missing, follow this order every time. Do not skip steps.

#### The debugging ladder

```
1. Is the app running?
2. Does /metrics respond?
3. Is the target in Prometheus Targets UI?
4. Is the target UP?
5. Does the metric name and label key match your query?
6. Has enough traffic accumulated for rate()?
```

#### Troubleshooting matrix

| Symptom | Checks | Likely fix |
|---|---|---|
| `NotFound` on `prometheuses` / `servicemonitors` | `kubectl get crd prometheuses.monitoring.coreos.com` | Run `kubectl apply -f manifests/manual-stack/01-crds.yaml` or `./scripts/manual-stack/operator-stack/install_operator_crds.sh` **before** files 07-13 |
| `up{job="status-web"}` empty | `kubectl -n default get svc status-web -o yaml`; Targets UI → **Dropped**; compare Service port name vs SM `endpoints.port` | Align port **names** (`http-metrics` for prod, `http` for file 09); re-apply file 12 |
| Target exists but DOWN | `kubectl -n default exec` into pod; `curl localhost:9898/metrics` | Fix network policy or app crash |
| Targets dropped, no active scrape | `curl .../api/v1/targets?state=dropped` — look for `__meta_kubernetes_endpoint_port_name` | ServiceMonitor `endpoints.port` ≠ Service `ports[].name` (most common CR-mode miss) |
| Target UP, query empty | Check metric name; generate traffic; verify label is `status` not `code` | Fix PromQL; wait for scrape + rate window |
| Alert rule exists but never fires | Confirm metrics first: `up{job="status-web"}`; run ratio expr in Graph; check **Alerts** tab (not Graph) | No scrape → fix port name; if expr true, wait for `for:` duration; use `prometheus-k8s` not plain `prometheus` |
| ServiceMonitor not picked up | `kubectl -n monitoring-manual get prometheus k8s -o yaml`; check `serviceMonitorSelector` | Add `release: manual-operator` label to ServiceMonitor |
| PrometheusRule not loaded | `kubectl -n monitoring-manual get prometheusrule`; check `ruleSelector` on Prometheus CR | With `ruleSelector: {}` any rule in watched namespace loads; tighten selector if rules missing |
| Operator does not see SM | Check operator args `--namespaces` | Add app namespace to operator watch list; restart operator |
| Alerts not in Alertmanager (operator mode) | `kubectl -n monitoring-manual get deploy,svc alertmanager`; `curl .../api/v1/alertmanagers` on `prometheus-k8s` | Deploy files 02-03 (`deploy_manual_stack.sh operator` includes them); verify `spec.alerting` on file 10 |
| Alerts not in Alertmanager (plain mode) | Check `alerting` block in `02`; port-forward Alertmanager API | Fix alertmanager discovery in `02`; restart Alertmanager after config change in `04` |
| Too many notifications | Review `group_by`, `group_wait`, `inhibit_rules`, `repeat_interval` | Tune routing (Chapter 8) |

#### Plain mode: annotation checklist

```bash
kubectl -n default get svc status-web -o jsonpath='{.metadata.annotations}' | python3 -m json.tool
```

Must include exactly:
- `prometheus.io/scrape: "true"` (string `true`, not `yes` or `1`)
- `prometheus.io/path: /metrics`
- `prometheus.io/port: "9898"`

#### CR mode: selector checklist

```bash
## Service port name vs ServiceMonitor port (must match exactly)
kubectl -n default get svc status-web -o jsonpath='Service port name: {.spec.ports[0].name}{"\n"}'
kubectl -n default get servicemonitor status-web -o jsonpath='SM endpoints.port: {.spec.endpoints[0].port}{"\n"}'

## ServiceMonitor labels
kubectl -n default get servicemonitor status-web -o yaml | grep -A5 'labels:'

## Prometheus CR selector
kubectl -n monitoring-manual get prometheus k8s -o jsonpath='{.spec.serviceMonitorSelector}'

## Operator namespace scope
kubectl -n monitoring-manual get deploy prometheus-operator -o yaml | grep namespaces
```

#### Useful commands

```bash
## Port-forwards
kubectl -n monitoring-manual port-forward svc/prometheus 9090:9090      # plain
kubectl -n monitoring-manual port-forward svc/prometheus-k8s 9090:9090  # operator
kubectl -n monitoring-manual port-forward svc/alertmanager 9093:9093
kubectl -n monitoring-manual port-forward svc/grafana 3000:3000

## Rules loaded?
curl -s 'http://127.0.0.1:9090/api/v1/rules' | python3 -m json.tool

## Active alerts
curl -s 'http://127.0.0.1:9090/api/v1/alerts' | python3 -m json.tool
curl -s 'http://127.0.0.1:9093/api/v2/alerts' | python3 -m json.tool

## Cleanup and rerun
./scripts/manual-stack/cleanup_manual_stack.sh
```

#### Most common beginner mistakes

1. Wrong ServiceMonitor label — not selected by Prometheus CR.
2. Wrong ServiceMonitor namespace — outside operator watch scope.
3. **Port name mismatch** — ServiceMonitor says `http` but prod Service uses `http-metrics` (targets silently dropped; alerts never fire).
4. Querying `code` instead of `status` label.
5. Checking PromQL before the first successful scrape.
6. Port-forwarding the wrong Prometheus service (plain `prometheus` vs operator `prometheus-k8s`).
7. Looking at the **Graph** tab for alerts — use **Alerts** tab; alerts need `for:` duration in **pending** before **firing**.

#### Alert not firing under load (debug checklist)

You generated 500s with `watch curl .../status/500` but **Alerts** shows `StatusWebHigh5xxRate` inactive:

```
1. Port-forward operator Prometheus (not plain):
     kubectl -n monitoring-manual port-forward svc/prometheus-k8s 9090:9090

2. Metrics exist?
     up{job="status-web"}                    # must return 1
     sum by (status) (rate(http_request_duration_seconds_count{job="status-web"}[1m]))

3. Ratio expr true?
     (sum(rate(...{status=~"5.."}[1m])) / sum(rate(...[1m]))) > 0

4. Rule loaded?
     Status → Rules → status-web-alerts group

5. Alert state?
     Status → Alerts → pending (for: window) → firing
```

If step 2 is empty, the rule cannot fire — fix scraping (port name) before tuning `for:` or thresholds.

---

### Chapter 8: Production Grade

Lab setups teach mechanics. Production demands discipline. This chapter covers alerting, routing, and the operational basics every team needs before go-live.

**Convention in Chapter 8–9:** Every YAML block is a **complete file** you can save and `kubectl apply -f`. Each block lists its path under `manifests/prod/`, what it depends on, and what mounts it. Replace `REPLACE_*` placeholders before applying.

For capacity math, resource sizing, HA, and the full Staff engineer gate checklist, continue to [Chapter 9](#chapter-9-staff-engineer-production-playbook).

#### 8.1 Alert lifecycle — know the full story

```
Prometheus evaluates rules every evaluation_interval (30s)
  → expression becomes true
  → alert state = PENDING (if for: duration is set)
  → after for: passes → FIRING
  → Prometheus POSTs to Alertmanager /api/v2/alerts

Alertmanager receives alert
  → groups by group_by labels
  → waits group_wait for related alerts to arrive
  → sends ONE notification to matched receiver

While still FIRING
  → Alertmanager re-notifies every repeat_interval

Expression becomes false
  → Prometheus sends resolved flag
  → Alertmanager waits resolve_timeout
  → sends "resolved" notification
```

**Staff note:** Total time-to-page = `for:` duration + `group_wait` + notification latency. A rule with `for: 10m` and `group_wait: 60s` means the earliest page is ~11 minutes after the condition first became true. Document this in runbooks so incident commanders do not assume instant detection.

#### 8.2 Reducing alert fatigue

Alert fatigue is not a tooling bug — it is an architecture failure. When on-call stops trusting pages, outages get longer. Treat alert volume as an SLO.

**The 100-alert scenario:** Without grouping, 100 pods crash-looping means 100 pages. With proper grouping, it means **one** notification**.

The `group_by`, `group_wait`, `group_interval`, and `repeat_interval` fields live inside the **full** Alertmanager Secret in [Strategy 3–4](#strategy-34-full-production-alertmanager-secret--prometheusrule) below. The lab baseline for comparison:

**File (lab):** `manifests/manual-stack/02-alertmanager-config.yaml`

```yaml
route:
  receiver: default-receiver
  group_by: ['alertname', 'team', 'namespace']
  routes:
  - matchers: [team="payments"]
    receiver: team-payments
  - matchers: [team="order"]
    receiver: team-order

receivers:
- name: team-payments
  slack_configs:
  - channel: '#alerts-payments'
    text: |
      Team: {{ .GroupLabels.team }}
      Namespace: {{ .GroupLabels.namespace }}
```

**PrometheusRule labels (file 10):** each alert sets `team: payments` so Alertmanager can route it.

See [Lab team routing](#lab-team-routing-and-notification-templates), [Lab inhibit_rules](#lab-inhibit_rules-and-the-equal-field), and the full file for inhibit rules and receivers.

What happens:
1. All 100 alerts arrive within seconds.
2. They share `alertname` and `namespace` → one group.
3. Alertmanager waits 60s (`group_wait`) for stragglers.
4. Sends **one** Slack/PagerDuty message listing all 100.

##### Lab: `inhibit_rules` and the `equal` field

**File:** `manifests/manual-stack/02-alertmanager-config.yaml`

Inhibition suppresses **noisy child alerts** when a **parent/root-cause alert** is already firing. In the lab, when `status-web` cannot be scraped, we suppress the 5xx ratio alert — a high error rate is meaningless if there is nothing to scrape.

```yaml
inhibit_rules:
- source_matchers:
  - alertname="StatusWebTargetDown"    # parent: scrape target down
  target_matchers:
  - alertname="StatusWebHigh5xxRate"   # child: symptom alert
  equal: ['job', 'namespace', 'team']
```

Include `team` in `equal` when alerts carry a `team` label so payments outages do not inhibit order-team alerts.

**How it works (three steps):**

```
1. Source alert matches source_matchers  →  StatusWebTargetDown firing
2. Target alert matches target_matchers  →  StatusWebHigh5xxRate firing
3. For EVERY label name in equal, source and target must have the SAME value
   → only then is the target notification suppressed
```

**What `equal` is (and is not):**

| | |
|---|---|
| `equal` is | A list of **label names** to compare between source and target |
| `equal` is not | Label values (`job=status-web` goes in matchers or on the rule, not here) |
| Empty `equal: []` | Inhibit all matching targets when source fires — no label check (risky multi-service) |

**Why `job` and `namespace` in this lab:**

| Label | Identifies | Why in `equal` |
|---|---|---|
| `job` | Which scrape target / app (`status-web`) | Only suppress 5xx for the **same** app that is down |
| `namespace` | Kubernetes namespace (`default`) | `payments/api` down must not inhibit `default/status-web` 5xx |

**Other labels you can put in `equal` (production):**

| Label | Use when |
|---|---|
| `cluster` | One Alertmanager serves multiple clusters |
| `environment` | `prod` vs `staging` must not cross-inhibit |
| `team` | Team-scoped on-call; platform down ≠ payments alerts |
| `node` | Node down inhibits pod alerts **on that node** (`equal: ['node']`) |
| `instance` | Very narrow — same pod IP:port only |
| `alertname` | Usually redundant — use `source_matchers` / `target_matchers` instead |

**Multi-label example (production):**

```yaml
equal: ['cluster', 'namespace', 'job']
```

All three must match on source and target for inhibition.

**Common production patterns:**

```yaml
## Critical suppresses warning for the same incident
- source_matchers: [severity="critical"]
  target_matchers: [severity="warning"]
  equal: ['alertname', 'namespace', 'team']

## Node down suppresses pod crash alerts on that node
- source_matchers: [alertname="NodeDown"]
  target_matchers: [alertname=~"PodCrashLooping|TargetDown"]
  equal: ['node']
```

**What NOT to put in `equal`:**

| Avoid | Why |
|---|---|
| `severity` | Source/target often differ (`warning` vs `critical`) — values won't match |
| Labels only on one alert | Both alerts must have the label with the same value, or both missing |
| High-cardinality labels (`pod`, `uid`) | Unless you intend per-pod inhibition only |

**Labels must exist on both alerts:** `StatusWebTargetDown` inherits `job` from `up{job="status-web"}`. `StatusWebHigh5xxRate` uses `sum()` and may **drop** labels — add explicit labels on the rule so `equal` works:

```yaml
## manifests/manual-stack/13-operator-status-web-prometheusrule.yaml
labels:
  severity: critical
  job: status-web
  namespace: default
```

**Verify inhibition:**

```bash
kubectl -n monitoring-manual port-forward svc/alertmanager 9093:9093 &
curl -s 'http://127.0.0.1:9093/api/v2/alerts' | python3 -c "
import json,sys
for a in json.load(sys.stdin):
    print(a['labels'].get('alertname'), '| inhibited:', a.get('status',{}).get('inhibitedBy', []))
"
```

Suppressed alerts show a non-empty `inhibitedBy` list.

##### Maintenance: scale status-web to 0

When you intentionally scale down, you usually want **no 5xx pages** (nothing to scrape). Use three layers:

**Layer 1 — PromQL guard (primary)** — file `16` / `02`:

```promql
(...) > 0.02
and on()
sum(up{job="status-web"} == 1) > 0
```

No target UP → 5xx alert cannot fire.

**Layer 2 — Alertmanager inhibit (backup)** — file `04`:

`StatusWebTargetDown` suppresses `StatusWebHigh5xxRate` when `job`, `namespace`, and `team` match (see above).

**Layer 3 — Silence (planned maintenance):**

```bash
kubectl -n default scale deploy/status-web --replicas=0

kubectl -n monitoring-manual port-forward svc/alertmanager 9093:9093 &
docker run --rm --network host prom/alertmanager:v0.27.0 \
  amtool --alertmanager.url=http://127.0.0.1:9093 silence add \
  alertname=StatusWebTargetDown alertname=StatusWebHigh5xxRate \
  --duration=2h --comment="status-web maintenance"
```

| Alert | Scaled to 0? | Mitigation |
|---|---|---|
| `StatusWebHigh5xxRate` | Should not fire | PromQL `up` guard + inhibit |
| `StatusWebTargetDown` | May fire after `for: 5m` | Expected — use silence if unwanted |

Scale back: `kubectl -n default scale deploy/status-web --replicas=2`

##### Lab: team routing and notification templates

Route alerts to **payments**, **order**, or other teams using a `team` label on PrometheusRule alerts and matching `route.routes` in Alertmanager.

**Step 1 — Label alerts (PrometheusRule, file 10):**

```yaml
## manifests/manual-stack/13-operator-status-web-prometheusrule.yaml
- alert: StatusWebHigh5xxRate
  expr: ...
  labels:
    team: payments        # ← Alertmanager routes on this exact string
    severity: critical
    job: status-web
    namespace: default
```

Order team adds their own `PrometheusRule` with `team: order` on every alert.

**Step 2 — Route by team (Alertmanager, file 04):**

```yaml
route:
  receiver: default-receiver
  group_by: ['alertname', 'team', 'namespace']
  routes:
  - matchers:
    - team="payments"
    receiver: team-payments
  - matchers:
    - team="order"
    receiver: team-order

receivers:
- name: team-payments
  slack_configs:
  - api_url: https://hooks.slack.com/services/REPLACE/PAYMENTS/WEBHOOK
    channel: '#alerts-payments'
    text: |
      Team: {{ .GroupLabels.team }}
      Namespace: {{ .GroupLabels.namespace }}
      {{ range .Alerts.Firing }}• {{ .Annotations.summary }}
      {{ end }}
- name: team-order
  slack_configs:
  - api_url: https://hooks.slack.com/services/REPLACE/ORDER/WEBHOOK
    channel: '#alerts-order'
```

Apply:

```bash
kubectl apply -f manifests/manual-stack/13-operator-status-web-prometheusrule.yaml
kubectl apply -f manifests/manual-stack/02-alertmanager-config.yaml
kubectl -n monitoring-manual rollout restart deploy/alertmanager
```

**How `{{ .GroupLabels.team }}` is populated:**

Alertmanager does **not** read the PrometheusRule YAML at notify time. Follow the full chain:

```
1. PrometheusRule (file 10)
   labels:
     team: payments          ← you set this
     severity: critical
        │
        ▼
2. Prometheus fires alert → POST to Alertmanager
   Payload includes:
   {
     "labels": {
       "alertname": "StatusWebHigh5xxRate",
       "team": "payments",
       "severity": "critical",
       "job": "status-web",
       ...
     }
   }
        │
        ▼
3. Alertmanager route matches team="payments" → receiver team-payments
   group_by: ['alertname', 'team', 'namespace']
        │
        ▼
4. Alerts with SAME alertname + team + namespace → one notification group
   GroupLabels = { alertname, team, namespace }
        │
        ▼
5. Slack template renders:
   Team: {{ .GroupLabels.team }}  →  "Team: payments"
```

| Template variable | Source |
|---|---|
| `{{ .GroupLabels.team }}` | Label `team` from `route.group_by` (same for whole notification group) |
| `{{ .GroupLabels.alertname }}` | From `group_by` |
| `{{ .GroupLabels.namespace }}` | From `group_by` |
| `{{ .CommonLabels.severity }}` | Label identical on **all** alerts in the group |
| `{{ .Alerts.Firing[].Labels.pod }}` | Per-alert label (pod, instance, …) |
| `{{ .Alerts.Firing[].Annotations.summary }}` | From PrometheusRule `annotations` |

**If `Team:` is blank in Slack:**

| Cause | Fix |
|---|---|
| Missing `team` on PrometheusRule | Add `labels: team: payments` |
| `team` not in `group_by` | Add to `group_by: ['alertname', 'team', 'namespace']` |
| Typo | Matcher `team="payments"` must match label exactly |

**Verify without Slack:**

```bash
kubectl -n monitoring-manual port-forward svc/alertmanager 9093:9093 &
curl -s 'http://127.0.0.1:9093/api/v2/alerts' | python3 -m json.tool
## Look for "team": "payments" under labels
```

Production expands this pattern in [Strategy 3–4](#strategy-34-full-production-alertmanager-secret--prometheusrule) with PagerDuty keys and severity sub-routes.

##### Strategy 1: Choose group_by carefully

| group_by | Effect | Staff guidance |
|---|---|---|
| `[alertname, namespace, pod]` | One notification per pod | Only for single-replica stateful systems where pod identity matters |
| `[alertname, namespace]` | One notification per alert per namespace | Default for infra/app outages |
| `[alertname, team, namespace]` | Groups and routes per owning team | Default for multi-team platforms |
| `[alertname]` only | Very wide groups | Risk: unrelated namespaces merged; use with team routes |

##### Strategy 2: Tune timing knobs

| Field | Purpose | Production starting point | Under resource crunch |
|---|---|---|---|
| `group_wait` | Collect burst before first send | `60s` | Increase to `90–120s` during known deploy windows |
| `group_interval` | Wait before notifying about new alerts in same group | `5m` | Keep; do not set below `2m` |
| `repeat_interval` | Re-notify if still firing | `4h` warnings, `1h` critical | Warnings: `12–24h`; never page on repeat for warnings |
| `resolve_timeout` | Wait before "resolved" message | `5m` | `5–15m`; longer reduces flip-flop noise |

##### Strategy 3–4: Full production Alertmanager Secret + PrometheusRule

The snippets below are **complete Kubernetes manifests** — not fragments. They include grouping (Strategy 1–2), team/severity routing (Strategy 3), and inhibition (Strategy 4).

**File:** `manifests/prod/alertmanager-config.yaml`  
**Apply:** `kubectl apply -f manifests/prod/alertmanager-config.yaml`  
**Mounted by:** Alertmanager pod at `/etc/alertmanager/alertmanager.yml` (see `manifests/prod/alertmanager.yaml` in the same section).

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: alertmanager-config
  namespace: monitoring
  labels:
    app.kubernetes.io/name: alertmanager
    app.kubernetes.io/part-of: monitoring
type: Opaque
stringData:
  alertmanager.yml: |
    global:
      resolve_timeout: 5m

    route:
      receiver: default-receiver
      group_by: ['alertname', 'team', 'namespace']
      group_wait: 60s
      group_interval: 5m
      repeat_interval: 4h
      routes:
      - matchers:
        - severity="critical"
        - team="payments"
        receiver: pagerduty-payments
        group_wait: 30s
        repeat_interval: 1h
      - matchers:
        - severity="critical"
        - team="platform"
        receiver: pagerduty-platform
        group_wait: 30s
        repeat_interval: 1h
      - matchers:
        - severity="warning"
        receiver: slack-warnings
        repeat_interval: 24h

    inhibit_rules:
    - source_matchers:
      - severity="critical"
      target_matchers:
      - severity="warning"
      equal: ['alertname', 'namespace', 'team']
    - source_matchers:
      - alertname="NodeDown"
      target_matchers:
      - alertname=~"PodCrashLooping|TargetDown|KubePodCrashLooping"
      equal: ['node']

    receivers:
    - name: default-receiver
      slack_configs:
      - api_url: https://hooks.slack.com/services/REPLACE/SLACK/WEBHOOK
        channel: '#alerts-unrouted'
        send_resolved: true
        title: '[{{ .Status | toUpper }}] {{ .GroupLabels.alertname }}'
        text: |
          Cluster: {{ .CommonLabels.cluster }}
          Environment: {{ .CommonLabels.environment }}
          Team: {{ .GroupLabels.team }}
          Namespace: {{ .GroupLabels.namespace }}
          Firing: {{ len .Alerts.Firing }} | Resolved: {{ len .Alerts.Resolved }}
    - name: pagerduty-payments
      pagerduty_configs:
      - routing_key: REPLACE_WITH_PAYMENTS_PAGERDUTY_ROUTING_KEY
        send_resolved: true
        description: '{{ .GroupLabels.alertname }} — {{ len .Alerts }} alert(s) in {{ .GroupLabels.namespace }}'
        severity: '{{ if eq .Status "firing" }}critical{{ else }}info{{ end }}'
    - name: pagerduty-platform
      pagerduty_configs:
      - routing_key: REPLACE_WITH_PLATFORM_PAGERDUTY_ROUTING_KEY
        send_resolved: true
        description: '{{ .GroupLabels.alertname }} — {{ len .Alerts }} alert(s) in {{ .GroupLabels.namespace }}'
    - name: slack-warnings
      slack_configs:
      - api_url: https://hooks.slack.com/services/REPLACE/SLACK/WEBHOOK
        channel: '#alerts-warning'
        send_resolved: true
        title: '[WARNING] {{ .GroupLabels.alertname }}'
        text: |
          Team: {{ .GroupLabels.team }} | Namespace: {{ .GroupLabels.namespace }}
          Firing: {{ len .Alerts.Firing }}
          {{ range .Alerts.Firing }}• {{ .Labels.pod }}: {{ .Annotations.summary }}
          {{ end }}
```

**File:** `manifests/prod/status-web-prometheusrule.yaml`  
**Apply:** `kubectl apply -f manifests/prod/status-web-prometheusrule.yaml`  
**Selected by:** Prometheus CR `ruleSelector` (label `prometheus: kube-prom` in production example).  
**Purpose:** Alert rules with `team`, `severity`, and `runbook_url` labels that Alertmanager routes on.

```yaml
apiVersion: monitoring.coreos.com/v1
kind: PrometheusRule
metadata:
  name: status-web-alerts
  namespace: default
  labels:
    prometheus: kube-prom
    app.kubernetes.io/name: status-web
spec:
  groups:
  - name: status-web.availability
    interval: 30s
    rules:
    - alert: StatusWebTargetDown
      expr: up{job="status-web", cluster="prod-us-east-1", environment="prod"} == 0
      for: 5m
      labels:
        severity: warning
        team: payments
      annotations:
        summary: status-web scrape target is down
        description: Prometheus cannot scrape status-web in namespace {{ $labels.namespace }} for 5m.
        runbook_url: https://wiki.example.com/runbooks/status-web-target-down
    - alert: StatusWebHigh5xxRate
      expr: |
        (
          sum(rate(http_request_duration_seconds_count{job="status-web", status=~"5..", cluster="prod-us-east-1"}[5m]))
          /
          sum(rate(http_request_duration_seconds_count{job="status-web", cluster="prod-us-east-1"}[5m]))
        ) > 0.02
      for: 10m
      labels:
        severity: critical
        team: payments
      annotations:
        summary: status-web 5xx error rate is high
        description: 5xx ratio is above 2% for 10m in {{ $labels.namespace }}.
        runbook_url: https://wiki.example.com/runbooks/status-web-high-5xx
```

**Staff rule:** Every page-worthy alert must have exactly one owning `team` label. Alerts without `team` land in the `default-receiver` queue and rot.

##### Strategy 5: Silences for maintenance

```bash
amtool silence add --alertmanager.url=http://alertmanager:9093 \
  job=status-web --duration=2h --comment="planned maintenance"
```

Require silence comments and expiry in production. Permanent silences are technical debt.

##### Strategy 6: Alert on symptoms, not causes

| Noisy (avoid) | Better (user-visible) |
|---|---|
| Pod restart count | High 5xx rate |
| Container OOM | Latency p99 above SLO |
| CPU > 80% | Error budget burn rate |
| Single target `up == 0` | Aggregated target-down ratio > 20% |

##### Strategy 7: Alert budget (Staff practice)

Define an alert budget per team per week:

| Metric | Target |
|---|---|
| Pages per on-call shift | < 3 actionable pages |
| Alerts per incident | 1 primary + inhibited children |
| Repeat pages same root cause | 0 within 24h after ack |
| Warning → Slack messages/day | < 10 per channel |

Review weekly: any alert that fired but required no action gets deleted or downgraded.

#### 8.3 External labels for multi-cluster

`external_labels` are set on Prometheus itself. They attach to **every** time series outbound (remote_write) and **every** alert sent to Alertmanager. Alertmanager then routes using labels like `cluster` and `team` without hardcoding them in each rule.

**Rules:**
- Use stable, low-cardinality keys (`cluster`, `environment`, `team`).
- Never use pod names, hostnames, or UUIDs as external labels.
- `prometheus_replica` is for HA deduplication pipelines, not dashboard filters.

##### Option A — Plain Prometheus (ConfigMap)

**File:** `manifests/prod/prometheus-config-plain.yaml`  
**Apply:** `kubectl apply -f manifests/prod/prometheus-config-plain.yaml`  
**Mounted by:** `manifests/prod/prometheus-deployment.yaml` at `/etc/prometheus/config/prometheus.yml` and `/etc/prometheus/rules/alerts.yml`

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: prometheus-config
  namespace: monitoring
  labels:
    app.kubernetes.io/name: prometheus
    app.kubernetes.io/part-of: monitoring
data:
  prometheus.yml: |
    global:
      scrape_interval: 30s
      evaluation_interval: 30s
      scrape_timeout: 10s
      external_labels:
        cluster: prod-us-east-1
        environment: prod
        team: platform
        prometheus: monitoring-main
        prometheus_replica: prom-0

    alerting:
      alertmanagers:
      - kubernetes_sd_configs:
        - role: endpoints
          namespaces:
            names:
            - monitoring
        relabel_configs:
        - action: keep
          source_labels: [__meta_kubernetes_service_name]
          regex: alertmanager
        - action: keep
          source_labels: [__meta_kubernetes_endpoint_port_name]
          regex: http
        api_version: v2

    rule_files:
    - /etc/prometheus/rules/alerts.yml

    scrape_configs:
    - job_name: prometheus
      static_configs:
      - targets: ["localhost:9090"]

    - job_name: kubernetes-service-endpoints
      kubernetes_sd_configs:
      - role: endpoints
      relabel_configs:
      - source_labels: [__meta_kubernetes_service_annotation_prometheus_io_scrape]
        action: keep
        regex: true
      - source_labels: [__meta_kubernetes_service_annotation_prometheus_io_path]
        action: replace
        target_label: __metrics_path__
        regex: (.+)
      - source_labels: [__address__, __meta_kubernetes_service_annotation_prometheus_io_port]
        action: replace
        target_label: __address__
        regex: ([^:]+)(?::\d+)?;(\d+)
        replacement: $1:$2
      - source_labels: [__meta_kubernetes_namespace]
        target_label: namespace
      - source_labels: [__meta_kubernetes_service_name]
        target_label: service
      - source_labels: [__meta_kubernetes_service_name]
        target_label: job

  alerts.yml: |
    groups:
    - name: status-web-alerts
      rules:
      - alert: StatusWebTargetDown
        expr: up{job="status-web"} == 0
        for: 5m
        labels:
          severity: warning
          team: payments
        annotations:
          summary: "status-web target is down"
          description: "Prometheus cannot scrape status-web for 5m."
          runbook_url: "https://wiki.example.com/runbooks/status-web-target-down"
      - alert: StatusWebHigh5xxRate
        expr: |
          (
            sum(rate(http_request_duration_seconds_count{job="status-web",status=~"5.."}[5m]))
            /
            sum(rate(http_request_duration_seconds_count{job="status-web"}[5m]))
          ) > 0.02
        for: 10m
        labels:
          severity: critical
          team: payments
        annotations:
          summary: "status-web high 5xx rate"
          description: "5xx ratio is above 2% for 10m."
          runbook_url: "https://wiki.example.com/runbooks/status-web-high-5xx"
```

**File:** `manifests/prod/prometheus-deployment.yaml` (mounts the ConfigMap above)

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: prometheus
  namespace: monitoring
  labels:
    app.kubernetes.io/name: prometheus
spec:
  replicas: 2
  selector:
    matchLabels:
      app.kubernetes.io/name: prometheus
  template:
    metadata:
      labels:
        app.kubernetes.io/name: prometheus
    spec:
      serviceAccountName: prometheus
      containers:
      - name: prometheus
        image: prom/prometheus:v2.53.0
        args:
        - --config.file=/etc/prometheus/config/prometheus.yml
        - --storage.tsdb.path=/prometheus
        - --storage.tsdb.retention.time=15d
        - --web.enable-lifecycle
        - --web.enable-admin-api=false
        ports:
        - name: http
          containerPort: 9090
        resources:
          requests:
            cpu: "2"
            memory: 8Gi
          limits:
            cpu: "4"
            memory: 16Gi
        volumeMounts:
        - name: config
          mountPath: /etc/prometheus/config
        - name: rules
          mountPath: /etc/prometheus/rules
        - name: data
          mountPath: /prometheus
      volumes:
      - name: config
        configMap:
          name: prometheus-config
          items:
          - key: prometheus.yml
            path: prometheus.yml
      - name: rules
        configMap:
          name: prometheus-config
          items:
          - key: alerts.yml
            path: alerts.yml
      - name: data
        persistentVolumeClaim:
          claimName: prometheus-data
---
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: prometheus-data
  namespace: monitoring
spec:
  accessModes: ["ReadWriteOnce"]
  resources:
    requests:
      storage: 200Gi
---
apiVersion: v1
kind: Service
metadata:
  name: prometheus
  namespace: monitoring
  labels:
    app.kubernetes.io/name: prometheus
spec:
  selector:
    app.kubernetes.io/name: prometheus
  ports:
  - name: http
    port: 9090
    targetPort: http
```

For HA plain mode, deploy **two** Deployments (or a StatefulSet) with different `prometheus_replica` values (`prom-0`, `prom-1`) in each ConfigMap's `external_labels`.

##### Option B — Operator Prometheus CR (recommended for production)

**File:** `manifests/prod/prometheus-cr.yaml`  
**Apply:** `kubectl apply -f manifests/prod/prometheus-cr.yaml`  
**Reconciled by:** Prometheus Operator → generates scrape config Secret → mounts into Prometheus pods

```yaml
apiVersion: monitoring.coreos.com/v1
kind: Prometheus
metadata:
  name: k8s
  namespace: monitoring
  labels:
    app.kubernetes.io/name: prometheus
    app.kubernetes.io/part-of: monitoring
spec:
  replicas: 2
  serviceAccountName: prometheus-k8s
  version: v2.53.0
  scrapeInterval: 30s
  scrapeTimeout: 10s
  evaluationInterval: 30s
  retention: 15d
  enableAdminAPI: false
  externalLabels:
    cluster: prod-us-east-1
    environment: prod
    team: platform
    prometheus: monitoring-main
  podMetadata:
    labels:
      app.kubernetes.io/name: prometheus
  alerting:
    alertmanagers:
    - namespace: monitoring
      name: alertmanager
      port: http
      apiVersion: v2
  serviceMonitorSelector:
    matchLabels:
      prometheus: kube-prom
  serviceMonitorNamespaceSelector:
    matchLabels:
      monitoring: enabled
  ruleSelector:
    matchLabels:
      prometheus: kube-prom
  ruleNamespaceSelector:
    matchLabels:
      monitoring: enabled
  resources:
    requests:
      cpu: "2"
      memory: 8Gi
    limits:
      cpu: "4"
      memory: 16Gi
  storage:
    volumeClaimTemplate:
      metadata:
        name: prometheus-data
      spec:
        accessModes: ["ReadWriteOnce"]
        resources:
          requests:
            storage: 200Gi
  remoteWrite:
  - url: https://mimir.example.com/api/v1/push
    queueConfig:
      capacity: 10000
      maxShards: 50
      minShards: 1
      maxSamplesPerSend: 2000
      batchSendDeadline: 5s
```

For HA with `replicas: 2`, keep shared labels (`cluster`, `environment`, `team`) in `externalLabels`. Do **not** hardcode `prometheus_replica: prom-0` in the CR — the operator assigns per-pod identity for deduplication. Use separate plain ConfigMaps per replica only if you run plain Deployments instead of the Operator.

1. `externalLabels` on the Prometheus CR → attached to every firing alert.
2. `team` label on PrometheusRule → merged into alert labels.
3. Alertmanager `route.routes` matches `severity` + `team` → correct receiver.
4. `group_by: ['alertname', 'team', 'namespace']` → 100 pod alerts become one notification per team.

Example alert payload Alertmanager receives (note `cluster`, `environment`, `team` from external + rule labels):

```json
{
  "labels": {
    "alertname": "StatusWebHigh5xxRate",
    "severity": "critical",
    "team": "payments",
    "job": "status-web",
    "namespace": "default",
    "cluster": "prod-us-east-1",
    "environment": "prod",
    "prometheus": "monitoring-main",
    "prometheus_replica": "prometheus-k8s-0"
  },
  "annotations": {
    "summary": "status-web 5xx error rate is high",
    "description": "5xx ratio is above 2% for 10m in default.",
    "runbook_url": "https://wiki.example.com/runbooks/status-web-high-5xx"
  }
}
```

#### 8.4 Production checklist (pre-go-live)

| Area | Check |
|---|---|
| Discovery | Annotations correct (plain) or ServiceMonitor labels/selectors correct (CR) |
| Target health | `up == 1` stable for all production targets |
| Metrics quality | No high-cardinality labels; RED metrics (rate, errors, duration) present |
| Alert quality | Every alert has `for:`, `severity`, actionable `summary` and `description` |
| Routing | Critical → PagerDuty; warning → Slack; `group_by` tested under burst |
| Inhibition | Parent/child rules defined for cascading failures |
| Runbooks | Every alert links to response steps; on-call knows silence workflow |
| Resources | Prometheus CPU/memory/disk sized; retention and scrape interval tuned |
| Security | Alertmanager config in Secret; RBAC least-privilege; no cluster-admin operator |
| HA | 2+ Prometheus replicas; 3 Alertmanager replicas; persistent volumes |
| Persistence | TSDB on PVC/StatefulSet — not `emptyDir` |
| Monitoring the monitors | Meta-alerts on Prometheus/Alertmanager health |

#### 8.5 Quick sizing signals

| Symptom | Likely cause | First action |
|---|---|---|
| High CPU | Too many targets, heavy rules, short scrape interval | Increase `scrapeInterval`; add recording rules; scale CPU |
| High memory | Cardinality explosion | Audit top labels; `metric_relabel_configs` drops |
| Disk full | Retention too long vs disk size | Shorten retention or expand PVC; remote_write to long-term store |
| Slow dashboards | Expensive PromQL over raw counters | Pre-aggregate with recording rules |
| Scrape timeouts | `scrapeTimeout` ≥ `scrapeInterval` overlap | Set timeout to ~80% of interval |
| OOMKilled Prometheus | Undersized memory limit | Size from active series count (Chapter 9) |

Primary ingestion limit:

```
samples_per_second ≈ (active_targets × avg_series_per_target) / scrape_interval_seconds
```

---

### Chapter 9: Staff Engineer Production Playbook

This chapter is for the person signing off on a production rollout. The lab manifests in this repo are **intentionally minimal**. Do not copy them verbatim into production without addressing every item below.

#### 9.1 What the lab does vs what production needs

| Lab default (`manual-stack`) | Production expectation |
|---|---|
| `replicas: 1` Prometheus | 2+ replicas with sharding or HA pair + dedup |
| `emptyDir` TSDB storage (`03-prometheus.yaml`) | PVC or StatefulSet with sized disk |
| `retention: 24h` | 15–30 days local + remote_write for long-term |
| No resource requests/limits on plain Prometheus | Explicit requests/limits on every component |
| Operator bound to `cluster-admin` (`07-operator-rbac.yaml`) | Dedicated least-privilege ClusterRole |
| Single Alertmanager | 3-node Alertmanager cluster for quorum |
| `enableAdminAPI: true` | Disabled or restricted behind auth |
| Broad `serviceMonitorSelector: {}` patterns | Strict label selectors per team/environment |
| Default Grafana password in Secret | SSO + rotated credentials |

#### 9.2 Architecture decisions before you deploy

Answer these in a design doc before applying manifests.

**1. Plain Prometheus or Operator CR?**

| Factor | Plain | Operator + CR |
|---|---|---|
| Team size | 1–2 teams, small cluster | Platform team, many services |
| GitOps | ConfigMap for `prometheus.yml` | ServiceMonitor/PrometheusRule per app repo |
| Blast radius | One config file breaks all scraping | Misconfigured SM affects one job |
| Production fit | Edge cases, legacy | **Recommended default for K8s production** |

**2. One Prometheus or many?**

Split when any threshold is exceeded:

| Signal | Split trigger |
|---|---|
| Active series | > 5–10M per instance (org-dependent) |
| Ingestion rate | > 1–2M samples/sec sustained |
| Rule evaluation | p99 eval duration > `evaluation_interval` |
| Team ownership | Hard multi-tenant isolation required |

Patterns: shard by namespace/team via `hashmod`, federation for aggregate views, or Thanos/Mimir/Cortex for global query layer.

**3. Where does long-term data live?**

Prometheus local TSDB is for **recent** operational data. Plan `remote_write` to Mimir, Thanos, Cortex, or vendor backend for:
- Compliance retention (90d–1y)
- Cross-cluster queries
- Reducing local disk pressure

#### 9.3 Performance and ingestion math

Staff engineers size from numbers, not guesses.

**Step 1: Estimate active series per target**

For `status-web` (podinfo), expect ~50–200 series per pod. For a full node-exporter + kube-state-metrics stack, thousands per node.

**Step 2: Calculate total active series**

```
active_series = targets × series_per_target
```

Example: 500 targets × 300 series = **150,000 active series** (modest).

**Step 3: Calculate ingestion rate**

```
samples_per_second = active_series / scrape_interval_seconds
```

With `scrape_interval: 30s` and 150k series: **5,000 samples/sec**.

**Step 4: Disk for local retention**

Rule of thumb (varies by compression and label size):

```
disk_gb ≈ active_series × retention_seconds × bytes_per_sample / 1e9
```

Use ~1–2 bytes per sample as a planning estimate. For 150k series, 15d retention, 30s scrape:

```
150000 × (15 × 86400) / 30 × 1.5 bytes ≈ 10 TB raw upper bound — validate with pilot
```

**Always run a 48h pilot** in a staging cluster with production-like scrape config and measure:

```promql
## Active series
prometheus_tsdb_head_series

## Ingestion rate
rate(prometheus_tsdb_head_samples_appended_total[5m])

## Memory
process_resident_memory_bytes{job="prometheus"}

## Compaction / WAL
prometheus_tsdb_wal_corruptions_total
prometheus_tsdb_compactions_failed_total
```

#### 9.4 Resource sizing guide

Starting points for **operator-managed Prometheus** (tune with pilot metrics):

| Active series | CPU request | Memory request | Memory limit | Disk (15d local) |
|---|---|---|---|---|
| < 500k | 1 core | 4 Gi | 8 Gi | 50 Gi |
| 500k – 2M | 2 cores | 8 Gi | 16 Gi | 200 Gi |
| 2M – 5M | 4 cores | 16 Gi | 32 Gi | 500 Gi |
| > 5M | Shard or dedicated TSDB tier | 32 Gi+ | 64 Gi+ | Remote_write required |

**Alertmanager** (3 replicas):

| Load | CPU / pod | Memory / pod |
|---|---|---|
| < 1k alerts/hour | 100m | 256 Mi |
| High burst | 500m | 512 Mi |

**Prometheus Operator:**

| Cluster size | CPU | Memory |
|---|---|---|
| < 100 ServiceMonitors | 100m | 128 Mi |
| 100–500 ServiceMonitors | 200m | 256 Mi |
| 500+ | 500m | 512 Mi; watch reconcile latency |

**Grafana:** 250m CPU / 512 Mi memory minimum; scale with dashboard count and concurrent users.

#### 9.5 Speed vs cost tradeoffs

Every tuning knob trades **resolution**, **cost**, and **alert responsiveness**.

| Knob | Lower value (faster/more detail) | Higher value (cheaper/less load) | Staff guidance |
|---|---|---|---|
| `scrape_interval` | 15s — faster graphs | 60s–120s — less ingestion | App SLOs: 30s default; infra: 60s |
| `scrape_timeout` | Must be < interval | 80% of interval | Never equal interval (overlap storms) |
| `evaluation_interval` | 15s — faster alerts | 60s — less CPU | Match or exceed scrape interval |
| `for:` on alerts | 1m — fast page | 10–15m — fewer false positives | User-facing: 5m+; infra: 10m+ |
| Retention | 30d local | 7d local + remote | Disk is the hard limit |

**Under resource crunch — reduce in this order:**

1. Drop non-essential exporters and debug metrics (`metric_relabel_configs`).
2. Increase `scrape_interval` on infra jobs (node-exporter, kube-state).
3. Add recording rules so dashboards query pre-aggregated metrics.
4. Shorten local retention; keep long history in remote_write backend.
5. Shard Prometheus by team or namespace.
6. **Last resort:** reduce app scrape frequency (only if SLO allows).

#### 9.6 Cardinality — the silent killer

High cardinality destroys memory, slows queries, and lengthens compactions. One bad metric label can take down Prometheus.

**Never allow in production labels:**

| Label | Why |
|---|---|
| `user_id`, `customer_id` | Unbounded |
| `request_id`, `trace_id` | Unbounded |
| `url` (full path) | Thousands of paths |
| `pod` on aggregated alerts | Use grouping, not alert rules per pod |

**Defense layers — full manifests:**

**File:** `manifests/prod/status-web-servicemonitor.yaml`  
**Apply:** `kubectl apply -f manifests/prod/status-web-servicemonitor.yaml`  
**Selected by:** Prometheus CR `serviceMonitorSelector.matchLabels.prometheus: kube-prom`

```yaml
apiVersion: monitoring.coreos.com/v1
kind: ServiceMonitor
metadata:
  name: status-web
  namespace: default
  labels:
    prometheus: kube-prom
    app.kubernetes.io/name: status-web
spec:
  namespaceSelector:
    matchNames:
    - default
  selector:
    matchLabels:
      app: status-web
  endpoints:
  - port: http-metrics
    path: /metrics
    interval: 30s
    scrapeTimeout: 10s
    honorLabels: false
    metricRelabelings:
    - sourceLabels: [__name__]
      regex: go_gc_duration_seconds.*
      action: drop
    - sourceLabels: [__name__]
      regex: promhttp_.*
      action: drop
```

**File:** `manifests/prod/status-web-service.yaml` (port name must match ServiceMonitor `endpoints.port`)

```yaml
apiVersion: v1
kind: Service
metadata:
  name: status-web
  namespace: default
  labels:
    app.kubernetes.io/name: status-web
    app: status-web
    monitoring: enabled
spec:
  selector:
    app: status-web
  ports:
  - name: http-metrics
    port: 9898
    targetPort: http-metrics
```

**File:** `manifests/prod/status-web-prometheusrule-aggregated.yaml` (symptom alert — no per-pod fan-out)

```yaml
apiVersion: monitoring.coreos.com/v1
kind: PrometheusRule
metadata:
  name: status-web-aggregated-alerts
  namespace: default
  labels:
    prometheus: kube-prom
spec:
  groups:
  - name: status-web.symptoms
    rules:
    - alert: StatusWebHigh5xxRate
      expr: |
        (
          sum(rate(http_request_duration_seconds_count{job="status-web", status=~"5..", cluster="prod-us-east-1"}[5m]))
          /
          sum(rate(http_request_duration_seconds_count{job="status-web", cluster="prod-us-east-1"}[5m]))
        ) > 0.02
      for: 10m
      labels:
        severity: critical
        team: payments
      annotations:
        summary: status-web 5xx error rate is high
        description: More than 2% of requests returned 5xx for 10m.
        runbook_url: https://wiki.example.com/runbooks/status-web-high-5xx
    - alert: StatusWebHighTargetDownRatio
      expr: |
        (
          sum(up{job="status-web", cluster="prod-us-east-1"} == 0)
          /
          count(up{job="status-web", cluster="prod-us-east-1"})
        ) > 0.2
      for: 10m
      labels:
        severity: critical
        team: payments
      annotations:
        summary: more than 20% of status-web targets are down
        description: "{{ $value | humanizePercentage }} of status-web targets are not reachable."
        runbook_url: https://wiki.example.com/runbooks/status-web-target-down
```

**Audit command (run monthly):**

```promql
topk(20, count by (__name__) ({__name__=~".+"}))
```

Investigate any metric with series count an order of magnitude above peers.

#### 9.7 Query and dashboard performance

Slow Grafana = angry engineers = more direct Prometheus load. The primary fix is **recording rules** — see [Chapter 4.5](#chapter-45-managing-expensive-queries-with-recording-rules) for small → medium → complex examples with full manifests.

| Practice | Detail |
|---|---|
| Recording rules | Pre-compute `rate()` and histogram quantiles ([Example 1–3](#chapter-45-managing-expensive-queries-with-recording-rules)) |
| Range window | `[5m]` minimum for `rate()`; align with scrape interval |
| Avoid `offset` chains | Hard to reason; expensive at scale |
| Limit aggregation cardinality | `sum by (status, namespace)` not `sum by (pod)` on global dashboards |
| Query timeout | Set Grafana and Prometheus query timeouts (30–60s) |
| Subqueries | Avoid nested subqueries in alert rules on hot paths |

**Production files (defined in Chapter 4.5):**

| File | Level |
|---|---|
| `manifests/prod/status-web-recording-rules.yaml` | Example 2 — ratio chain + alert |
| `manifests/prod/status-web-recording-rules-advanced.yaml` | Example 3 — p99, SLO burn, cluster rollup |

Grafana dashboards should query recorded metrics (e.g. `job:status_web:http_requests:rate5m`) instead of raw `rate()` on counters.

#### 9.8 Reliability and HA

**Prometheus HA (pair model):**

```
                    ┌─────────────┐     ┌─────────────┐
  ServiceMonitors → │ Prometheus-0│     │ Prometheus-1│
                    │ replica: 0  │     │ replica: 1  │
                    └──────┬──────┘     └──────┬──────┘
                           │                    │
                           └────────┬───────────┘
                                    v
                            Alertmanager cluster
                            (dedup via replica label)
```

- Both replicas scrape the same targets.
- Both evaluate the same rules.
- Both send alerts with `prometheus_replica` external label.
- Alertmanager deduplicates identical alerts.
- **Do not** load-balance Grafana across replicas for alerting truth — pick one query source or use Thanos query frontend.

**Alertmanager clustering:**

- Run **3 replicas** (odd quorum).
- Use `alertmanager.io` mesh or Kubernetes headless service.
- Store silences and notification state on PVC.

**Persistence — full manifests (Operator HA pair + Alertmanager cluster):**

**File:** `manifests/prod/prometheus-cr-ha.yaml`  
(Same as Section 8.3 Option B — `replicas: 2`, `storage.volumeClaimTemplate`, `externalLabels` including `prometheus_replica` injected per-pod by the operator.)

**File:** `manifests/prod/alertmanager-cr.yaml`  
**Apply:** `kubectl apply -f manifests/prod/alertmanager-cr.yaml`  
**Uses config Secret from:** `manifests/prod/alertmanager-config.yaml` (Section 8.2)

```yaml
apiVersion: monitoring.coreos.com/v1
kind: Alertmanager
metadata:
  name: main
  namespace: monitoring
  labels:
    app.kubernetes.io/name: alertmanager
    app.kubernetes.io/part-of: monitoring
spec:
  replicas: 3
  version: v0.27.0
  serviceAccountName: alertmanager
  configSecret: alertmanager-config
  listenLocal: false
  externalUrl: https://alertmanager.example.com
  routePrefix: /
  resources:
    requests:
      cpu: 100m
      memory: 256Mi
    limits:
      cpu: 500m
      memory: 512Mi
  storage:
    volumeClaimTemplate:
      metadata:
        name: alertmanager-data
      spec:
        accessModes: ["ReadWriteOnce"]
        resources:
          requests:
            storage: 10Gi
---
apiVersion: v1
kind: Service
metadata:
  name: alertmanager
  namespace: monitoring
  labels:
    app.kubernetes.io/name: alertmanager
spec:
  selector:
    app.kubernetes.io/name: alertmanager
  ports:
  - name: http
    port: 9093
    targetPort: 9093
  - name: mesh
    port: 9094
    targetPort: 9094
```

**File:** `manifests/prod/alertmanager-serviceaccount.yaml`

```yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: alertmanager
  namespace: monitoring
```

#### 9.9 Security and blast radius

| Area | Lab | Production |
|---|---|---|
| Operator RBAC | `cluster-admin` | Custom ClusterRole: watch/list CRDs, configmaps, secrets in scope |
| Prometheus RBAC | Cluster-wide read | Namespace-scoped where possible |
| Alertmanager Secret | Demo receiver | Sealed Secrets / External Secrets Operator |
| Network | Open cluster | NetworkPolicy: only Prometheus → app metrics ports |
| Admin API | Enabled | Disabled |
| Grafana | Static password | SSO (OAuth/OIDC) |

Restrict `serviceMonitorNamespaceSelector` and `ruleNamespaceSelector` on the Prometheus CR so one team's Prometheus cannot accidentally ingest another team's monitors.

**File:** `manifests/prod/networkpolicy-prometheus-scrape.yaml`

```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: allow-prometheus-scrape
  namespace: default
spec:
  podSelector:
    matchLabels:
      app: status-web
  policyTypes:
  - Ingress
  ingress:
  - from:
    - namespaceSelector:
        matchLabels:
          kubernetes.io/metadata.name: monitoring
      podSelector:
        matchLabels:
          app.kubernetes.io/name: prometheus
    ports:
    - protocol: TCP
      port: 9898
```

#### 9.10 Operator namespace scope in production

The lab operator watches a fixed namespace list. Production uses the same pattern but you must list **every** namespace that hosts ServiceMonitors or PrometheusRules.

**File:** `manifests/prod/prometheus-operator-deployment.yaml`  
**Apply:** `kubectl apply -f manifests/prod/prometheus-operator-deployment.yaml`  
**Depends on:** `manifests/prod/prometheus-operator-rbac.yaml` (ServiceAccount + least-privilege ClusterRole — not `cluster-admin`)

```yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: prometheus-operator
  namespace: monitoring
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: prometheus-operator
  namespace: monitoring
  labels:
    app.kubernetes.io/name: prometheus-operator
    app.kubernetes.io/part-of: monitoring
spec:
  replicas: 1
  selector:
    matchLabels:
      app.kubernetes.io/name: prometheus-operator
  template:
    metadata:
      labels:
        app.kubernetes.io/name: prometheus-operator
    spec:
      serviceAccountName: prometheus-operator
      containers:
      - name: prometheus-operator
        image: quay.io/prometheus-operator/prometheus-operator:v0.76.0
        imagePullPolicy: IfNotPresent
        args:
        - --log-level=info
        - --kubelet-service=kube-system/kubelet
        - --prometheus-config-reloader=quay.io/prometheus-operator/prometheus-config-reloader:v0.76.0
        - --prometheus-instance-namespaces=monitoring
        - --alertmanager-instance-namespaces=monitoring
        - --thanos-ruler-instance-namespaces=monitoring
        - --namespaces=monitoring,default,payments,orders
        ports:
        - name: http
          containerPort: 8080
        resources:
          requests:
            cpu: 200m
            memory: 256Mi
          limits:
            cpu: 500m
            memory: 512Mi
```

In production:

- List **every** namespace that will host ServiceMonitors or PrometheusRules in `--namespaces`.
- Adding a new product namespace requires an operator rollout — automate this in GitOps.
- Separate operators per environment (prod/staging) — never one operator watching all envs without selector guardrails.

#### 9.11 Monitoring the monitors

If Prometheus is down, you are flying blind. Page on the monitoring stack itself.

| Alert | Expression idea | Severity |
|---|---|---|
| PrometheusDown | `up{job="prometheus"} == 0` | critical |
| PrometheusTSDBCompactionsFailing | `increase(prometheus_tsdb_compactions_failed_total[1h]) > 0` | warning |
| PrometheusNotIngesting | `rate(prometheus_tsdb_head_samples_appended_total[5m]) == 0` | critical |
| AlertmanagerDown | `up{job="alertmanager"} == 0` | critical |
| PrometheusRuleEvalSlow | `prometheus_rule_group_last_duration_seconds > 60` | warning |
| TargetScrapeFailureHigh | High `scrape_samples_post_metric_relabeling` drop or `up == 0` ratio | warning |

Run meta-monitoring from a **separate** lightweight Prometheus or your SaaS provider so a full monitoring outage still pages.

**File:** `manifests/prod/prometheus-meta-rules.yaml`  
**Apply:** `kubectl apply -f manifests/prod/prometheus-meta-rules.yaml`  
**Namespace:** `monitoring` — selected by Prometheus CR `ruleSelector`

```yaml
apiVersion: monitoring.coreos.com/v1
kind: PrometheusRule
metadata:
  name: prometheus-meta-alerts
  namespace: monitoring
  labels:
    prometheus: kube-prom
    app.kubernetes.io/name: prometheus
spec:
  groups:
  - name: prometheus.meta
    interval: 30s
    rules:
    - alert: PrometheusTargetDown
      expr: up{job="prometheus", cluster="prod-us-east-1"} == 0
      for: 5m
      labels:
        severity: critical
        team: platform
      annotations:
        summary: Prometheus scrape target is down
        description: Prometheus instance {{ $labels.instance }} is not reachable.
        runbook_url: https://wiki.example.com/runbooks/prometheus-down
    - alert: PrometheusNotIngesting
      expr: rate(prometheus_tsdb_head_samples_appended_total{cluster="prod-us-east-1"}[5m]) == 0
      for: 10m
      labels:
        severity: critical
        team: platform
      annotations:
        summary: Prometheus is not ingesting samples
        description: No samples appended for 10m on {{ $labels.instance }}.
        runbook_url: https://wiki.example.com/runbooks/prometheus-not-ingesting
    - alert: PrometheusTSDBCompactionsFailing
      expr: increase(prometheus_tsdb_compactions_failed_total{cluster="prod-us-east-1"}[1h]) > 0
      for: 5m
      labels:
        severity: warning
        team: platform
      annotations:
        summary: Prometheus TSDB compactions failing
        description: Compaction failures detected on {{ $labels.instance }}.
        runbook_url: https://wiki.example.com/runbooks/prometheus-compaction-failures
    - alert: PrometheusRuleEvalSlow
      expr: prometheus_rule_group_last_duration_seconds{cluster="prod-us-east-1"} > 60
      for: 10m
      labels:
        severity: warning
        team: platform
      annotations:
        summary: Prometheus rule evaluation is slow
        description: Rule group {{ $labels.rule_group }} took {{ $value }}s on {{ $labels.instance }}.
        runbook_url: https://wiki.example.com/runbooks/prometheus-slow-rules
    - alert: AlertmanagerTargetDown
      expr: up{job="alertmanager", cluster="prod-us-east-1"} == 0
      for: 5m
      labels:
        severity: critical
        team: platform
      annotations:
        summary: Alertmanager target is down
        description: Alertmanager {{ $labels.instance }} is not reachable.
        runbook_url: https://wiki.example.com/runbooks/alertmanager-down
    - alert: StatusWebScrapeFailureHigh
      expr: |
        (
          sum(up{job="status-web", cluster="prod-us-east-1"} == 0)
          /
          count(up{job="status-web", cluster="prod-us-east-1"})
        ) > 0.2
      for: 10m
      labels:
        severity: warning
        team: payments
      annotations:
        summary: high ratio of status-web scrape failures
        description: More than 20% of status-web targets are down.
        runbook_url: https://wiki.example.com/runbooks/status-web-scrape-failures
```

#### 9.12 Production rollout procedure

**Phase 0 — Design (1–2 weeks)**

- [ ] Ingestion and series estimates documented
- [ ] HA topology chosen
- [ ] Remote_write destination provisioned
- [ ] Alert routing tree reviewed with each team lead
- [ ] Runbook template agreed

**Phase 1 — Staging pilot**

- [ ] Deploy operator stack with production scrape intervals
- [ ] Import top 20 production dashboards
- [ ] Load test representative traffic
- [ ] Measure `prometheus_tsdb_head_series` and memory over 48h
- [ ] Simulate 50-alert burst; verify one grouped notification

**Phase 2 — Production canary**

- [ ] One non-critical namespace onboarded first
- [ ] Compare scrape success rate vs existing monitoring
- [ ] On-call shadow mode for 1 week (alerts to Slack only, no pages)

**Phase 3 — Full cutover**

- [ ] Enable PagerDuty routes for critical
- [ ] Decommission duplicate scrapers to avoid double-ingest
- [ ] Post-deploy review at 24h and 7d

#### 9.13 Incident and on-call expectations

Document for every production alert:

| Field | Required |
|---|---|
| `summary` | One line: what is broken |
| `description` | Impact + scope (use template variables) |
| `runbook_url` | Link to actionable steps |
| `severity` | `critical` = page; `warning` = Slack |
| `team` | Owning team for routing |

**During an incident:**

1. Ack alert in PagerDuty/Opsgenie.
2. Check `up`, error rate, and recent deploys in Grafana.
3. Silence only with ticket reference and expiry.
4. Post-incident: if alert did not help, delete or rewrite the rule.

#### 9.14 Production apply order (all Chapter 8–9 manifests)

Apply in this order so dependencies exist before selectors run:

```bash
## 1. Namespace and RBAC
kubectl apply -f manifests/prod/namespace.yaml
kubectl apply -f manifests/prod/prometheus-operator-rbac.yaml
kubectl apply -f manifests/prod/prometheus-k8s-rbac.yaml
kubectl apply -f manifests/prod/alertmanager-serviceaccount.yaml

## 2. Operator control plane
kubectl apply -f manifests/prod/prometheus-operator-deployment.yaml

## 3. Alert routing config (Secret must exist before Alertmanager CR)
kubectl apply -f manifests/prod/alertmanager-config.yaml
kubectl apply -f manifests/prod/alertmanager-cr.yaml

## 4. Prometheus instance (references Alertmanager service, PVC template, externalLabels)
kubectl apply -f manifests/prod/prometheus-cr.yaml

## 5. Application workload + discovery
kubectl apply -f manifests/prod/status-web-deployment.yaml
kubectl apply -f manifests/prod/status-web-service.yaml
kubectl apply -f manifests/prod/status-web-servicemonitor.yaml

## 6. Rules (app alerts, recording rules, meta alerts)
kubectl apply -f manifests/prod/status-web-prometheusrule.yaml
kubectl apply -f manifests/prod/status-web-recording-rules.yaml
kubectl apply -f manifests/prod/status-web-recording-rules-advanced.yaml
kubectl apply -f manifests/prod/prometheus-meta-rules.yaml

## 7. Network policy (optional)
kubectl apply -f manifests/prod/networkpolicy-prometheus-scrape.yaml

## 8. Verify
kubectl -n monitoring get prometheus,alertmanager,servicemonitor,prometheusrule
kubectl -n monitoring rollout status statefulset/prometheus-k8s --timeout=300s
kubectl -n monitoring rollout status statefulset/alertmanager-main --timeout=300s
```

**Manifest index (full files defined in this document):**

| File | Defined in section |
|---|---|
| `manifests/prod/alertmanager-config.yaml` | [8.2 Strategy 3–4](#strategy-34-full-production-alertmanager-secret--prometheusrule) |
| `manifests/prod/status-web-prometheusrule.yaml` | [8.2 Strategy 3–4](#strategy-34-full-production-alertmanager-secret--prometheusrule) |
| `manifests/prod/prometheus-config-plain.yaml` | [8.3 Option A](#option-a--plain-prometheus-configmap) |
| `manifests/prod/prometheus-deployment.yaml` | [8.3 Option A](#option-a--plain-prometheus-configmap) |
| `manifests/prod/prometheus-cr.yaml` | [8.3 Option B](#option-b--operator-prometheus-cr-recommended-for-production) |
| `manifests/prod/status-web-servicemonitor.yaml` | [9.6](#96-cardinality--the-silent-killer) |
| `manifests/prod/status-web-service.yaml` | [9.6](#96-cardinality--the-silent-killer) |
| `manifests/prod/status-web-recording-rules.yaml` | [4.5 Example 2](#example-2--medium-recording-chain--alert-on-recorded-ratio) |
| `manifests/prod/status-web-recording-rules-advanced.yaml` | [4.5 Example 3](#example-3--complex-histogram-p99-multi-label-aggregation-slo-style-burn) |
| `manifests/prod/alertmanager-cr.yaml` | [9.8](#98-reliability-and-ha) |
| `manifests/prod/prometheus-operator-deployment.yaml` | [9.10](#910-operator-namespace-scope-in-production) |
| `manifests/prod/prometheus-meta-rules.yaml` | [9.11](#911-monitoring-the-monitors) |
| `manifests/prod/networkpolicy-prometheus-scrape.yaml` | [9.9](#99-security-and-blast-radius) |

#### 9.15 Plain vs Operator — which production bundle to use

| Bundle | When | Key files |
|---|---|---|
| **Operator (recommended)** | Kubernetes production, multi-team, GitOps | `prometheus-cr.yaml`, `alertmanager-cr.yaml`, `status-web-servicemonitor.yaml`, `*-prometheusrule.yaml` |
| **Plain** | Legacy/small cluster, no operator | `prometheus-config-plain.yaml`, `prometheus-deployment.yaml` |

The Operator bundle in [Section 8.3 Option B](#option-b--operator-prometheus-cr-recommended-for-production) is the canonical production Prometheus manifest. It includes `externalLabels`, `alerting.alertmanagers`, PVC `storage`, `remoteWrite`, resource limits, and strict `serviceMonitorSelector` / `ruleSelector` — not a partial override of the lab `10-operator-prometheus-cr.yaml`.

#### 9.16 Staff engineer gate checklist (sign-off)

Before production traffic depends on this stack, every item must be checked:

**Capacity**
- [ ] Pilot measured active series and ingestion rate
- [ ] Memory limit ≥ 2× current `process_resident_memory_bytes` headroom
- [ ] Disk sized for retention with 30% headroom
- [ ] Scrape interval documented per job class

**Reliability**
- [ ] 2+ Prometheus replicas OR explicit single-replica risk accepted in writing
- [ ] 3 Alertmanager replicas with PVC
- [ ] TSDB on persistent volumes
- [ ] Meta-alerts firing correctly in test

**Alert quality**
- [ ] Every critical alert has `for:` ≥ 5m
- [ ] `group_by` tested with simulated burst (100 alerts → 1 notification)
- [ ] Inhibition rules for node/platform cascading failures
- [ ] No alert without runbook URL
- [ ] Alert budget reviewed with on-call lead

**Security**
- [ ] No `cluster-admin` for operator
- [ ] Alertmanager webhooks in secret manager
- [ ] NetworkPolicies applied
- [ ] Grafana SSO enabled

**Operability**
- [ ] Upgrade/runbook for Prometheus Operator version pinned
- [ ] Backup/restore tested for Alertmanager silences state
- [ ] Dashboards use recording rules where queries > 2s
- [ ] On-call trained on silence vs inhibition vs fix

---

### Chapter 4 (reference): Prometheus Config Anatomy

*Read this when you are staring at a `prometheus.yml` and need to understand each section.*

#### Top-level sections

| Section | Purpose |
|---|---|
| `global` | Defaults: `scrape_interval`, `evaluation_interval`, `external_labels` |
| `alerting` | Where to send alerts (`alertmanagers` block) |
| `rule_files` | Paths to alerting and recording rules |
| `scrape_configs` | **Most important** — one entry per scrape job |
| `storage` | TSDB retention settings |

#### Inside a scrape job

| Field | Meaning |
|---|---|
| `job_name` | Identifier (e.g. `kubernetes-service-endpoints` or `serviceMonitor/.../status-web/0`) |
| `kubernetes_sd_configs` | Discover targets from Kubernetes API |
| `relabel_configs` | Filter and label targets **before** scrape |
| `metric_relabel_configs` | Filter samples **after** scrape |
| `metrics_path` | Usually `/metrics` |
| `scrape_interval` | Override global default per job |

#### kubernetes_sd_configs roles

| Role | Discovers | Use when |
|---|---|---|
| `endpoints` | Service backends | Scraping through a Service (most apps) |
| `pod` | Pods directly | Pod annotations, no Service |
| `node` | Cluster nodes | node-exporter, kubelet |
| `endpointslice` | EndpointSlices | Large clusters |
| `service` | Services themselves | Blackbox checks |
| `ingress` | Ingress resources | URL probing |

For `status-web`, `role: endpoints` is correct.

#### relabel_configs actions

| Action | Effect |
|---|---|
| `keep` | Drop target if regex does **not** match |
| `drop` | Drop target if regex **does** match |
| `replace` | Set `target_label` from capture groups (default action) |
| `labelmap` | Copy `__meta_*` labels to metric labels |
| `labeldrop` | Remove labels matching regex |
| `hashmod` | Shard targets across Prometheus replicas |

**Pipeline model:** rules run top-to-bottom. One failed `keep` → target dropped → remaining rules never run.

#### Where config lives (Operator mode)

| Location | Path |
|---|---|
| Generated Secret | `prometheus-<cr-name>` → `prometheus.yaml.gz` |
| Inside pod | `/etc/prometheus/config_out/prometheus.env.yaml` |

---

### Appendix A: Manifest map (files 00-13)

Full **“I want to change X → edit file Y”** table: [Quick reference: what file to change?](#quick-reference-what-file-to-change)

| File | Mode | Purpose |
|---|---|---|
| `00-namespace.yaml` | Shared | Creates `monitoring-manual` |
| `01-crds.yaml` | CRD | Prometheus / ServiceMonitor / PrometheusRule API types |
| `02-alertmanager-config.yaml` | Shared | Alertmanager routing Secret |
| `03-alertmanager.yaml` | Shared | Alertmanager deployment |
| `04-grafana-secret.yaml` | Shared | Grafana admin credentials |
| `05-grafana-datasource.yaml` | Shared | Grafana datasource (`prometheus-k8s`) |
| `06-grafana.yaml` | Shared | Grafana deployment |
| `07-operator-rbac.yaml` | CR | Operator RBAC |
| `08-operator-deployment.yaml` | CR | Prometheus Operator |
| `09-operator-prometheus-rbac.yaml` | CR | Managed Prometheus RBAC |
| `10-operator-prometheus-cr.yaml` | CR | Prometheus CR (`spec.alerting` → Alertmanager Service) |
| `11-operator-prometheus-service.yaml` | CR | Expose operator Prometheus |
| `12-operator-status-web-servicemonitor.yaml` | CR | ServiceMonitor for status-web |
| `13-operator-status-web-prometheusrule.yaml` | CR | Recording rules + alerts (`team` labels) |

#### Optional Thanos stack (`manifests/manual-stack/thanos/`)

| File | Purpose |
|---|---|
| `01-minio.yaml` | MinIO object storage (kind lab) |
| `02-minio-bucket-job.yaml` | Create `thanos` bucket |
| `03-objstore-secret.yaml` | S3 config for sidecar / store / compactor |
| `04-prometheus-cr-thanos.yaml` | Prometheus CR with `spec.thanos` + PVC (replaces file `10` in thanos mode) |
| `05-thanos-query.yaml` | Thanos Query HTTP `:9090` |
| `06-thanos-store-gateway.yaml` | Historical data from object storage |
| `07-thanos-compactor.yaml` | Block compaction in object storage |
| `08-grafana-datasource-thanos.yaml` | Grafana default → Thanos Query |

### Appendix B: Scripts

| Script | Purpose |
|---|---|
| `scripts/manual-stack/deploy_manual_stack.sh` | `default` or `thanos`; `PRELOAD_IMAGES=true` for podman/kind |
| `scripts/manual-stack/cleanup_manual_stack.sh` | Full teardown; `DELETE_PVCS=true` to remove Prometheus PVCs |
| `scripts/manual-stack/thanos/cleanup_thanos_stack.sh` | Remove Thanos only; re-apply default Prometheus CR |
| `scripts/manual-stack/thanos/preload_images_podman_kind.sh` | Pull/load images with podman into kind |
| `scripts/manual-stack/operator-stack/deploy_operator_stack.sh` | Deploy operator extension only |
| `scripts/manual-stack/operator-stack/check_status_web_target.sh` | Query operator Prometheus for status-web |
| `scripts/deploy_and_test_status_web.sh` | Deploy status-web against kube-prometheus-stack in `monitoring` namespace |

### Appendix C: Key PromQL queries

```promql
## Is the target healthy?
up{job="status-web"}

## Request rate by HTTP status
sum by (status) (
  rate(http_request_duration_seconds_count{job="status-web", status=~"200|400|503"}[5m])
)

## 5xx error ratio (alert rule basis)
sum(rate(http_request_duration_seconds_count{job="status-web", status=~"5.."}[5m]))
/
sum(rate(http_request_duration_seconds_count{job="status-web"}[5m]))
```

---

### The one-page summary

1. **App** exposes `/metrics` → **Discovery** (annotations or ServiceMonitor) tells Prometheus what to scrape.
2. **Prometheus** stores time series and evaluates rules → sends firing alerts to **Alertmanager**.
3. **Alertmanager** groups, routes, inhibits, and notifies → **Grafana** visualizes.
4. Plain mode = annotations on Service + ConfigMap config.
5. CR mode = ServiceMonitor + Operator generates config.
6. Debug targets before PromQL. Match port **names** in CR mode. Use label `status`, not `code`.
7. In production: group alerts, inhibit cascades, route by team/severity, alert on symptoms, keep cardinality low.
8. **Staff engineers:** size from `active_series` and ingestion rate; use PVC not `emptyDir`; 2+ Prometheus + 3 Alertmanager replicas; never copy lab RBAC (`cluster-admin`); run a 48h staging pilot before go-live.

Welcome to the team. You now have the map.

---

<a id="appendix-c"></a>

# Appendix C: Prometheus config deep dive (standalone)

> Same topics as [Part 4](#part-4); kept for direct lookup and printing.

#### Who this is for
This guide is for beginners who can see Prometheus config but do not yet understand what each section means.

Your environment:
- Kubernetes kind cluster
- kube-prometheus-stack in namespace `monitoring`
- Prometheus Operator manages Prometheus config

---

#### Index (Read in This Order)

1. Start here
- [1) Big picture first](#1-big-picture-first)
- [2) Where this config lives](#2-where-this-config-lives)

2. Core config understanding
- [3) Understand the top-level sections](#3-understand-the-top-level-sections)
- [14) kubernetes_sd_configs Roles Explained (with real examples)](#14-kubernetes_sd_configs-roles-explained-with-real-examples)
- [15) relabel_configs: In Depth](#15-relabel_configs-in-depth)

3. App scraping flow
- [4) Deep dive into one scrape job](#4-deep-dive-into-one-scrape-job)
- [13) Appendix: Your Exact status-web Job, Annotated](#13-appendix-your-exact-status-web-job-annotated)
- [8) Mapping your webapp case to config](#8-mapping-your-webapp-case-to-config)

4. Validation and troubleshooting
- [10) Quick commands reference](#10-quick-commands-reference)
- [7) How to read config without getting overwhelmed](#7-how-to-read-config-without-getting-overwhelmed)
- [9) Most common beginner mistakes](#9-most-common-beginner-mistakes)

5. Alerting and production hardening
- [16) Alertmanager Config Secret: Use Case and Fields](#16-alertmanager-config-secret-use-case-and-fields)
- [17) How Prometheus Contacts Alertmanager and How Alerts Resolve](#17-how-prometheus-contacts-alertmanager-and-how-alerts-resolve)
- [5) Why ServiceMonitor label matters](#5-why-servicemonitor-label-matters)
- [6) Why no data without ServiceMonitor](#6-why-no-data-without-servicemonitor)
- [11) Final simplified summary](#11-final-simplified-summary)

---

#### Step-by-Step Execution Path (Deploy to Test)

Follow this checklist in order.

##### Step 1: Deploy the stack and app

1. Deploy manual monitoring stack:
```bash
./scripts/manual-stack/deploy_manual_stack.sh
```
2. Confirm pods are running:
```bash
kubectl -n monitoring-manual get pods
kubectl -n default get pods -l app=status-web
```

##### Step 2: Generate traffic and verify scraping

1. Run load and query tests:
```bash
./scripts/manual-stack/test_manual_stack.sh
```
2. Validate target is up and rate query returns data.

Read now:
- [4) Deep dive into one scrape job](#4-deep-dive-into-one-scrape-job)
- [13) Appendix: Your Exact status-web Job, Annotated](#13-appendix-your-exact-status-web-job-annotated)

##### Step 3: Inspect live Prometheus config

1. Open Prometheus config from pod:
```bash
POD=$(kubectl -n monitoring-manual get pod -l app=prometheus -o jsonpath='{.items[0].metadata.name}')
kubectl -n monitoring-manual exec "$POD" -- sed -n '1,220p' /etc/prometheus/config/prometheus.yml
```
2. Compare with sections:
- [3) Understand the top-level sections](#3-understand-the-top-level-sections)
- [14) kubernetes_sd_configs Roles Explained (with real examples)](#14-kubernetes_sd_configs-roles-explained-with-real-examples)
- [15) relabel_configs: In Depth](#15-relabel_configs-in-depth)

##### Step 4: Validate alerting path end-to-end

1. Port-forward Prometheus and Alertmanager:
```bash
kubectl -n monitoring-manual port-forward svc/prometheus 9090:9090
kubectl -n monitoring-manual port-forward svc/alertmanager 9093:9093
```
2. Check active alerts:
```bash
curl -s http://127.0.0.1:9090/api/v1/alerts | python3 -m json.tool
curl -s http://127.0.0.1:9093/api/v2/alerts | python3 -m json.tool
```

Read now:
- [16) Alertmanager Config Secret: Use Case and Fields](#16-alertmanager-config-secret-use-case-and-fields)
- [17) How Prometheus Contacts Alertmanager and How Alerts Resolve](#17-how-prometheus-contacts-alertmanager-and-how-alerts-resolve)

##### Step 5: Practice routing, grouping, inhibition

Use section 17 snippets to:
1. Set `group_by: [alertname, team, namespace]`
2. Add team-based routes
3. Add inhibition rules
4. Re-test with API payload examples

Then validate with:
```bash
curl -s http://127.0.0.1:9093/api/v2/alerts | python3 -m json.tool
```

##### Step 6: Troubleshoot if anything fails

Use this order:
1. [10) Quick commands reference](#10-quick-commands-reference)
2. [9) Most common beginner mistakes](#9-most-common-beginner-mistakes)
3. [7) How to read config without getting overwhelmed](#7-how-to-read-config-without-getting-overwhelmed)

##### Step 7: Cleanup and rerun lab

```bash
./scripts/manual-stack/cleanup_manual_stack.sh
```

Rerun from Step 1 to build hands-on confidence.

---

#### 1) Big picture first

In Prometheus Operator setup, you usually do **not** hand-edit a static `prometheus.yml`.

Instead:
1. You create Kubernetes resources (Prometheus, ServiceMonitor, PodMonitor, PrometheusRule).
2. Prometheus Operator reads those resources.
3. Operator generates the effective Prometheus config.
4. Generated config is stored in a Secret and rendered into the Prometheus Pod.

So when you see a long config with many `serviceMonitor/...` jobs, that is generated output.

---

#### 2) Where this config lives

##### A) In Kubernetes Secret (generated source)
Secret name pattern:
- `prometheus-<prometheus-cr-name>`

##### B) Inside Prometheus Pod (rendered file)
File path:
- `/etc/prometheus/config_out/prometheus.env.yaml`

This is the effective runtime config that Prometheus uses.

---

#### 3) Understand the top-level sections

You shared a config structure like this:
- `global`
- `runtime`
- `alerting`
- `rule_files`
- `scrape_configs`
- `storage`
- `otlp`

Here is what each means.

##### 3.1 global
Controls default behavior for all scrape jobs unless a job overrides it.

Common fields:
- `scrape_interval`: default how often to scrape targets (for example 30s).
- `scrape_timeout`: max time per scrape before timeout.
- `evaluation_interval`: how often Prometheus evaluates alerting/recording rules.
- `external_labels`: labels automatically attached to all time series and alerts.

Why it matters:
- If `scrape_interval` is too high, graphs look sparse.
- If timeout is too low, slow endpoints may fail with scrape timeout.

###### More on `external_labels` (important in production)

`external_labels` are static labels Prometheus adds to:
- all alerts sent to Alertmanager
- outbound samples sent via remote_write

Typical labels:
- `cluster`: identifies source cluster (`prod-us-east-1`)
- `environment`: `prod`, `staging`, `dev`
- `prometheus`: logical Prometheus instance name
- `prometheus_replica`: replica identity in HA setups

Example:
```yaml
global:
  external_labels:
    cluster: prod-us-east-1
    environment: prod
    prometheus: k8s-main
    prometheus_replica: prom-0
```

Why this matters:
1. Multi-cluster querying
- Same metric name from different clusters can be separated by `cluster` label.

2. Alert routing context
- Alertmanager can route based on `cluster` or `environment` without editing every alert rule.

3. HA deduplication
- In two-replica Prometheus HA, both replicas send same alert/samples.
- `prometheus_replica` lets downstream systems deduplicate correctly.

4. Remote write attribution
- Long-term storage can identify where samples came from.

Collision behavior:
- If a label with same key already exists on a series, Prometheus does not overwrite that series label with external label in local TSDB.
- For alerts, external labels are added to alert payload unless label key already exists on alert.

Good practice:
- Keep keys stable across org (`cluster`, `environment`, `team`).
- Do not use high-cardinality values (hostnames, UUIDs, request IDs) as external labels.
- Keep `prometheus_replica` only for dedup pipelines, not dashboard filtering.

Quick verification:
```bash
### check active config
curl -s http://localhost:9090/api/v1/status/config | python3 -m json.tool

### check alert labels include external labels
curl -s http://localhost:9090/api/v1/alerts | python3 -m json.tool
```

In the alert JSON, confirm labels like `cluster` and `environment` are present.

End-to-end example (production style):

1) Prometheus config with external labels:
```yaml
global:
  scrape_interval: 30s
  evaluation_interval: 30s
  external_labels:
    cluster: prod-us-east-1
    environment: prod
    team: platform
    prometheus: monitoring-main
    prometheus_replica: prom-0
```

2) Alert rule (no cluster/environment hardcoding needed):
```yaml
groups:
- name: app-alerts
  rules:
  - alert: ApiHigh5xxRate
    expr: |
      (
        sum(rate(http_request_duration_seconds_count{job="api",status=~"5.."}[5m]))
        /
        sum(rate(http_request_duration_seconds_count{job="api"}[5m]))
      ) > 0.02
    for: 10m
    labels:
      severity: critical
    annotations:
      summary: API 5xx rate is high
      description: 5xx ratio greater than 2% for 10m
```

3) Example alert payload received by Alertmanager:
```json
{
  "labels": {
    "alertname": "ApiHigh5xxRate",
    "severity": "critical",
    "job": "api",
    "cluster": "prod-us-east-1",
    "environment": "prod",
    "team": "platform",
    "prometheus": "monitoring-main",
    "prometheus_replica": "prom-0"
  },
  "annotations": {
    "summary": "API 5xx rate is high",
    "description": "5xx ratio greater than 2% for 10m"
  }
}
```

4) Alertmanager routing using those labels:
```yaml
route:
  receiver: default
  group_by: [alertname, cluster, environment, team]
  routes:
  - match:
      environment: prod
      severity: critical
    receiver: pagerduty-prod
  - match:
      environment: prod
      severity: warning
    receiver: slack-prod-warning
```

Result: one alert rule works across environments, and routing is controlled by stable external labels.

##### 3.2 runtime
Runtime tuning for Prometheus process itself.

Example:
- `gogc: 75` controls Go GC aggressiveness.

Usually advanced tuning; most users leave defaults unless troubleshooting memory/CPU.

##### 3.3 alerting
Defines where alerts are sent and how alert labels are relabeled.

Key parts:
- `alertmanagers`: where Prometheus sends firing alerts.
- `alert_relabel_configs`: modify alert labels before sending.

In your config, Alertmanager discovery uses Kubernetes endpoints in namespace `monitoring`.

##### 3.4 rule_files
Paths to rule files loaded by Prometheus.

These include:
- Recording rules (precompute expressions)
- Alerting rules (fire alerts when conditions match)

Operator mounts these files into the Pod.

##### 3.5 scrape_configs
Most important section for target scraping.

Each entry is one job.
Examples from your config:
- `serviceMonitor/monitoring/kube-prom-grafana/0`
- `serviceMonitor/monitoring/kube-prom-kube-prometheus-alertmanager/0`
- `serviceMonitor/monitoring/status-web/0`

This section tells Prometheus:
- where to discover targets
- which targets to keep/drop
- which endpoint path/scheme/port to use
- how to relabel metadata into metric labels

##### 3.6 storage
TSDB retention and storage behavior.

Example:
- `retention.time: 1w` means keep 1 week of data.

##### 3.7 otlp
OpenTelemetry ingestion translation behavior.

If you are not pushing OTLP into Prometheus, this is usually not your day-1 concern.

---

#### 4) Deep dive into one scrape job

Use this mental model on any job:

##### 4.1 job_name
Example:
- `serviceMonitor/monitoring/status-web/0`

Meaning:
- generated from ServiceMonitor named `status-web` in namespace `monitoring`
- `/0` is endpoint index in ServiceMonitor endpoints list

##### 4.2 scrape interval/timeout at job level
If present here, these override global defaults.

In your status-web job, interval is set from ServiceMonitor endpoint (`15s`).

##### 4.3 metrics_path and scheme
- `metrics_path: /metrics`
- `scheme: http` or `https`

These map directly to endpoint config and target protocol.

##### 4.4 kubernetes_sd_configs
Defines Kubernetes service discovery source.

Example:
- `role: endpoints`
- namespace list controls where discovery happens (`default`, `monitoring`, etc).

This means Prometheus asks Kubernetes API for endpoint objects and then filters.

##### 4.5 relabel_configs
This is the most confusing but most powerful part.

Think of relabeling as a target filter and label mapper pipeline.

Typical relabel actions in your config:
- keep only matching services by labels
- keep only matching endpoint port names
- map kubernetes metadata to labels like `namespace`, `service`, `pod`, `container`
- drop pods in terminal phase (`Failed|Succeeded`)
- set final `job` and `endpoint` labels

If a keep rule does not match, target is dropped.
That is often why people see no data.

##### 4.6 metric_relabel_configs
Applied after scraping, on each sample.

Used to:
- drop noisy metrics
- reduce cardinality
- keep only selected metrics

In your config, some kubelet jobs drop many high-volume metrics to reduce storage pressure.

---

#### 5) Why ServiceMonitor label matters

You asked why `release: kube-prom` mattered.

Because Prometheus CR has selector:
- `spec.serviceMonitorSelector.matchLabels.release = kube-prom`

Meaning:
- Operator only includes ServiceMonitors with that label.
- Included ServiceMonitors become generated jobs in `scrape_configs`.

That is exactly why your `status-web` job appeared only after adding matching label.

---

#### 6) Why no data without ServiceMonitor

Without matching ServiceMonitor:
- no generated `serviceMonitor/.../status-web/...` scrape job
- Prometheus has no instruction to scrape your app
- query returns empty even if app responds 200/400/503

With matching ServiceMonitor:
- job appears in `scrape_configs`
- target appears in Targets UI and becomes UP
- metrics become queryable

---

#### 7) How to read config without getting overwhelmed

Use this order every time:

1. Find top-level `global` to know defaults.
2. Find your job in `scrape_configs` by name.
3. Verify `metrics_path`, `scheme`, `scrape_interval`.
4. Verify `kubernetes_sd_configs` namespace and role.
5. Read relabel rules in order; check keep/drop conditions.
6. Confirm target status in Prometheus Targets page.
7. Then debug PromQL labels (`job`, `namespace`, `service`, `status`).

---

#### 8) Mapping your webapp case to config

Your app:
- Service name: `status-web`
- Namespace: `default`
- Metrics: `/metrics` on port `http` (9898)

Your generated job:
- `job_name: serviceMonitor/monitoring/status-web/0`
- discovery from namespace `default`
- relabels set labels such as `namespace=default`, `service=status-web`

Metric for status codes in podinfo:
- `http_request_duration_seconds_count`
- label key `status`

Good PromQL:
- `sum by (status) (rate(http_request_duration_seconds_count{job="status-web",status=~"200|400|503"}[5m]))`

---

#### 9) Most common beginner mistakes

1. Wrong ServiceMonitor label (not selected by Prometheus CR).
2. Wrong ServiceMonitor namespace.
3. Wrong service label selector in ServiceMonitor.
4. Wrong endpoint port name (must match Service port name, not container port number).
5. Querying wrong metric name or wrong label key (`code` vs `status`).
6. Looking at PromQL before first successful scrapes.

---

#### 10) Quick commands reference

##### Show Prometheus selector (which ServiceMonitors are accepted)

```bash
kubectl -n monitoring get prometheus -o jsonpath='{.items[0].spec.serviceMonitorSelector.matchLabels}'
```

##### Show generated config from Secret

```bash
PROM=$(kubectl -n monitoring get prometheus -o jsonpath='{.items[0].metadata.name}')
kubectl -n monitoring get secret "prometheus-${PROM}" -o jsonpath='{.data.prometheus\.yaml\.gz}' \
| openssl base64 -d -A | gunzip -c
```

##### Show rendered config inside Pod

```bash
POD=$(kubectl -n monitoring get pod -l app.kubernetes.io/name=prometheus -o jsonpath='{.items[0].metadata.name}')
kubectl -n monitoring exec "$POD" -c config-reloader -- sed -n '1,120p' /etc/prometheus/config_out/prometheus.env.yaml
```

##### Find your job quickly

```bash
kubectl -n monitoring exec "$POD" -c config-reloader -- \
  grep -n 'job_name: serviceMonitor/monitoring/status-web/0' /etc/prometheus/config_out/prometheus.env.yaml
```

---

#### 11) Final simplified summary

- Prometheus Operator builds config for you.
- `scrape_configs` is where target scraping rules live.
- ServiceMonitor creates those scrape jobs.
- Label selectors decide whether a ServiceMonitor is included.
- If job exists and target is UP, your PromQL should work.

---

#### 12) Regex and Relabeling: In and Out

This section explains the regex rules you see in `relabel_configs` and `metric_relabel_configs`.

##### 12.1 Why regex appears everywhere

Prometheus Kubernetes discovery gives many metadata labels like:
- `__meta_kubernetes_service_label_*`
- `__meta_kubernetes_endpoint_port_name`
- `__meta_kubernetes_namespace`

Relabel rules use regex to:
- keep only desired targets
- drop unwanted targets
- extract values from metadata
- rewrite labels (`job`, `namespace`, `pod`, etc.)

---

##### 12.2 Core relabel actions and exact meaning

###### action: keep

Meaning:
- Keep target only if regex matches source labels.
- If no match, target is dropped.

Example from your config:

```yaml
- action: keep
  source_labels:
  - __meta_kubernetes_service_label_release
  - __meta_kubernetes_service_labelpresent_release
  regex: (kube-prom);true
```

How to read:
- Join source labels with `separator: ;` (default is `;`), so value becomes like `kube-prom;true`.
- Keep only if service label `release` exists and equals `kube-prom`.

###### action: drop

Meaning:
- Drop target/sample if regex matches.

Example:

```yaml
- action: drop
  source_labels:
  - __meta_kubernetes_pod_phase
  regex: (Failed|Succeeded)
```

How to read:
- Ignore completed/failed pods from scraping.

###### action: replace

Meaning:
- Set `target_label` using regex capture groups.

Example:

```yaml
- source_labels:
  - __meta_kubernetes_service_name
  target_label: job
  replacement: ${1}
```

Usually paired with a regex that captures value into group 1.

Another common one from your config:

```yaml
- source_labels:
  - __meta_kubernetes_endpoint_address_target_kind
  - __meta_kubernetes_endpoint_address_target_name
  regex: Pod;(.*)
  replacement: ${1}
  target_label: pod
```

How to read:
- Input like `Pod;status-web-xxxxx` => set `pod=status-web-xxxxx`.

###### action: hashmod

Meaning:
- Hash label value and take modulus.
- Used for sharding targets across Prometheus replicas.

Example:

```yaml
- source_labels:
  - __tmp_hash
  modulus: 1
  target_label: __tmp_hash
  action: hashmod
```

With modulus 1, all hashes become 0 (single shard setup).

---

##### 12.3 Regex building blocks you will see

###### (value)
Capturing group 1.

Example:
- `regex: (kube-prom);true`

###### (a|b|c)
Alternation (OR).

Example:
- `regex: (Failed|Succeeded)`

###### (.*)
Capture any text.

Example:
- `regex: Pod;(.*)` captures pod name.

###### .+
One or more characters.

Example:
- `regex: (.+)` means value must be non-empty.

###### Anchoring behavior
Prometheus relabel regex is matched against full concatenated value for relabel processing.
In practice, write explicit patterns as if full value should match.

---

##### 12.4 labelpresent pattern: why two source labels are used

Pattern in your config:

```yaml
source_labels:
- __meta_kubernetes_service_label_release
- __meta_kubernetes_service_labelpresent_release
regex: (kube-prom);true
```

Why this is used:
- first label gives actual value (`kube-prom`)
- second label indicates existence (`true`/`false`)

This prevents accidental matches when label is missing.

---

##### 12.5 separator and concatenation

When multiple `source_labels` are used:
- Values are joined by `separator` (default `;`).

So with:
- value1 = `kube-prom`
- value2 = `true`

Input to regex becomes:
- `kube-prom;true`

That is why many regex patterns in your file include a semicolon.

---

##### 12.6 ${1} and $1 replacement

Both represent captured group 1 depending on context/style generated.

Examples from generated configs:
- `replacement: ${1}`
- `replacement: $1`

Both mean: substitute first regex capture group.

---

##### 12.7 SHARD placeholder you see in generated config

You may see:

```yaml
regex: $(SHARD);|.+;.+
```

Meaning:
- This is templated by operator for shard logic.
- Combined with `hashmod`, it keeps only targets for this Prometheus shard.
- In single replica/single shard setups, effectively all intended targets are kept.

Do not manually edit this in generated config; it is operator-managed.

---

##### 12.8 Reading one keep rule end to end

Rule:

```yaml
- action: keep
  source_labels:
  - __meta_kubernetes_endpoint_port_name
  regex: http
```

Interpretation:
1. Read endpoint port name from Kubernetes metadata.
2. Keep only endpoints whose port name is exactly `http`.
3. If service exposes only `metrics` port name but rule expects `http`, target is dropped.

This is a common cause of missing targets.

---

##### 12.9 metric_relabel regex (post-scrape)

Example style from your kubelet jobs:

```yaml
- source_labels: [__name__]
  regex: container_spec.*
  action: drop
```

Meaning:
- scrape succeeds
- then samples with metric names matching `container_spec.*` are removed
- helps reduce cardinality/storage

Important:
- `relabel_configs` filters targets before scrape
- `metric_relabel_configs` filters samples after scrape

---

##### 12.10 Regex troubleshooting checklist

If a target is missing, verify in this order:

1. ServiceMonitor label matches Prometheus selector.
2. Service labels match ServiceMonitor selector.
3. Endpoint `port` name matches relabel keep rule.
4. Namespace in discovery block includes your namespace.
5. Keep/drop regex does not exclude your target.

If metrics are missing but target is UP:

1. Check metric name exists.
2. Check label key (`status` vs `code`).
3. Check metric_relabel rules are not dropping the metric.

---

##### 12.11 Safe rule of thumb for beginners

- Treat generated regex blocks as read-only output.
- Make changes in ServiceMonitor/PodMonitor/Prometheus spec, not in generated file.
- After change, verify generated job appears and target is UP.

---

#### 13) Appendix: Your Exact status-web Job, Annotated

Below is the live block captured from your running Prometheus rendered config.

```yaml
- job_name: serviceMonitor/monitoring/status-web/0
  honor_labels: false
  kubernetes_sd_configs:
  - role: endpoints
    namespaces:
      names:
      - default
  scrape_interval: 15s
  metrics_path: /metrics
  relabel_configs:
  - source_labels:
    - job
    target_label: __tmp_prometheus_job_name
  - action: keep
    source_labels:
    - __meta_kubernetes_service_label_app
    - __meta_kubernetes_service_labelpresent_app
    regex: (status-web);true
  - action: keep
    source_labels:
    - __meta_kubernetes_endpoint_port_name
    regex: http
  - source_labels:
    - __meta_kubernetes_endpoint_address_target_kind
    - __meta_kubernetes_endpoint_address_target_name
    separator: ;
    regex: Node;(.*)
    replacement: ${1}
    target_label: node
  - source_labels:
    - __meta_kubernetes_endpoint_address_target_kind
    - __meta_kubernetes_endpoint_address_target_name
    separator: ;
    regex: Pod;(.*)
    replacement: ${1}
    target_label: pod
  - source_labels:
    - __meta_kubernetes_namespace
    target_label: namespace
  - source_labels:
    - __meta_kubernetes_service_name
    target_label: service
  - source_labels:
    - __meta_kubernetes_pod_name
    target_label: pod
  - source_labels:
    - __meta_kubernetes_pod_container_name
    target_label: container
  - action: drop
    source_labels:
    - __meta_kubernetes_pod_phase
    regex: (Failed|Succeeded)
  - source_labels:
    - __meta_kubernetes_service_name
    target_label: job
    replacement: ${1}
  - target_label: endpoint
    replacement: http
  - source_labels:
    - __address__
    - __tmp_hash
    target_label: __tmp_hash
    regex: (.+);
    replacement: $1
    action: replace
  - source_labels:
    - __tmp_hash
    target_label: __tmp_hash
    modulus: 1
    action: hashmod
  - source_labels:
    - __tmp_hash
    - __tmp_disable_sharding
    regex: 0;|.+;.+
    action: keep
```

##### 13.1 Line-by-line meaning

1. `job_name: serviceMonitor/monitoring/status-web/0`
- Generated from ServiceMonitor named `status-web` in namespace `monitoring`.
- `/0` means first endpoint entry in that ServiceMonitor.

2. `honor_labels: false`
- If scraped metrics already have labels that conflict with target labels, Prometheus target labels win.

3. `kubernetes_sd_configs -> role: endpoints`
- Discover Kubernetes Endpoints objects.
- Prometheus starts with all endpoint candidates, then relabel rules filter.

4. `namespaces -> default`
- Only discover endpoints in namespace `default` for this job.

5. `scrape_interval: 15s`
- Scrape this target every 15 seconds.
- This came from ServiceMonitor endpoint interval.

6. `metrics_path: /metrics`
- HTTP path used for scraping.

7. First relabel: copy original `job` to temp label
- `__tmp_prometheus_job_name` stores previous value as internal working data.

8. Keep rule with `regex: (status-web);true`
- Requires service label `app=status-web` and confirms label exists.
- If not matched, target is dropped.

9. Keep rule with `regex: http`
- Keeps only endpoint port name exactly `http`.
- If your Service port name is different, scrape target disappears.

10. Node extraction rule `regex: Node;(.*)`
- If endpoint target kind is Node, capture node name into label `node`.

11. Pod extraction rule `regex: Pod;(.*)`
- If endpoint target kind is Pod, capture pod name into label `pod`.

12. Namespace mapping rule
- Copies Kubernetes namespace metadata into final label `namespace`.

13. Service mapping rule
- Copies service name into final label `service`.

14. Pod mapping rule
- Copies pod name into final label `pod`.

15. Container mapping rule
- Copies container name into final label `container`.

16. Drop terminal pod phases
- `regex: (Failed|Succeeded)` drops non-running lifecycle pods from scrape.

17. Set `job` label from service name
- Rewrites `job` to service name, usually becoming `status-web`.

18. Set endpoint label
- Adds `endpoint=http` for filtering/graphing.

19. Internal hash prepare rule
- Builds `__tmp_hash` value used for sharding logic.

20. `hashmod` rule with modulus 1
- Hash result modulo 1 is always 0 (single shard behavior).

21. Final shard keep rule `regex: 0;|.+;.+`
- Keeps target for this shard when sharding condition matches.
- In your setup, target is kept.

##### 13.2 Practical consequences for debugging

- If ServiceMonitor is correct but Service port name is not `http`, target drops at step 9.
- If Service label `app` is not `status-web`, target drops at step 8.
- If target is UP but query empty, issue is likely metric name/label query, not discovery.

##### 13.3 What to edit and what not to edit

- Do edit: ServiceMonitor labels/selectors/endpoints.
- Do edit: Service labels and port names.
- Do not edit: generated relabel block inside runtime config file.

Generated file is output; source of truth is Kubernetes CRDs and Helm values.

---

#### 14) kubernetes_sd_configs Roles Explained (with real examples)

You asked about this block:

```yaml
- job_name: kubernetes-service-endpoints
  kubernetes_sd_configs:
  - role: endpoints
```

Meaning:
- `job_name` is just the scrape job label/name.
- `kubernetes_sd_configs` tells Prometheus to discover targets from Kubernetes API.
- `role: endpoints` means discover endpoint addresses behind Services.

##### 14.1 Common Kubernetes SD roles

###### role: endpoints
- Discovers Endpoints objects (service backends).
- Best when scraping through Services.
- Common for service-level monitoring.

Typical use:
```yaml
- job_name: kubernetes-service-endpoints
  kubernetes_sd_configs:
  - role: endpoints
```

Pros:
- Stable service-based discovery.
- Works well with Service annotations and ServiceMonitor-like patterns.

###### role: pod
- Discovers pods directly.
- Good when scraping pod endpoints not exposed via Service.
- Often used with pod annotations or PodMonitor-like behavior.

Typical use:
```yaml
- job_name: kubernetes-pods
  kubernetes_sd_configs:
  - role: pod
```

Pros:
- Fine-grained per-pod control.

Trade-off:
- More target churn as pods restart frequently.

###### role: service
- Discovers Services as targets (service DNS/cluster IP model).
- Less common for app metrics than `endpoints`.
- Useful for service-level blackbox style checks.

Typical use:
```yaml
- job_name: kubernetes-services
  kubernetes_sd_configs:
  - role: service
```

###### role: endpointslice
- Discovers EndpointSlice resources (newer scalable replacement for Endpoints).
- Better scalability in large clusters.

Typical use:
```yaml
- job_name: kubernetes-endpointslice
  kubernetes_sd_configs:
  - role: endpointslice
```

###### role: node
- Discovers cluster nodes.
- Useful for kubelet/node-exporter style scraping.

Typical use:
```yaml
- job_name: kubernetes-nodes
  kubernetes_sd_configs:
  - role: node
```

###### role: ingress
- Discovers Ingress resources.
- Usually used with blackbox probing rather than direct app metrics scraping.

Typical use:
```yaml
- job_name: kubernetes-ingress
  kubernetes_sd_configs:
  - role: ingress
```

##### 14.2 Which role to use for your app

For your current app monitoring lab:
- Use `role: endpoints` if you scrape via Kubernetes Service.
- Use `role: pod` only when you intentionally want pod-direct scraping.

Since your app is exposed with Service `status-web`, `endpoints` is the right choice.

##### 14.3 Quick decision matrix

- Service-based scraping with stable port name: `endpoints`
- Pod-level scraping with pod annotations: `pod`
- Node metrics: `node`
- Large clusters with EndpointSlice adoption: `endpointslice`
- Ingress/URL probing workflows: `ingress`

##### 14.4 Important follow-up

Role only decides discovery source. You still need `relabel_configs` to:
- keep only the right targets
- set labels (`job`, `namespace`, `service`, `pod`)
- drop noisy or invalid targets

So `role: endpoints` is step 1 (discover), relabeling is step 2 (select and shape).

---

#### 15) relabel_configs: In Depth

##### 15.1 What is relabel_configs?

After Prometheus discovers targets from Kubernetes (using `kubernetes_sd_configs`), every discovered target carries a large set of temporary metadata labels that start with `__meta_`.

`relabel_configs` is a pipeline of rules that:
1. Reads those `__meta_*` labels.
2. Filters targets (keep/drop).
3. Transforms labels (rename, extract, rewrite).
4. Produces the final set of labels attached to all scraped metrics.

If relabeling drops a target, Prometheus never scrapes it.

---

##### 15.2 Pipeline model (sequential, not parallel)

Rules are applied top to bottom, one at a time.

```
discovered target
  → rule 1 (runs on current labels)
  → rule 2 (runs on result of rule 1)
  → rule 3 (runs on result of rule 2)
  → ...
  → final target labels OR dropped
```

If any keep rule does not match, target is dropped immediately and remaining rules do not run.

---

##### 15.3 Every available action

###### action: keep
Keep target only when regex matches joined source labels.  
If no match: target dropped.

```yaml
- action: keep
  source_labels: [__meta_kubernetes_service_annotation_prometheus_io_scrape]
  regex: true
```

Meaning: only keep targets where the annotation `prometheus.io/scrape` equals `true`.

---

###### action: drop
Drop target when regex matches.  
If match: target dropped.

```yaml
- action: drop
  source_labels: [__meta_kubernetes_pod_phase]
  regex: (Failed|Succeeded)
```

Meaning: drop completed/terminated pods.

---

###### action: replace
Read source labels, apply regex, write capture group into target label.  
Default action when action is omitted.

```yaml
- source_labels: [__meta_kubernetes_namespace]
  target_label: namespace
```

Meaning: copy namespace metadata into final `namespace` label on every metric.

With regex and capture group:

```yaml
- source_labels: [__address__, __meta_kubernetes_service_annotation_prometheus_io_port]
  regex: ([^:]+)(?::\d+)?;(\d+)
  replacement: $1:$2
  target_label: __address__
```

Meaning: rewrite scrape target address to use port from annotation instead of default.

---

###### action: labelmap
Copy labels matching regex to new label names based on replacement pattern.

```yaml
- action: labelmap
  regex: __meta_kubernetes_service_label_(.+)
```

Meaning: copy all service labels from metadata into metric labels. For example, `__meta_kubernetes_service_label_app` becomes `app`.

---

###### action: labeldrop
Remove labels matching regex from final label set.

```yaml
- action: labeldrop
  regex: (prometheus_replica)
```

Meaning: remove `prometheus_replica` label before storing/alerting.  
Seen in your Alertmanager alert_relabel_configs.

---

###### action: labelkeep
Keep only labels matching regex, drop all others.

```yaml
- action: labelkeep
  regex: (job|namespace|service|status)
```

Meaning: strip all labels except the ones listed.

---

###### action: hashmod
Hash source label values and compute modulus.  
Used for sharding targets across Prometheus replicas.

```yaml
- source_labels: [__address__]
  modulus: 3
  target_label: __tmp_hash
  action: hashmod
```

Meaning: assign each target to one of 3 shards based on hash of address.

---

##### 15.4 Special internal labels

These are written by Prometheus relabeling engine itself:

| Label | Meaning |
|---|---|
| `__address__` | target host:port used for scraping |
| `__metrics_path__` | metrics path (default /metrics) |
| `__scheme__` | http or https |
| `__param_<name>` | URL query params passed to scrape |
| `__tmp_*` | temporary working labels, not stored in final metrics |

Example of rewriting the scrape address:

```yaml
- source_labels: [__address__, __meta_kubernetes_service_annotation_prometheus_io_port]
  regex: ([^:]+)(?::\d+)?;(\d+)
  replacement: $1:$2
  target_label: __address__
```

This rewrites `10.0.0.5:80` into `10.0.0.5:9898` using port annotation value.

---

##### 15.5 Available __meta_* labels per role

When using `role: endpoints`:

| Label | Value |
|---|---|
| `__meta_kubernetes_namespace` | namespace of the endpoint |
| `__meta_kubernetes_service_name` | service name |
| `__meta_kubernetes_endpoint_port_name` | port name from Service spec |
| `__meta_kubernetes_endpoint_port_protocol` | TCP or UDP |
| `__meta_kubernetes_endpoint_address_target_kind` | Node or Pod |
| `__meta_kubernetes_endpoint_address_target_name` | pod or node name |
| `__meta_kubernetes_service_label_<labelname>` | any service label |
| `__meta_kubernetes_service_annotation_<annotationname>` | any service annotation |
| `__meta_kubernetes_pod_name` | pod name backing this endpoint |
| `__meta_kubernetes_pod_label_<labelname>` | any pod label |

When using `role: pod`:

| Label | Value |
|---|---|
| `__meta_kubernetes_pod_name` | pod name |
| `__meta_kubernetes_pod_namespace` | namespace |
| `__meta_kubernetes_pod_label_<labelname>` | pod labels |
| `__meta_kubernetes_pod_annotation_<annotationname>` | pod annotations |
| `__meta_kubernetes_pod_container_name` | container name |
| `__meta_kubernetes_pod_container_port_name` | container port name |
| `__meta_kubernetes_pod_ip` | pod IP |
| `__meta_kubernetes_pod_phase` | Running/Pending/Failed/Succeeded |

When using `role: node`:

| Label | Value |
|---|---|
| `__meta_kubernetes_node_name` | node name |
| `__meta_kubernetes_node_label_<labelname>` | node labels |
| `__meta_kubernetes_node_annotation_<annotationname>` | node annotations |
| `__meta_kubernetes_node_address_InternalIP` | node internal IP |

---

##### 15.6 Your exact config relabeling pipeline explained (manual stack)

From your [manifests/manual-stack/02-prometheus-config.yaml](manifests/manual-stack/02-prometheus-config.yaml):

```yaml
- job_name: kubernetes-service-endpoints
  kubernetes_sd_configs:
  - role: endpoints
  relabel_configs:
  - source_labels: [__meta_kubernetes_service_annotation_prometheus_io_scrape]
    action: keep
    regex: true
  - source_labels: [__meta_kubernetes_service_annotation_prometheus_io_path]
    action: replace
    target_label: __metrics_path__
    regex: (.+)
  - source_labels: [__address__, __meta_kubernetes_service_annotation_prometheus_io_port]
    action: replace
    target_label: __address__
    regex: ([^:]+)(?::\d+)?;(\d+)
    replacement: $1:$2
  - source_labels: [__meta_kubernetes_namespace]
    target_label: namespace
  - source_labels: [__meta_kubernetes_service_name]
    target_label: service
  - source_labels: [__meta_kubernetes_service_name]
    target_label: job
```

Step by step:

1. Rule 1 (keep): Only scrape services where annotation `prometheus.io/scrape=true` is set. Everything else is dropped.
2. Rule 2 (replace): If service has annotation `prometheus.io/path`, rewrite `__metrics_path__` to that value. Otherwise defaults to `/metrics`.
3. Rule 3 (replace): Rewrite scrape address to use port from annotation `prometheus.io/port`. This overrides any default service port.
4. Rule 4 (replace): Copy namespace metadata into final `namespace` label on metrics.
5. Rule 5 (replace): Copy service name into final `service` label.
6. Rule 6 (replace): Copy service name into final `job` label.

Result of this pipeline for your status-web service:
- Scrapes `10.x.x.x:9898/metrics`
- Attaches labels: `job=status-web`, `service=status-web`, `namespace=default`

---

##### 15.7 Common mistakes with relabel_configs

1. Wrong source label name
- `__meta_kubernetes_service_annotation_prometheus_io_scrape` is the correct key.
- Annotation `prometheus.io/scrape` maps to label name with dots replaced by underscores and slash replaced by underscore.
- So `prometheus.io/scrape` becomes `prometheus_io_scrape` in the key suffix.

2. Missing keep rule matching
- If annotation is absent or value is not exact `true`, target is dropped at rule 1.
- Changing annotation to `yes` or `1` breaks discovery.

3. Address rewrite regex mismatch
- Regex `([^:]+)(?::\d+)?;(\d+)` expects two source labels joined by `;`.
- `$1` is the host part of address, `$2` is the port from annotation.
- If annotation is missing, second part is empty and rewrite may fail.

4. Wrong target_label name
- Writing to `__address__` changes scrape target.
- Writing to `__metrics_path__` changes scrape path.
- Writing to anything else just adds a label to metrics.

---

#### 16) Alertmanager Config Secret: Use Case and Fields

##### 16.1 Why a Secret, not a ConfigMap?

Alertmanager config frequently contains sensitive credentials:
- Slack webhook URLs
- PagerDuty API keys
- Email SMTP passwords
- OpsGenie tokens

So it is stored as a Kubernetes Secret (base64-encoded, RBAC-restricted) instead of a plain ConfigMap.

##### 16.2 How it is mounted into the Alertmanager pod

In `manifests/manual-stack/05-alertmanager.yaml`:

```yaml
volumes:
- name: config
  secret:
    secretName: alertmanager-config
```

Kubernetes mounts the Secret as a file at:
- `/etc/alertmanager/alertmanager.yml`

Alertmanager reads that file at startup.

##### 16.3 Each field explained

```yaml
global:
  resolve_timeout: 5m
```
When a firing alert stops firing, Alertmanager waits 5 minutes before sending a "resolved" notification.

```yaml
route:
  receiver: default-receiver
  group_wait: 30s
  group_interval: 5m
  repeat_interval: 3h
```

- `group_wait`: when a new alert fires, wait 30s before sending the first notification.  
  Gives time for related alerts to arrive so they can be grouped into one notification.
- `group_interval`: after sending the first notification for a group, wait 5m before sending again if new alerts join the same group.
- `repeat_interval`: if an alert keeps firing with no change, re-send notification every 3h.

```yaml
receivers:
- name: default-receiver
```
- This is a no-op receiver used for the lab (no real notification target).
- In production you would add Slack/PagerDuty/email config here.

##### 16.4 Production example with Slack receiver

```yaml
receivers:
- name: default-receiver
  slack_configs:
  - api_url: https://hooks.slack.com/services/xxx/yyy/zzz
    channel: '#alerts'
    title: '{{ .GroupLabels.alertname }}'
    text: '{{ range .Alerts }}{{ .Annotations.description }}{{ end }}'
```

This is why Alertmanager config is a Secret: the webhook URL is sensitive and should not be in a plain ConfigMap.

##### 16.5 Routing tree (production pattern)

In larger setups, routes can be nested by team/severity:

```yaml
route:
  receiver: default-receiver
  group_by: [alertname, namespace]
  routes:
  - match:
      severity: critical
    receiver: pagerduty-receiver
  - match:
      team: payments
    receiver: slack-payments
receivers:
- name: default-receiver
- name: pagerduty-receiver
  pagerduty_configs:
  - routing_key: <your-pagerduty-key>
- name: slack-payments
  slack_configs:
  - api_url: https://hooks.slack.com/services/xxx/yyy/zzz
    channel: '#payments-alerts'
```

This routes:
- `severity=critical` alerts to PagerDuty.
- `team=payments` alerts to a Slack channel.
- Everything else to default.

---

#### 17) How Prometheus Contacts Alertmanager and How Alerts Resolve

##### 17.1 Full alert lifecycle flow

```
Prometheus evaluates rule every evaluation_interval (30s)
  → expression becomes true
  → alert state = PENDING (if for: duration set)
  → after for: duration passes, state = FIRING
  → Prometheus POSTs alert payload to Alertmanager POST /api/v2/alerts

Alertmanager receives alert
  → groups it with other alerts sharing same group_by labels
  → waits group_wait (30s) for more alerts to join same group
  → sends ONE grouped notification to matched receiver

While alert stays FIRING:
  → Prometheus re-sends alert to Alertmanager every ~60s
  → Alertmanager re-notifies every repeat_interval (e.g. 3h)

Expression becomes false:
  → Prometheus sends RESOLVED flag to Alertmanager
  → Alertmanager waits resolve_timeout (5m)
  → sends "resolved" notification to receiver
```

##### 17.2 How Prometheus knows where Alertmanager is

In `prometheus.yml`, the `alerting` block defines Alertmanager discovery.

Static (hard-coded, fragile):
```yaml
alerting:
  alertmanagers:
  - static_configs:
    - targets:
      - alertmanager.monitoring-manual.svc:9093
```

Dynamic (Kubernetes service discovery, production-safe):
```yaml
alerting:
  alertmanagers:
  - kubernetes_sd_configs:
    - role: endpoints
      namespaces:
        names:
        - monitoring-manual
    relabel_configs:
    - action: keep
      source_labels: [__meta_kubernetes_service_name]
      regex: alertmanager
    - action: keep
      source_labels: [__meta_kubernetes_endpoint_port_name]
      regex: http
    api_version: v2
```

Why dynamic is better:
- Alertmanager pod IP can change after restart.
- Dynamic discovery follows the pod automatically.
- No config file edit required when Alertmanager moves.

##### 17.3 The `for:` duration and PENDING state

```yaml
- alert: StatusWebTargetDown
  expr: up{job="status-web"} == 0
  for: 5m
```

- When expression first becomes true, alert enters `PENDING`.
- It stays in PENDING for 5 minutes.
- Only after 5 continuous minutes does it become `FIRING` and notification is sent.

Why this matters:
- Prevents false alarms for transient flaps.
- A pod restart that takes 30s would not trigger the alert.
- A real outage lasting 5+ minutes will trigger it.

##### 17.4 The 100-alerts scenario: grouping behavior

Suppose your system fires 100 alerts at once, all with the same `alertname` and `namespace`.

Without grouping:
- Alertmanager sends 100 separate notifications.
- On-call engineer wakes up to 100 pages.
- Alert fatigue begins immediately.

With grouping (how Alertmanager works by default):
```yaml
route:
  group_by: [alertname, namespace]
  group_wait: 30s
  group_interval: 5m
  repeat_interval: 3h
```

What happens:
1. All 100 alerts arrive within seconds of each other.
2. Alertmanager groups them into one group because they share `alertname` and `namespace`.
3. Alertmanager waits `group_wait: 30s` for more alerts to join.
4. Sends **one notification** summarizing all 100 alerts in the group.

So yes, 100 alerts = 1 notification (assuming same group labels).

##### 17.5 What happens after 3 hours if alerts are still active

```
T+0m   → 100 alerts fire → grouped → 1 notification sent
T+30m  → 20 more alerts join same group → group_interval (5m) passes → 1 more notification
T+3h   → all 100 still firing → repeat_interval fires → 1 reminder notification
T+6h   → still firing → 1 more reminder
```

So you still get notified, but as a single grouped reminder every 3h rather than 100 individual pages.

##### 17.6 How resolution works for a group

When alerts start resolving:
- If all 100 alerts resolve → one "resolved" notification sent after `resolve_timeout`.
- If 50 resolve, 50 still fire → Alertmanager updates the group, sends one notification with the current state.

Prometheus sends a `resolved` flag per alert individually to Alertmanager.  
Alertmanager tracks which alerts in the group are still active.

##### 17.7 Reducing alert fatigue: production strategies

###### Strategy 1: Correct group_by labels

Group by meaningful dimensions, not too narrow and not too wide.

Too narrow (causes alert storm):
```yaml
group_by: [alertname, namespace, pod]
```
Each pod generates its own group → separate notification per pod.

Better for multi-pod outage:
```yaml
group_by: [alertname, namespace]
```
All pods in same namespace grouped → one notification.

###### Strategy 2: Tune group_wait for burst tolerance

```yaml
group_wait: 60s
```
Give Alertmanager 60s to collect all alerts from a cascading failure before sending.  
Reduces initial burst of notifications during mass outage.

###### Strategy 3: Increase repeat_interval for non-critical alerts

```yaml
routes:
- match:
    severity: warning
  repeat_interval: 12h
- match:
    severity: critical
  repeat_interval: 1h
```

Warning alerts do not need hourly reminders.  
Critical alerts should remind every hour until resolved.

###### Strategy 4: Use inhibition rules

Suppress child alerts when parent alert is already firing.

Example: if a node is down, suppress all pod alerts on that node:
```yaml
inhibit_rules:
- source_match:
    alertname: NodeDown
  target_match_re:
    alertname: (PodCrashLooping|TargetDown)
  equal: [node]
```

Effect: if NodeDown fires, all PodCrashLooping/TargetDown alerts for same node are silenced.  
On-call sees 1 alert (NodeDown) not 50 (NodeDown + 49 pod alerts).

###### Strategy 5: Silence during maintenance

Alertmanager supports silences via UI or API:
```bash
### silence all alerts for status-web for 2 hours
amtool silence add --alertmanager.url=http://alertmanager:9093 \
  job=status-web --duration=2h --comment="planned maintenance"
```

###### Strategy 6: Alert on symptoms not causes

Bad (too many alerts, all overlapping):
- Alert on pod restart
- Alert on container OOM
- Alert on high CPU
- Alert on disk full
- Alert on slow DB

Better (alert on user-visible impact):
- Alert on high 5xx rate (user-facing symptom)
- Alert on latency p99 above SLO threshold

This cuts alert volume from 20+ to 2-3 meaningful signals.

##### 17.8 Production recommended route config

```yaml
route:
  receiver: default-receiver
  group_by: [alertname, namespace]
  group_wait: 60s
  group_interval: 5m
  repeat_interval: 4h
  routes:
  - match:
      severity: critical
    receiver: pagerduty-receiver
    repeat_interval: 1h
    group_wait: 30s
  - match:
      severity: warning
    receiver: slack-warnings
    repeat_interval: 24h

inhibit_rules:
- source_match:
    severity: critical
  target_match:
    severity: warning
  equal: [alertname, namespace]

receivers:
- name: default-receiver
- name: pagerduty-receiver
  pagerduty_configs:
  - routing_key: <key>
- name: slack-warnings
  slack_configs:
  - api_url: <webhook>
    channel: '#alerts-warning'
```

Effect:
- Critical alerts go to PagerDuty, remind every 1h.
- Warning alerts go to Slack, remind every 24h.
- If critical and warning fire for same issue, warning is suppressed (inhibition).
- All grouped by alertname + namespace, so 100 pod alerts = 1 notification.

---

##### 17.2 What an alert payload looks like (100 alerts)

When Prometheus fires alerts, it POSTs JSON to Alertmanager.
Here is exactly what the payload looks like for one alert and for 100 alerts.

Single alert payload:
```json
[
  {
    "labels": {
      "alertname": "StatusWebTargetDown",
      "severity": "warning",
      "job": "status-web",
      "namespace": "default",
      "team": "payments"
    },
    "annotations": {
      "summary": "status-web target is down",
      "description": "Prometheus cannot scrape status-web for 5m."
    },
    "startsAt": "2024-06-17T10:00:00Z",
    "endsAt": "0001-01-01T00:00:00Z",
    "generatorURL": "http://prometheus:9090/graph?g0.expr=up%7Bjob%3D%22status-web%22%7D+%3D%3D+0"
  }
]
```

Key fields:
- `labels`: all labels attached to alert rule plus target labels
- `annotations`: summary/description text shown in notification
- `startsAt`: when alert fired
- `endsAt`: zero value = still firing; set to real time when resolved
- `generatorURL`: link back to Prometheus graph for debugging

When 100 pods all fire the same alert, Prometheus sends 100 objects in one POST:
```json
[
  { "labels": { "alertname": "PodCrashLooping", "pod": "app-1",   "namespace": "prod", "team": "payments" }, "annotations": { "description": "Pod app-1 is crash looping"   } },
  { "labels": { "alertname": "PodCrashLooping", "pod": "app-2",   "namespace": "prod", "team": "payments" }, "annotations": { "description": "Pod app-2 is crash looping"   } },
  ...
  { "labels": { "alertname": "PodCrashLooping", "pod": "app-100", "namespace": "prod", "team": "payments" }, "annotations": { "description": "Pod app-100 is crash looping" } }
]
```

All 100 share same `alertname`, `namespace`, `team` but different `pod` label.
Alertmanager groups them by `group_by` labels and sends ONE notification.

---

##### 17.3b group_by: [alertname, team, namespace] in depth

```yaml
route:
  group_by: [alertname, team, namespace]
```

Alertmanager groups alerts into the same bucket only if ALL THREE labels share the same value.

Scenario: 100 PodCrashLooping alerts across 2 teams.

| pod | alertname | team | namespace |
|---|---|---|---|
| app-1 to app-80 | PodCrashLooping | payments | prod |
| svc-1 to svc-20 | PodCrashLooping | orders | prod |

With `group_by: [alertname, team, namespace]`:
- Group 1: team=payments → 80 alerts → **1 notification to payments team**
- Group 2: team=orders → 20 alerts → **1 notification to orders team**
- Total: 2 notifications instead of 100

With `group_by: [alertname, namespace]` (no team):
- Group 1: namespace=prod → all 100 alerts → **1 notification to default receiver**
- Both teams share the same single notification (or neither gets it if routing isn't split)

Wrong grouping: `group_by: [alertname, namespace, pod]`
- Each pod makes its own group (100 unique pod labels)
- 100 alerts = 100 separate notifications
- Alert storm

---

##### 17.4b How to route alerts to different teams

The `team` label in the alert rule is the key trigger.

Step 1: Add team label in PrometheusRule:
```yaml
apiVersion: monitoring.coreos.com/v1
kind: PrometheusRule
metadata:
  name: payments-alerts
  namespace: monitoring-manual
  labels:
    release: kube-prom
spec:
  groups:
  - name: payments.alerts
    rules:
    - alert: PodCrashLooping
      expr: kube_pod_container_status_restarts_total{namespace="prod"} > 5
      for: 5m
      labels:
        severity: critical
        team: payments
      annotations:
        summary: "Pod {{ $labels.pod }} crash looping"
        description: "Pod {{ $labels.pod }} in {{ $labels.namespace }} restarted >5 times"
```

Step 2: Route in Alertmanager config Secret based on team label:
```yaml
route:
  receiver: default-receiver
  group_by: [alertname, team, namespace]
  group_wait: 60s
  group_interval: 5m
  repeat_interval: 4h
  routes:
  - match:
      team: payments
    receiver: slack-payments
    repeat_interval: 2h
  - match:
      team: orders
    receiver: slack-orders
    repeat_interval: 2h
  - match:
      team: platform
    receiver: pagerduty-platform
    repeat_interval: 30m

receivers:
- name: default-receiver
- name: slack-payments
  slack_configs:
  - api_url: https://hooks.slack.com/services/xxx
    channel: '#payments-alerts'
    title: '[{{ .Status | toUpper }}] {{ .GroupLabels.alertname }}'
    text: |
      *Team:* {{ .GroupLabels.team }}
      *Namespace:* {{ .GroupLabels.namespace }}
      *Total firing:* {{ len .Alerts.Firing }}
      {{ range .Alerts.Firing }}
      • *Pod:* {{ .Labels.pod }} — {{ .Annotations.description }}
      {{ end }}
- name: slack-orders
  slack_configs:
  - api_url: https://hooks.slack.com/services/yyy
    channel: '#orders-alerts'
    title: '[{{ .Status | toUpper }}] {{ .GroupLabels.alertname }}'
    text: |
      *Team:* {{ .GroupLabels.team }}
      *Total firing:* {{ len .Alerts.Firing }}
      {{ range .Alerts.Firing }}
      • *Pod:* {{ .Labels.pod }} — {{ .Annotations.description }}
      {{ end }}
- name: pagerduty-platform
  pagerduty_configs:
  - routing_key: <key>
    description: '{{ .GroupLabels.alertname }} — {{ len .Alerts }} alerts in {{ .GroupLabels.namespace }}'
```

Where to make changes summary:
- Add `team` label → PrometheusRule `labels:` block
- Routing logic → `route.routes` in Alertmanager config Secret
- Receiver targets → `receivers` in Alertmanager config Secret

---

##### 17.5b Inhibition rules: in depth

Inhibition suppresses (silences) child alerts when a parent alert is already firing.

Problem without inhibition:
- Node goes down → Prometheus fires NodeDown
- All 49 pods on that node crash → Prometheus fires 49x PodCrashLooping
- All 20 services unavailable → Prometheus fires 20x TargetDown
- On-call gets 70 alerts, most caused by the single node failure

With inhibition:
- NodeDown fires → on-call gets 1 page
- All pod/target alerts on same node are silenced automatically

Inhibition rule structure:
```yaml
inhibit_rules:
- source_match:           # parent alert that causes suppression
    alertname: NodeDown
  target_match_re:        # child alerts to suppress (regex)
    alertname: (PodCrashLooping|TargetDown)
  equal: [node]           # both parent and child MUST share this label value
```

How it works step by step:
1. NodeDown fires for `node=worker-1`
2. PodCrashLooping fires for `node=worker-1, pod=app-1`
3. Alertmanager checks: is there a NodeDown with `node=worker-1`?
4. Yes → PodCrashLooping for `node=worker-1` is suppressed
5. On-call only sees NodeDown

The `equal` field is critical:
- `equal: [node]` means source AND target must share exact same `node` value
- Without it, ANY NodeDown would suppress ALL PodCrashLooping everywhere

Multiple inhibition rules:
```yaml
inhibit_rules:
### critical suppresses warning for same issue
- source_match:
    severity: critical
  target_match:
    severity: warning
  equal: [alertname, namespace, team]

### NodeDown suppresses pod/target alerts on same node
- source_match:
    alertname: NodeDown
  target_match_re:
    alertname: (PodCrashLooping|TargetDown|ContainerOOMKilled)
  equal: [node]

### Namespace quota exceeded suppresses individual OOM on same namespace
- source_match:
    alertname: NamespaceQuotaExceeded
  target_match:
    alertname: ContainerOOMKilled
  equal: [namespace]
```

Concrete label-level example (how matching really happens):

Inhibition rule:
```yaml
inhibit_rules:
- source_match:
    alertname: NodeDown
  target_match_re:
    alertname: (PodCrashLooping|TargetDown)
  equal: [node]
```

Source (parent) alert labels:
```yaml
labels:
  alertname: NodeDown
  severity: critical
  node: worker-1
  team: platform
annotations:
  summary: Node worker-1 is down
```

Target (child) alert labels:
```yaml
labels:
  alertname: PodCrashLooping
  severity: warning
  node: worker-1
  pod: payments-api-7c4d9f6f8d-x2m9p
  namespace: prod
  team: payments
annotations:
  summary: Pod crash looping on worker-1
```

Why this child alert is suppressed:
1. `source_match` is true because parent has `alertname=NodeDown`.
2. `target_match_re` is true because child has `alertname=PodCrashLooping`.
3. `equal: [node]` is true because both have `node=worker-1`.

Child alert that is NOT suppressed (different node):
```yaml
labels:
  alertname: PodCrashLooping
  node: worker-2
  pod: orders-api-55f6c8d9f-9l2kt
```

This one is not inhibited because `node` value does not match the source alert.

API payload test example (post both alerts to Alertmanager):
```json
[
  {
    "labels": {
      "alertname": "NodeDown",
      "node": "worker-1",
      "severity": "critical",
      "team": "platform"
    },
    "annotations": {
      "summary": "Node worker-1 is down"
    },
    "startsAt": "2026-06-17T10:00:00Z"
  },
  {
    "labels": {
      "alertname": "PodCrashLooping",
      "node": "worker-1",
      "pod": "payments-api-abc",
      "namespace": "prod",
      "severity": "warning",
      "team": "payments"
    },
    "annotations": {
      "summary": "Pod crash looping on worker-1"
    },
    "startsAt": "2026-06-17T10:00:00Z"
  }
]
```

##### 17.5c Avoid hardcoded node label values in alert rules

You are correct: in production, alert rules should not hardcode specific node names like `node="worker-1"`.

Bad (hardcoded node value):
```promql
up{job="node-exporter", node="worker-1"} == 0
```

Why bad:
- New/replaced node names break alert intent.
- Rule does not scale with autoscaling/cluster changes.

Good pattern 1 (all nodes, dynamic labels from metrics):
```promql
up{job="node-exporter"} == 0
```

Good pattern 2 (scope by stable metadata, not node name):
```promql
up{job="node-exporter", cluster="prod-us-east-1"} == 0
```

Good pattern 3 (role/team scoping via node labels joined from kube-state-metrics):
```promql
(
  up{job="node-exporter"} == 0
)
* on (node) group_left(label_node_role_kubernetes_io_worker)
  kube_node_labels{label_node_role_kubernetes_io_worker="true"}
```

This alerts on worker nodes dynamically, without hardcoding individual node names.

Production recommendation:
1. Hardcode only stable dimensions (`cluster`, `environment`, `team`).
2. Never hardcode ephemeral identities (`pod`, specific node name, replica hash).
3. Let target labels from discovery/metrics provide per-node values.

##### 17.5d How to implement this in production (step by step)

Below is a practical pattern to avoid hardcoded node names and still get actionable alerts.

Step 1: Ensure node metrics include a stable node label

Check label shape first:
```promql
up{job="node-exporter"}
```

You should see labels like:
- `instance="10.0.0.12:9100"`
- `job="node-exporter"`
- often `node="worker-1"` (if relabeling adds it)

If `node` label is not present, add relabeling in scrape config to map node name into `node`.

Step 2: Scope alerts by stable dimensions only

Good production alert (cluster + env scope, no node hardcoding):
```yaml
- alert: NodeExporterTargetDown
  expr: up{job="node-exporter",cluster="prod-us-east-1",environment="prod"} == 0
  for: 10m
  labels:
    severity: critical
    team: platform
  annotations:
    summary: "Node exporter target down"
    description: "Node exporter target {{ $labels.instance }} is down in {{ $labels.cluster }}"
```

Step 3: Use node roles dynamically when needed

Alert only for worker nodes (dynamic role filtering):
```yaml
- alert: WorkerNodeDown
  expr: |
    (
      up{job="node-exporter",cluster="prod-us-east-1"} == 0
    )
    * on (node) group_left(label_node_role_kubernetes_io_worker)
      kube_node_labels{label_node_role_kubernetes_io_worker="true"}
  for: 10m
  labels:
    severity: critical
    team: platform
  annotations:
    summary: "Worker node down"
    description: "Worker node {{ $labels.node }} is down"
```

Step 4: Keep alert volume low using aggregation

Instead of one alert per noisy metric series, aggregate by stable dimensions:
```yaml
- alert: HighNodeExporterDownRatio
  expr: |
    (
      sum(up{job="node-exporter",cluster="prod-us-east-1"} == 0)
      /
      count(up{job="node-exporter",cluster="prod-us-east-1"})
    ) > 0.2
  for: 10m
  labels:
    severity: critical
    team: platform
  annotations:
    summary: "High node target down ratio"
    description: "More than 20% node-exporter targets are down in prod-us-east-1"
```

Step 5: Route using team/severity, not node name

```yaml
route:
  receiver: default-receiver
  group_by: [alertname, team, cluster, environment]
  routes:
  - match:
      team: platform
      severity: critical
    receiver: pagerduty-platform
```

Step 6: Validate before production rollout

Use these checks:

```bash
### 1) ensure no hardcoded node value in rules
kubectl -n monitoring get prometheusrule -o yaml | grep -E 'node="[^"]+"' || true

### 2) preview affected series for alert query
kubectl -n monitoring port-forward svc/prometheus 9090:9090
curl -s 'http://127.0.0.1:9090/api/v1/query?query=up%7Bjob%3D%22node-exporter%22%2Ccluster%3D%22prod-us-east-1%22%7D' | python3 -m json.tool

### 3) verify rule is loaded and active
curl -s 'http://127.0.0.1:9090/api/v1/rules' | python3 -m json.tool
```

Expected production behavior:
- New/replaced nodes are automatically covered by the same rule.
- No rule edits required when node names change.
- Team routing remains stable because routing keys use stable labels (`team`, `severity`, `cluster`).

---

##### 17.6b How 100 grouped alerts appear in notification

Alertmanager sends one message with all alerts via template:

```yaml
text: |
  *Group:* {{ .GroupLabels.alertname }} in {{ .GroupLabels.namespace }}
  *Total alerts:* {{ len .Alerts }}
  *Firing:* {{ len .Alerts.Firing }}
  *Resolved:* {{ len .Alerts.Resolved }}
  {{ range .Alerts.Firing }}
  • Pod: {{ .Labels.pod }} — {{ .Annotations.description }}
  {{ end }}
```

This produces one Slack message:
```
Group: PodCrashLooping in prod
Total alerts: 100
Firing: 100
Resolved: 0
• Pod: app-1 — Pod app-1 is crash looping
• Pod: app-2 — Pod app-2 is crash looping
...
```

---

##### 17.7b Verification checklist: how to confirm everything is wired correctly

Check 1: Prometheus alert state:
```bash
kubectl -n monitoring-manual port-forward svc/prometheus 9090:9090 &
curl -s http://localhost:9090/api/v1/alerts | python3 -m json.tool
```
Expected: alerts with `state: firing` or `state: pending`.

Check 2: Alertmanager receives alerts:
```bash
kubectl -n monitoring-manual port-forward svc/alertmanager 9093:9093 &
curl -s http://localhost:9093/api/v2/alerts | python3 -m json.tool
```
Expected: fired alerts appear with their labels.

Check 3: Test routing logic manually:
```bash
### simulate routing for a payments/critical alert
curl -s -X POST http://localhost:9093/api/v2/alerts \
  -H 'Content-Type: application/json' \
  -d '[{"labels":{"alertname":"TestAlert","team":"payments","severity":"critical","namespace":"prod"},"annotations":{"summary":"test"},"startsAt":"2024-06-17T10:00:00Z","endsAt":"0001-01-01T00:00:00Z","generatorURL":"http://test"}]'
### then check http://localhost:9093 UI to see which group/receiver it landed in
```

Check 4: Verify grouping in Alertmanager UI:
- Open http://localhost:9093
- See grouped alerts under their group key labels
- Confirm grouping matches your `group_by`

Check 5: Confirm inhibition is working:
```bash
curl -s http://localhost:9093/api/v2/alerts | \
  python3 -c "
import sys, json
for a in json.load(sys.stdin):
    print(a['labels'].get('alertname'), '| inhibited:', a.get('inhibited', False))
"
```
Expected: suppressed alerts show `inhibited: True`.

---

##### 17.8b Production complete config

```yaml
global:
  resolve_timeout: 5m

route:
  receiver: default-receiver
  group_by: [alertname, team, namespace]
  group_wait: 60s
  group_interval: 5m
  repeat_interval: 4h
  routes:
  - match:
      severity: critical
      team: payments
    receiver: pagerduty-payments
    repeat_interval: 1h
    group_wait: 30s
  - match:
      severity: critical
      team: orders
    receiver: pagerduty-orders
    repeat_interval: 1h
  - match:
      severity: warning
    receiver: slack-warnings
    repeat_interval: 24h

inhibit_rules:
- source_match:
    severity: critical
  target_match:
    severity: warning
  equal: [alertname, namespace, team]
- source_match:
    alertname: NodeDown
  target_match_re:
    alertname: (PodCrashLooping|TargetDown)
  equal: [node]

receivers:
- name: default-receiver
- name: pagerduty-payments
  pagerduty_configs:
  - routing_key: <payments-key>
    description: '{{ .GroupLabels.alertname }} — {{ len .Alerts }} alerts'
- name: pagerduty-orders
  pagerduty_configs:
  - routing_key: <orders-key>
    description: '{{ .GroupLabels.alertname }} — {{ len .Alerts }} alerts'
- name: slack-warnings
  slack_configs:
  - api_url: <webhook>
    channel: '#alerts-warning'
    title: '[WARNING] {{ .GroupLabels.alertname }}'
    text: |
      *Namespace:* {{ .GroupLabels.namespace }}
      *Team:* {{ .GroupLabels.team }}
      *Firing:* {{ len .Alerts.Firing }}
      {{ range .Alerts.Firing }}• {{ .Labels.pod }}: {{ .Annotations.summary }}
      {{ end }}
```

What this achieves:
- 100 payments alerts → 1 PagerDuty page to payments team
- 50 orders alerts → 1 PagerDuty page to orders team
- Warnings → Slack only, no repeat for 24h
- If critical and warning fire for same issue → warning suppressed
- If node goes down → pod/target alerts on that node suppressed

---

<a id="appendix-d"></a>

# Appendix D: kind webapp monitoring runbook

> Operator/CR mode runbook; overlaps [Part 2](#part-2) and [Part 3](#part-3).

#### Goal

| Topic | Details |
|---|---|
| Primary objective | Deploy and operate web app monitoring on kind |
| Monitoring namespace | monitoring-manual |
| App namespace | default |
| Stack mode | Operator + Prometheus CR + ServiceMonitor (optional Thanos) |
| Companion doc | [Part 1](#part-1)–[Part 7](#part-7) (this file) |

---

#### Index

| Section | Link |
|---|---|
| Files Used | [Files Used](#files-used) |
| Prerequisites | [Prerequisites](#prerequisites) |
| Deployment Runbook | [Deployment Runbook](#deployment-runbook) |
| Alerting and Routing | [Alerting and Routing](#alerting-and-routing) |
| Prometheus CR YAML Field Table | [Prometheus CR YAML Field Table](#prometheus-cr-yaml-field-table) |
| Operator Namespace Scope Table | [Operator Namespace Scope Table](#operator-namespace-scope-table) |
| File Purpose and Dependency Table | [File Purpose and Dependency Table](#file-purpose-and-dependency-table) |
| ServiceMonitor Limits and Sizing | [ServiceMonitor Limits and Sizing](#servicemonitor-limits-and-sizing) |
| Production Checklist | [Production Checklist](#production-checklist) |
| Troubleshooting Matrix | [Troubleshooting Matrix](#troubleshooting-matrix) |
| Cleanup and Rerun | [Cleanup and Rerun](#cleanup-and-rerun) |

---

#### Files Used

##### Manifest Inventory

| File | Mode | Purpose |
|---|---|---|
| manifests/manual-stack/00-namespace.yaml | Shared | Creates monitoring-manual namespace |
| manifests/manual-stack/01-rbac.yaml | Plain | RBAC for plain Prometheus discovery |
| manifests/manual-stack/02-prometheus-config.yaml | Plain | Prometheus config + alerts.yml |
| manifests/manual-stack/03-prometheus.yaml | Plain | Deploys plain Prometheus service |
| manifests/manual-stack/04-alertmanager-config.yaml | Shared | Alertmanager routing config secret |
| manifests/manual-stack/05-alertmanager.yaml | Shared | Alertmanager deployment + service |
| manifests/manual-stack/06-grafana-secret.yaml | Shared | Grafana admin credentials |
| manifests/manual-stack/07-grafana-datasource.yaml | Shared | Grafana datasource configuration |
| manifests/manual-stack/08-grafana.yaml | Shared | Grafana deployment + service |
| manifests/manual-stack/09-status-web-service-annotations.yaml | Shared | status-web app/service and annotations |
| manifests/manual-stack/10-operator-rbac.yaml | CR | ServiceAccount + ClusterRoleBinding for operator |
| manifests/manual-stack/11-operator-deployment.yaml | CR | Prometheus Operator deployment and watch args |
| manifests/manual-stack/12-operator-prometheus-rbac.yaml | CR | RBAC for operator-managed Prometheus pods |
| manifests/manual-stack/13-operator-prometheus-cr.yaml | CR | Prometheus custom resource |
| manifests/manual-stack/14-operator-prometheus-service.yaml | CR | Service exposing operator Prometheus |
| manifests/manual-stack/15-operator-status-web-servicemonitor.yaml | CR | ServiceMonitor selecting status-web |

##### Script Inventory

| File | Purpose |
|---|---|
| scripts/manual-stack/deploy_manual_stack.sh | Applies manual stack resources |
| scripts/manual-stack/test_manual_stack.sh | Generates load and validates queries |
| scripts/manual-stack/cleanup_manual_stack.sh | Deletes manual stack resources |
| scripts/manual-stack/operator-stack/deploy_operator_stack.sh | Applies operator extension resources |
| scripts/manual-stack/operator-stack/check_status_web_target.sh | Validates status-web target via operator Prometheus |

---

#### Prerequisites

| Check | Command | Expected |
|---|---|---|
| Current context | kubectl config current-context | kind context active |
| Namespaces | kubectl get ns | Cluster reachable |
| Monitoring namespace state | kubectl -n monitoring-manual get pods \|\| true | Namespace may or may not exist |

---

#### Deployment Runbook

| Step | Command | Purpose | Success Signal |
|---|---|---|---|
| Deploy app | kubectl apply -f manifests/prod/status-web-deployment.yaml | Create status-web workload | Pods Running in default |
| App rollout | kubectl -n default rollout status deploy/status-web --timeout=180s | Confirm app readiness | Rollout complete |
| Deploy stack | ./scripts/manual-stack/deploy_manual_stack.sh | Deploy monitoring components | All applies succeed |
| Check pods | kubectl -n monitoring-manual get pods | Check monitoring health | Prometheus/Alertmanager/Grafana ready |
| Check service metadata | kubectl -n default get svc status-web -o yaml | Confirm selectors/annotations | Service fields match discovery mode |

##### Executable Command Snippets

```bash
### Step 1: deploy app
kubectl apply -f manifests/prod/status-web-deployment.yaml
kubectl -n default rollout status deploy/status-web --timeout=180s

### Step 2: deploy monitoring stack
./scripts/manual-stack/deploy_manual_stack.sh

### Step 3: quick health checks
kubectl -n monitoring-manual get pods
kubectl -n default get svc status-web -o yaml
```

##### Validation Commands

| Validation | Command |
|---|---|
| Generate test traffic | ./scripts/manual-stack/test_manual_stack.sh |
| Query up metric | curl -s 'http://127.0.0.1:9090/api/v1/query?query=up%7Bjob%3D%22status-web%22%7D' \| python3 -m json.tool |
| Query status rates | curl -s 'http://127.0.0.1:9090/api/v1/query?query=sum%20by%20(status)%20(rate(http_request_duration_seconds_count%7Bjob%3D%22status-web%22%2Cstatus%3D~%22200%7C400%7C503%22%7D%5B5m%5D))' \| python3 -m json.tool |

---

#### Alerting and Routing

| Topic | File | What to edit |
|---|---|---|
| Alertmanager routing | manifests/manual-stack/04-alertmanager-config.yaml | route.group_by, route.routes, receivers, inhibit_rules |
| Plain Prometheus alert destinations | manifests/manual-stack/02-prometheus-config.yaml | alerting.alertmanagers block |
| Alertmanager rollout after change | N/A | kubectl apply -f manifests/manual-stack/04-alertmanager-config.yaml; kubectl -n monitoring-manual rollout restart deploy/alertmanager |

---

#### Prometheus CR YAML Field Table

Source YAML: manifests/manual-stack/13-operator-prometheus-cr.yaml

| YAML Field | Meaning | Why it exists |
|---|---|---|
| apiVersion: monitoring.coreos.com/v1 | Uses Operator CRD API | Needed to create Prometheus custom resource |
| kind: Prometheus | Declares Prometheus instance | Operator reconciles this object |
| metadata.name: k8s | Logical instance name | Used in generated labels/selectors |
| metadata.namespace: monitoring-manual | CR object namespace | Keeps monitoring control-plane in one namespace |
| metadata.labels.app.kubernetes.io/name | Organizational label | Easier resource filtering |
| spec.replicas: 1 | One replica | Minimal local environment footprint |
| spec.serviceAccountName: prometheus-k8s | Pod identity | Maps to RBAC in file 12 |
| spec.evaluationInterval: 30s | Rule evaluation cadence | Balances responsiveness and CPU |
| spec.scrapeInterval: 30s | Default scrape cadence | Balances granularity and ingestion |
| spec.retention: 24h | Metric retention | Limits local disk usage |
| spec.enableAdminAPI: true | Enables admin API | Useful for debugging in local setup |
| spec.ruleSelector: {} | Rule selection | Selects PrometheusRules (scope depends on namespace selector) |
| spec.ruleNamespaceSelector: {} | Rule namespace filter | Works within namespaces visible to operator |
| spec.serviceMonitorSelector.matchLabels.release: manual-operator | ServiceMonitor label filter | Isolates to intended ServiceMonitors |
| spec.serviceMonitorNamespaceSelector: {} | ServiceMonitor namespace filter | Applies within operator watch scope |
| spec.podMonitorSelector: {} | PodMonitor filter | Optional path, broad by default |
| spec.podMonitorNamespaceSelector: {} | PodMonitor namespace filter | Optional path, broad by default |
| spec.resources.requests | Scheduler reservation | Guarantees minimum CPU and memory |
| spec.resources.limits | Runtime cap | Prevents uncontrolled resource growth |

##### Prometheus CR Example Snippet

```yaml
apiVersion: monitoring.coreos.com/v1
kind: Prometheus
metadata:
	name: k8s
	namespace: monitoring-manual
	labels:
		app.kubernetes.io/name: prometheus
spec:
	replicas: 1
	serviceAccountName: prometheus-k8s
	evaluationInterval: 30s
	scrapeInterval: 30s
	retention: 24h
	enableAdminAPI: true
	ruleSelector: {}
	ruleNamespaceSelector: {}
	serviceMonitorSelector:
		matchLabels:
			release: manual-operator
	serviceMonitorNamespaceSelector: {}
	podMonitorSelector: {}
	podMonitorNamespaceSelector: {}
	resources:
		requests:
			cpu: 200m
			memory: 512Mi
		limits:
			cpu: 1000m
			memory: 2Gi
```

---

#### Operator Namespace Scope Table

| Layer | Configuration | Function |
|---|---|---|
| Operator process scope | manifests/manual-stack/11-operator-deployment.yaml args: --namespaces=monitoring-manual,default | Hard watch boundary; operator cannot see outside this list |
| Per-Prometheus CR scope | manifests/manual-stack/13-operator-prometheus-cr.yaml serviceMonitorNamespaceSelector | Additional filter inside operator-visible namespaces |

##### Adding payments namespace to operator args

| Item | Value |
|---|---|
| File | manifests/manual-stack/11-operator-deployment.yaml |
| Required args line | --namespaces=monitoring-manual,default,payments |
| Apply command | kubectl apply -f manifests/manual-stack/11-operator-deployment.yaml |
| Restart command | kubectl -n monitoring-manual rollout restart deploy/prometheus-operator |
| Verify command | kubectl -n monitoring-manual rollout status deploy/prometheus-operator --timeout=180s |

```yaml
### manifests/manual-stack/11-operator-deployment.yaml (args excerpt)
args:
- --log-level=info
- --kubelet-service=kube-system/kubelet
- --prometheus-config-reloader=quay.io/prometheus-operator/prometheus-config-reloader:v0.76.0
- --prometheus-instance-namespaces=monitoring-manual
- --alertmanager-instance-namespaces=monitoring-manual
- --thanos-ruler-instance-namespaces=monitoring-manual
- --namespaces=monitoring-manual,default,payments
```

```bash
kubectl apply -f manifests/manual-stack/11-operator-deployment.yaml
kubectl -n monitoring-manual rollout restart deploy/prometheus-operator
kubectl -n monitoring-manual rollout status deploy/prometheus-operator --timeout=180s
```

---

#### File Purpose and Dependency Table

| File | Purpose | Depends On | Mode |
|---|---|---|---|
| 00-namespace.yaml | Creates namespace | None | Shared |
| 01-rbac.yaml | Plain Prometheus RBAC | 00 | Plain |
| 02-prometheus-config.yaml | Plain Prometheus config + rules | 00 | Plain |
| 03-prometheus.yaml | Plain Prometheus workload | 00, 01, 02 | Plain |
| 04-alertmanager-config.yaml | Alertmanager config secret | 00 | Shared |
| 05-alertmanager.yaml | Alertmanager workload | 00, 04 | Shared |
| 06-grafana-secret.yaml | Grafana credentials | 00 | Shared |
| 07-grafana-datasource.yaml | Grafana datasource | 00, 03 or 14 | Shared |
| 08-grafana.yaml | Grafana workload | 00, 06, 07 | Shared |
| 09-status-web-service-annotations.yaml | Test app + service | None | Shared |
| 10-operator-rbac.yaml | Operator RBAC | 00 | CR |
| 11-operator-deployment.yaml | Operator workload | 00, 10 | CR |
| 12-operator-prometheus-rbac.yaml | Managed Prometheus RBAC | 00 | CR |
| 13-operator-prometheus-cr.yaml | Prometheus CR | 00, 11, 12 | CR |
| 14-operator-prometheus-service.yaml | Expose managed Prometheus | 13 | CR |
| 15-operator-status-web-servicemonitor.yaml | Discovery definition | 09, 11, 13 | CR |

#### Architecture Diagram

```
  default namespace                    monitoring-manual namespace
  ┌─────────────────────┐              ┌──────────────────────────────────┐
  │ status-web Deploy   │              │ Namespace                        │
  │        │            │              │   ├── Operator Deployment        │
  │        ▼            │              │   ├── Prometheus CR (k8s)        │
  │ status-web Service  │◄── scrape ───│   ├── Service prometheus-k8s     │
  │        ▲            │   /metrics   │   ├── Alertmanager ◄── Config    │
  │ ServiceMonitor      │──selector───►│   └── Grafana ◄── Datasource CM  │
  └─────────────────────┘              └──────────────────────────────────┘

  Prometheus CR ──alerts──► Alertmanager
  Grafana ──queries──► prometheus-k8s
```

| Edge | Meaning |
|---|---|
| Prometheus Operator -> Prometheus CR | Operator watches and reconciles CR into running Prometheus workload |
| ServiceMonitor -> Prometheus CR | CR selector (`release=manual-operator`) controls which ServiceMonitors are used |
| Prometheus Service -> status-web Service | Operator Prometheus scrapes app metrics endpoint selected by ServiceMonitor |
| Prometheus CR -> Alertmanager | Alert rules fire and route alerts to Alertmanager |
| Grafana -> Prometheus Service | Dashboards query Prometheus for visualization |

##### Mode-Specific Apply Snippets

```bash
### Plain Prometheus mode (annotation-based)
kubectl apply -f manifests/manual-stack/00-namespace.yaml
kubectl apply -f manifests/manual-stack/01-rbac.yaml
kubectl apply -f manifests/manual-stack/02-prometheus-config.yaml
kubectl apply -f manifests/manual-stack/03-prometheus.yaml
kubectl apply -f manifests/manual-stack/04-alertmanager-config.yaml
kubectl apply -f manifests/manual-stack/05-alertmanager.yaml
kubectl apply -f manifests/manual-stack/06-grafana-secret.yaml
kubectl apply -f manifests/manual-stack/07-grafana-datasource.yaml
kubectl apply -f manifests/manual-stack/08-grafana.yaml
kubectl apply -f manifests/manual-stack/09-status-web-service-annotations.yaml
```

```bash
### Operator CR mode (ServiceMonitor-based)
kubectl apply -f manifests/manual-stack/00-namespace.yaml
kubectl apply -f manifests/manual-stack/10-operator-rbac.yaml
kubectl apply -f manifests/manual-stack/11-operator-deployment.yaml
kubectl apply -f manifests/manual-stack/12-operator-prometheus-rbac.yaml
kubectl apply -f manifests/manual-stack/13-operator-prometheus-cr.yaml
kubectl apply -f manifests/manual-stack/14-operator-prometheus-service.yaml
kubectl apply -f manifests/manual-stack/15-operator-status-web-servicemonitor.yaml
kubectl apply -f manifests/manual-stack/04-alertmanager-config.yaml
kubectl apply -f manifests/manual-stack/05-alertmanager.yaml
kubectl apply -f manifests/manual-stack/06-grafana-secret.yaml
kubectl apply -f manifests/manual-stack/07-grafana-datasource.yaml
kubectl apply -f manifests/manual-stack/08-grafana.yaml
kubectl apply -f manifests/manual-stack/09-status-web-service-annotations.yaml
```

---

#### ServiceMonitor Limits and Sizing

##### Primary Limit Factors

| Factor | Signal | Impact |
|---|---|---|
| Ingestion rate | targets x metrics_per_target / scrape_interval_seconds | Higher CPU, WAL and memory |
| Label cardinality | High-cardinality labels like user_id/request_id | Memory blow-up, slower queries |
| Timeout to interval ratio | scrapeTimeout near scrapeInterval | Overlaps and scrape failures |
| Discovery breadth | Broad selectors across many namespaces | Higher API and relabel overhead |
| Rule/query complexity | Frequent heavy PromQL | Evaluation latency and CPU pressure |

##### ServiceMonitor Constraints

| Constraint | Required condition |
|---|---|
| CRD presence | Prometheus Operator CRDs installed |
| Operator health | Operator deployment running |
| Label match | ServiceMonitor labels satisfy CR serviceMonitorSelector |
| Namespace visibility | Namespace visible to operator args and allowed by CR namespace selector |
| Port match | ServiceMonitor endpoints.port equals Service port name |

##### Tuning Playbook

| Symptom | Action |
|---|---|
| High CPU | Increase scrapeInterval, simplify rules, scale CPU |
| High memory | Remove high-cardinality labels, drop noisy metrics, raise memory |
| Missing targets | Check selectors, namespaces, ServiceMonitor port name |
| Slow evaluations | Increase evaluationInterval or split workload |

---

#### Production Checklist

| Area | Checklist |
|---|---|
| Discovery | Correct annotations for plain mode or correct ServiceMonitor labels/selectors for CR mode |
| Target health | up metric stable and equals 1 for live targets |
| Metrics quality | Avoid high-cardinality labels; maintain rate/error/latency metrics |
| Alert quality | Use for windows, severity labels, actionable summary and description |
| Routing quality | Correct critical/warning routes and repeat intervals |
| Runbook quality | Operators know mute/silence and response steps |

---

#### Troubleshooting Matrix

| Problem | Checks | Likely fix |
|---|---|---|
| up{job="status-web"} empty | kubectl -n default get pods -l app=status-web; kubectl -n default get svc status-web -o yaml | Fix selectors, annotations (plain) or ServiceMonitor labels/selectors (CR) |
| Target exists, query empty | Validate metric name and label keys; regenerate traffic | Use status label for podinfo, verify query window |
| Alerts not reaching Alertmanager | Verify alerting block in 02 for plain mode; verify rules loaded for CR mode; query Alertmanager API | Fix routing config and reload/restart |
| Too many alerts | Review group_by, group_wait, inhibit_rules, repeat_interval | Tune routing and inhibition |

##### Troubleshooting Query Snippets

```bash
### Plain Prometheus endpoint
kubectl -n monitoring-manual port-forward svc/prometheus 9090:9090

### Operator Prometheus endpoint
kubectl -n monitoring-manual port-forward svc/prometheus-k8s 9090:9090
```

```bash
### Query target health
curl -s 'http://127.0.0.1:9090/api/v1/query?query=up%7Bjob%3D%22status-web%22%7D' | python3 -m json.tool

### Query rates by status
curl -s 'http://127.0.0.1:9090/api/v1/query?query=sum%20by%20(status)%20(rate(http_request_duration_seconds_count%7Bjob%3D%22status-web%22%2Cstatus%3D~%22200%7C400%7C503%22%7D%5B5m%5D))' | python3 -m json.tool

### Query active targets
curl -s 'http://127.0.0.1:9090/api/v1/targets?state=active' | python3 -m json.tool

### Query loaded rules
curl -s 'http://127.0.0.1:9090/api/v1/rules' | python3 -m json.tool
```

---

#### Cleanup and Rerun

| Action | Command |
|---|---|
| Cleanup stack | ./scripts/manual-stack/cleanup_manual_stack.sh |
| Delete test app (optional) | kubectl -n default delete deploy status-web --ignore-not-found; kubectl -n default delete svc status-web --ignore-not-found |
| Rerun | kubectl apply -f manifests/prod/status-web-deployment.yaml; ./scripts/manual-stack/deploy_manual_stack.sh; ./scripts/manual-stack/test_manual_stack.sh |

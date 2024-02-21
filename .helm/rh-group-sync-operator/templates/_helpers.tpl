{{/*
Expand the name of the chart.
*/}}
{{- define "rh-group-sync-operator.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "rh-group-sync-operator.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Allow the release namespace to be overridden
*/}}
{{- define "rh-group-sync-operator.namespace" -}}
{{- default .Release.Namespace .Values.namespaceOverride -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "rh-group-sync-operator.labels" -}}
app.kubernetes.io/name: {{ include "rh-group-sync-operator.name" . }}
helm.sh/chart: {{ include "rh-group-sync-operator.chart" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/instance: {{ include "rh-group-sync-operator.name" . }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "rh-group-sync-operator.selectorLabels" -}}
control-plane: controller-manager
{{- end }}

{{/*
Match labels
*/}}
{{- define "rh-group-sync-operator.matchLabels" -}}
app.kubernetes.io/name: {{ include "rh-group-sync-operator.name" . }}
app.kubernetes.io/instance: {{ include "rh-group-sync-operator.name" . }}
{{- end }}
{{/*
Expand the name of the chart.
*/}}
{{- define "istio-config.name" -}}
{{- .Chart.Name | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "istio-config.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "istio-config.labels" -}}
helm.sh/chart: {{ include "istio-config.chart" . }}
{{ include "istio-config.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "istio-config.selectorLabels" -}}
app.kubernetes.io/name: {{ include "istio-config.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

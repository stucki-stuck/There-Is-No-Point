{{/*
Expand the name of the chart.
*/}}
{{- define "httpbingo-mesh.name" -}}
{{- .Chart.Name | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "httpbingo-mesh.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "httpbingo-mesh.labels" -}}
helm.sh/chart: {{ include "httpbingo-mesh.chart" . }}
{{ include "httpbingo-mesh.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "httpbingo-mesh.selectorLabels" -}}
app.kubernetes.io/name: {{ include "httpbingo-mesh.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

# Copyright 2021 Security Scorecard Authors
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

FROM golang@sha256:bd9823cdad5700fb4abe983854488749421d5b4fc84154c30dae474100468b85 AS base
WORKDIR /src
ENV CGO_ENABLED=0
COPY go.* ./
RUN go mod download
COPY . ./

FROM base AS webapp
ARG TARGETOS
ARG TARGETARCH
RUN CGO_ENABLED=0 make scorecard-webapp

FROM gcr.io/distroless/base:nonroot@sha256:d65ac1a65a4d82a48ebd0a22aea2acdd95d7abeeda245dfee932ec0018c781f4
COPY --from=webapp /src/scorecard-webapp /
ENTRYPOINT ["/scorecard-webapp"]

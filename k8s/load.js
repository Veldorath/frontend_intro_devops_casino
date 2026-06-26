import http from "k6/http";
import { check } from "k6";

// Carga progresiva contra la URL publica del frontend (LoadBalancer).
// Objetivo: p95 < 800 ms y tasa de error < 1% .
export const options = {
  stages: [
    { duration: "1m", target: 50 },
    { duration: "3m", target: 100 },
    { duration: "1m", target: 0 },
  ],
  thresholds: {
    http_req_duration: ["p(95)<800"],
    http_req_failed: ["rate<0.01"],
  },
};

export default function () {
  // __ENV.LB se pasa con -e LB=<dns-del-loadbalancer>
  const res = http.get(`http://${__ENV.LB}/`);
  check(res, { "status 200": (r) => r.status === 200 });
}
